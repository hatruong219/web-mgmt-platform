-- ═══════════════════════════════════════════════════════════════════════════
-- Migration: User Management System
-- Date: 2026-02-27
-- Description: Add profiles, site_members, invitations tables for multi-tenant
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
COMMENT ON COLUMN invitations.site_id IS 'Target site for the invitation';
COMMENT ON COLUMN invitations.role IS 'Role to assign when invitation is accepted';

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
-- TRIGGER: Auto-update updated_at for profiles
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TRIGGER set_updated_at_profiles
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ═══════════════════════════════════════════════════════════════════════════
-- TRIGGER: Auto-create profile when user signs up
-- ═══════════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, avatar_url, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name'),
    NEW.raw_user_meta_data->>'avatar_url',
    'editor'  -- Default role, Super Admin will upgrade if needed
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ═══════════════════════════════════════════════════════════════════════════
-- ROW LEVEL SECURITY - Enable RLS
-- ═══════════════════════════════════════════════════════════════════════════
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE invitations ENABLE ROW LEVEL SECURITY;

-- ═══════════════════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS (SECURITY DEFINER để tránh infinite recursion)
-- ═══════════════════════════════════════════════════════════════════════════

-- Function kiểm tra user có phải super_admin không
CREATE OR REPLACE FUNCTION is_super_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM profiles 
    WHERE id = auth.uid() AND role = 'super_admin'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Function lấy role của user trong 1 site
CREATE OR REPLACE FUNCTION get_site_role(site_uuid UUID)
RETURNS TEXT AS $$
  SELECT role FROM site_members 
  WHERE site_id = site_uuid AND user_id = auth.uid()
  LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Function kiểm tra user có phải member của site không
CREATE OR REPLACE FUNCTION is_site_member(site_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM site_members 
    WHERE site_id = site_uuid AND user_id = auth.uid()
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Function kiểm tra user có phải admin của site không
CREATE OR REPLACE FUNCTION is_site_admin(site_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM site_members 
    WHERE site_id = site_uuid AND user_id = auth.uid() AND role = 'admin'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Function kiểm tra user có quyền edit (admin hoặc editor)
CREATE OR REPLACE FUNCTION can_edit_site(site_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM site_members 
    WHERE site_id = site_uuid AND user_id = auth.uid() AND role IN ('admin', 'editor')
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- ═══════════════════════════════════════════════════════════════════════════
-- DROP OLD POLICIES (nếu có)
-- ═══════════════════════════════════════════════════════════════════════════
DROP POLICY IF EXISTS "Allow all for authenticated users" ON sites;
DROP POLICY IF EXISTS "Allow all for authenticated users" ON articles;
DROP POLICY IF EXISTS "Allow all for authenticated users" ON media;

-- ═══════════════════════════════════════════════════════════════════════════
-- RLS POLICIES (dùng helper functions để tránh recursion)
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── Profiles ─────────────────────────────────────────────────────────────
-- Mọi authenticated user có thể xem profiles (cần cho join)
CREATE POLICY "Authenticated can view profiles" ON profiles
  FOR SELECT USING (auth.uid() IS NOT NULL);

-- User chỉ update được profile của mình
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (id = auth.uid());

-- ─── Sites ────────────────────────────────────────────────────────────────
-- Super admin: full access
CREATE POLICY "Super admin full access sites" ON sites
  FOR ALL USING (is_super_admin());

-- Members: chỉ xem sites mình là member
CREATE POLICY "Members can view their sites" ON sites
  FOR SELECT USING (is_site_member(id));

-- Site admin: có thể update site của mình
CREATE POLICY "Site admin can update site" ON sites
  FOR UPDATE USING (is_site_admin(id));

-- ─── Articles ─────────────────────────────────────────────────────────────
-- Super admin: full access
CREATE POLICY "Super admin full access articles" ON articles
  FOR ALL USING (is_super_admin());

-- Members: xem articles của sites mình là member
CREATE POLICY "Members can view articles" ON articles
  FOR SELECT USING (is_site_member(site_id));

-- Editors+: tạo articles
CREATE POLICY "Editors can create articles" ON articles
  FOR INSERT WITH CHECK (can_edit_site(site_id));

-- Editors+: update articles (chỉ của site mình)
CREATE POLICY "Editors can update articles" ON articles
  FOR UPDATE USING (can_edit_site(site_id));

-- Admin: xóa articles
CREATE POLICY "Admin can delete articles" ON articles
  FOR DELETE USING (is_site_admin(site_id));

-- ─── Media ────────────────────────────────────────────────────────────────
-- Super admin: full access
CREATE POLICY "Super admin full access media" ON media
  FOR ALL USING (is_super_admin());

-- Members: xem media của sites mình là member
CREATE POLICY "Members can view media" ON media
  FOR SELECT USING (is_site_member(site_id));

-- Editors+: upload media
CREATE POLICY "Editors can upload media" ON media
  FOR INSERT WITH CHECK (can_edit_site(site_id));

-- Admin: xóa media
CREATE POLICY "Admin can delete media" ON media
  FOR DELETE USING (is_site_admin(site_id));

-- ─── Site Members ─────────────────────────────────────────────────────────
-- Super admin: full access
CREATE POLICY "Super admin full access site_members" ON site_members
  FOR ALL USING (is_super_admin());

-- Members: xem members của site mình
CREATE POLICY "Members can view site_members" ON site_members
  FOR SELECT USING (is_site_member(site_id));

-- Site admin: quản lý members (chỉ editors/viewers)
CREATE POLICY "Site admin can insert members" ON site_members
  FOR INSERT WITH CHECK (
    is_site_admin(site_id) AND role IN ('editor', 'viewer')
  );

CREATE POLICY "Site admin can delete members" ON site_members
  FOR DELETE USING (
    is_site_admin(site_id) AND role IN ('editor', 'viewer')
  );

-- ─── Invitations ──────────────────────────────────────────────────────────
-- Super admin: full access
CREATE POLICY "Super admin full access invitations" ON invitations
  FOR ALL USING (is_super_admin());

-- Site admin: tạo invitations cho editors/viewers
CREATE POLICY "Site admin can create invitations" ON invitations
  FOR INSERT WITH CHECK (
    is_site_admin(site_id) AND role IN ('editor', 'viewer')
  );

-- Site admin: xem invitations của site mình
CREATE POLICY "Site admin can view invitations" ON invitations
  FOR SELECT USING (is_site_admin(site_id));

-- Ai cũng xem được invitation (để accept) - validation ở app
CREATE POLICY "Anyone can view invitation by token" ON invitations
  FOR SELECT USING (true);
