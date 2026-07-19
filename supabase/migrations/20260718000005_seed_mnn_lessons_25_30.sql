-- Seed: Minna no Nihongo — Bài 25-30 (từ vựng)
-- Nguồn: PDF Minato Dorimu, đối chiếu + sửa lỗi theo danh mục từ vựng MNN chuẩn
-- Quy tắc: word = kana (+ chú thích sách), reading = CHỈ kana + ～, kanji = kanji (NULL nếu không có)
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c
--
-- Sửa lỗi PDF đáng chú ý:
--   Bài 26: みます PDF ghi 2 kanji "見る, 診ます" → tách 2 row: 見ます (xem, nhìn) + 診ます (khám bệnh);
--           chuẩn hóa thể ます (PDF ghi 見る)
--   Bài 27: 通信販売 PDF ghi "thương mại viễn thông" → sửa "mua bán qua đặt hàng từ xa"
--   Bài 28: 人気 PDF ghi "hâm mộ" → sửa "được ưa chuộng, nổi tiếng"
--   Bài 29: STT 1150 われます / 割れます PDF ghi "có thể nghe thấy" → SỬA "vỡ, bể (cốc, kính)"
--   Chú thích trong cột kana của PDF (駅に～, 年を～, いろいろ, お, な) đã chuẩn hóa: () → [], 〜 → ～

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  l25 uuid; l26 uuid; l27 uuid; l28 uuid; l29 uuid; l30 uuid;
BEGIN
SELECT id INTO l25 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 25;
SELECT id INTO l26 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 26;
SELECT id INTO l27 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 27;
SELECT id INTO l28 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 28;
SELECT id INTO l29 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 29;
SELECT id INTO l30 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 30;
IF l25 IS NULL OR l26 IS NULL OR l27 IS NULL OR l28 IS NULL OR l29 IS NULL OR l30 IS NULL THEN
  RAISE EXCEPTION 'mnn_lessons 25-30 chưa được seed';
END IF;

-- ════════════════════════════════════════
-- BÀI 25 — xóa và seed lại (16 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l25;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l25, 'かんがえます',                     'かんがえます',               'kangaemasu',                    'nghĩ, suy nghĩ',                        '動詞', 1,  '考えます'),
  (sid, l25, 'つきます [駅に～]',                'つきます',                   'tsukimasu [eki ni ~]',          'đến (ga)',                              '動詞', 2,  '着きます [駅に～]'),
  (sid, l25, 'りゅうがくします',                 'りゅうがくします',           'ryuugaku shimasu',              'du học',                                '動詞', 3,  '留学します'),
  (sid, l25, 'とります [年を～]',                'とります',                   'torimasu [toshi o ~]',          'thêm (tuổi), có tuổi',                  '動詞', 4,  '取ります [年を～]'),
  (sid, l25, 'いなか',                           'いなか',                     'inaka',                         'quê, nông thôn',                        '名詞', 5,  '田舎'),
  (sid, l25, 'たいしかん',                       'たいしかん',                 'taishikan',                     'đại sứ quán',                           '名詞', 6,  '大使館'),
  (sid, l25, 'グループ',                         'グループ',                   'guruupu',                       'nhóm',                                  '名詞', 7,  NULL),
  (sid, l25, 'チャンス',                         'チャンス',                   'chansu',                        'cơ hội',                                '名詞', 8,  NULL),
  (sid, l25, 'おく',                             'おく',                       'oku',                           'một trăm triệu (10^8)',                 '名詞', 9,  '億'),
  (sid, l25, 'もし',                             'もし',                       'moshi',                         'nếu',                                   '副詞', 10, NULL),
  (sid, l25, 'いくら',                           'いくら',                     'ikura',                         'cho dù, dù thế nào (bao nhiêu)',        '副詞', 11, NULL),
  (sid, l25, 'てんきん',                         'てんきん',                   'tenkin',                        'việc chuyển nơi làm việc',              '名詞', 12, '転勤'),
  (sid, l25, 'こと',                             'こと',                       'koto',                          'việc',                                  '名詞', 13, NULL),
  (sid, l25, 'いっぱいのみましょう',             'いっぱいのみましょう',       'ippai nomimashou',              'chúng ta cùng đi uống nhé (một chén)',  '表現', 14, '一杯飲みましょう'),
  (sid, l25, 'どうぞおげんきで',                 'どうぞおげんきで',           'douzo ogenki de',               'chúc anh chị mạnh khỏe',                '挨拶', 15, 'どうぞ元気で'),
  (sid, l25, '[いろいろ]おせわになりました',     'いろいろおせわになりました', '[iroiro] osewa ni narimashita', '(cảm ơn vì) đã giúp đỡ tôi nhiều',      '挨拶', 16, '[いろいろ]お世話になりました');

-- ════════════════════════════════════════
-- BÀI 26 — xóa và seed lại (47 từ: 46 PDF + tách みます 見ます/診ます)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l26;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l26, 'みます',                 'みます',                 'mimasu',           'xem, nhìn',                        '動詞',   1,  '見ます'),
  (sid, l26, 'みます',                 'みます',                 'mimasu',           'khám (bệnh)',                      '動詞',   2,  '診ます'),
  (sid, l26, 'さがします',             'さがします',             'sagashimasu',      'tìm, tìm kiếm',                    '動詞',   3,  '探します'),
  (sid, l26, 'おくれます',             'おくれます',             'okuremasu',        'chậm, muộn, trễ giờ',              '動詞',   4,  '遅れます'),
  (sid, l26, 'まにあいます',           'まにあいます',           'ma ni aimasu',     'kịp giờ',                          '動詞',   5,  '間に合います'),
  (sid, l26, 'やります',               'やります',               'yarimasu',         'làm, thực hiện',                   '動詞',   6,  NULL),
  (sid, l26, 'さんかします',           'さんかします',           'sanka shimasu',    'tham gia',                         '動詞',   7,  '参加します'),
  (sid, l26, 'もうしこみます',         'もうしこみます',         'moushikomimasu',   'đăng ký',                          '動詞',   8,  '申し込みます'),
  (sid, l26, 'つごうがいい',           'つごうがいい',           'tsugou ga ii',     'có thời gian, thuận tiện',         '表現',   9,  '都合がいい'),
  (sid, l26, 'つごうがわるい',         'つごうがわるい',         'tsugou ga warui',  'không có thời gian, bận',          '表現',   10, '都合が悪い'),
  (sid, l26, 'きぶんがいい',           'きぶんがいい',           'kibun ga ii',      'tâm trạng/thể trạng tốt',          '表現',   11, '気分がいい'),
  (sid, l26, 'きぶんがわるい',         'きぶんがわるい',         'kibun ga warui',   'tâm trạng/thể trạng xấu',          '表現',   12, '気分が悪い'),
  (sid, l26, 'しんぶんしゃ',           'しんぶんしゃ',           'shinbunsha',       'tòa soạn báo',                     '名詞',   13, '新聞社'),
  (sid, l26, 'じゅうどう',             'じゅうどう',             'juudou',           'judo, nhu đạo',                    '名詞',   14, '柔道'),
  (sid, l26, 'うんどうかい',           'うんどうかい',           'undoukai',         'hội thao, hội thi thể thao',       '名詞',   15, '運動会'),
  (sid, l26, 'ばしょ',                 'ばしょ',                 'basho',            'nơi chốn, địa điểm',               '名詞',   16, '場所'),
  (sid, l26, 'ボランティア',           'ボランティア',           'borantia',         'tình nguyện viên',                 '名詞',   17, NULL),
  (sid, l26, '～べん',                 '～べん',                 '~ ben',            'tiếng ～ (giọng địa phương)',       '接尾辞', 18, '～弁'),
  (sid, l26, 'こんど',                 'こんど',                 'kondo',            'lần tới, lần này',                 '名詞',   19, '今度'),
  (sid, l26, 'ずいぶん',               'ずいぶん',               'zuibun',           'khá, tương đối',                   '副詞',   20, NULL),
  (sid, l26, 'ちょくせつ',             'ちょくせつ',             'chokusetsu',       'trực tiếp',                        '副詞',   21, '直接'),
  (sid, l26, 'いつでも',               'いつでも',               'itsu demo',        'lúc nào cũng',                     '副詞',   22, NULL),
  (sid, l26, 'どこでも',               'どこでも',               'doko demo',        'ở đâu cũng',                       '副詞',   23, NULL),
  (sid, l26, 'だれでも',               'だれでも',               'dare demo',        'ai cũng',                          '代名詞', 24, NULL),
  (sid, l26, 'なんでも',               'なんでも',               'nan demo',         'cái gì cũng',                      '代名詞', 25, '何でも'),
  (sid, l26, 'こんな',                 'こんな',                 'konna',            'như thế này (loại này)',           '連体詞', 26, NULL),
  (sid, l26, 'そんな',                 'そんな',                 'sonna',            'như thế đó',                       '連体詞', 27, NULL),
  (sid, l26, 'あんな',                 'あんな',                 'anna',             'như thế kia',                      '連体詞', 28, NULL),
  (sid, l26, 'かたづきます',           'かたづきます',           'katazukimasu',     '(được) dọn dẹp, sắp xếp gọn',      '動詞',   29, '片付きます'),
  (sid, l26, 'ごみ',                   'ごみ',                   'gomi',             'rác',                              '名詞',   30, NULL),
  (sid, l26, 'だします',               'だします',               'dashimasu',        'đổ, vứt (rác)',                    '動詞',   31, '出します'),
  (sid, l26, 'もえます',               'もえます',               'moemasu',          'cháy được (rác đốt được)',         '動詞',   32, '燃えます'),
  (sid, l26, 'おきば',                 'おきば',                 'okiba',            'chỗ để, chỗ đặt',                  '名詞',   33, '置き場'),
  (sid, l26, 'よこ',                   'よこ',                   'yoko',             'bên cạnh',                         '名詞',   34, '横'),
  (sid, l26, 'びん',                   'びん',                   'bin',              'cái chai',                         '名詞',   35, '瓶'),
  (sid, l26, 'かん',                   'かん',                   'kan',              'cái lon, hộp kim loại',            '名詞',   36, '缶'),
  (sid, l26, '[お]ゆ',                 'おゆ',                   '[o]yu',            'nước nóng',                        '名詞',   37, '[お]湯'),
  (sid, l26, 'ガス',                   'ガス',                   'gasu',             'ga (gas)',                         '名詞',   38, NULL),
  (sid, l26, '～かいしゃ',             '～かいしゃ',             '~ kaisha',         'công ty ～',                       '接尾辞', 39, '～会社'),
  (sid, l26, 'れんらくします',         'れんらくします',         'renraku shimasu',  'liên lạc',                         '動詞',   40, '連絡します'),
  (sid, l26, 'こまったなあ',           'こまったなあ',           'komatta naa',      'gay quá, căng quá!',               '表現',   41, '困ったなあ'),
  (sid, l26, 'でんしメール',           'でんしメール',           'denshi meeru',     'email, thư điện tử',               '名詞',   42, '電子メール'),
  (sid, l26, 'うちゅう',               'うちゅう',               'uchuu',            'vũ trụ',                           '名詞',   43, '宇宙'),
  (sid, l26, 'うちゅうせん',           'うちゅうせん',           'uchuusen',         'tàu vũ trụ',                       '名詞',   44, '宇宙船'),
  (sid, l26, 'こわい',                 'こわい',                 'kowai',            'sợ, đáng sợ',                      'い形容詞', 45, '怖い'),
  (sid, l26, 'べつの',                 'べつの',                 'betsu no',         'khác',                             '連体詞', 46, '別の'),
  (sid, l26, 'うちゅうひこうし',       'うちゅうひこうし',       'uchuu hikoushi',   'nhà du hành vũ trụ',               '名詞',   47, NULL);

-- ════════════════════════════════════════
-- BÀI 27 — xóa và seed lại (48 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l27;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l27, 'かいます',               'かいます',               'kaimasu',            'nuôi, chăn nuôi',                  '動詞',   1,  '飼います'),
  (sid, l27, 'たてます',               'たてます',               'tatemasu',           'xây dựng',                         '動詞',   2,  '建てます'),
  (sid, l27, 'はしります',             'はしります',             'hashirimasu',        'chạy',                             '動詞',   3,  '走ります'),
  (sid, l27, 'とります',               'とります',               'torimasu',           'xin (nghỉ), lấy',                  '動詞',   4,  '取ります'),
  (sid, l27, 'みえます',               'みえます',               'miemasu',            'có thể nhìn thấy',                 '動詞',   5,  '見えます'),
  (sid, l27, 'きこえます',             'きこえます',             'kikoemasu',          'có thể nghe thấy',                 '動詞',   6,  '聞こえます'),
  (sid, l27, 'できます',               'できます',               'dekimasu',           'được hoàn thành, được làm ra',     '動詞',   7,  NULL),
  (sid, l27, 'ひらきます',             'ひらきます',             'hirakimasu',         'mở, mở (lớp học)',                 '動詞',   8,  '開きます'),
  (sid, l27, 'ペット',                 'ペット',                 'petto',              'thú cưng, động vật nuôi',          '名詞',   9,  NULL),
  (sid, l27, 'とり',                   'とり',                   'tori',               'chim',                             '名詞',   10, '鳥'),
  (sid, l27, 'こえ',                   'こえ',                   'koe',                'tiếng, giọng nói',                 '名詞',   11, '声'),
  (sid, l27, 'なみ',                   'なみ',                   'nami',               'sóng',                             '名詞',   12, '波'),
  (sid, l27, 'はなび',                 'はなび',                 'hanabi',             'pháo hoa',                         '名詞',   13, '花火'),
  (sid, l27, 'けしき',                 'けしき',                 'keshiki',            'phong cảnh',                       '名詞',   14, '景色'),
  (sid, l27, 'ひるま',                 'ひるま',                 'hiruma',             'ban ngày',                         '名詞',   15, '昼間'),
  (sid, l27, 'むかし',                 'むかし',                 'mukashi',            'ngày xưa',                         '名詞',   16, '昔'),
  (sid, l27, 'どうぐ',                 'どうぐ',                 'dougu',              'dụng cụ',                          '名詞',   17, '道具'),
  (sid, l27, 'じどうはんばいき',       'じどうはんばいき',       'jidou hanbaiki',     'máy bán hàng tự động',             '名詞',   18, '自動販売機'),
  (sid, l27, 'つうしんはんばい',       'つうしんはんばい',       'tsuushin hanbai',    'mua bán qua đặt hàng từ xa',       '名詞',   19, '通信販売'),
  (sid, l27, 'クリーニング',           'クリーニング',           'kuriiningu',         'giặt ủi, giặt khô',                '名詞',   20, NULL),
  (sid, l27, 'マンション',             'マンション',             'manshon',            'chung cư',                         '名詞',   21, NULL),
  (sid, l27, 'だいどころ',             'だいどころ',             'daidokoro',          'nhà bếp',                          '名詞',   22, '台所'),
  (sid, l27, '～ご',                   '～ご',                   '~ go',               'sau ～',                           '接尾辞', 23, '～後'),
  (sid, l27, '～しか',                 '～しか',                 '~ shika',            'chỉ (dùng với phủ định)',          '助詞',   24, NULL),
  (sid, l27, 'ほかの',                 'ほかの',                 'hoka no',            'khác',                             '連体詞', 25, NULL),
  (sid, l27, 'はっきり',               'はっきり',               'hakkiri',            'rõ, rõ ràng',                      '副詞',   26, NULL),
  (sid, l27, 'ほとんど',               'ほとんど',               'hotondo',            'hầu như',                          '副詞',   27, NULL),
  (sid, l27, '～きょうしつ',           '～きょうしつ',           '~ kyoushitsu',       'lớp học ～',                       '接尾辞', 28, '～教室'),
  (sid, l27, 'ほんだな',               'ほんだな',               'hondana',            'kệ sách, giá sách',                '名詞',   29, '本棚'),
  (sid, l27, 'いつか',                 'いつか',                 'itsuka',             'một ngày nào đó',                  '副詞',   30, NULL),
  (sid, l27, 'ゆめ',                   'ゆめ',                   'yume',               'giấc mơ, mơ',                      '名詞',   31, '夢'),
  (sid, l27, 'いえ',                   'いえ',                   'ie',                 'nhà',                              '名詞',   32, '家'),
  (sid, l27, 'すばらしい',             'すばらしい',             'subarashii',         'tuyệt vời',                        'い形容詞', 33, '素晴らしい'),
  (sid, l27, 'こどもたち',             'こどもたち',             'kodomotachi',        'bọn trẻ',                          '名詞',   34, '子どもたち'),
  (sid, l27, 'だいすき',               'だいすき',               'daisuki',            'rất thích',                        'な形容詞', 35, '大好き'),
  (sid, l27, 'まんが',                 'まんが',                 'manga',              'truyện tranh',                     '名詞',   36, '漫画'),
  (sid, l27, 'しゅじんこう',           'しゅじんこう',           'shujinkou',          'nhân vật chính',                   '名詞',   37, '主人公'),
  (sid, l27, 'かたち',                 'かたち',                 'katachi',            'hình dạng',                        '名詞',   38, '形'),
  (sid, l27, 'ロボット',               'ロボット',               'robotto',            'người máy, robot',                 '名詞',   39, NULL),
  (sid, l27, 'ふしぎ [な]',            'ふしぎ',                 'fushigi [na]',       'kì lạ, bí ẩn',                     'な形容詞', 40, '不思議 [な]'),
  (sid, l27, 'ポケット',               'ポケット',               'poketto',            'túi (áo, quần)',                   '名詞',   41, NULL),
  (sid, l27, 'たとえば',               'たとえば',               'tatoeba',            'ví dụ',                            '副詞',   42, '例えば'),
  (sid, l27, 'つけます',               'つけます',               'tsukemasu',          'gắn, lắp, đính',                   '動詞',   43, '付けます'),
  (sid, l27, 'じゆうに',               'じゆうに',               'jiyuu ni',           '(một cách) tự do',                 '副詞',   44, '自由に'),
  (sid, l27, 'そら',                   'そら',                   'sora',               'bầu trời',                         '名詞',   45, '空'),
  (sid, l27, 'とびます',               'とびます',               'tobimasu',           'bay',                              '動詞',   46, '飛びます'),
  (sid, l27, 'じぶん',                 'じぶん',                 'jibun',              'tự mình, bản thân',                '名詞',   47, '自分'),
  (sid, l27, 'しょうらい',             'しょうらい',             'shourai',            'tương lai',                        '名詞',   48, '将来');

-- ════════════════════════════════════════
-- BÀI 28 — xóa và seed lại (44 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l28;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l28, 'うれます',               'うれます',               'uremasu',          'bán được, bán chạy',               '動詞',   1,  '売れます'),
  (sid, l28, 'おどります',             'おどります',             'odorimasu',        'nhảy, múa',                        '動詞',   2,  '踊ります'),
  (sid, l28, 'かみます',               'かみます',               'kamimasu',         'nhai, cắn',                        '動詞',   3,  NULL),
  (sid, l28, 'えらびます',             'えらびます',             'erabimasu',        'lựa, lựa chọn',                    '動詞',   4,  '選びます'),
  (sid, l28, 'かよいます',             'かよいます',             'kayoimasu',        'đi lại (thường xuyên), đi học',    '動詞',   5,  '通います'),
  (sid, l28, 'メモします',             'メモします',             'memo shimasu',     'ghi chép',                         '動詞',   6,  'メモします'),
  (sid, l28, 'まじめ',                 'まじめ',                 'majime',           'nghiêm túc',                       'な形容詞', 7,  NULL),
  (sid, l28, 'ねっしん',               'ねっしん',               'nesshin',          'nhiệt tình',                       'な形容詞', 8,  '熱心'),
  (sid, l28, 'えらい',                 'えらい',                 'erai',             'vĩ đại, đáng kính trọng',          'い形容詞', 9,  '偉い'),
  (sid, l28, 'ちょうどいい',           'ちょうどいい',           'choudo ii',        'vừa đúng, vừa vặn',                'い形容詞', 10, NULL),
  (sid, l28, 'やさしい',               'やさしい',               'yasashii',         'dịu dàng, hiền lành',              'い形容詞', 11, '優しい'),
  (sid, l28, 'しゅうかん',             'しゅうかん',             'shuukan',          'thói quen, tập quán',              '名詞',   12, '習慣'),
  (sid, l28, 'けいけん',               'けいけん',               'keiken',           'kinh nghiệm',                      '名詞',   13, '経験'),
  (sid, l28, 'ちから',                 'ちから',                 'chikara',          'sức mạnh, sức lực',                '名詞',   14, '力'),
  (sid, l28, 'にんき',                 'にんき',                 'ninki',            'được ưa chuộng, nổi tiếng',        '名詞',   15, '人気'),
  (sid, l28, 'かたち',                 'かたち',                 'katachi',          'hình dáng',                        '名詞',   16, '形'),
  (sid, l28, 'いろ',                   'いろ',                   'iro',              'màu',                              '名詞',   17, '色'),
  (sid, l28, 'あじ',                   'あじ',                   'aji',              'vị',                               '名詞',   18, '味'),
  (sid, l28, 'ガム',                   'ガム',                   'gamu',             'kẹo cao su',                       '名詞',   19, NULL),
  (sid, l28, 'しなもの',               'しなもの',               'shinamono',        'hàng hóa',                         '名詞',   20, '品物'),
  (sid, l28, 'ねだん',                 'ねだん',                 'nedan',            'giá cả',                           '名詞',   21, '値段'),
  (sid, l28, 'きゅうりょう',           'きゅうりょう',           'kyuuryou',         'lương',                            '名詞',   22, '給料'),
  (sid, l28, 'ボーナス',               'ボーナス',               'boonasu',          'tiền thưởng',                      '名詞',   23, NULL),
  (sid, l28, 'ばんぐみ',               'ばんぐみ',               'bangumi',          'chương trình (TV)',                '名詞',   24, '番組'),
  (sid, l28, 'ドラマ',                 'ドラマ',                 'dorama',           'kịch, phim truyền hình',           '名詞',   25, NULL),
  (sid, l28, 'しょうせつ',             'しょうせつ',             'shousetsu',        'tiểu thuyết',                      '名詞',   26, '小説'),
  (sid, l28, 'しょうせつか',           'しょうせつか',           'shousetsuka',      'tiểu thuyết gia, nhà văn',         '名詞',   27, '小説家'),
  (sid, l28, 'かしゅ',                 'かしゅ',                 'kashu',            'ca sĩ',                            '名詞',   28, '歌手'),
  (sid, l28, 'かんりにん',             'かんりにん',             'kanrinin',         'người quản lí',                    '名詞',   29, '管理人'),
  (sid, l28, 'むすこ',                 'むすこ',                 'musuko',           'con trai (của mình)',              '名詞',   30, '息子'),
  (sid, l28, 'むすこさん',             'むすこさん',             'musuko san',       'con trai (của người khác)',        '名詞',   31, '息子さん'),
  (sid, l28, 'むすめ',                 'むすめ',                 'musume',           'con gái (của mình)',               '名詞',   32, '娘'),
  (sid, l28, 'むすめさん',             'むすめさん',             'musume san',       'con gái (của người khác)',         '名詞',   33, '娘さん'),
  (sid, l28, 'じぶん',                 'じぶん',                 'jibun',            'bản thân',                         '名詞',   34, '自分'),
  (sid, l28, 'しょうらい',             'しょうらい',             'shourai',          'tương lai',                        '名詞',   35, '将来'),
  (sid, l28, 'しばらく',               'しばらく',               'shibaraku',        'một lát, một khoảng thời gian ngắn', '副詞', 36, NULL),
  (sid, l28, 'たいてい',               'たいてい',               'taitei',           'thường, thông thường',             '副詞',   37, NULL),
  (sid, l28, 'それに',                 'それに',                 'sore ni',          'ngoài ra, hơn nữa',                '接続詞', 38, NULL),
  (sid, l28, 'それで',                 'それで',                 'sore de',          'do đó, thế nên',                   '接続詞', 39, NULL),
  (sid, l28, 'ホームステイ',           'ホームステイ',           'hoomusutei',       'homestay, ở nhà dân bản xứ',       '名詞',   40, NULL),
  (sid, l28, 'かいわ',                 'かいわ',                 'kaiwa',            'hội thoại',                        '名詞',   41, '会話'),
  (sid, l28, 'おしゃべりします',       'おしゃべりします',       'oshaberi shimasu', 'trò chuyện, tán gẫu',              '動詞',   42, 'おしゃべりします'),
  (sid, l28, 'おしらせ',               'おしらせ',               'oshirase',         'thông báo',                        '名詞',   43, 'お知らせ'),
  (sid, l28, 'むりょう',               'むりょう',               'muryou',           'miễn phí',                         '名詞',   44, '無料');

-- ════════════════════════════════════════
-- BÀI 29 — xóa và seed lại (43 từ)  [STT 1150 われます đã sửa nghĩa]
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l29;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l29, 'あきます',               'あきます',               'akimasu',          'mở (cửa mở)',                      '動詞',   1,  '開きます'),
  (sid, l29, 'しまります',             'しまります',             'shimarimasu',      'đóng (cửa đóng)',                  '動詞',   2,  '閉まります'),
  (sid, l29, 'つきます',               'つきます',               'tsukimasu',        '(đèn) bật sáng',                   '動詞',   3,  NULL),
  (sid, l29, 'きえます',               'きえます',               'kiemasu',          'tắt (đèn)',                        '動詞',   4,  '消えます'),
  (sid, l29, 'こみます',               'こみます',               'komimasu',         'đông (đường đông đúc)',            '動詞',   5,  '込みます'),
  (sid, l29, 'すきます',               'すきます',               'sukimasu',         'vắng, trống (đường vắng)',         '動詞',   6,  NULL),
  (sid, l29, 'こわれます',             'こわれます',             'kowaremasu',       'hỏng, vỡ (ghế)',                   '動詞',   7,  '壊れます'),
  (sid, l29, 'われます',               'われます',               'waremasu',         'vỡ, bể (cốc, kính)',               '動詞',   8,  '割れます'),
  (sid, l29, 'おれます',               'おれます',               'oremasu',          'gãy (cây)',                        '動詞',   9,  '折れます'),
  (sid, l29, 'やぶれます',             'やぶれます',             'yaburemasu',       'rách (giấy)',                      '動詞',   10, '破れます'),
  (sid, l29, 'よごれます',             'よごれます',             'yogoremasu',       'dơ, bẩn (tay)',                    '動詞',   11, '汚れます'),
  (sid, l29, 'つきます',               'つきます',               'tsukimasu',        'dính, đính (có túi)',              '動詞',   12, '付きます'),
  (sid, l29, 'はずれます',             'はずれます',             'hazuremasu',       'tuột, bung, rời ra (sút nút)',     '動詞',   13, '外れます'),
  (sid, l29, 'とまります',             'とまります',             'tomarimasu',       'dừng',                             '動詞',   14, '止まります'),
  (sid, l29, 'まちがえます',           'まちがえます',           'machigaemasu',     'nhầm lẫn, sai',                    '動詞',   15, NULL),
  (sid, l29, 'おとします',             'おとします',             'otoshimasu',       'làm rơi, rớt',                     '動詞',   16, '落とします'),
  (sid, l29, 'かかります',             'かかります',             'kakarimasu',       'khóa (được khóa)',                 '動詞',   17, '掛かります'),
  (sid, l29, 'さら',                   'さら',                   'sara',             'đĩa',                              '名詞',   18, '皿'),
  (sid, l29, 'ちゃわん',               'ちゃわん',               'chawan',           'bát, chén',                        '名詞',   19, NULL),
  (sid, l29, 'コップ',                 'コップ',                 'koppu',            'cốc',                              '名詞',   20, NULL),
  (sid, l29, 'ガラス',                 'ガラス',                 'garasu',           'thủy tinh, kính',                  '名詞',   21, NULL),
  (sid, l29, 'ふくろ',                 'ふくろ',                 'fukuro',           'túi',                              '名詞',   22, '袋'),
  (sid, l29, 'さいふ',                 'さいふ',                 'saifu',            'ví (bóp tiền)',                    '名詞',   23, '財布'),
  (sid, l29, 'えだ',                   'えだ',                   'eda',              'cành cây',                         '名詞',   24, '枝'),
  (sid, l29, 'えきいん',               'えきいん',               'ekiin',            'nhân viên nhà ga',                 '名詞',   25, '駅員'),
  (sid, l29, 'このへん',               'このへん',               'kono hen',         'xung quanh đây, gần đây',          '名詞',   26, 'この辺'),
  (sid, l29, 'このくらい',             'このくらい',             'kono kurai',       'cỡ khoảng như này',                '副詞',   27, NULL),
  (sid, l29, 'おさきにどうぞ',         'おさきにどうぞ',         'osaki ni douzo',   'mời anh/chị cứ đi trước',          '表現',   28, 'お先にどうぞ'),
  (sid, l29, 'わすれもの',             'わすれもの',             'wasuremono',       'đồ để quên, đồ bỏ quên',           '名詞',   29, '忘れ物'),
  (sid, l29, 'がわ',                   'がわ',                   'gawa',             'phía, bên',                        '名詞',   30, '側'),
  (sid, l29, 'ポケット',               'ポケット',               'poketto',          'túi áo, túi quần',                 '名詞',   31, NULL),
  (sid, l29, 'へん',                   'へん',                   'hen',              'chỗ, vùng',                        '名詞',   32, '辺'),
  (sid, l29, 'あみだな',               'あみだな',               'amidana',          'giá để hành lý (trên tàu)',        '名詞',   33, '網棚'),
  (sid, l29, 'たしか',                 'たしか',                 'tashika',          'chắc là, hình như (nếu tôi nhớ không nhầm)', '副詞', 34, '確か'),
  (sid, l29, 'じしん',                 'じしん',                 'jishin',           'động đất',                         '名詞',   35, '地震'),
  (sid, l29, 'かべ',                   'かべ',                   'kabe',             'bức tường',                        '名詞',   36, '壁'),
  (sid, l29, 'はり',                   'はり',                   'hari',             'kim đồng hồ',                      '名詞',   37, '針'),
  (sid, l29, 'いまのでんしゃ',         'いまのでんしゃ',         'ima no densha',    'đoàn tàu vừa rồi',                 '名詞',   38, '今の電車'),
  (sid, l29, 'えきまえ',               'えきまえ',               'ekimae',           'trước ga',                         '名詞',   39, '駅前'),
  (sid, l29, 'さします',               'さします',               'sashimasu',        'chỉ, chỉ vào',                     '動詞',   40, '指します'),
  (sid, l29, 'たおれます',             'たおれます',             'taoremasu',        'đổ, ngã đổ',                       '動詞',   41, '倒れます'),
  (sid, l29, 'にしのほう',             'にしのほう',             'nishi no hou',     'phía tây',                         '名詞',   42, '西の方'),
  (sid, l29, 'もえます',               'もえます',               'moemasu',          'cháy',                             '動詞',   43, '燃えます');

-- ════════════════════════════════════════
-- BÀI 30 — xóa và seed lại (51 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l30;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l30, 'はります',               'はります',               'harimasu',            'dán',                           '動詞',   1,  NULL),
  (sid, l30, 'かけます',               'かけます',               'kakemasu',            'treo',                          '動詞',   2,  '掛けます'),
  (sid, l30, 'かざります',             'かざります',             'kazarimasu',          'trang trí',                     '動詞',   3,  '飾ります'),
  (sid, l30, 'ならべます',             'ならべます',             'narabemasu',          'xếp thành hàng, sắp thành hàng','動詞',   4,  '並べます'),
  (sid, l30, 'うえます',               'うえます',               'uemasu',              'trồng (cây)',                   '動詞',   5,  '植えます'),
  (sid, l30, 'もどします',             'もどします',             'modoshimasu',         'đưa về, trả về (chỗ cũ)',       '動詞',   6,  '戻します'),
  (sid, l30, 'まとめます',             'まとめます',             'matomemasu',          'tập hợp lại, tóm tắt',          '動詞',   7,  NULL),
  (sid, l30, 'かたづけます',           'かたづけます',           'katazukemasu',        'dọn dẹp, sắp xếp',              '動詞',   8,  '片づけます'),
  (sid, l30, 'しまいます',             'しまいます',             'shimaimasu',          'cất vào, để vào',               '動詞',   9,  NULL),
  (sid, l30, 'きめます',               'きめます',               'kimemasu',            'quyết định',                    '動詞',   10, '決めます'),
  (sid, l30, 'しらせます',             'しらせます',             'shirasemasu',         'thông báo',                     '動詞',   11, '知らせます'),
  (sid, l30, 'そうだんします',         'そうだんします',         'soudan shimasu',      'thảo luận, trao đổi, bàn bạc',  '動詞',   12, '相談します'),
  (sid, l30, 'よしゅうします',         'よしゅうします',         'yoshuu shimasu',      'chuẩn bị bài mới',              '動詞',   13, '予習します'),
  (sid, l30, 'ふくしゅうします',       'ふくしゅうします',       'fukushuu shimasu',    'ôn bài cũ',                     '動詞',   14, '復習します'),
  (sid, l30, 'そのままにします',       'そのままにします',       'sono mama ni shimasu','để nguyên như thế',             '表現',   15, NULL),
  (sid, l30, 'おこさん',               'おこさん',               'okosan',              'con (của người khác)',          '名詞',   16, 'お子さん'),
  (sid, l30, 'じゅぎょう',             'じゅぎょう',             'jugyou',              'giờ học, tiết học',             '名詞',   17, '授業'),
  (sid, l30, 'こうぎ',                 'こうぎ',                 'kougi',               'bài giảng',                     '名詞',   18, '講義'),
  (sid, l30, 'ミーティング',           'ミーティング',           'miitingu',            'cuộc họp',                      '名詞',   19, NULL),
  (sid, l30, 'よてい',                 'よてい',                 'yotei',               'kế hoạch, dự định',             '名詞',   20, '予定'),
  (sid, l30, 'おしらせ',               'おしらせ',               'oshirase',            'bản thông báo',                 '名詞',   21, 'お知らせ'),
  (sid, l30, 'あんないしょ',           'あんないしょ',           'annaisho',            'tài liệu hướng dẫn',            '名詞',   22, '案内書'),
  (sid, l30, 'カレンダー',             'カレンダー',             'karendaa',            'lịch, tờ lịch',                 '名詞',   23, NULL),
  (sid, l30, 'ポスター',               'ポスター',               'posutaa',             'tờ quảng cáo, áp phích, poster','名詞',   24, NULL),
  (sid, l30, 'ごみばこ',               'ごみばこ',               'gomibako',            'thùng rác',                     '名詞',   25, 'ごみ箱'),
  (sid, l30, 'にんぎょう',             'にんぎょう',             'ningyou',             'con búp bê, con rối',           '名詞',   26, '人形'),
  (sid, l30, 'かびん',                 'かびん',                 'kabin',               'lọ hoa, bình hoa',              '名詞',   27, '花瓶'),
  (sid, l30, 'かがみ',                 'かがみ',                 'kagami',              'cái gương',                     '名詞',   28, '鏡'),
  (sid, l30, 'ひきだし',               'ひきだし',               'hikidashi',           'ngăn kéo',                      '名詞',   29, '引き出し'),
  (sid, l30, 'げんかん',               'げんかん',               'genkan',              'cửa vào, lối vào',              '名詞',   30, '玄関'),
  (sid, l30, 'ろうか',                 'ろうか',                 'rouka',               'hành lang',                     '名詞',   31, '廊下'),
  (sid, l30, 'かべ',                   'かべ',                   'kabe',                'bức tường',                     '名詞',   32, '壁'),
  (sid, l30, 'いけ',                   'いけ',                   'ike',                 'cái ao',                        '名詞',   33, '池'),
  (sid, l30, 'こうばん',               'こうばん',               'kouban',              'trạm cảnh sát, bốt cảnh sát',   '名詞',   34, '交番'),
  (sid, l30, 'もとのところ',           'もとのところ',           'moto no tokoro',      'địa điểm ban đầu, chỗ cũ',      '名詞',   35, '元の所'),
  (sid, l30, 'まわり',                 'まわり',                 'mawari',              'xung quanh',                    '名詞',   36, '周り'),
  (sid, l30, 'まんなか',               'まんなか',               'mannaka',             'giữa, chính giữa, trung tâm',   '名詞',   37, '真ん中'),
  (sid, l30, 'すみ',                   'すみ',                   'sumi',                'góc',                           '名詞',   38, NULL),
  (sid, l30, 'まだ',                   'まだ',                   'mada',                'chưa',                          '副詞',   39, NULL),
  (sid, l30, '～ほど',                 '～ほど',                 '~ hodo',              'chừng ～, khoảng ～',            '助詞',   40, NULL),
  (sid, l30, 'よていひょう',           'よていひょう',           'yoteihyou',           'thời khóa biểu, bảng kế hoạch', '名詞',   41, '予定表'),
  (sid, l30, 'ごくろうさま',           'ごくろうさま',           'gokurousama',         'anh chị đã vất vả rồi',         '挨拶',   42, NULL),
  (sid, l30, 'きぼう',                 'きぼう',                 'kibou',               'hi vọng, nguyện vọng',          '名詞',   43, '希望'),
  (sid, l30, 'なにかごきぼうがありますか', 'なにかごきぼうがありますか', 'nani ka go kibou ga arimasu ka', 'anh/chị có nguyện vọng gì không?', '表現', 44, '何かご希望がありますか'),
  (sid, l30, 'まるい',                 'まるい',                 'marui',               'tròn',                          'い形容詞', 45, '丸い'),
  (sid, l30, 'つき',                   'つき',                   'tsuki',               'mặt trăng',                     '名詞',   46, '月'),
  (sid, l30, 'ちきゅう',               'ちきゅう',               'chikyuu',             'trái đất',                      '名詞',   47, '地球'),
  (sid, l30, 'うれしい',               'うれしい',               'ureshii',             'vui, vui mừng',                 'い形容詞', 48, NULL),
  (sid, l30, 'いや [な]',              'いや',                   'iya [na]',            'chán, ghét, không chấp nhận được', 'な形容詞', 49, '嫌 [な]'),
  (sid, l30, 'すると',                 'すると',                 'suru to',             'thế là, sau đó',                '接続詞', 50, NULL),
  (sid, l30, 'めがさめます',           'めがさめます',           'me ga samemasu',      'tỉnh giấc, mở mắt',             '動詞',   51, '目が覚めます');

END $$;
