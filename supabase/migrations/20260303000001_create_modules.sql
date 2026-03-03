-- ═══════════════════════════════════════════════════════════════════════════
-- F-11: Dynamic Site Modules System
-- Migration: Create modules + site_modules tables
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. Module Registry (tất cả modules có sẵn) ─────────────────────────────
CREATE TABLE IF NOT EXISTS modules (
  id             TEXT PRIMARY KEY,
  name           VARCHAR(100) NOT NULL,
  name_en        VARCHAR(100),
  description    TEXT,
  icon           VARCHAR(50)  NOT NULL,
  route_segment  VARCHAR(100) NOT NULL,
  config_schema  JSONB        NOT NULL DEFAULT '{}',
  is_system      BOOLEAN      NOT NULL DEFAULT false,
  is_active      BOOLEAN      NOT NULL DEFAULT true,
  category       VARCHAR(50),
  order_index    INT          NOT NULL DEFAULT 0,
  created_at     TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- ─── 2. Per-site Module Config ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS site_modules (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  site_id     UUID        NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  module_id   TEXT        NOT NULL REFERENCES modules(id) ON DELETE RESTRICT,
  is_enabled  BOOLEAN     NOT NULL DEFAULT true,
  order_index INT         NOT NULL DEFAULT 0,
  config      JSONB       NOT NULL DEFAULT '{}',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT site_modules_unique UNIQUE (site_id, module_id)
);

CREATE INDEX IF NOT EXISTS idx_site_modules_site_id ON site_modules(site_id);
CREATE INDEX IF NOT EXISTS idx_site_modules_enabled ON site_modules(site_id, is_enabled, order_index);

-- Auto-update updated_at
CREATE TRIGGER update_site_modules_updated_at
  BEFORE UPDATE ON site_modules
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- ─── 3. RLS ─────────────────────────────────────────────────────────────────
ALTER TABLE modules      ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_modules ENABLE ROW LEVEL SECURITY;

-- modules: readable by anyone authenticated
CREATE POLICY "Authenticated read modules"
  ON modules FOR SELECT TO authenticated
  USING (is_active = true);

-- site_modules: managed by site admins + super_admins
CREATE POLICY "Admin manage site_modules"
  ON site_modules
  USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'super_admin'
    )
    OR
    EXISTS (
      SELECT 1 FROM site_members
      WHERE site_id = site_modules.site_id
        AND user_id = auth.uid()
        AND role = 'admin'
    )
  );

-- ─── 4. Seed: Built-in modules ───────────────────────────────────────────────
INSERT INTO modules (id, name, name_en, description, icon, route_segment, is_system, category, order_index) VALUES
  ('settings',          'Cài đặt',      'Settings',         'Cài đặt tổng quan cho site',              'settings',       'settings',   true,  'system',   0),
  ('articles',          'Bài viết',     'Articles',         'Quản lý bài viết / blog posts',           'article',        'articles',   false, 'content',  1),
  ('media',             'Media',        'Media',            'Quản lý hình ảnh và file đa phương tiện', 'image',          'media',      false, 'content',  2),
  ('members',           'Members',      'Members',          'Quản lý thành viên site',                 'users',          'members',    false, 'system',   3),
  ('clients',           'Clients',      'Clients',          'Quản lý khách hàng / đối tác',            'clients',        'clients',    false, 'system',   4),
  ('vocabulary',        'Từ vựng',      'Vocabulary',       'Quản lý từ vựng học ngoại ngữ',           'bookOpen',       'vocabulary',  false, 'learning', 5),
  ('decks',             'Bộ thẻ',       'Decks',            'Quản lý bộ thẻ flashcard',                'layers',         'decks',      false, 'learning', 6),
  ('lessons',           'Bài học',      'Lessons',          'Quản lý bài học có cấu trúc',             'graduationCap',  'lessons',    false, 'learning', 7),
  ('user-progress',     'Tiến độ học',  'User Progress',    'Theo dõi tiến độ học tập',                'trendingUp',     'progress',   false, 'learning', 8),
  ('vocabulary-import', 'Import CSV',   'Import CSV',       'Nhập từ vựng hàng loạt qua CSV',          'upload',         'import',     false, 'learning', 9)
ON CONFLICT (id) DO NOTHING;

-- ─── 5. Seed: Default site_modules cho sites hiện có ────────────────────────
-- gnourt-portfolio → articles, media, settings
-- language-learning → vocabulary, decks, vocabulary-import, settings
-- Dùng slug để tránh hardcode UUID

DO $$
DECLARE
  portfolio_id UUID;
  learning_id  UUID;
BEGIN
  SELECT id INTO portfolio_id FROM sites WHERE slug = 'gnourt-portfolio' LIMIT 1;
  SELECT id INTO learning_id  FROM sites WHERE slug = 'language-learning' LIMIT 1;

  -- Portfolio site defaults
  IF portfolio_id IS NOT NULL THEN
    INSERT INTO site_modules (site_id, module_id, is_enabled, order_index) VALUES
      (portfolio_id, 'settings',  true, 0),
      (portfolio_id, 'articles',  true, 1),
      (portfolio_id, 'media',     true, 2),
      (portfolio_id, 'members',   true, 3),
      (portfolio_id, 'clients',   true, 4)
    ON CONFLICT (site_id, module_id) DO NOTHING;
  END IF;

  -- Language learning site defaults
  IF learning_id IS NOT NULL THEN
    INSERT INTO site_modules (site_id, module_id, is_enabled, order_index) VALUES
      (learning_id, 'settings',          true, 0),
      (learning_id, 'vocabulary',        true, 1),
      (learning_id, 'decks',             true, 2),
      (learning_id, 'vocabulary-import', true, 3),
      (learning_id, 'articles',          true, 4),
      (learning_id, 'media',             true, 5)
    ON CONFLICT (site_id, module_id) DO NOTHING;
  END IF;
END $$;
