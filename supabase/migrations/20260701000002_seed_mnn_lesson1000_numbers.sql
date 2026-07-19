-- Seed: Minna no Nihongo — Lesson 1000 "Số đếm" (numbers)
-- Quy tắc: word = kana, reading = kana, kanji = kanji (nếu có, không thì NULL)
-- Nhiều cách đọc dùng ' / ' (như bài 4: '～ふん / ～ぷん')
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c

ALTER TABLE mnn_vocabulary ADD COLUMN IF NOT EXISTS kanji text;

DO $$
DECLARE
  sid    uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  lesson uuid;
BEGIN

-- Tạo lesson 1000 nếu chưa có
INSERT INTO mnn_lessons (site_id, lesson_number, title_vi, situation_vi, order_index)
VALUES (sid, 1000, 'Số đếm', 'Học số đếm trong tiếng Nhật', 1000)
ON CONFLICT (site_id, lesson_number) DO NOTHING;

SELECT id INTO lesson FROM mnn_lessons WHERE site_id = sid AND lesson_number = 1000;

-- ════════════════════════════════════════
-- SỐ ĐẾM — xóa và seed lại (29 số: 0-10, 100-900, 1000-9000)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = lesson;

INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, lesson, 'ゼロ / れい',           'ゼロ / れい',           'zero / rei',      '0 (không)',        '数詞', 1,  NULL),
  (sid, lesson, 'いち',                  'いち',                  'ichi',            '1 (một)',          '数詞', 2,  '一'),
  (sid, lesson, 'に',                    'に',                    'ni',              '2 (hai)',          '数詞', 3,  '二'),
  (sid, lesson, 'さん',                  'さん',                  'san',             '3 (ba)',           '数詞', 4,  '三'),
  (sid, lesson, 'よん / よ / し',        'よん / よ / し',        'yon / yo / shi',  '4 (bốn)',          '数詞', 5,  '四'),
  (sid, lesson, 'ご',                    'ご',                    'go',              '5 (năm)',          '数詞', 6,  '五'),
  (sid, lesson, 'ろく',                  'ろく',                  'roku',            '6 (sáu)',          '数詞', 7,  '六'),
  (sid, lesson, 'なな / しち',           'なな / しち',           'nana / shichi',   '7 (bảy)',          '数詞', 8,  '七'),
  (sid, lesson, 'はち',                  'はち',                  'hachi',           '8 (tám)',          '数詞', 9,  '八'),
  (sid, lesson, 'きゅう / く',           'きゅう / く',           'kyuu / ku',       '9 (chín)',         '数詞', 10, '九'),
  (sid, lesson, 'じゅう',                'じゅう',                'juu',             '10 (mười)',        '数詞', 11, '十'),
  (sid, lesson, 'ひゃく',                'ひゃく',                'hyaku',           '100 (một trăm)',   '数詞', 12, '百'),
  (sid, lesson, 'にひゃく',              'にひゃく',              'nihyaku',         '200 (hai trăm)',   '数詞', 13, '二百'),
  (sid, lesson, 'さんびゃく',            'さんびゃく',            'sanbyaku',        '300 (ba trăm)',    '数詞', 14, '三百'),
  (sid, lesson, 'よんひゃく',            'よんひゃく',            'yonhyaku',        '400 (bốn trăm)',   '数詞', 15, '四百'),
  (sid, lesson, 'ごひゃく',              'ごひゃく',              'gohyaku',         '500 (năm trăm)',   '数詞', 16, '五百'),
  (sid, lesson, 'ろっぴゃく',            'ろっぴゃく',            'roppyaku',        '600 (sáu trăm)',   '数詞', 17, '六百'),
  (sid, lesson, 'ななひゃく',            'ななひゃく',            'nanahyaku',       '700 (bảy trăm)',   '数詞', 18, '七百'),
  (sid, lesson, 'はっぴゃく',            'はっぴゃく',            'happyaku',        '800 (tám trăm)',   '数詞', 19, '八百'),
  (sid, lesson, 'きゅうひゃく',          'きゅうひゃく',          'kyuuhyaku',       '900 (chín trăm)',  '数詞', 20, '九百'),
  (sid, lesson, 'せん',                  'せん',                  'sen',             '1000 (một nghìn)', '数詞', 21, '千'),
  (sid, lesson, 'にせん',                'にせん',                'nisen',           '2000 (hai nghìn)', '数詞', 22, '二千'),
  (sid, lesson, 'さんぜん',              'さんぜん',              'sanzen',          '3000 (ba nghìn)',  '数詞', 23, '三千'),
  (sid, lesson, 'よんせん',              'よんせん',              'yonsen',          '4000 (bốn nghìn)', '数詞', 24, '四千'),
  (sid, lesson, 'ごせん',                'ごせん',                'gosen',           '5000 (năm nghìn)', '数詞', 25, '五千'),
  (sid, lesson, 'ろくせん',              'ろくせん',              'rokusen',         '6000 (sáu nghìn)', '数詞', 26, '六千'),
  (sid, lesson, 'ななせん',              'ななせん',              'nanasen',         '7000 (bảy nghìn)', '数詞', 27, '七千'),
  (sid, lesson, 'はっせん',              'はっせん',              'hassen',          '8000 (tám nghìn)', '数詞', 28, '八千'),
  (sid, lesson, 'きゅうせん',            'きゅうせん',            'kyuusen',         '9000 (chín nghìn)','数詞', 29, '九千'),

  -- ── THÁNG (12 tháng + hỏi) ──
  (sid, lesson, 'いちがつ',              'いちがつ',              'ichigatsu',       'tháng 1',          '名詞', 30, '一月'),
  (sid, lesson, 'にがつ',                'にがつ',                'nigatsu',         'tháng 2',          '名詞', 31, '二月'),
  (sid, lesson, 'さんがつ',              'さんがつ',              'sangatsu',        'tháng 3',          '名詞', 32, '三月'),
  (sid, lesson, 'しがつ',                'しがつ',                'shigatsu',        'tháng 4',          '名詞', 33, '四月'),
  (sid, lesson, 'ごがつ',                'ごがつ',                'gogatsu',         'tháng 5',          '名詞', 34, '五月'),
  (sid, lesson, 'ろくがつ',              'ろくがつ',              'rokugatsu',       'tháng 6',          '名詞', 35, '六月'),
  (sid, lesson, 'しちがつ',              'しちがつ',              'shichigatsu',     'tháng 7',          '名詞', 36, '七月'),
  (sid, lesson, 'はちがつ',              'はちがつ',              'hachigatsu',      'tháng 8',          '名詞', 37, '八月'),
  (sid, lesson, 'くがつ',                'くがつ',                'kugatsu',         'tháng 9',          '名詞', 38, '九月'),
  (sid, lesson, 'じゅうがつ',            'じゅうがつ',            'juugatsu',        'tháng 10',         '名詞', 39, '十月'),
  (sid, lesson, 'じゅういちがつ',        'じゅういちがつ',        'juuichigatsu',    'tháng 11',         '名詞', 40, '十一月'),
  (sid, lesson, 'じゅうにがつ',          'じゅうにがつ',          'juunigatsu',      'tháng 12',         '名詞', 41, '十二月'),
  (sid, lesson, 'なんがつ',              'なんがつ',              'nangatsu',        'tháng mấy?',       '疑問詞', 42, '何月'),

  -- ── THỨ (7 ngày trong tuần + hỏi) ──
  (sid, lesson, 'にちようび',            'にちようび',            'nichiyoubi',      'chủ nhật',         '名詞', 43, '日曜日'),
  (sid, lesson, 'げつようび',            'げつようび',            'getsuyoubi',      'thứ hai',          '名詞', 44, '月曜日'),
  (sid, lesson, 'かようび',              'かようび',              'kayoubi',         'thứ ba',           '名詞', 45, '火曜日'),
  (sid, lesson, 'すいようび',            'すいようび',            'suiyoubi',        'thứ tư',           '名詞', 46, '水曜日'),
  (sid, lesson, 'もくようび',            'もくようび',            'mokuyoubi',       'thứ năm',          '名詞', 47, '木曜日'),
  (sid, lesson, 'きんようび',            'きんようび',            'kinyoubi',        'thứ sáu',          '名詞', 48, '金曜日'),
  (sid, lesson, 'どようび',              'どようび',              'doyoubi',         'thứ bảy',          '名詞', 49, '土曜日'),
  (sid, lesson, 'なんようび',            'なんようび',            'nanyoubi',        'thứ mấy?',         '疑問詞', 50, '何曜日'),

  -- ── NGÀY TRONG THÁNG (1-31 + hỏi) ──
  (sid, lesson, 'ついたち',              'ついたち',              'tsuitachi',       'ngày mồng 1',              '名詞', 51, '一日'),
  (sid, lesson, 'ふつか',                'ふつか',                'futsuka',         'ngày mồng 2, 2 ngày',      '名詞', 52, '二日'),
  (sid, lesson, 'みっか',                'みっか',                'mikka',           'ngày mồng 3, 3 ngày',      '名詞', 53, '三日'),
  (sid, lesson, 'よっか',                'よっか',                'yokka',           'ngày mồng 4, 4 ngày',      '名詞', 54, '四日'),
  (sid, lesson, 'いつか',                'いつか',                'itsuka',          'ngày mồng 5, 5 ngày',      '名詞', 55, '五日'),
  (sid, lesson, 'むいか',                'むいか',                'muika',           'ngày mồng 6, 6 ngày',      '名詞', 56, '六日'),
  (sid, lesson, 'なのか',                'なのか',                'nanoka',          'ngày mồng 7, 7 ngày',      '名詞', 57, '七日'),
  (sid, lesson, 'ようか',                'ようか',                'youka',           'ngày mồng 8, 8 ngày',      '名詞', 58, '八日'),
  (sid, lesson, 'ここのか',              'ここのか',              'kokonoka',        'ngày mồng 9, 9 ngày',      '名詞', 59, '九日'),
  (sid, lesson, 'とおか',                'とおか',                'tooka',           'ngày mồng 10, 10 ngày',    '名詞', 60, '十日'),
  (sid, lesson, 'じゅういちにち',        'じゅういちにち',        'juuichinichi',    'ngày 11, 11 ngày',         '名詞', 61, '十一日'),
  (sid, lesson, 'じゅうににち',          'じゅうににち',          'juuninichi',      'ngày 12, 12 ngày',         '名詞', 62, '十二日'),
  (sid, lesson, 'じゅうさんにち',        'じゅうさんにち',        'juusannichi',     'ngày 13, 13 ngày',         '名詞', 63, '十三日'),
  (sid, lesson, 'じゅうよっか',          'じゅうよっか',          'juuyokka',        'ngày 14, 14 ngày',         '名詞', 64, '十四日'),
  (sid, lesson, 'じゅうごにち',          'じゅうごにち',          'juugonichi',      'ngày 15, 15 ngày',         '名詞', 65, '十五日'),
  (sid, lesson, 'じゅうろくにち',        'じゅうろくにち',        'juurokunichi',    'ngày 16, 16 ngày',         '名詞', 66, '十六日'),
  (sid, lesson, 'じゅうしちにち',        'じゅうしちにち',        'juushichinichi',  'ngày 17, 17 ngày',         '名詞', 67, '十七日'),
  (sid, lesson, 'じゅうはちにち',        'じゅうはちにち',        'juuhachinichi',   'ngày 18, 18 ngày',         '名詞', 68, '十八日'),
  (sid, lesson, 'じゅうくにち',          'じゅうくにち',          'juukunichi',      'ngày 19, 19 ngày',         '名詞', 69, '十九日'),
  (sid, lesson, 'はつか',                'はつか',                'hatsuka',         'ngày 20, 20 ngày',         '名詞', 70, '二十日'),
  (sid, lesson, 'にじゅういちにち',      'にじゅういちにち',      'nijuuichinichi',  'ngày 21, 21 ngày',         '名詞', 71, '二十一日'),
  (sid, lesson, 'にじゅうににち',        'にじゅうににち',        'nijuuninichi',    'ngày 22, 22 ngày',         '名詞', 72, '二十二日'),
  (sid, lesson, 'にじゅうさんにち',      'にじゅうさんにち',      'nijuusannichi',   'ngày 23, 23 ngày',         '名詞', 73, '二十三日'),
  (sid, lesson, 'にじゅうよっか',        'にじゅうよっか',        'nijuuyokka',      'ngày 24, 24 ngày',         '名詞', 74, '二十四日'),
  (sid, lesson, 'にじゅうごにち',        'にじゅうごにち',        'nijuugonichi',    'ngày 25, 25 ngày',         '名詞', 75, '二十五日'),
  (sid, lesson, 'にじゅうろくにち',      'にじゅうろくにち',      'nijuurokunichi',  'ngày 26, 26 ngày',         '名詞', 76, '二十六日'),
  (sid, lesson, 'にじゅうしちにち',      'にじゅうしちにち',      'nijuushichinichi','ngày 27, 27 ngày',         '名詞', 77, '二十七日'),
  (sid, lesson, 'にじゅうはちにち',      'にじゅうはちにち',      'nijuuhachinichi', 'ngày 28, 28 ngày',         '名詞', 78, '二十八日'),
  (sid, lesson, 'にじゅうくにち',        'にじゅうくにち',        'nijuukunichi',    'ngày 29, 29 ngày',         '名詞', 79, '二十九日'),
  (sid, lesson, 'さんじゅうにち',        'さんじゅうにち',        'sanjuunichi',     'ngày 30, 30 ngày',         '名詞', 80, '三十日'),
  (sid, lesson, 'さんじゅういちにち',    'さんじゅういちにち',    'sanjuuichinichi', 'ngày 31, 31 ngày',         '名詞', 81, '三十一日'),
  (sid, lesson, 'なんにち',              'なんにち',              'nannichi',        'ngày bao nhiêu?',          '疑問詞', 82, '何日'),

  -- ── GIỜ 〜時 (1-12 + hỏi; 4/7/9 đọc bất quy tắc) ──
  (sid, lesson, 'いちじ',                'いちじ',                'ichiji',          '1 giờ',            '名詞', 83, '一時'),
  (sid, lesson, 'にじ',                  'にじ',                  'niji',            '2 giờ',            '名詞', 84, '二時'),
  (sid, lesson, 'さんじ',                'さんじ',                'sanji',           '3 giờ',            '名詞', 85, '三時'),
  (sid, lesson, 'よじ',                  'よじ',                  'yoji',            '4 giờ',            '名詞', 86, '四時'),
  (sid, lesson, 'ごじ',                  'ごじ',                  'goji',            '5 giờ',            '名詞', 87, '五時'),
  (sid, lesson, 'ろくじ',                'ろくじ',                'rokuji',          '6 giờ',            '名詞', 88, '六時'),
  (sid, lesson, 'しちじ',                'しちじ',                'shichiji',        '7 giờ',            '名詞', 89, '七時'),
  (sid, lesson, 'はちじ',                'はちじ',                'hachiji',         '8 giờ',            '名詞', 90, '八時'),
  (sid, lesson, 'くじ',                  'くじ',                  'kuji',            '9 giờ',            '名詞', 91, '九時'),
  (sid, lesson, 'じゅうじ',              'じゅうじ',              'juuji',           '10 giờ',           '名詞', 92, '十時'),
  (sid, lesson, 'じゅういちじ',          'じゅういちじ',          'juuichiji',       '11 giờ',           '名詞', 93, '十一時'),
  (sid, lesson, 'じゅうにじ',            'じゅうにじ',            'juuniji',         '12 giờ',           '名詞', 94, '十二時'),
  (sid, lesson, 'なんじ',                'なんじ',                'nanji',           'mấy giờ?',         '疑問詞', 95, '何時'),

  -- ── PHÚT 〜分 (1-10 + hỏi; biến âm っ/ぷ) ──
  (sid, lesson, 'いっぷん',              'いっぷん',              'ippun',           '1 phút',           '名詞', 96,  '一分'),
  (sid, lesson, 'にふん',                'にふん',                'nifun',           '2 phút',           '名詞', 97,  '二分'),
  (sid, lesson, 'さんぷん',              'さんぷん',              'sanpun',          '3 phút',           '名詞', 98,  '三分'),
  (sid, lesson, 'よんぷん',              'よんぷん',              'yonpun',          '4 phút',           '名詞', 99,  '四分'),
  (sid, lesson, 'ごふん',                'ごふん',                'gofun',           '5 phút',           '名詞', 100, '五分'),
  (sid, lesson, 'ろっぷん',              'ろっぷん',              'roppun',          '6 phút',           '名詞', 101, '六分'),
  (sid, lesson, 'ななふん',              'ななふん',              'nanafun',         '7 phút',           '名詞', 102, '七分'),
  (sid, lesson, 'はっぷん',              'はっぷん',              'happun',          '8 phút',           '名詞', 103, '八分'),
  (sid, lesson, 'きゅうふん',            'きゅうふん',            'kyuufun',         '9 phút',           '名詞', 104, '九分'),
  (sid, lesson, 'じゅっぷん / じっぷん',  'じゅっぷん / じっぷん',  'juppun / jippun', '10 phút',          '名詞', 105, '十分'),
  (sid, lesson, 'にじゅっぷん',          'にじゅっぷん',          'nijuppun',        '20 phút',          '名詞', 106, '二十分'),
  (sid, lesson, 'さんじゅっぷん',        'さんじゅっぷん',        'sanjuppun',       '30 phút',          '名詞', 107, '三十分'),
  (sid, lesson, 'よんじゅっぷん',        'よんじゅっぷん',        'yonjuppun',       '40 phút',          '名詞', 108, '四十分'),
  (sid, lesson, 'ごじゅっぷん',          'ごじゅっぷん',          'gojuppun',        '50 phút',          '名詞', 109, '五十分'),
  (sid, lesson, 'なんぷん',              'なんぷん',              'nanpun',          'mấy phút?',        '疑問詞', 110, '何分'),
  (sid, lesson, 'はん',                  'はん',                  'han',             'rưỡi (30 phút)',   '名詞', 111, '半');

END $$;
