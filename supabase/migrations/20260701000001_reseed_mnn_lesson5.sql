-- Reseed: Minna no Nihongo I — Bài 5 (correct vocabulary)
-- Quy tắc: word = kana, reading = kana, kanji = kanji (nếu có, không thì NULL)
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c

ALTER TABLE mnn_vocabulary ADD COLUMN IF NOT EXISTS kanji text;

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  l5  uuid;
BEGIN

SELECT id INTO l5 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 5;

-- ════════════════════════════════════════
-- BÀI 5 — xóa và seed lại (54 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l5;

INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l5, '～ばんせん',                   '～ばんせん',                   '~ bansen',             'sân ga số ~',                                         '接尾辞',   1,  '～番線'),
  (sid, l5, 'いきます',                     'いきます',                     'ikimasu',              'đi',                                                  '動詞',     2,  '行きます'),
  (sid, l5, 'きます',                       'きます',                       'kimasu',               'đến',                                                 '動詞',     3,  '来ます'),
  (sid, l5, 'かえります',                   'かえります',                   'kaerimasu',            'về (nhà)',                                            '動詞',     4,  '帰ります'),
  (sid, l5, 'がっこう',                     'がっこう',                     'gakkou',               'trường học',                                          '名詞',     5,  '学校'),
  (sid, l5, 'スーパー',                     'スーパー',                     'suupaa',               'siêu thị',                                            '名詞',     6,  NULL),
  (sid, l5, 'えき',                         'えき',                         'eki',                  'ga, nhà ga',                                          '名詞',     7,  '駅'),
  (sid, l5, 'ひこうき',                     'ひこうき',                     'hikouki',              'máy bay',                                             '名詞',     8,  '飛行機'),
  (sid, l5, 'ふね',                         'ふね',                         'fune',                 'thuyền, tàu thủy',                                    '名詞',     9,  '船'),
  (sid, l5, 'でんしゃ',                     'でんしゃ',                     'densha',               'tàu điện',                                            '名詞',     10, '電車'),
  (sid, l5, 'ちかてつ',                     'ちかてつ',                     'chikatetsu',           'tàu điện ngầm',                                       '名詞',     11, '地下鉄'),
  (sid, l5, 'しんかんせん',                 'しんかんせん',                 'shinkansen',           'tàu Shinkansen (tàu điện siêu tốc)',                  '名詞',     12, '新幹線'),
  (sid, l5, 'バス',                         'バス',                         'basu',                 'xe buýt',                                             '名詞',     13, NULL),
  (sid, l5, 'タクシー',                     'タクシー',                     'takushii',             'tắc-xi (taxi)',                                       '名詞',     14, NULL),
  (sid, l5, 'じてんしゃ',                   'じてんしゃ',                   'jitensha',             'xe đạp',                                              '名詞',     15, '自転車'),
  (sid, l5, 'あるいて',                     'あるいて',                     'aruite',               'đi bộ',                                               '副詞',     16, '歩いて'),
  (sid, l5, 'ひと',                         'ひと',                         'hito',                 'người',                                               '名詞',     17, '人'),
  (sid, l5, 'ともだち',                     'ともだち',                     'tomodachi',            'bạn, bạn bè',                                         '名詞',     18, '友達'),
  (sid, l5, 'かれ',                         'かれ',                         'kare',                 'anh ấy, bạn trai',                                    '名詞',     19, '彼'),
  (sid, l5, 'かのじょ',                     'かのじょ',                     'kanojo',               'chị ấy, bạn gái',                                     '名詞',     20, '彼女'),
  (sid, l5, 'かぞく',                       'かぞく',                       'kazoku',               'gia đình',                                            '名詞',     21, '家族'),
  (sid, l5, 'せんしゅう',                   'せんしゅう',                   'senshuu',              'tuần trước',                                          '名詞',     22, '先週'),
  (sid, l5, 'こんしゅう',                   'こんしゅう',                   'konshuu',              'tuần này',                                            '名詞',     23, '今週'),
  (sid, l5, 'らいしゅう',                   'らいしゅう',                   'raishuu',              'tuần sau',                                            '名詞',     24, '来週'),
  (sid, l5, 'せんげつ',                     'せんげつ',                     'sengetsu',             'tháng trước',                                         '名詞',     25, '先月'),
  (sid, l5, 'こんげつ',                     'こんげつ',                     'kongetsu',             'tháng này',                                           '名詞',     26, '今月'),
  (sid, l5, 'らいげつ',                     'らいげつ',                     'raigetsu',             'tháng sau',                                           '名詞',     27, '来月'),
  (sid, l5, 'きょねん',                     'きょねん',                     'kyonen',               'năm ngoái',                                           '名詞',     28, '去年'),
  (sid, l5, 'ことし',                       'ことし',                       'kotoshi',              'năm nay',                                             '名詞',     29, NULL),
  (sid, l5, 'らいねん',                     'らいねん',                     'rainen',               'năm sau',                                             '名詞',     30, '来年'),
  (sid, l5, '～がつ',                       '～がつ',                       '~ gatsu',              'tháng ~',                                             '接尾辞',   31, '～月'),
  (sid, l5, 'なんがつ',                     'なんがつ',                     'nangatsu',             'tháng mấy',                                           '疑問詞',   32, '何月'),
  (sid, l5, 'ついたち',                     'ついたち',                     'tsuitachi',            'ngày mồng 1',                                         '名詞',     33, '一日'),
  (sid, l5, 'ふつか',                       'ふつか',                       'futsuka',              'ngày mồng 2, 2 ngày',                                 '名詞',     34, '二日'),
  (sid, l5, 'みっか',                       'みっか',                       'mikka',                'ngày mồng 3, 3 ngày',                                 '名詞',     35, '三日'),
  (sid, l5, 'よっか',                       'よっか',                       'yokka',                'ngày mồng 4, 4 ngày',                                 '名詞',     36, '四日'),
  (sid, l5, 'いつか',                       'いつか',                       'itsuka',               'ngày mồng 5, 5 ngày',                                 '名詞',     37, '五日'),
  (sid, l5, 'むいか',                       'むいか',                       'muika',                'ngày mồng 6, 6 ngày',                                 '名詞',     38, '六日'),
  (sid, l5, 'なのか',                       'なのか',                       'nanoka',               'ngày mồng 7, 7 ngày',                                 '名詞',     39, '七日'),
  (sid, l5, 'ようか',                       'ようか',                       'youka',                'ngày mồng 8, 8 ngày',                                 '名詞',     40, '八日'),
  (sid, l5, 'ここのか',                     'ここのか',                     'kokonoka',             'ngày mồng 9, 9 ngày',                                 '名詞',     41, '九日'),
  (sid, l5, 'とおか',                       'とおか',                       'tooka',                'ngày mồng 10, 10 ngày',                               '名詞',     42, '十日'),
  (sid, l5, 'じゅうよっか',                 'じゅうよっか',                 'juuyokka',             'ngày 14, 14 ngày',                                    '名詞',     43, '十四日'),
  (sid, l5, 'はつか',                       'はつか',                       'hatsuka',              'ngày 20, 20 ngày',                                    '名詞',     44, '二十日'),
  (sid, l5, 'にじゅうよっか',               'にじゅうよっか',               'nijuuyokka',           'ngày 24, 24 ngày',                                    '名詞',     45, '二十四日'),
  (sid, l5, '～にち',                       '～にち',                       '~ nichi',              'ngày ~, ~ ngày',                                      '接尾辞',   46, '～日'),
  (sid, l5, 'なんにち',                     'なんにち',                     'nannichi',             'ngày mấy, bao nhiêu ngày',                            '疑問詞',   47, '何日'),
  (sid, l5, 'いつ',                         'いつ',                         'itsu',                 'bao giờ, khi nào',                                    '疑問詞',   48, NULL),
  (sid, l5, 'たんじょうび',                 'たんじょうび',                 'tanjoubi',             'sinh nhật',                                           '名詞',     49, '誕生日'),
  (sid, l5, 'ふつう',                       'ふつう',                       'futsuu',               'tàu thường (dừng cả ở các ga lẻ)',                    '名詞',     50, '普通'),
  (sid, l5, 'きゅうこう',                   'きゅうこう',                   'kyuukou',              'tàu tốc hành',                                        '名詞',     51, '急行'),
  (sid, l5, 'とっきゅう',                   'とっきゅう',                   'tokkyuu',              'tàu tốc hành đặc biệt',                               '名詞',     52, '特急'),
  (sid, l5, 'つぎの',                       'つぎの',                       'tsugi no',             'tiếp theo',                                           '名詞',     53, '次の'),
  (sid, l5, 'どういたしまして',             'どういたしまして',             'dou itashimashite',    'không có chi',                                        '挨拶',     54, NULL);

END $$;
