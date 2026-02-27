-- ═══════════════════════════════════════════════════════════════════════════
-- Migration: User Management System
-- Date: 2026-02-27
-- Description: Add profiles, site_members, invitations + ALL RLS policies
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- TABLE 1: profiles — Extends Supabase auth.users
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS profiles (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email       TEXT NOT NULL,
  full_name   TEXT,
  avatar_url  TEXT,
  role        TEXT DEFAULT 'editor' CHECK (role IN ('super_admin', 'admin', 'editor')),
  is_active   BOOLEAN DEFAULT true,
  metadata    JSONB DEFAULT '{}',
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE profiles IS 'User profiles extending Supabase auth.users';
COMMENT ON COLUMN profiles.role IS 'Platform-level role: super_admin can manage all, admin/editor need site assignment';

-- ═══════════════════════════════════════════════════════════════════════════
-- TABLE 2: site_members — Assign users to sites with specific roles
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS site_members (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  site_id     UUID NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  user_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  role        TEXT DEFAULT 'editor' CHECK (role IN ('admin', 'editor', 'viewer')),
  invited_by  UUID REFERENCES profiles(id) ON DELETE SET NULL,
  invited_at  TIMESTAMPTZ DEFAULT NOW(),
  accepted_at TIMESTAMPTZ,
  UNIQUE(site_id, user_id)
);

COMMENT ON TABLE site_members IS 'Maps users to sites with site-specific roles';
COMMENT ON COLUMN site_members.role IS 'Site-level role: admin can invite editors, editor can create content';

-- ═══════════════════════════════════════════════════════════════════════════
-- TABLE 3: invitations — Pending invites for dashboard users
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS invitations (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email       TEXT NOT NULL,
  site_id     UUID REFERENCES sites(id) ON DELETE CASCADE,
  role        TEXT NOT NULL CHECK (role IN ('admin', 'editor', 'viewer')),
  token       TEXT UNIQUE NOT NULL,
  invited_by  UUID REFERENCES profiles(id) ON DELETE SET NULL,
  expires_at  TIMESTAMPTZ NOT NULL,
  accepted_at TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE invitations IS 'Pending invitations for new users';

-- ═══════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ═══════════════════════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);
CREATE INDEX IF NOT EXISTS idx_site_members_site ON site_members(site_id);
CREATE INDEX IF NOT EXISTS idx_site_members_user ON site_members(user_id);
CREATE INDEX IF NOT EXISTS idx_site_members_role ON site_members(role);
CREATE INDEX IF NOT EXISTS idx_invitations_token ON invitations(token);
CREATE INDEX IF NOT EXISTS idx_invitations_email ON invitations(email);
CREATE INDEX IF NOT EXISTS idx_invitations_site ON invitations(site_id);

-- ═══════════════════════════════════════════════════════════════════════════
-- TRIGGERS
-- ═══════════════════════════════════════════════════════════════════════════
DROP TRIGGER IF EXISTS set_updated_at_profiles ON profiles;
CREATE TRIGGER set_updated_at_profiles
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Auto-create profile when user signs up
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, avatar_url, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name'),
    NEW.raw_user_meta_data->>'avatar_url',
    'editor'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ═══════════════════════════════════════════════════════════════════════════
-- ENABLE RLS ON NEW TABLES
-- ═══════════════════════════════════════════════════════════════════════════
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE invitations ENABLE ROW LEVEL SECURITY;

-- ═══════════════════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS (SECURITY DEFINER - bypass RLS to avoid recursion)
-- ═══════════════════════════════════════════════════════════════════════════

-- Check if current user is super_admin
CREATE OR REPLACE FUNCTION is_super_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM profiles 
    WHERE id = auth.uid() AND role = 'super_admin'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Get user's role in a site
CREATE OR REPLACE FUNCTION get_site_role(site_uuid UUID)
RETURNS TEXT AS $$
  SELECT role FROM site_members 
  WHERE site_id = site_uuid AND user_id = auth.uid()
  LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Check if user is member of a site
CREATE OR REPLACE FUNCTION is_site_member(site_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM site_members 
    WHERE site_id = site_uuid AND user_id = auth.uid()
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Check if user is admin of a site
CREATE OR REPLACE FUNCTION is_site_admin(site_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM site_members 
    WHERE site_id = site_uuid AND user_id = auth.uid() AND role = 'admin'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Check if user can edit (admin or editor)
CREATE OR REPLACE FUNCTION can_edit_site(site_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM site_members 
    WHERE site_id = site_uuid AND user_id = auth.uid() AND role IN ('admin', 'editor')
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- ═══════════════════════════════════════════════════════════════════════════
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── PROFILES ─────────────────────────────────────────────────────────────
-- User can view their own profile
CREATE POLICY "profiles_select_own" ON profiles
  FOR SELECT USING (id = auth.uid());

-- Super admin can view all profiles (Users page)
CREATE POLICY "profiles_super_admin_all" ON profiles
  FOR SELECT USING (is_super_admin());

-- User can update their own profile
CREATE POLICY "profiles_update_own" ON profiles
  FOR UPDATE USING (id = auth.uid());

-- ─── SITES ────────────────────────────────────────────────────────────────
-- Super admin: full access to all sites
CREATE POLICY "sites_super_admin" ON sites
  FOR ALL USING (is_super_admin());

-- Members: can view sites they belong to
CREATE POLICY "sites_member_select" ON sites
  FOR SELECT USING (is_site_member(id));

-- Site admin: can update their site
CREATE POLICY "sites_admin_update" ON sites
  FOR UPDATE USING (is_site_admin(id));

-- ─── ARTICLES ─────────────────────────────────────────────────────────────
-- Super admin: full access
CREATE POLICY "articles_super_admin" ON articles
  FOR ALL USING (is_super_admin());

-- Members: can view articles
CREATE POLICY "articles_member_select" ON articles
  FOR SELECT USING (is_site_member(site_id));

-- Editors+: can create articles
CREATE POLICY "articles_editor_insert" ON articles
  FOR INSERT WITH CHECK (can_edit_site(site_id));

-- Editors+: can update articles
CREATE POLICY "articles_editor_update" ON articles
  FOR UPDATE USING (can_edit_site(site_id));

-- Admin: can delete articles
CREATE POLICY "articles_admin_delete" ON articles
  FOR DELETE USING (is_site_admin(site_id));

-- ─── MEDIA ────────────────────────────────────────────────────────────────
-- Super admin: full access
CREATE POLICY "media_super_admin" ON media
  FOR ALL USING (is_super_admin());

-- Members: can view media
CREATE POLICY "media_member_select" ON media
  FOR SELECT USING (is_site_member(site_id));

-- Editors+: can upload media
CREATE POLICY "media_editor_insert" ON media
  FOR INSERT WITH CHECK (can_edit_site(site_id));

-- Admin: can delete media
CREATE POLICY "media_admin_delete" ON media
  FOR DELETE USING (is_site_admin(site_id));

-- ─── SITE MEMBERS ─────────────────────────────────────────────────────────
-- Super admin: full access
CREATE POLICY "site_members_super_admin" ON site_members
  FOR ALL USING (is_super_admin());

-- Members: can view members of their sites
CREATE POLICY "site_members_select" ON site_members
  FOR SELECT USING (is_site_member(site_id));

-- Site admin: can add editors/viewers
CREATE POLICY "site_members_admin_insert" ON site_members
  FOR INSERT WITH CHECK (is_site_admin(site_id) AND role IN ('editor', 'viewer'));

-- Site admin: can remove editors/viewers
CREATE POLICY "site_members_admin_delete" ON site_members
  FOR DELETE USING (is_site_admin(site_id) AND role IN ('editor', 'viewer'));

-- ─── INVITATIONS ──────────────────────────────────────────────────────────
-- Super admin: full access
CREATE POLICY "invitations_super_admin" ON invitations
  FOR ALL USING (is_super_admin());

-- Site admin: can create invitations for editors/viewers
CREATE POLICY "invitations_admin_insert" ON invitations
  FOR INSERT WITH CHECK (is_site_admin(site_id) AND role IN ('editor', 'viewer'));

-- Site admin: can view invitations for their site
CREATE POLICY "invitations_admin_select" ON invitations
  FOR SELECT USING (is_site_admin(site_id));

-- Anyone can view invitation (needed for accepting)
CREATE POLICY "invitations_public_select" ON invitations
  FOR SELECT USING (true);
