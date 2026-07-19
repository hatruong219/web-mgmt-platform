-- Seed: Minna no Nihongo — Bài 49-50 (từ vựng)
-- Nguồn: bảng từ vựng user cung cấp (bài 49-50, không có trong PDF Minato Dorimu)
-- Quy tắc: word = kana (+ chú thích sách), reading = CHỈ kana + ～, kanji = kanji (NULL nếu không có)
-- Đã bỏ dòng section header 〈会話〉/〈読み物〉 và dòng trống; sửa lỗi kanji nguồn (勤め増す→勤めます, ご存じます→ご存じです)
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  l49 uuid; l50 uuid;
BEGIN
SELECT id INTO l49 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 49;
SELECT id INTO l50 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 50;
IF l49 IS NULL OR l50 IS NULL THEN
  RAISE EXCEPTION 'mnn_lessons 49-50 chưa được seed';
END IF;

-- ════════════════════════════════════════
-- BÀI 49 — xóa và seed lại (35 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l49;

INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l49, 'りようします',                     'りようします',                     'riyou shimasu',           'sử dụng',                                                    '動詞',     1,  '利用します'),
  (sid, l49, 'つとめます [かいしゃに～]',         'つとめます',                       'tsutomemasu [kaisha ni ~]','làm việc [ở công ty]',                                       '動詞',     2,  '勤めます [会社に～]'),
  (sid, l49, 'かけます [いすに～]',              'かけます',                         'kakemasu [isu ni ~]',     'ngồi xuống [ghế]',                                           '動詞',     3,  '掛けます [いすに～]'),
  (sid, l49, 'すごします',                       'すごします',                       'sugoshimasu',             'trải qua (thời gian)',                                       '動詞',     4,  '過ごします'),
  (sid, l49, 'いらっしゃいます',                 'いらっしゃいます',                 'irasshaimasu',            'đi, ở, đến (kính ngữ của います・いきます・きます)',           '動詞',     5,  NULL),
  (sid, l49, 'めしあがります',                   'めしあがります',                   'meshiagarimasu',          'ăn, uống (kính ngữ của たべます・のみます)',                   '動詞',     6,  '召し上がります'),
  (sid, l49, 'おっしゃいます',                   'おっしゃいます',                   'osshaimasu',              'nói, tên là ~ (kính ngữ của いいます)',                       '動詞',     7,  NULL),
  (sid, l49, 'なさいます',                       'なさいます',                       'nasaimasu',               'làm (kính ngữ của します)',                                   '動詞',     8,  NULL),
  (sid, l49, 'ごらんになります',                 'ごらんになります',                 'goran ni narimasu',       'xem (kính ngữ của みます)',                                   '動詞',     9,  'ご覧になります'),
  (sid, l49, 'ごぞんじです',                     'ごぞんじです',                     'gozonji desu',            'biết (kính ngữ của しっています)',                            '表現',     10, 'ご存じです'),
  (sid, l49, 'あいさつ',                         'あいさつ',                         'aisatsu',                 'chào hỏi (～をします: chào), lời chào mừng',                   '名詞',     11, NULL),
  (sid, l49, 'りょかん',                         'りょかん',                         'ryokan',                  'nhà khách kiểu Nhật truyền thống',                           '名詞',     12, '旅館'),
  (sid, l49, 'バスてい',                         'バスてい',                         'basutei',                 'bến xe buýt',                                                '名詞',     13, 'バス停'),
  (sid, l49, 'おくさま',                         'おくさま',                         'okusama',                 'vợ của người khác (kính ngữ của おくさん)',                    '名詞',     14, '奥様'),
  (sid, l49, '～さま',                           '～さま',                           '~ sama',                  '~ (kính ngữ của ～さん)',                                      '接尾辞',   15, '～様'),
  (sid, l49, 'たまに',                           'たまに',                           'tama ni',                 'thỉnh thoảng',                                               '副詞',     16, NULL),
  (sid, l49, 'どなたでも',                       'どなたでも',                       'donata demo',             'vị nào cũng (kính ngữ của だれでも)',                          '表現',     17, NULL),
  (sid, l49, '～といいます',                     '～といいます',                     '~ to iimasu',             'tên là ~',                                                   '表現',     18, NULL),
  (sid, l49, '～ねん～くみ',                     '～ねん～くみ',                     '~ nen ~ kumi',            'khối ~ lớp ~ (cách gọi lớp học ở trường)',                    '表現',     19, '～年～組'),
  (sid, l49, 'だします [ねつを～]',              'だします',                         'dashimasu [netsu o ~]',   'bị [sốt]',                                                   '動詞',     20, '出します [熱を～]'),
  (sid, l49, 'よろしくおつたえください',         'よろしくおつたえください',         'yoroshiku otsutae kudasai','Cho tôi gửi lời hỏi thăm.',                                  '表現',     21, 'よろしくお伝えください'),
  (sid, l49, 'しつれいいたします',               'しつれいいたします',               'shitsurei itashimasu',    'Tôi xin phép (kính ngữ của しつれいします)',                   '表現',     22, '失礼いたします'),
  (sid, l49, 'ひまわりしょうがっこう',           'ひまわりしょうがっこう',           'Himawari shougakkou',     'trường tiểu học Himawari (tên giả định trong bài)',           '固有名詞', 23, 'ひまわり小学校'),
  (sid, l49, 'けいれき',                         'けいれき',                         'keireki',                 'lí lịch',                                                    '名詞',     24, '経歴'),
  (sid, l49, 'いがくぶ',                         'いがくぶ',                         'igakubu',                 'khoa y',                                                     '名詞',     25, '医学部'),
  (sid, l49, 'めざします',                       'めざします',                       'mezashimasu',             'hướng đến, muốn trở thành',                                  '動詞',     26, '目指します'),
  (sid, l49, 'すすみます',                       'すすみます',                       'susumimasu',              'học lên, tiến lên',                                          '動詞',     27, '進みます'),
  (sid, l49, 'iPSさいぼう',                       'アイピーエスさいぼう',             'iPS saibou',              'tế bào iPS',                                                 '名詞',     28, 'iPS細胞'),
  (sid, l49, 'かいはつします',                   'かいはつします',                   'kaihatsu shimasu',        'phát triển',                                                 '動詞',     29, '開発します'),
  (sid, l49, 'マウス',                           'マウス',                           'mausu',                   'chuột (động vật thí nghiệm)',                                '名詞',     30, NULL),
  (sid, l49, 'ヒト',                             'ヒト',                             'hito',                    'con người (sinh học)',                                       '名詞',     31, NULL),
  (sid, l49, 'じゅしょうします',                 'じゅしょうします',                 'jushou shimasu',          'nhận giải thưởng',                                           '動詞',     32, '受賞します'),
  (sid, l49, 'こうえんかい',                     'こうえんかい',                     'kouenkai',                'buổi nói chuyện, buổi diễn thuyết',                          '名詞',     33, '講演会'),
  (sid, l49, 'やまなかしんや',                   'やまなかしんや',                   'Yamanaka Shinya',         'Yamanaka Shinya (nhà nghiên cứu người Nhật, 1962-)',          '固有名詞', 34, '山中伸弥'),
  (sid, l49, 'ノーベルしょう',                   'ノーベルしょう',                   'Nooberu shou',            'giải Nobel',                                                 '名詞',     35, 'ノーベル賞');

-- ════════════════════════════════════════
-- BÀI 50 — xóa và seed lại (33 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l50;

INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l50, 'まいります',                       'まいります',                       'mairimasu',               'đi, đến (khiêm nhường ngữ của いきます・きます)',              '動詞',     1,  '参ります'),
  (sid, l50, 'おります',                         'おります',                         'orimasu',                 'ở (khiêm nhường ngữ của います)',                             '動詞',     2,  NULL),
  (sid, l50, 'いただきます',                     'いただきます',                     'itadakimasu',             'ăn, uống, nhận (khiêm nhường ngữ của たべます・のみます・もらいます)', '動詞', 3, NULL),
  (sid, l50, 'もうします',                       'もうします',                       'moushimasu',              'nói, tên là ~ (khiêm nhường ngữ của いいます)',                '動詞',     4,  '申します'),
  (sid, l50, 'いたします',                       'いたします',                       'itashimasu',              'làm (khiêm nhường ngữ của します)',                           '動詞',     5,  NULL),
  (sid, l50, 'はいけんします',                   'はいけんします',                   'haiken shimasu',          'xem (khiêm nhường ngữ của みます)',                           '動詞',     6,  '拝見します'),
  (sid, l50, 'ぞんじます',                       'ぞんじます',                       'zonjimasu',               'biết (khiêm nhường ngữ của しります)',                        '動詞',     7,  '存じます'),
  (sid, l50, 'うかがいます',                     'うかがいます',                     'ukagaimasu',              'hỏi, đến thăm (khiêm nhường ngữ của ききます・いきます)',       '動詞',     8,  '伺います'),
  (sid, l50, 'おめにかかります',                 'おめにかかります',                 'ome ni kakarimasu',       'gặp (khiêm nhường ngữ của あいます)',                         '動詞',     9,  'お目にかかります'),
  (sid, l50, 'いれます [コーヒーを～]',          'いれます',                         'iremasu [koohii o ~]',    'pha [cà phê]',                                               '動詞',     10, '入れます [コーヒーを～]'),
  (sid, l50, 'よういします',                     'よういします',                     'youi shimasu',            'chuẩn bị sẵn',                                               '動詞',     11, '用意します'),
  (sid, l50, 'わたくし',                         'わたくし',                         'watakushi',               'tôi (khiêm nhường ngữ của わたし)',                           '代名詞',   12, '私'),
  (sid, l50, 'ガイド',                           'ガイド',                           'gaido',                   'hướng dẫn viên du lịch',                                     '名詞',     13, NULL),
  (sid, l50, 'メールアドレス',                   'メールアドレス',                   'meeru adoresu',           'địa chỉ email',                                              '名詞',     14, NULL),
  (sid, l50, 'スケジュール',                     'スケジュール',                     'sukejuuru',               'lịch làm việc',                                              '名詞',     15, NULL),
  (sid, l50, 'さらいしゅう',                     'さらいしゅう',                     'saraishuu',               'tuần sau nữa',                                               '名詞',     16, '再来週'),
  (sid, l50, 'さらいげつ',                       'さらいげつ',                       'saraigetsu',              'tháng sau nữa',                                              '名詞',     17, '再来月'),
  (sid, l50, 'さらいねん',                       'さらいねん',                       'sarainen',                'năm sau nữa',                                                '名詞',     18, '再来年'),
  (sid, l50, 'はじめに',                         'はじめに',                         'hajime ni',               'trước hết, đầu tiên',                                        '副詞',     19, '初めに'),
  (sid, l50, 'えどとうきょうはくぶつかん',       'えどとうきょうはくぶつかん',       'Edo Toukyou hakubutsukan','Bảo tàng Edo-Tokyo',                                         '固有名詞', 20, '江戸東京博物館'),
  (sid, l50, 'きんちょうします',                 'きんちょうします',                 'kinchou shimasu',         'hồi hộp, căng thẳng',                                        '動詞',     21, '緊張します'),
  (sid, l50, 'しょうきん',                       'しょうきん',                       'shoukin',                 'tiền thưởng',                                                '名詞',     22, '賞金'),
  (sid, l50, 'きりん',                           'きりん',                           'kirin',                   'hươu cao cổ',                                                '名詞',     23, NULL),
  (sid, l50, 'ころ',                             'ころ',                             'koro',                    'lúc, thời, khoảng',                                          '名詞',     24, NULL),
  (sid, l50, 'かないます [ゆめが～]',            'かないます',                       'kanaimasu [yume ga ~]',   'thành hiện thực [ước mơ ~]',                                 '動詞',     25, NULL),
  (sid, l50, 'おうえんします',                   'おうえんします',                   'ouen shimasu',            'động viên, cổ vũ',                                           '動詞',     26, '応援します'),
  (sid, l50, 'こころから',                       'こころから',                       'kokoro kara',             'từ đáy lòng',                                                '副詞',     27, '心から'),
  (sid, l50, 'かんしゃします',                   'かんしゃします',                   'kansha shimasu',          'cảm ơn, biết ơn',                                            '動詞',     28, '感謝します'),
  (sid, l50, 'おれい',                           'おれい',                           'orei',                    'lời cảm ơn',                                                 '名詞',     29, 'お礼'),
  (sid, l50, 'おげんきでいらっしゃいますか',     'おげんきでいらっしゃいますか',     'ogenki de irasshaimasu ka','Anh/Chị có khỏe không ạ? (kính ngữ của おげんきですか)',       '表現',     30, 'お元気でいらっしゃいますか'),
  (sid, l50, 'めいわくをかけます',               'めいわくをかけます',               'meiwaku o kakemasu',      'làm phiền',                                                  '動詞',     31, '迷惑をかけます'),
  (sid, l50, 'いかします',                       'いかします',                       'ikashimasu',              'phát huy, tận dụng',                                         '動詞',     32, '生かします'),
  (sid, l50, 'ミュンヘン',                       'ミュンヘン',                       'Myunhen',                 'München (Đức)',                                              '固有名詞', 33, NULL);

END $$;
