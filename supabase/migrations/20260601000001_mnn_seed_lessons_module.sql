-- Register 'lessons' module and enable it for the language-learning site

INSERT INTO modules (id, name, name_en, description, icon, route_segment, is_system, category, order_index)
VALUES (
  'lessons',
  'Bài học MNN',
  'MNN Lessons',
  'Quản lý bài học Minna no Nihongo (từ vựng, ngữ pháp, bài tập)',
  'bookOpen',
  'lessons',
  false,
  'content',
  6
)
ON CONFLICT (id) DO NOTHING;

-- Requires the 'language-learning' site to be seeded first (20260303000001_create_modules.sql)
DO $$
DECLARE
  learning_id UUID;
BEGIN
  SELECT id INTO learning_id FROM sites WHERE slug = 'language-learning' LIMIT 1;

  IF learning_id IS NOT NULL THEN
    INSERT INTO site_modules (site_id, module_id, is_enabled, order_index)
    VALUES (learning_id, 'lessons', true, 6)
    ON CONFLICT (site_id, module_id) DO NOTHING;
  END IF;
END $$;
