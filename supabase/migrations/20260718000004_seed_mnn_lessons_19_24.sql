-- Seed: Minna no Nihongo — Bài 19-24 (từ vựng)
-- Nguồn: PDF Minato Dorimu, đối chiếu + sửa lỗi theo danh mục từ vựng MNN chuẩn
-- Quy tắc: word = kana (+ chú thích sách), reading = CHỈ kana + ～, kanji = kanji (NULL nếu không có)
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c
--
-- Sửa lỗi PDF đáng chú ý:
--   Bài 20: "ビザが～いります" → chuẩn hóa thành いります [ビザが～]
--   Bài 21: どっち PDF ghi "ở đâu" → sửa "phía nào, cái nào"
--   Bài 22: コートー → コート; わしつ PDF ghi "phòng ăn kiểu Nhật" → sửa "phòng kiểu Nhật"
--   Bài 23: ひっこししします (thừa し) → ひっこしします
--   Bài 24: tách おばあさん／おばあちゃん thành 2 row; bổ sung おじいちゃん (chuẩn MNN có cặp đối xứng)

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  l19 uuid; l20 uuid; l21 uuid; l22 uuid; l23 uuid; l24 uuid;
BEGIN
SELECT id INTO l19 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 19;
SELECT id INTO l20 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 20;
SELECT id INTO l21 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 21;
SELECT id INTO l22 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 22;
SELECT id INTO l23 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 23;
SELECT id INTO l24 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 24;

-- ════════════════════════════════════════
-- BÀI 19 — xóa và seed lại (30 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l19;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l19, 'のぼります',             'のぼります',             'noborimasu',           'leo (núi)',                                            '動詞',     1,  '登ります'),
  (sid, l19, 'れんしゅうします',       'れんしゅうします',       'renshuu shimasu',      'luyện tập, thực hành',                                 '動詞',     2,  '練習します'),
  (sid, l19, 'そうじします',           'そうじします',           'souji shimasu',        'dọn dẹp, lau dọn',                                     '動詞',     3,  '掃除します'),
  (sid, l19, 'せんたくします',         'せんたくします',         'sentaku shimasu',      'giặt giũ',                                             '動詞',     4,  '洗濯します'),
  (sid, l19, 'なります',               'なります',               'narimasu',             'trở nên, trở thành',                                   '動詞',     5,  NULL),
  (sid, l19, 'とまります',             'とまります',             'tomarimasu',           'trọ, nghỉ lại (khách sạn)',                            '動詞',     6,  '泊まります'),
  (sid, l19, 'ねむい',                 'ねむい',                 'nemui',                'buồn ngủ',                                             'い形容詞', 7,  '眠い'),
  (sid, l19, 'つよい',                 'つよい',                 'tsuyoi',               'mạnh',                                                 'い形容詞', 8,  '強い'),
  (sid, l19, 'よわい',                 'よわい',                 'yowai',                'yếu',                                                  'い形容詞', 9,  '弱い'),
  (sid, l19, 'ちょうし',               'ちょうし',               'choushi',              'tình trạng, trạng thái',                               '名詞',     10, '調子'),
  (sid, l19, 'ちょうしがわるい',       'ちょうしがわるい',       'choushi ga warui',     'tình trạng xấu, không được tốt',                       '表現',     11, '調子が悪い'),
  (sid, l19, 'ちょうしがいい',         'ちょうしがいい',         'choushi ga ii',        'tình trạng tốt',                                       '表現',     12, '調子がいい'),
  (sid, l19, 'おちゃ',                 'おちゃ',                 'ocha',                 'trà đạo',                                              '名詞',     13, 'お茶'),
  (sid, l19, 'すもう',                 'すもう',                 'sumou',                'vật sumo',                                             '名詞',     14, '相撲'),
  (sid, l19, 'パチンコ',               'パチンコ',               'pachinko',             'pachinko (trò chơi giải trí của Nhật)',                '名詞',     15, NULL),
  (sid, l19, 'ゴルフ',                 'ゴルフ',                 'gorufu',               'gôn (golf)',                                           '名詞',     16, NULL),
  (sid, l19, 'ひ',                     'ひ',                     'hi',                   'ngày',                                                 '名詞',     17, '日'),
  (sid, l19, 'もうすぐ',               'もうすぐ',               'mou sugu',             'sắp sửa, sắp',                                         '副詞',     18, NULL),
  (sid, l19, 'だんだん',               'だんだん',               'dandan',               'dần dần',                                              '副詞',     19, NULL),
  (sid, l19, 'いちど',                 'いちど',                 'ichido',               'một lần',                                              '副詞',     20, '一度'),
  (sid, l19, 'いちども',               'いちども',               'ichido mo',            'chưa một lần nào (dùng với phủ định)',                 '副詞',     21, '一度も'),
  (sid, l19, 'おかげさまで',           'おかげさまで',           'okagesama de',         'nhờ ơn anh/chị (đáp lễ khi được hỏi thăm, giúp đỡ)',   '表現',     22, NULL),
  (sid, l19, 'かんぱい',               'かんぱい',               'kanpai',               'cạn chén, nâng cốc',                                   '感動詞',   23, '乾杯'),
  (sid, l19, 'じつは',                 'じつは',                 'jitsu wa',             'thực ra là, nói thật là',                              '副詞',     24, '実は'),
  (sid, l19, 'ダイエット',             'ダイエット',             'daietto',              'ăn kiêng',                                             '名詞',     25, NULL),
  (sid, l19, 'なんかいも',             'なんかいも',             'nankai mo',            'nhiều lần',                                            '副詞',     26, '何回も'),
  (sid, l19, 'しかし',                 'しかし',                 'shikashi',             'tuy nhiên, nhưng',                                     '接続詞',   27, NULL),
  (sid, l19, 'むり [な]',              'むり',                   'muri [na]',            'quá sức, không thể được',                              'な形容詞', 28, '無理 [な]'),
  (sid, l19, 'からだにいい',           'からだにいい',           'karada ni ii',         'tốt cho sức khỏe',                                     '表現',     29, '体にいい'),
  (sid, l19, 'ケーキ',                 'ケーキ',                 'keeki',                'bánh ga-tô',                                           '名詞',     30, NULL);

-- ════════════════════════════════════════
-- BÀI 20 — xóa và seed lại (29 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l20;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l20, 'いります [ビザが～]',    'いります',               'irimasu [biza ga ~]',  'cần [visa]',                                           '動詞',     1,  '要ります [ビザが～]'),
  (sid, l20, 'しらべます',             'しらべます',             'shirabemasu',          'tìm hiểu, điều tra',                                   '動詞',     2,  '調べます'),
  (sid, l20, 'なおします',             'なおします',             'naoshimasu',           'sửa, chữa',                                            '動詞',     3,  '直します'),
  (sid, l20, 'しゅうりします',         'しゅうりします',         'shuuri shimasu',       'sửa chữa, tu sửa',                                     '動詞',     4,  '修理します'),
  (sid, l20, 'でんわします',           'でんわします',           'denwa shimasu',        'gọi điện thoại',                                       '動詞',     5,  '電話します'),
  (sid, l20, 'ぼく',                   'ぼく',                   'boku',                 'tớ, mình (nam giới, thân mật)',                        '代名詞',   6,  '僕'),
  (sid, l20, 'きみ',                   'きみ',                   'kimi',                 'cậu, bạn (thân mật)',                                  '代名詞',   7,  '君'),
  (sid, l20, '～くん',                 '～くん',                 '~ kun',                'hậu tố thân mật đặt sau tên con trai',                 '接尾辞',   8,  '～君'),
  (sid, l20, 'うん',                   'うん',                   'un',                   'ừ, có (cách nói thân mật của はい)',                   '感動詞',   9,  NULL),
  (sid, l20, 'ううん',                 'ううん',                 'uun',                  'không (cách nói thân mật của いいえ)',                 '感動詞',   10, NULL),
  (sid, l20, 'サラリーマン',           'サラリーマン',           'sarariiman',           'nhân viên công ty, người làm công ăn lương',           '名詞',     11, NULL),
  (sid, l20, 'ことば',                 'ことば',                 'kotoba',               'từ, tiếng, ngôn ngữ',                                  '名詞',     12, '言葉'),
  (sid, l20, 'ぶっか',                 'ぶっか',                 'bukka',                'giá cả, vật giá',                                      '名詞',     13, '物価'),
  (sid, l20, 'きもの',                 'きもの',                 'kimono',               'kimono (trang phục truyền thống của Nhật Bản)',        '名詞',     14, '着物'),
  (sid, l20, 'ビザ',                   'ビザ',                   'biza',                 'visa, thị thực',                                       '名詞',     15, NULL),
  (sid, l20, 'はじめ',                 'はじめ',                 'hajime',               'bắt đầu, đầu',                                         '名詞',     16, '初め'),
  (sid, l20, 'おわり',                 'おわり',                 'owari',                'kết thúc, cuối',                                       '名詞',     17, '終わり'),
  (sid, l20, 'こっち',                 'こっち',                 'kocchi',               'phía này (cách nói thân mật của こちら)',              '指示語',   18, NULL),
  (sid, l20, 'そっち',                 'そっち',                 'socchi',               'phía đó (cách nói thân mật của そちら)',               '指示語',   19, NULL),
  (sid, l20, 'あっち',                 'あっち',                 'acchi',                'phía kia (cách nói thân mật của あちら)',              '指示語',   20, NULL),
  (sid, l20, 'どっち',                 'どっち',                 'docchi',               'phía nào, cái nào (cách nói thân mật của どちら)',     '疑問詞',   21, NULL),
  (sid, l20, 'このあいだ',             'このあいだ',             'kono aida',            'hôm nọ, mới đây',                                      '副詞',     22, 'この間'),
  (sid, l20, 'みんなで',               'みんなで',               'minna de',             'tất cả cùng nhau, mọi người cùng',                     '副詞',     23, NULL),
  (sid, l20, '～けど',                 '～けど',                 '~ kedo',               'nhưng (cách nói thân mật của ～が)',                   '助詞',     24, NULL),
  (sid, l20, 'くにへかえるの',         'くにへかえるの',         'kuni e kaeru no',      'Anh/chị về nước à?',                                   '表現',     25, '国へ帰るの'),
  (sid, l20, 'どうするの',             'どうするの',             'dou suru no',          'Anh/chị tính sao? / Định làm thế nào?',                '表現',     26, NULL),
  (sid, l20, 'どうしようかな',         'どうしようかな',         'dou shiyou ka na',     'Tính sao đây / để tôi xem',                            '表現',     27, NULL),
  (sid, l20, 'よかったら',             'よかったら',             'yokattara',            'nếu anh/chị thích thì',                                '表現',     28, NULL),
  (sid, l20, 'いろいろ',               'いろいろ',               'iroiro',               'nhiều thứ, đa dạng',                                   '副詞',     29, NULL);

-- ════════════════════════════════════════
-- BÀI 21 — xóa và seed lại (35 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l21;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l21, 'おもいます',             'おもいます',             'omoimasu',             'nghĩ',                                                 '動詞',     1,  '思います'),
  (sid, l21, 'いいます',               'いいます',               'iimasu',               'nói',                                                  '動詞',     2,  '言います'),
  (sid, l21, 'たります',               'たります',               'tarimasu',             'đủ',                                                   '動詞',     3,  '足ります'),
  (sid, l21, 'かちます',               'かちます',               'kachimasu',            'thắng',                                                '動詞',     4,  '勝ちます'),
  (sid, l21, 'まけます',               'まけます',               'makemasu',             'thua',                                                 '動詞',     5,  '負けます'),
  (sid, l21, 'あります [おまつりが～]', 'あります',              'arimasu [omatsuri ga ~]', 'được tổ chức [lễ hội]',                             '動詞',     6,  NULL),
  (sid, l21, 'やくにたちます',         'やくにたちます',         'yaku ni tachimasu',    'giúp ích, có ích',                                     '動詞',     7,  '役に立ちます'),
  (sid, l21, 'むだ',                   'むだ',                   'muda',                 'vô ích, lãng phí',                                     'な形容詞', 8,  '無駄'),
  (sid, l21, 'ふべん',                 'ふべん',                 'fuben',                'bất tiện',                                             'な形容詞', 9,  '不便'),
  (sid, l21, 'おなじ',                 'おなじ',                 'onaji',                'giống, giống nhau',                                    'な形容詞', 10, '同じ'),
  (sid, l21, 'すごい',                 'すごい',                 'sugoi',                'giỏi, tuyệt, ghê gớm',                                 'い形容詞', 11, NULL),
  (sid, l21, 'しゅしょう',             'しゅしょう',             'shushou',              'thủ tướng',                                            '名詞',     12, '首相'),
  (sid, l21, 'だいとうりょう',         'だいとうりょう',         'daitouryou',           'tổng thống',                                           '名詞',     13, '大統領'),
  (sid, l21, 'せいじ',                 'せいじ',                 'seiji',                'chính trị',                                            '名詞',     14, '政治'),
  (sid, l21, 'ニュース',               'ニュース',               'nyuusu',               'tin tức',                                              '名詞',     15, NULL),
  (sid, l21, 'スピーチ',               'スピーチ',               'supiichi',             'bài phát biểu, diễn thuyết',                           '名詞',     16, NULL),
  (sid, l21, 'しあい',                 'しあい',                 'shiai',                'trận đấu',                                             '名詞',     17, '試合'),
  (sid, l21, 'アルバイト',             'アルバイト',             'arubaito',             'việc làm thêm',                                        '名詞',     18, NULL),
  (sid, l21, 'いけん',                 'いけん',                 'iken',                 'ý kiến',                                               '名詞',     19, '意見'),
  (sid, l21, 'はなし',                 'はなし',                 'hanashi',              'câu chuyện, bài nói chuyện',                           '名詞',     20, '話'),
  (sid, l21, 'ユーモア',               'ユーモア',               'yuumoa',               'sự hài hước, u-mua',                                   '名詞',     21, NULL),
  (sid, l21, 'デザイン',               'デザイン',               'dezain',               'thiết kế',                                             '名詞',     22, NULL),
  (sid, l21, 'こうつう',               'こうつう',               'koutsuu',              'giao thông',                                           '名詞',     23, '交通'),
  (sid, l21, 'ラッシュ',               'ラッシュ',               'rasshu',               'giờ cao điểm',                                         '名詞',     24, NULL),
  (sid, l21, 'さいきん',               'さいきん',               'saikin',               'gần đây',                                              '副詞',     25, '最近'),
  (sid, l21, 'たぶん',                 'たぶん',                 'tabun',                'có lẽ, chắc là',                                       '副詞',     26, NULL),
  (sid, l21, 'きっと',                 'きっと',                 'kitto',                'chắc chắn, nhất định',                                 '副詞',     27, NULL),
  (sid, l21, 'ほんとうに',             'ほんとうに',             'hontou ni',            'thật sự',                                              '副詞',     28, '本当に'),
  (sid, l21, 'そんなに',               'そんなに',               'sonna ni',             '(không) ~ đến thế, (không) ~ lắm',                     '副詞',     29, NULL),
  (sid, l21, '～について',             '～について',             '~ ni tsuite',          'về ~, liên quan đến ~',                                '表現',     30, NULL),
  (sid, l21, 'しかたがありません',     'しかたがありません',     'shikata ga arimasen',  'không còn cách nào khác, đành chịu',                   '表現',     31, '仕方がありません'),
  (sid, l21, 'しばらくですね',         'しばらくですね',         'shibaraku desu ne',    'Lâu rồi không gặp',                                    '挨拶',     32, NULL),
  (sid, l21, 'みないと…',              'みないと',               'minai to',             'phải xem mới được (không xem không được)',             '表現',     33, '見ないと…'),
  (sid, l21, 'もちろん',               'もちろん',               'mochiron',             'tất nhiên, dĩ nhiên',                                  '副詞',     34, NULL),
  (sid, l21, 'カンガルー',             'カンガルー',             'kangaruu',             'con căng-gu-ru, chuột túi',                            '名詞',     35, NULL);

-- ════════════════════════════════════════
-- BÀI 22 — xóa và seed lại (21 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l22;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l22, 'きます [シャツを～]',    'きます',                 'kimasu [shatsu o ~]',  'mặc [áo sơ mi, áo]',                                   '動詞',     1,  '着ます [シャツを～]'),
  (sid, l22, 'はきます [くつを～]',    'はきます',               'hakimasu [kutsu o ~]', 'đi [giày], mặc [quần, váy]',                           '動詞',     2,  NULL),
  (sid, l22, 'かぶります [ぼうしを～]', 'かぶります',            'kaburimasu [boushi o ~]', 'đội [mũ, nón]',                                     '動詞',     3,  NULL),
  (sid, l22, 'かけます [めがねを～]',  'かけます',               'kakemasu [megane o ~]', 'đeo [kính]',                                          '動詞',     4,  NULL),
  (sid, l22, 'うまれます',             'うまれます',             'umaremasu',            'sinh ra, được sinh ra',                                '動詞',     5,  '生まれます'),
  (sid, l22, 'コート',                 'コート',                 'kooto',                'áo khoác',                                             '名詞',     6,  NULL),
  (sid, l22, 'スーツ',                 'スーツ',                 'suutsu',               'com-lê',                                               '名詞',     7,  NULL),
  (sid, l22, 'セーター',               'セーター',               'seetaa',               'áo len',                                               '名詞',     8,  NULL),
  (sid, l22, 'ぼうし',                 'ぼうし',                 'boushi',               'mũ, nón',                                              '名詞',     9,  '帽子'),
  (sid, l22, 'めがね',                 'めがね',                 'megane',               'kính',                                                 '名詞',     10, '眼鏡'),
  (sid, l22, 'よく',                   'よく',                   'yoku',                 'thường, hay',                                          '副詞',     11, NULL),
  (sid, l22, 'おめでとうございます',   'おめでとうございます',   'omedetou gozaimasu',   'chúc mừng',                                            '挨拶',     12, NULL),
  (sid, l22, 'こちら',                 'こちら',                 'kochira',              'đây, cái này (cách nói lịch sự của これ)',             '指示語',   13, NULL),
  (sid, l22, 'やちん',                 'やちん',                 'yachin',               'tiền thuê nhà, tiền nhà',                              '名詞',     14, '家賃'),
  (sid, l22, 'うーん',                 'うーん',                 'uun',                  'ừ-m, để tôi xem (từ đệm khi suy nghĩ)',                '感動詞',   15, NULL),
  (sid, l22, 'ダイニングキッチン',     'ダイニングキッチン',     'dainingu kicchin',     'bếp kèm phòng ăn',                                     '名詞',     16, NULL),
  (sid, l22, 'わしつ',                 'わしつ',                 'washitsu',             'phòng kiểu Nhật',                                      '名詞',     17, '和室'),
  (sid, l22, 'おしいれ',               'おしいれ',               'oshiire',              'ô tường đựng chăn đệm trong phòng kiểu Nhật',          '名詞',     18, '押し入れ'),
  (sid, l22, 'ふとん',                 'ふとん',                 'futon',                'chăn, đệm (kiểu Nhật)',                                '名詞',     19, '布団'),
  (sid, l22, 'アパート',               'アパート',               'apaato',               'nhà chung cư, căn hộ',                                 '名詞',     20, NULL),
  (sid, l22, 'パリ',                   'パリ',                   'Pari',                 'Pa-ri',                                                '固有名詞', 21, NULL);

-- ════════════════════════════════════════
-- BÀI 23 — xóa và seed lại (28 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l23;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l23, 'ききます [せんせいに～]', 'ききます',              'kikimasu [sensei ni ~]', 'hỏi [giáo viên]',                                    '動詞',     1,  '聞きます [先生に～]'),
  (sid, l23, 'まわします',             'まわします',             'mawashimasu',          'vặn, xoay (núm)',                                      '動詞',     2,  '回します'),
  (sid, l23, 'ひきます',               'ひきます',               'hikimasu',             'kéo',                                                  '動詞',     3,  '引きます'),
  (sid, l23, 'かえます',               'かえます',               'kaemasu',              'đổi, thay đổi',                                        '動詞',     4,  '変えます'),
  (sid, l23, 'さわります',             'さわります',             'sawarimasu',           'sờ, chạm vào',                                         '動詞',     5,  '触ります'),
  (sid, l23, 'でます',                 'でます',                 'demasu',               'ra, chạy ra (tiền thừa)',                              '動詞',     6,  '出ます'),
  (sid, l23, 'うごきます',             'うごきます',             'ugokimasu',            'chuyển động, chạy (máy móc, đồng hồ)',                 '動詞',     7,  '動きます'),
  (sid, l23, 'あるきます',             'あるきます',             'arukimasu',            'đi bộ (trên đường)',                                   '動詞',     8,  '歩きます'),
  (sid, l23, 'わたります',             'わたります',             'watarimasu',           'đi qua, băng qua (cầu, đường)',                        '動詞',     9,  '渡ります'),
  (sid, l23, 'きをつけます',           'きをつけます',           'ki o tsukemasu',       'chú ý, cẩn thận',                                      '動詞',     10, '気をつけます'),
  (sid, l23, 'ひっこしします',         'ひっこしします',         'hikkoshi shimasu',     'chuyển nhà',                                           '動詞',     11, '引っ越しします'),
  (sid, l23, 'でんきや',               'でんきや',               'denkiya',              'cửa hàng đồ điện',                                     '名詞',     12, '電気屋'),
  (sid, l23, 'こしょう',               'こしょう',               'koshou',               'hỏng, trục trặc (máy móc)',                            '名詞',     13, '故障'),
  (sid, l23, '～や',                   '～や',                   '~ ya',                 'cửa hàng ~, tiệm ~',                                   '接尾辞',   14, '～屋'),
  (sid, l23, 'サイズ',                 'サイズ',                 'saizu',                'cỡ, kích thước',                                       '名詞',     15, NULL),
  (sid, l23, 'おと',                   'おと',                   'oto',                  'âm thanh, tiếng',                                      '名詞',     16, '音'),
  (sid, l23, 'きかい',                 'きかい',                 'kikai',                'máy móc',                                              '名詞',     17, '機械'),
  (sid, l23, 'みち',                   'みち',                   'michi',                'đường, con đường',                                     '名詞',     18, '道'),
  (sid, l23, 'こうさてん',             'こうさてん',             'kousaten',             'ngã tư',                                               '名詞',     19, '交差点'),
  (sid, l23, 'しんごう',               'しんごう',               'shingou',              'đèn tín hiệu giao thông',                              '名詞',     20, '信号'),
  (sid, l23, 'つまみ',                 'つまみ',                 'tsumami',              'núm vặn',                                              '名詞',     21, NULL),
  (sid, l23, 'かど',                   'かど',                   'kado',                 'góc, góc phố',                                         '名詞',     22, '角'),
  (sid, l23, 'はし',                   'はし',                   'hashi',                'cầu',                                                  '名詞',     23, '橋'),
  (sid, l23, 'ちゅうしゃじょう',       'ちゅうしゃじょう',       'chuushajou',           'bãi đỗ xe',                                            '名詞',     24, '駐車場'),
  (sid, l23, 'おしょうがつ',           'おしょうがつ',           'oshougatsu',           'Tết, năm mới',                                         '名詞',     25, 'お正月'),
  (sid, l23, 'ごちそうさまでした',     'ごちそうさまでした',     'gochisousama deshita', 'Cảm ơn vì bữa ăn (nói sau khi được mời ăn)',           '挨拶',     26, NULL),
  (sid, l23, '～め',                   '～め',                   '~ me',                 'thứ ~ (hậu tố chỉ thứ tự)',                            '接尾辞',   27, '～目'),
  (sid, l23, 'たてもの',               'たてもの',               'tatemono',             'tòa nhà',                                              '名詞',     28, '建物');

-- ════════════════════════════════════════
-- BÀI 24 — xóa và seed lại (20 từ: 18 PDF + tách おばあちゃん + bổ sung おじいちゃん)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l24;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l24, 'くれます',               'くれます',               'kuremasu',             'cho, tặng (tôi)',                                      '動詞',     1,  NULL),
  (sid, l24, 'つれていきます',         'つれていきます',         'tsurete ikimasu',      'dẫn đi, đưa đi',                                       '動詞',     2,  '連れて行きます'),
  (sid, l24, 'つれてきます',           'つれてきます',           'tsurete kimasu',       'dẫn đến, đưa đến',                                     '動詞',     3,  '連れて来ます'),
  (sid, l24, 'おくります',             'おくります',             'okurimasu',            'đưa đi, đưa đến, tiễn (người)',                        '動詞',     4,  '送ります'),
  (sid, l24, 'しょうかいします',       'しょうかいします',       'shoukai shimasu',      'giới thiệu',                                           '動詞',     5,  '紹介します'),
  (sid, l24, 'あんないします',         'あんないします',         'annai shimasu',        'hướng dẫn, chỉ đường',                                 '動詞',     6,  '案内します'),
  (sid, l24, 'せつめいします',         'せつめいします',         'setsumei shimasu',     'giải thích, trình bày',                                '動詞',     7,  '説明します'),
  (sid, l24, 'いれます',               'いれます',               'iremasu',              'pha (cà phê)',                                         '動詞',     8,  NULL),
  (sid, l24, 'おじいさん',             'おじいさん',             'ojiisan',              'ông (nội/ngoại), ông cụ già',                          '名詞',     9,  NULL),
  (sid, l24, 'おばあさん',             'おばあさん',             'obaasan',              'bà (nội/ngoại), bà cụ già',                            '名詞',     10, NULL),
  (sid, l24, 'おばあちゃん',           'おばあちゃん',           'obaachan',             'bà (cách gọi thân mật của おばあさん)',                '名詞',     11, NULL),
  (sid, l24, 'じゅんび',               'じゅんび',               'junbi',                'sự chuẩn bị, chuẩn bị',                                '名詞',     12, '準備'),
  (sid, l24, 'いみ',                   'いみ',                   'imi',                  'ý nghĩa, nghĩa',                                       '名詞',     13, '意味'),
  (sid, l24, 'おかし',                 'おかし',                 'okashi',               'bánh kẹo',                                             '名詞',     14, 'お菓子'),
  (sid, l24, 'ぜんぶ',                 'ぜんぶ',                 'zenbu',                'toàn bộ, tất cả',                                      '副詞',     15, '全部'),
  (sid, l24, 'じぶんで',               'じぶんで',               'jibun de',             'tự mình',                                              '副詞',     16, '自分で'),
  (sid, l24, 'ほかに',                 'ほかに',                 'hoka ni',              'ngoài ra, bên cạnh đó',                                '副詞',     17, '他に'),
  (sid, l24, 'おべんとう',             'おべんとう',             'obentou',              'cơm hộp',                                              '名詞',     18, 'お弁当'),
  (sid, l24, 'ははのひ',               'ははのひ',               'haha no hi',           'Ngày của Mẹ',                                          '名詞',     19, '母の日'),
  (sid, l24, 'おじいちゃん',           'おじいちゃん',           'ojiichan',             'ông (cách gọi thân mật của おじいさん)',               '名詞',     20, NULL); -- bổ sung ngoài PDF

END $$;
