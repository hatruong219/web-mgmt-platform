-- ═══════════════════════════════════════════════════════════════════════════
-- Migration: Site Clients
-- Date: 2026-02-27
-- Description: Table để lưu thông tin clients (end-users) của các site con
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- TABLE: site_clients — End-users của các site con
-- ═══════════════════════════════════════════════════════════════════════════
-- Lưu ý: Đây là bảng riêng, KHÔNG liên kết với auth.users của dashboard
-- Site con sẽ có Supabase project riêng hoặc dùng chung project với namespace

CREATE TABLE IF NOT EXISTS site_clients (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  site_id     UUID NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  
  -- Auth info (từ Supabase Auth của site con hoặc custom)
  external_id TEXT,                    -- ID từ auth provider (Supabase Auth uid, Google sub, etc.)
  provider    TEXT DEFAULT 'email',    -- 'email', 'google', 'facebook', etc.
  
  -- Profile info
  email       TEXT NOT NULL,
  full_name   TEXT,
  avatar_url  TEXT,
  phone       TEXT,
  
  -- Status
  is_active   BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  
  -- Metadata
  metadata    JSONB DEFAULT '{}',      -- Custom fields per site
  last_login  TIMESTAMPTZ,
  login_count INTEGER DEFAULT 0,
  
  -- Timestamps
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  
  -- Constraints
  UNIQUE(site_id, email),
  UNIQUE(site_id, external_id)
);

COMMENT ON TABLE site_clients IS 'End-users (clients) của các site con';
COMMENT ON COLUMN site_clients.external_id IS 'User ID từ auth provider của site con';
COMMENT ON COLUMN site_clients.provider IS 'Auth provider: email, google, facebook, etc.';
COMMENT ON COLUMN site_clients.metadata IS 'Custom fields cho từng site (subscription, preferences, etc.)';

-- ═══════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ═══════════════════════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_site_clients_site ON site_clients(site_id);
CREATE INDEX IF NOT EXISTS idx_site_clients_email ON site_clients(email);
CREATE INDEX IF NOT EXISTS idx_site_clients_provider ON site_clients(provider);
CREATE INDEX IF NOT EXISTS idx_site_clients_created ON site_clients(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_site_clients_last_login ON site_clients(last_login DESC);

-- ═══════════════════════════════════════════════════════════════════════════
-- TRIGGER: Auto-update updated_at
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TRIGGER set_updated_at_site_clients
  BEFORE UPDATE ON site_clients
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ═══════════════════════════════════════════════════════════════════════════
-- ROW LEVEL SECURITY
-- ═══════════════════════════════════════════════════════════════════════════
ALTER TABLE site_clients ENABLE ROW LEVEL SECURITY;

-- Super admin: full access
CREATE POLICY "Super admin full access site_clients" ON site_clients
  FOR ALL USING (is_super_admin());

-- Site members: can view clients of their sites
CREATE POLICY "Site members can view clients" ON site_clients
  FOR SELECT USING (is_site_member(site_id));

-- Site admins: can manage clients
CREATE POLICY "Site admins can manage clients" ON site_clients
  FOR ALL USING (is_site_admin(site_id));
