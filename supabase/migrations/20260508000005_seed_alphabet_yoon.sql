-- Migration: Seed Hiragana + Katakana yōon (拗音) — âm ghép
-- 20260508000005_seed_alphabet_yoon.sql

-- -----------------------------------------------
-- Hiragana yōon
-- -----------------------------------------------
WITH site AS (SELECT id FROM sites WHERE slug = 'language-learning' LIMIT 1)
INSERT INTO alphabet_characters (site_id, language_code, script, character, romanization, group_name, order_index)
SELECT site.id, 'ja', 'hiragana', char, roma, grp, idx
FROM (VALUES
  -- きゃ行 (kya)
  ('きゃ', 'kya', 'kya-row', 72), ('きゅ', 'kyu', 'kya-row', 73), ('きょ', 'kyo', 'kya-row', 74),
  -- しゃ行 (sha)
  ('しゃ', 'sha', 'sha-row', 75), ('しゅ', 'shu', 'sha-row', 76), ('しょ', 'sho', 'sha-row', 77),
  -- ちゃ行 (cha)
  ('ちゃ', 'cha', 'cha-row', 78), ('ちゅ', 'chu', 'cha-row', 79), ('ちょ', 'cho', 'cha-row', 80),
  -- にゃ行 (nya)
  ('にゃ', 'nya', 'nya-row', 81), ('にゅ', 'nyu', 'nya-row', 82), ('にょ', 'nyo', 'nya-row', 83),
  -- ひゃ行 (hya)
  ('ひゃ', 'hya', 'hya-row', 84), ('ひゅ', 'hyu', 'hya-row', 85), ('ひょ', 'hyo', 'hya-row', 86),
  -- みゃ行 (mya)
  ('みゃ', 'mya', 'mya-row', 87), ('みゅ', 'myu', 'mya-row', 88), ('みょ', 'myo', 'mya-row', 89),
  -- りゃ行 (rya)
  ('りゃ', 'rya', 'rya-row', 90), ('りゅ', 'ryu', 'rya-row', 91), ('りょ', 'ryo', 'rya-row', 92),
  -- ぎゃ行 (gya) — 濁音
  ('ぎゃ', 'gya', 'gya-row', 93), ('ぎゅ', 'gyu', 'gya-row', 94), ('ぎょ', 'gyo', 'gya-row', 95),
  -- じゃ行 (ja) — 濁音
  ('じゃ', 'ja',  'ja-row',  96), ('じゅ', 'ju',  'ja-row',  97), ('じょ', 'jo',  'ja-row',  98),
  -- びゃ行 (bya) — 濁音
  ('びゃ', 'bya', 'bya-row', 99), ('びゅ', 'byu', 'bya-row', 100), ('びょ', 'byo', 'bya-row', 101),
  -- ぴゃ行 (pya) — 半濁音
  ('ぴゃ', 'pya', 'pya-row', 102), ('ぴゅ', 'pyu', 'pya-row', 103), ('ぴょ', 'pyo', 'pya-row', 104)
) AS c(char, roma, grp, idx), site;

-- -----------------------------------------------
-- Katakana yōon
-- -----------------------------------------------
WITH site AS (SELECT id FROM sites WHERE slug = 'language-learning' LIMIT 1)
INSERT INTO alphabet_characters (site_id, language_code, script, character, romanization, group_name, order_index)
SELECT site.id, 'ja', 'katakana', char, roma, grp, idx
FROM (VALUES
  ('キャ', 'kya', 'kya-row', 72), ('キュ', 'kyu', 'kya-row', 73), ('キョ', 'kyo', 'kya-row', 74),
  ('シャ', 'sha', 'sha-row', 75), ('シュ', 'shu', 'sha-row', 76), ('ショ', 'sho', 'sha-row', 77),
  ('チャ', 'cha', 'cha-row', 78), ('チュ', 'chu', 'cha-row', 79), ('チョ', 'cho', 'cha-row', 80),
  ('ニャ', 'nya', 'nya-row', 81), ('ニュ', 'nyu', 'nya-row', 82), ('ニョ', 'nyo', 'nya-row', 83),
  ('ヒャ', 'hya', 'hya-row', 84), ('ヒュ', 'hyu', 'hya-row', 85), ('ヒョ', 'hyo', 'hya-row', 86),
  ('ミャ', 'mya', 'mya-row', 87), ('ミュ', 'myu', 'mya-row', 88), ('ミョ', 'myo', 'mya-row', 89),
  ('リャ', 'rya', 'rya-row', 90), ('リュ', 'ryu', 'rya-row', 91), ('リョ', 'ryo', 'rya-row', 92),
  ('ギャ', 'gya', 'gya-row', 93), ('ギュ', 'gyu', 'gya-row', 94), ('ギョ', 'gyo', 'gya-row', 95),
  ('ジャ', 'ja',  'ja-row',  96), ('ジュ', 'ju',  'ja-row',  97), ('ジョ', 'jo',  'ja-row',  98),
  ('ビャ', 'bya', 'bya-row', 99), ('ビュ', 'byu', 'bya-row', 100), ('ビョ', 'byo', 'bya-row', 101),
  ('ピャ', 'pya', 'pya-row', 102), ('ピュ', 'pyu', 'pya-row', 103), ('ピョ', 'pyo', 'pya-row', 104)
) AS c(char, roma, grp, idx), site;
