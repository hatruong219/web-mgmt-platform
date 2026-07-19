-- Seed: Minna no Nihongo I — Bài 6 (từ vựng)
-- Quy tắc: word = kana, reading = kana, kanji = kanji (nếu có, không thì NULL)
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c

ALTER TABLE mnn_vocabulary ADD COLUMN IF NOT EXISTS kanji text;

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  l6  uuid;
BEGIN

-- Bài 6 chưa có trong mnn_lessons → tạo mới (idempotent)
INSERT INTO mnn_lessons (site_id, lesson_number, title_vi, situation_vi, order_index) VALUES
  (sid, 6, '～を ～ます', 'Ngoại động từ (tân ngữ + を), rủ mời làm gì', 6)
ON CONFLICT (site_id, lesson_number) DO NOTHING;

SELECT id INTO l6 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 6;

-- ════════════════════════════════════════
-- BÀI 6 — xóa và seed lại (53 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l6;

INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l6, 'たべます',                   'たべます',                   'tabemasu',             'ăn',                                                   '動詞',   1,  '食べます'),
  (sid, l6, 'のみます',                   'のみます',                   'nomimasu',             'uống',                                                 '動詞',   2,  '飲みます'),
  (sid, l6, 'すいます [たばこを～]',       'すいます',                   'suimasu [tabako o ~]', 'hút [thuốc lá]',                                       '動詞',   3,  '吸います'),
  (sid, l6, 'みます',                     'みます',                     'mimasu',               'xem, nhìn, trông',                                     '動詞',   4,  '見ます'),
  (sid, l6, 'ききます',                   'ききます',                   'kikimasu',             'nghe',                                                 '動詞',   5,  '聞きます'),
  (sid, l6, 'よみます',                   'よみます',                   'yomimasu',             'đọc',                                                  '動詞',   6,  '読みます'),
  (sid, l6, 'かきます',                   'かきます',                   'kakimasu',             'viết, vẽ',                                             '動詞',   7,  '書きます'),
  (sid, l6, 'かいます',                   'かいます',                   'kaimasu',              'mua',                                                  '動詞',   8,  '買います'),
  (sid, l6, 'とります [しゃしんを～]',     'とります',                   'torimasu [shashin o ~]','chụp [ảnh]',                                          '動詞',   9,  '撮ります [写真を～]'),
  (sid, l6, 'します',                     'します',                     'shimasu',              'làm',                                                  '動詞',   10, NULL),
  (sid, l6, 'あいます [ともだちに～]',     'あいます',                   'aimasu [tomodachi ni ~]','gặp [bạn]',                                          '動詞',   11, '会います [友達に～]'),
  (sid, l6, 'ごはん',                     'ごはん',                     'gohan',                'cơm, bữa ăn',                                          '名詞',   12, NULL),
  (sid, l6, 'あさごはん',                 'あさごはん',                 'asagohan',             'cơm sáng',                                             '名詞',   13, '朝ごはん'),
  (sid, l6, 'ひるごはん',                 'ひるごはん',                 'hirugohan',            'cơm trưa',                                             '名詞',   14, '昼ごはん'),
  (sid, l6, 'ばんごはん',                 'ばんごはん',                 'bangohan',             'cơm tối',                                              '名詞',   15, '晩ごはん'),
  (sid, l6, 'パン',                       'パン',                       'pan',                  'bánh mì',                                              '名詞',   16, NULL),
  (sid, l6, 'たまご',                     'たまご',                     'tamago',               'trứng',                                                '名詞',   17, '卵'),
  (sid, l6, 'にく',                       'にく',                       'niku',                 'thịt',                                                 '名詞',   18, '肉'),
  (sid, l6, 'さかな',                     'さかな',                     'sakana',               'cá',                                                   '名詞',   19, '魚'),
  (sid, l6, 'やさい',                     'やさい',                     'yasai',                'rau',                                                  '名詞',   20, '野菜'),
  (sid, l6, 'くだもの',                   'くだもの',                   'kudamono',             'hoa quả, trái cây',                                    '名詞',   21, '果物'),
  (sid, l6, 'みず',                       'みず',                       'mizu',                 'nước',                                                 '名詞',   22, '水'),
  (sid, l6, 'おちゃ',                     'おちゃ',                     'ocha',                 'trà (nói chung)',                                      '名詞',   23, 'お茶'),
  (sid, l6, 'こうちゃ',                   'こうちゃ',                   'koucha',               'trà đen',                                              '名詞',   24, '紅茶'),
  (sid, l6, 'ぎゅうにゅう (ミルク)',       'ぎゅうにゅう',               'gyuunyuu (miruku)',    'sữa bò',                                               '名詞',   25, '牛乳'),
  (sid, l6, 'ジュース',                   'ジュース',                   'juusu',                'nước hoa quả',                                         '名詞',   26, NULL),
  (sid, l6, 'ビール',                     'ビール',                     'biiru',                'bia',                                                  '名詞',   27, NULL),
  (sid, l6, '[お]さけ',                   'おさけ',                     '[o]sake',              'rượu, rượu sake',                                      '名詞',   28, '[お]酒'),
  (sid, l6, 'ビデオ',                     'ビデオ',                     'bideo',                'video, băng video, đầu video',                         '名詞',   29, NULL),
  (sid, l6, 'えいが',                     'えいが',                     'eiga',                 'phim, điện ảnh',                                       '名詞',   30, '映画'),
  (sid, l6, 'ＣＤ',                        'ＣＤ',                        'CD',                   'đĩa CD',                                               '名詞',   31, NULL),
  (sid, l6, 'てがみ',                     'てがみ',                     'tegami',               'thư',                                                  '名詞',   32, '手紙'),
  (sid, l6, 'レポート',                   'レポート',                   'repooto',              'báo cáo',                                              '名詞',   33, NULL),
  (sid, l6, 'しゃしん',                   'しゃしん',                   'shashin',              'ảnh',                                                  '名詞',   34, '写真'),
  (sid, l6, 'みせ',                       'みせ',                       'mise',                 'cửa hàng, tiệm',                                       '名詞',   35, '店'),
  (sid, l6, 'レストラン',                 'レストラン',                 'resutoran',            'nhà hàng',                                             '名詞',   36, NULL),
  (sid, l6, 'にわ',                       'にわ',                       'niwa',                 'vườn',                                                 '名詞',   37, '庭'),
  (sid, l6, 'しゅくだい',                 'しゅくだい',                 'shukudai',             'bài tập về nhà (～をします: làm bài tập)',              '名詞',   38, '宿題'),
  (sid, l6, 'テニス',                     'テニス',                     'tenisu',               'quần vợt (～をします: đánh quần vợt)',                  '名詞',   39, NULL),
  (sid, l6, 'サッカー',                   'サッカー',                   'sakkaa',               'bóng đá (～をします: chơi bóng đá)',                    '名詞',   40, NULL),
  (sid, l6, '[お]はなみ',                 'おはなみ',                   '[o]hanami',            'việc ngắm hoa anh đào (～をします: ngắm hoa anh đào)',  '名詞',   41, '[お]花見'),
  (sid, l6, 'なに',                       'なに',                       'nani',                 'cái gì, gì',                                           '疑問詞', 42, '何'),
  (sid, l6, 'いっしょに',                 'いっしょに',                 'isshoni',              'cùng, cùng nhau',                                      '副詞',   43, NULL),
  (sid, l6, 'ちょっと',                   'ちょっと',                   'chotto',               'một chút',                                             '副詞',   44, NULL),
  (sid, l6, 'いつも',                     'いつも',                     'itsumo',               'luôn luôn, lúc nào cũng',                              '副詞',   45, NULL),
  (sid, l6, 'ときどき',                   'ときどき',                   'tokidoki',             'thỉnh thoảng',                                         '副詞',   46, '時々'),
  (sid, l6, 'それから',                   'それから',                   'sorekara',             'sau đó, tiếp theo',                                    '接続詞', 47, NULL),
  (sid, l6, 'ええ',                       'ええ',                       'ee',                   'vâng, được (cách nói thân mật của「はい」)',            '感動詞', 48, NULL),
  (sid, l6, 'いいですね。',               'いいですね。',               'ii desu ne.',          'Được đấy nhỉ./ hay quá.',                              '表現',   49, NULL),
  (sid, l6, 'わかりました。',             'わかりました。',             'wakarimashita.',       'Tôi hiểu rồi/ vâng ạ.',                                '表現',   50, NULL),
  (sid, l6, 'なんですか',                 'なんですか',                 'nan desu ka',          'Có gì đấy ạ?/ cái gì vậy?/ vâng có tôi.',              '表現',   51, '何ですか。'),
  (sid, l6, 'じゃ、また[あした]。',       'じゃ、また[あした]。',       'ja, mata [ashita].',   'Hẹn gặp lại [ngày mai].',                              '挨拶',   52, NULL),
  (sid, l6, 'メキシコ',                   'メキシコ',                   'mekishiko',            'Mexico',                                               '名詞',   53, NULL);

END $$;
