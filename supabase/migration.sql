-- =============================================
-- Web Management Platform — Database Schema
-- Chạy file SQL này trong Supabase SQL Editor
-- =============================================

-- BƯỚC 1: Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- BƯỚC 2: Bảng sites
CREATE TABLE IF NOT EXISTS sites (
  id          UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name        TEXT NOT NULL,
  slug        TEXT UNIQUE NOT NULL,
  domain      TEXT,
  description TEXT,
  status      TEXT DEFAULT 'active' CHECK (status IN ('active', 'archived')),
  metadata    JSONB DEFAULT '{}',
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- BƯỚC 3: Bảng articles
CREATE TABLE IF NOT EXISTS articles (
  id           UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  site_id      UUID NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  title        TEXT NOT NULL,
  slug         TEXT NOT NULL,
  content      TEXT DEFAULT '',
  excerpt      TEXT,
  cover_image  TEXT,
  status       TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  tags         TEXT[] DEFAULT '{}',
  metadata     JSONB DEFAULT '{}',
  published_at TIMESTAMPTZ,
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  updated_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(site_id, slug)
);

-- BƯỚC 4: Bảng media
CREATE TABLE IF NOT EXISTS media (
  id         UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  site_id    UUID REFERENCES sites(id) ON DELETE CASCADE,
  filename   TEXT NOT NULL,
  url        TEXT NOT NULL,
  mime_type  TEXT,
  size       BIGINT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- BƯỚC 5: Indexes
CREATE INDEX IF NOT EXISTS idx_articles_site_id ON articles(site_id);
CREATE INDEX IF NOT EXISTS idx_articles_status  ON articles(status);
CREATE INDEX IF NOT EXISTS idx_articles_slug    ON articles(site_id, slug);
CREATE INDEX IF NOT EXISTS idx_media_site_id    ON media(site_id);

-- BƯỚC 6: Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_updated_at_sites ON sites;
CREATE TRIGGER set_updated_at_sites
  BEFORE UPDATE ON sites
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS set_updated_at_articles ON articles;
CREATE TRIGGER set_updated_at_articles
  BEFORE UPDATE ON articles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- BƯỚC 7: Row Level Security
ALTER TABLE sites    ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE media    ENABLE ROW LEVEL SECURITY;

-- Policy: Cho phép authenticated users truy cập toàn bộ (single-user app)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_policies WHERE policyname = 'auth_all_sites') THEN
    CREATE POLICY auth_all_sites ON sites FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT FROM pg_policies WHERE policyname = 'auth_all_articles') THEN
    CREATE POLICY auth_all_articles ON articles FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT FROM pg_policies WHERE policyname = 'auth_all_media') THEN
    CREATE POLICY auth_all_media ON media FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
END $$;

-- BƯỚC 8: Storage bucket (chạy riêng nếu cần)
-- INSERT INTO storage.buckets (id, name, public) VALUES ('media', 'media', true);
