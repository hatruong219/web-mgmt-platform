-- Migration: Seed Hiragana + Katakana dakuten (゛) and handakuten (゜) characters
-- 20260508000004_seed_alphabet_dakuten.sql

-- -----------------------------------------------
-- Hiragana: 濁音 (ga/za/da/ba rows) + 半濁音 (pa row)
-- -----------------------------------------------
WITH site AS (SELECT id FROM sites WHERE slug = 'language-learning' LIMIT 1)
INSERT INTO alphabet_characters (site_id, language_code, script, character, romanization, group_name, order_index)
SELECT site.id, 'ja', 'hiragana', char, roma, grp, idx
FROM (VALUES
  -- が行 (ga-row)
  ('が', 'ga', 'ga-row', 47), ('ぎ', 'gi', 'ga-row', 48), ('ぐ', 'gu', 'ga-row', 49), ('げ', 'ge', 'ga-row', 50), ('ご', 'go', 'ga-row', 51),
  -- ざ行 (za-row)
  ('ざ', 'za', 'za-row', 52), ('じ', 'ji', 'za-row', 53), ('ず', 'zu', 'za-row', 54), ('ぜ', 'ze', 'za-row', 55), ('ぞ', 'zo', 'za-row', 56),
  -- だ行 (da-row)
  ('だ', 'da', 'da-row', 57), ('ぢ', 'ji', 'da-row', 58), ('づ', 'zu', 'da-row', 59), ('で', 'de', 'da-row', 60), ('ど', 'do', 'da-row', 61),
  -- ば行 (ba-row)
  ('ば', 'ba', 'ba-row', 62), ('び', 'bi', 'ba-row', 63), ('ぶ', 'bu', 'ba-row', 64), ('べ', 'be', 'ba-row', 65), ('ぼ', 'bo', 'ba-row', 66),
  -- ぱ行 (pa-row) — 半濁音 (maru ゜)
  ('ぱ', 'pa', 'pa-row', 67), ('ぴ', 'pi', 'pa-row', 68), ('ぷ', 'pu', 'pa-row', 69), ('ぺ', 'pe', 'pa-row', 70), ('ぽ', 'po', 'pa-row', 71)
) AS c(char, roma, grp, idx), site;

-- -----------------------------------------------
-- Katakana: 濁音 (ga/za/da/ba rows) + 半濁音 (pa row)
-- -----------------------------------------------
WITH site AS (SELECT id FROM sites WHERE slug = 'language-learning' LIMIT 1)
INSERT INTO alphabet_characters (site_id, language_code, script, character, romanization, group_name, order_index)
SELECT site.id, 'ja', 'katakana', char, roma, grp, idx
FROM (VALUES
  -- ガ行 (ga-row)
  ('ガ', 'ga', 'ga-row', 47), ('ギ', 'gi', 'ga-row', 48), ('グ', 'gu', 'ga-row', 49), ('ゲ', 'ge', 'ga-row', 50), ('ゴ', 'go', 'ga-row', 51),
  -- ザ行 (za-row)
  ('ザ', 'za', 'za-row', 52), ('ジ', 'ji', 'za-row', 53), ('ズ', 'zu', 'za-row', 54), ('ゼ', 'ze', 'za-row', 55), ('ゾ', 'zo', 'za-row', 56),
  -- ダ行 (da-row)
  ('ダ', 'da', 'da-row', 57), ('ヂ', 'ji', 'da-row', 58), ('ヅ', 'zu', 'da-row', 59), ('デ', 'de', 'da-row', 60), ('ド', 'do', 'da-row', 61),
  -- バ行 (ba-row)
  ('バ', 'ba', 'ba-row', 62), ('ビ', 'bi', 'ba-row', 63), ('ブ', 'bu', 'ba-row', 64), ('ベ', 'be', 'ba-row', 65), ('ボ', 'bo', 'ba-row', 66),
  -- パ行 (pa-row) — 半濁音 (maru ゜)
  ('パ', 'pa', 'pa-row', 67), ('ピ', 'pi', 'pa-row', 68), ('プ', 'pu', 'pa-row', 69), ('ペ', 'pe', 'pa-row', 70), ('ポ', 'po', 'pa-row', 71)
) AS c(char, roma, grp, idx), site;
