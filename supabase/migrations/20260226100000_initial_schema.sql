-- ═══════════════════════════════════════════════════════════════════════════
-- Web Management Platform — Database Schema
-- Migration 001: Initial Schema
-- ═══════════════════════════════════════════════════════════════════════════

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ═══════════════════════════════════════════════════════════════════════════
-- TABLES
-- ═══════════════════════════════════════════════════════════════════════════

-- Sites table
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

-- Articles table
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

-- Media table
CREATE TABLE IF NOT EXISTS media (
  id         UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  site_id    UUID REFERENCES sites(id) ON DELETE CASCADE,
  filename   TEXT NOT NULL,
  url        TEXT NOT NULL,
  mime_type  TEXT,
  size       BIGINT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ═══════════════════════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_articles_site_id ON articles(site_id);
CREATE INDEX IF NOT EXISTS idx_articles_status  ON articles(status);
CREATE INDEX IF NOT EXISTS idx_articles_slug    ON articles(site_id, slug);
CREATE INDEX IF NOT EXISTS idx_media_site_id    ON media(site_id);

-- ═══════════════════════════════════════════════════════════════════════════
-- TRIGGERS: Auto-update updated_at
-- ═══════════════════════════════════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════════════════════════════════
-- ROW LEVEL SECURITY - Enable only (policies in next migration)
-- ═══════════════════════════════════════════════════════════════════════════
ALTER TABLE sites    ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE media    ENABLE ROW LEVEL SECURITY;

-- NOTE: RLS Policies sẽ được tạo trong migration user_management
-- để đảm bảo helper functions tồn tại trước khi policies sử dụng chúng

-- ═══════════════════════════════════════════════════════════════════════════
-- STORAGE BUCKET
-- ═══════════════════════════════════════════════════════════════════════════
INSERT INTO storage.buckets (id, name, public)
VALUES ('media-bucket', 'media-bucket', true)
ON CONFLICT (id) DO NOTHING;

-- Storage Policies
DO $$
BEGIN
  -- Public read
  IF NOT EXISTS (SELECT FROM pg_policies WHERE policyname = 'public_read_media' AND tablename = 'objects') THEN
    CREATE POLICY "public_read_media" ON storage.objects FOR SELECT TO public
    USING (bucket_id = 'media-bucket');
  END IF;
  
  -- Authenticated insert
  IF NOT EXISTS (SELECT FROM pg_policies WHERE policyname = 'auth_insert_media' AND tablename = 'objects') THEN
    CREATE POLICY "auth_insert_media" ON storage.objects FOR INSERT TO authenticated
    WITH CHECK (bucket_id = 'media-bucket');
  END IF;
  
  -- Authenticated update
  IF NOT EXISTS (SELECT FROM pg_policies WHERE policyname = 'auth_update_media' AND tablename = 'objects') THEN
    CREATE POLICY "auth_update_media" ON storage.objects FOR UPDATE TO authenticated
    USING (bucket_id = 'media-bucket');
  END IF;
  
  -- Authenticated delete
  IF NOT EXISTS (SELECT FROM pg_policies WHERE policyname = 'auth_delete_media' AND tablename = 'objects') THEN
    CREATE POLICY "auth_delete_media" ON storage.objects FOR DELETE TO authenticated
    USING (bucket_id = 'media-bucket');
  END IF;
END $$;
