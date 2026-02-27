-- ═══════════════════════════════════════════════════════════════════════════
-- RESET EXISTING DATABASE
-- ═══════════════════════════════════════════════════════════════════════════
-- Chạy file này NẾU database đã có data và policies cũ bị conflict
-- File này sẽ xóa policies cũ và tạo lại đúng
-- 
-- SAU KHI CHẠY FILE NÀY, không cần chạy lại migrations
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- STEP 1: XÓA TẤT CẢ POLICIES CŨ
-- ═══════════════════════════════════════════════════════════════════════════

-- Profiles
DO $$ 
DECLARE pol RECORD;
BEGIN
  FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'profiles' AND schemaname = 'public'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON profiles', pol.policyname);
  END LOOP;
END $$;

-- Sites
DO $$ 
DECLARE pol RECORD;
BEGIN
  FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'sites' AND schemaname = 'public'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON sites', pol.policyname);
  END LOOP;
END $$;

-- Articles
DO $$ 
DECLARE pol RECORD;
BEGIN
  FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'articles' AND schemaname = 'public'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON articles', pol.policyname);
  END LOOP;
END $$;

-- Media
DO $$ 
DECLARE pol RECORD;
BEGIN
  FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'media' AND schemaname = 'public'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON media', pol.policyname);
  END LOOP;
END $$;

-- Site Members
DO $$ 
DECLARE pol RECORD;
BEGIN
  FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'site_members' AND schemaname = 'public'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON site_members', pol.policyname);
  END LOOP;
END $$;

-- Invitations
DO $$ 
DECLARE pol RECORD;
BEGIN
  FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'invitations' AND schemaname = 'public'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON invitations', pol.policyname);
  END LOOP;
END $$;

-- Site Clients
DO $$ 
DECLARE pol RECORD;
BEGIN
  FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'site_clients' AND schemaname = 'public'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON site_clients', pol.policyname);
  END LOOP;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════
-- STEP 2: TẠO/CẬP NHẬT HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION is_super_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM profiles 
    WHERE id = auth.uid() AND role = 'super_admin'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION get_site_role(site_uuid UUID)
RETURNS TEXT AS $$
  SELECT role FROM site_members 
  WHERE site_id = site_uuid AND user_id = auth.uid()
  LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION is_site_member(site_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM site_members 
    WHERE site_id = site_uuid AND user_id = auth.uid()
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION is_site_admin(site_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM site_members 
    WHERE site_id = site_uuid AND user_id = auth.uid() AND role = 'admin'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION can_edit_site(site_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM site_members 
    WHERE site_id = site_uuid AND user_id = auth.uid() AND role IN ('admin', 'editor')
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- ═══════════════════════════════════════════════════════════════════════════
-- STEP 3: TẠO POLICIES MỚI
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── PROFILES ─────────────────────────────────────────────────────────────
CREATE POLICY "profiles_select_own" ON profiles
  FOR SELECT USING (id = auth.uid());

CREATE POLICY "profiles_super_admin_all" ON profiles
  FOR SELECT USING (is_super_admin());

CREATE POLICY "profiles_update_own" ON profiles
  FOR UPDATE USING (id = auth.uid());

-- ─── SITES ────────────────────────────────────────────────────────────────
CREATE POLICY "sites_super_admin" ON sites
  FOR ALL USING (is_super_admin());

CREATE POLICY "sites_member_select" ON sites
  FOR SELECT USING (is_site_member(id));

CREATE POLICY "sites_admin_update" ON sites
  FOR UPDATE USING (is_site_admin(id));

-- ─── ARTICLES ─────────────────────────────────────────────────────────────
CREATE POLICY "articles_super_admin" ON articles
  FOR ALL USING (is_super_admin());

CREATE POLICY "articles_member_select" ON articles
  FOR SELECT USING (is_site_member(site_id));

CREATE POLICY "articles_editor_insert" ON articles
  FOR INSERT WITH CHECK (can_edit_site(site_id));

CREATE POLICY "articles_editor_update" ON articles
  FOR UPDATE USING (can_edit_site(site_id));

CREATE POLICY "articles_admin_delete" ON articles
  FOR DELETE USING (is_site_admin(site_id));

-- ─── MEDIA ────────────────────────────────────────────────────────────────
CREATE POLICY "media_super_admin" ON media
  FOR ALL USING (is_super_admin());

CREATE POLICY "media_member_select" ON media
  FOR SELECT USING (is_site_member(site_id));

CREATE POLICY "media_editor_insert" ON media
  FOR INSERT WITH CHECK (can_edit_site(site_id));

CREATE POLICY "media_admin_delete" ON media
  FOR DELETE USING (is_site_admin(site_id));

-- ─── SITE MEMBERS ─────────────────────────────────────────────────────────
CREATE POLICY "site_members_super_admin" ON site_members
  FOR ALL USING (is_super_admin());

CREATE POLICY "site_members_select" ON site_members
  FOR SELECT USING (is_site_member(site_id));

CREATE POLICY "site_members_admin_insert" ON site_members
  FOR INSERT WITH CHECK (is_site_admin(site_id) AND role IN ('editor', 'viewer'));

CREATE POLICY "site_members_admin_delete" ON site_members
  FOR DELETE USING (is_site_admin(site_id) AND role IN ('editor', 'viewer'));

-- ─── INVITATIONS ──────────────────────────────────────────────────────────
CREATE POLICY "invitations_super_admin" ON invitations
  FOR ALL USING (is_super_admin());

CREATE POLICY "invitations_admin_insert" ON invitations
  FOR INSERT WITH CHECK (is_site_admin(site_id) AND role IN ('editor', 'viewer'));

CREATE POLICY "invitations_admin_select" ON invitations
  FOR SELECT USING (is_site_admin(site_id));

CREATE POLICY "invitations_public_select" ON invitations
  FOR SELECT USING (true);

-- ─── SITE CLIENTS ─────────────────────────────────────────────────────────
-- Chỉ tạo nếu table tồn tại
DO $$
BEGIN
  IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'site_clients') THEN
    EXECUTE 'CREATE POLICY "site_clients_super_admin" ON site_clients FOR ALL USING (is_super_admin())';
    EXECUTE 'CREATE POLICY "site_clients_member_select" ON site_clients FOR SELECT USING (is_site_member(site_id))';
    EXECUTE 'CREATE POLICY "site_clients_admin_all" ON site_clients FOR ALL USING (is_site_admin(site_id))';
  END IF;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════
-- DONE - Verify
-- ═══════════════════════════════════════════════════════════════════════════
SELECT tablename, policyname, cmd 
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname;
