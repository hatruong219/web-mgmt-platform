-- ═══════════════════════════════════════════════════════════════════════════
-- Feedback Module
-- Migration: Create feedbacks table + register module
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. Feedbacks table ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS feedbacks (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  site_id    UUID        NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  name       TEXT        NOT NULL,
  email      TEXT,
  message    TEXT        NOT NULL,
  rating     SMALLINT    CHECK (rating BETWEEN 1 AND 5),
  image      TEXT,                         -- nullable, for future use
  status     TEXT        NOT NULL DEFAULT 'pending'
               CHECK (status IN ('pending', 'reviewed', 'archived')),
  metadata   JSONB       NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─── 2. Indexes ──────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_feedbacks_site_id ON feedbacks(site_id);
CREATE INDEX IF NOT EXISTS idx_feedbacks_status  ON feedbacks(site_id, status);
CREATE INDEX IF NOT EXISTS idx_feedbacks_created ON feedbacks(site_id, created_at DESC);

-- ─── 3. Auto-update updated_at ───────────────────────────────────────────────
CREATE TRIGGER update_feedbacks_updated_at
  BEFORE UPDATE ON feedbacks
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- ─── 4. RLS ──────────────────────────────────────────────────────────────────
ALTER TABLE feedbacks ENABLE ROW LEVEL SECURITY;

-- Site admins and super_admins can manage feedbacks
CREATE POLICY "Site admins manage feedbacks"
  ON feedbacks
  USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'super_admin'
    )
    OR
    EXISTS (
      SELECT 1 FROM site_members
      WHERE site_id  = feedbacks.site_id
        AND user_id  = auth.uid()
        AND role     IN ('admin', 'editor')
    )
  );

-- ─── 5. Register module ───────────────────────────────────────────────────────
INSERT INTO modules (id, name, name_en, description, icon, route_segment, is_system, category, order_index)
VALUES (
  'feedbacks',
  'Phản hồi',
  'Feedbacks',
  'Quản lý phản hồi và đánh giá từ người dùng',
  'messageSquare',
  'feedbacks',
  false,
  'content',
  10
)
ON CONFLICT (id) DO NOTHING;
