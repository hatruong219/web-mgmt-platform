CREATE INDEX IF NOT EXISTS idx_mnn_lessons_site    ON mnn_lessons(site_id);
CREATE INDEX IF NOT EXISTS idx_mnn_lessons_order   ON mnn_lessons(site_id, lesson_number);
CREATE INDEX IF NOT EXISTS idx_mnn_vocab_lesson    ON mnn_vocabulary(lesson_id);
CREATE INDEX IF NOT EXISTS idx_mnn_vocab_site      ON mnn_vocabulary(site_id);
CREATE INDEX IF NOT EXISTS idx_mnn_grammar_lesson  ON mnn_grammar(lesson_id);
CREATE INDEX IF NOT EXISTS idx_mnn_grammar_site    ON mnn_grammar(site_id);
CREATE INDEX IF NOT EXISTS idx_mnn_exercises_lesson ON mnn_exercises(lesson_id);
CREATE INDEX IF NOT EXISTS idx_mnn_exercises_site   ON mnn_exercises(site_id);
