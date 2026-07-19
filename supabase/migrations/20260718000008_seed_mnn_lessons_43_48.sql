-- Seed: Minna no Nihongo — Bài 43-48 (từ vựng)
-- Nguồn: PDF Minato Dorimu, đối chiếu + sửa lỗi theo danh mục từ vựng MNN chuẩn
-- Quy tắc: word = kana (+ chú thích sách), reading = CHỈ kana + ～, kanji = kanji (NULL nếu không có)
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c
--
-- Chuẩn hóa: 「な」→ [な]; annotation 「…」／（…）→ [ … ]; bỏ marker nhóm động từ I/II/III; bỏ 。 cuối câu.
-- Cột "Âm Hán" trong PDF bỏ qua hoàn toàn (nhiều giá trị lệch dòng).
-- Sửa lỗi PDF đáng chú ý:
--   Bài 45: 1892 コース (PDF scan hỏng thành "ロース") — sửa theo nghĩa "đường chạy marathon".
--   Bài 47: 1937 わかれます nghĩa "chia ra, phân nhánh" → kanji 分かれます (PDF ghi 別れます, trùng với Bài 44).
--   Bài 47: 1959 平均寿命 (PDF scan kanji hỏng thành "平均十冥") — sửa lại 寿命.
--   Bài 48: 1975 にゅうかん nghĩa "sở nhập cảnh" → 入管 (viết tắt 入国管理局; PDF ghi 入館 đồng âm sai).
--   Bài 48: 1986 ～せいき / ～世紀 (PDF ghi "一世紀" nhưng nghĩa "thế kỷ ~" = hậu tố đếm).

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  l43 uuid; l44 uuid; l45 uuid; l46 uuid; l47 uuid; l48 uuid;
BEGIN
SELECT id INTO l43 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 43;
SELECT id INTO l44 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 44;
SELECT id INTO l45 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 45;
SELECT id INTO l46 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 46;
SELECT id INTO l47 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 47;
SELECT id INTO l48 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 48;

IF l43 IS NULL OR l44 IS NULL OR l45 IS NULL OR l46 IS NULL OR l47 IS NULL OR l48 IS NULL THEN
  RAISE EXCEPTION 'mnn_lessons 43-48 chưa được seed';
END IF;

-- ════════════════════════════════════════
-- BÀI 43 — xóa và seed lại (30 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l43;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l43, 'ふえます',       'ふえます',       'fuemasu',      'tăng, tăng lên (xuất khẩu)',                     '動詞',     1,  '増えます'),
  (sid, l43, 'へります',       'へります',       'herimasu',     'giảm, giảm xuống (xuất khẩu)',                   '動詞',     2,  '減ります'),
  (sid, l43, 'あがります',     'あがります',     'agarimasu',    'tăng, tăng lên (giá)',                           '動詞',     3,  '上がります'),
  (sid, l43, 'さがります',     'さがります',     'sagarimasu',   'giảm, giảm xuống (giá)',                         '動詞',     4,  '下がります'),
  (sid, l43, 'きれます',       'きれます',       'kiremasu',     'đứt',                                            '動詞',     5,  '切れます'),
  (sid, l43, 'とれます',       'とれます',       'toremasu',     'tuột, rơi ra',                                   '動詞',     6,  NULL),
  (sid, l43, 'おちます',       'おちます',       'ochimasu',     'rơi, rớt',                                       '動詞',     7,  NULL),
  (sid, l43, 'なくなります',   'なくなります',   'nakunarimasu', 'hết, cạn (ví dụ hết xăng)',                      '動詞',     8,  NULL),
  (sid, l43, 'じょうぶ [な]',  'じょうぶ',       'joubu [na]',   'chắc, bền',                                      'な形容詞', 9,  '丈夫 [な]'),
  (sid, l43, 'へん [な]',      'へん',           'hen [na]',     'lạ, kì quặc',                                    'な形容詞', 10, '変 [な]'),
  (sid, l43, 'しあわせ',       'しあわせ',       'shiawase',     'hạnh phúc',                                      '名詞',     11, '幸せ'),
  (sid, l43, 'うまい',         'うまい',         'umai',         'ngon',                                           'い形容詞', 12, NULL),
  (sid, l43, 'まずい',         'まずい',         'mazui',        'dở',                                             'い形容詞', 13, NULL),
  (sid, l43, 'つまらない',     'つまらない',     'tsumaranai',   'buồn tẻ, không hấp dẫn, không thú vị',           'い形容詞', 14, NULL),
  (sid, l43, 'ガソリン',       'ガソリン',       'gasorin',      'xăng',                                           '名詞',     15, NULL),
  (sid, l43, 'ひ',             'ひ',             'hi',           'lửa',                                            '名詞',     16, '火'),
  (sid, l43, 'だんぼう',       'だんぼう',       'danbou',       'lò sưởi, thiết bị sưởi ấm',                      '名詞',     17, '暖房'),
  (sid, l43, 'れいぼう',       'れいぼう',       'reibou',       'máy làm mát, điều hòa',                          '名詞',     18, '冷房'),
  (sid, l43, 'センス',         'センス',         'sensu',        'khiếu, gu thẩm mỹ',                              '名詞',     19, NULL),
  (sid, l43, 'いまにも',       'いまにも',       'ima ni mo',    'sắp, sắp sửa (~ đến nơi)',                       '副詞',     20, '今にも'),
  (sid, l43, 'わあ',           'わあ',           'waa',          'ôi! (thán từ ngạc nhiên)',                       '感動詞',   21, NULL),
  (sid, l43, 'かいいん',       'かいいん',       'kaiin',        'thành viên, hội viên',                           '名詞',     22, '会員'),
  (sid, l43, 'てきとう [な]',  'てきとう',       'tekitou [na]', 'thích hợp, vừa phải',                            'な形容詞', 23, '適当 [な]'),
  (sid, l43, 'ねんれい',       'ねんれい',       'nenrei',       'tuổi, độ tuổi',                                  '名詞',     24, '年齢'),
  (sid, l43, 'しゅうにゅう',   'しゅうにゅう',   'shuunyuu',     'thu nhập',                                       '名詞',     25, '収入'),
  (sid, l43, 'ぴったり',       'ぴったり',       'pittari',      'vừa vặn, khít, đúng',                            '副詞',     26, NULL),
  (sid, l43, 'そのうえ',       'そのうえ',       'sono ue',      'thêm vào đó, hơn thế nữa',                       '接続詞',   27, NULL),
  (sid, l43, '～といいます',   '～といいます',   '~ to iimasu',  'tên là ~, được gọi là ~',                        '表現',     28, '～と言います'),
  (sid, l43, 'ばら',           'ばら',           'bara',         'hoa hồng',                                       '名詞',     29, NULL),
  (sid, l43, 'ドライブ',       'ドライブ',       'doraibu',      'lái xe (đi chơi)',                               '名詞',     30, NULL);

-- ════════════════════════════════════════
-- BÀI 44 — xóa và seed lại (41 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l44;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l44, 'なきます',                       'なきます',                       'nakimasu',                    'khóc',                                  '動詞',     1,  '泣きます'),
  (sid, l44, 'わらいます',                     'わらいます',                     'waraimasu',                   'cười',                                  '動詞',     2,  '笑います'),
  (sid, l44, 'かわきます',                     'かわきます',                     'kawakimasu',                  'khô, ráo',                              '動詞',     3,  '乾きます'),
  (sid, l44, 'ぬれます',                       'ぬれます',                       'nuremasu',                    'ướt',                                   '動詞',     4,  NULL),
  (sid, l44, 'すべります',                     'すべります',                     'suberimasu',                  'trượt, trượt chân',                     '動詞',     5,  '滑ります'),
  (sid, l44, 'おきます',                       'おきます',                       'okimasu',                     'xảy ra (sự việc)',                      '動詞',     6,  '起きます'),
  (sid, l44, 'ちょうせつします',               'ちょうせつします',               'chousetsu shimasu',           'điều chỉnh',                            '動詞',     7,  '調節します'),
  (sid, l44, 'あんぜん [な]',                  'あんぜん',                       'anzen [na]',                  'an toàn',                               'な形容詞', 8,  '安全 [な]'),
  (sid, l44, 'ていねい [な]',                  'ていねい',                       'teinei [na]',                 'lịch sự, cẩn thận',                     'な形容詞', 9,  '丁寧 [な]'),
  (sid, l44, 'こまかい',                       'こまかい',                       'komakai',                     'nhỏ, chi tiết, vụn',                    'い形容詞', 10, '細かい'),
  (sid, l44, 'こい',                           'こい',                           'koi',                         'đậm, đặc',                              'い形容詞', 11, '濃い'),
  (sid, l44, 'うすい',                         'うすい',                         'usui',                        'nhạt, loãng, mỏng',                     'い形容詞', 12, '薄い'),
  (sid, l44, 'くうき',                         'くうき',                         'kuuki',                       'không khí',                             '名詞',     13, '空気'),
  (sid, l44, 'なみだ',                         'なみだ',                         'namida',                      'nước mắt',                              '名詞',     14, '涙'),
  (sid, l44, 'わしょく',                       'わしょく',                       'washoku',                     'món ăn Nhật',                           '名詞',     15, '和食'),
  (sid, l44, 'ようしょく',                     'ようしょく',                     'youshoku',                    'món ăn Tây',                            '名詞',     16, '洋食'),
  (sid, l44, 'おかず',                         'おかず',                         'okazu',                       'thức ăn (kèm cơm)',                     '名詞',     17, NULL),
  (sid, l44, 'りょう',                         'りょう',                         'ryou',                        'lượng, số lượng',                       '名詞',     18, '量'),
  (sid, l44, '～ばい',                         '～ばい',                         '~ bai',                       'gấp ~ lần',                             '接尾辞',   19, '～倍'),
  (sid, l44, 'はんぶん',                       'はんぶん',                       'hanbun',                      'một nửa',                               '名詞',     20, '半分'),
  (sid, l44, 'シングル',                       'シングル',                       'shinguru',                    'phòng đơn',                             '名詞',     21, NULL),
  (sid, l44, 'ツイン',                         'ツイン',                         'tsuin',                       'phòng đôi',                             '名詞',     22, NULL),
  (sid, l44, 'たんす',                         'たんす',                         'tansu',                       'tủ quần áo',                            '名詞',     23, NULL),
  (sid, l44, 'せんたくもの',                   'せんたくもの',                   'sentakumono',                 'đồ giặt',                               '名詞',     24, '洗濯物'),
  (sid, l44, 'りゆう',                         'りゆう',                         'riyuu',                       'lý do',                                 '名詞',     25, '理由'),
  (sid, l44, 'どうなさいますか',               'どうなさいますか',               'dou nasaimasu ka',            'ông/chị muốn làm thế nào ạ?',           '表現',     26, NULL),
  (sid, l44, 'カット',                         'カット',                         'katto',                       'cắt (tóc)',                             '名詞',     27, NULL),
  (sid, l44, 'シャンプー',                     'シャンプー',                     'shanpuu',                     'dầu gội đầu',                           '名詞',     28, NULL),
  (sid, l44, 'どういうふうになさいますか',     'どういうふうになさいますか',     'dou iu fuu ni nasaimasu ka',  'ông/chị muốn làm kiểu như thế nào ạ?',  '表現',     29, NULL),
  (sid, l44, 'ショート',                       'ショート',                       'shooto',                      '(kiểu tóc) ngắn',                       '名詞',     30, NULL),
  (sid, l44, '～みたいにしてください',         '～みたいにしてください',         '~ mitai ni shite kudasai',    'xin làm giống như ~',                   '表現',     31, NULL),
  (sid, l44, 'これでよろしいでしょうか',       'これでよろしいでしょうか',       'kore de yoroshii deshou ka',  'thế này được chưa ạ?',                  '表現',     32, NULL),
  (sid, l44, '[どうも] おつかれさまでした',    'どうもおつかれさまでした',       '[doumo] otsukaresama deshita','cám ơn (anh/chị) đã vất vả',            '挨拶',     33, NULL),
  (sid, l44, 'いやがります',                   'いやがります',                   'iyagarimasu',                 'tỏ ra khó chịu, ghét',                  '動詞',     34, '嫌がります'),
  (sid, l44, 'また',                           'また',                           'mata',                        'và, ngoài ra',                          '接続詞',   35, NULL),
  (sid, l44, 'じゅんじょ',                     'じゅんじょ',                     'junjo',                       'thứ tự, trình tự',                      '名詞',     36, '順序'),
  (sid, l44, 'ひょうげん',                     'ひょうげん',                     'hyougen',                     'cách nói, cách diễn đạt',               '名詞',     37, '表現'),
  (sid, l44, 'たとえば',                       'たとえば',                       'tatoeba',                     'ví dụ',                                 '副詞',     38, '例えば'),
  (sid, l44, 'わかれます',                     'わかれます',                     'wakaremasu',                  'chia tay, chia cách',                   '動詞',     39, '別れます'),
  (sid, l44, 'これら',                         'これら',                         'korera',                      'những cái này, những thứ này',          '代名詞',   40, NULL),
  (sid, l44, 'えんぎがわるい',                 'えんぎがわるい',                 'engi ga warui',               'điềm xấu, không may',                   '表現',     41, '縁起が悪い');

-- ════════════════════════════════════════
-- BÀI 45 — xóa và seed lại (32 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l45;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l45, 'あやまります',       'あやまります',       'ayamarimasu',      'xin lỗi, tạ lỗi',                       '動詞',     1,  '謝ります'),
  (sid, l45, 'あいます [じこに～]','あいます',           'aimasu [jiko ni ~]','gặp phải (tai nạn)',                   '動詞',     2,  NULL),
  (sid, l45, 'しんじます',         'しんじます',         'shinjimasu',       'tin, tin tưởng',                        '動詞',     3,  '信じます'),
  (sid, l45, 'よういします',       'よういします',       'youi shimasu',     'chuẩn bị',                              '動詞',     4,  '用意します'),
  (sid, l45, 'キャンセルします',   'キャンセルします',   'kyanseru shimasu', 'hủy, hủy bỏ',                           '動詞',     5,  NULL),
  (sid, l45, 'うまくいきます',     'うまくいきます',     'umaku ikimasu',    'suôn sẻ, thuận lợi',                    '動詞',     6,  NULL),
  (sid, l45, 'ほしょうしょ',       'ほしょうしょ',       'hoshousho',        'giấy bảo hành',                         '名詞',     7,  '保証書'),
  (sid, l45, 'りょうしゅうしょ',   'りょうしゅうしょ',   'ryoushuusho',      'biên lai, hóa đơn',                     '名詞',     8,  '領収書'),
  (sid, l45, 'おくりもの',         'おくりもの',         'okurimono',        'quà tặng',                              '名詞',     9,  '贈り物'),
  (sid, l45, 'まちがいでんわ',     'まちがいでんわ',     'machigai denwa',   'cuộc gọi nhầm số',                      '名詞',     10, '間違い電話'),
  (sid, l45, 'キャンプ',           'キャンプ',           'kyanpu',           'cắm trại',                              '名詞',     11, NULL),
  (sid, l45, 'かかり',             'かかり',             'kakari',           'nhân viên, người phụ trách',            '名詞',     12, '係'),
  (sid, l45, 'ちゅうし',           'ちゅうし',           'chuushi',          'sự đình chỉ, sự hủy bỏ (giữa chừng)',   '名詞',     13, '中止'),
  (sid, l45, 'てん',               'てん',               'ten',              'điểm, chấm',                            '名詞',     14, '点'),
  (sid, l45, 'レバー',             'レバー',             'rebaa',            'cần gạt, cần điều khiển',               '名詞',     15, NULL),
  (sid, l45, '[えん] さつ',        'えんさつ',           '[en] satsu',       'tờ tiền giấy (mệnh giá yên)',           '名詞',     16, '[円] 札'),
  (sid, l45, 'ちゃんと',           'ちゃんと',           'chanto',           'đàng hoàng, đúng cách, hẳn hoi',        '副詞',     17, NULL),
  (sid, l45, 'きゅうに',           'きゅうに',           'kyuu ni',          'đột nhiên, bất chợt',                   '副詞',     18, '急に'),
  (sid, l45, 'いじょうです',       'いじょうです',       'ijou desu',        'xin hết (đã trình bày xong)',           '表現',     19, '以上です'),
  (sid, l45, 'かかりいん',         'かかりいん',         'kakariin',         'nhân viên phụ trách',                   '名詞',     20, '係員'),
  (sid, l45, 'コース',             'コース',             'koosu',            'đường chạy (marathon), lộ trình',       '名詞',     21, NULL),
  (sid, l45, 'スタート',           'スタート',           'sutaato',          'xuất phát, khởi đầu',                   '名詞',     22, NULL),
  (sid, l45, 'ゆうしょうします',   'ゆうしょうします',   'yuushou shimasu',  'vô địch, giải nhất',                    '動詞',     23, '優勝します'),
  (sid, l45, 'なやみ',             'なやみ',             'nayami',           'điều lo nghĩ, trăn trở, phiền muộn',    '名詞',     24, '悩み'),
  (sid, l45, 'めざまし [とけい]',  'めざましとけい',     'mezamashi [tokei]','đồng hồ báo thức',                      '名詞',     25, '目覚まし [時計]'),
  (sid, l45, 'ねむります',         'ねむります',         'nemurimasu',       'ngủ',                                   '動詞',     26, '眠ります'),
  (sid, l45, 'めがさめます',       'めがさめます',       'me ga samemasu',   'tỉnh giấc, thức giấc',                  '動詞',     27, '目が覚めます'),
  (sid, l45, 'だいがくせい',       'だいがくせい',       'daigakusei',       'sinh viên đại học',                     '名詞',     28, '大学生'),
  (sid, l45, 'かいとう',           'かいとう',           'kaitou',           'câu trả lời, hồi đáp',                  '名詞',     29, '回答'),
  (sid, l45, 'なります',           'なります',           'narimasu',         'reo, kêu, vang lên (chuông)',           '動詞',     30, NULL),
  (sid, l45, 'セットします',       'セットします',       'setto shimasu',    'cài đặt, thiết lập',                    '動詞',     31, NULL),
  (sid, l45, 'それでも',           'それでも',           'sore demo',        'tuy nhiên, dù vậy',                     '接続詞',   32, NULL);

-- ════════════════════════════════════════
-- BÀI 46 — xóa và seed lại (32 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l46;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l46, 'やきます',                   'やきます',                   'yakimasu',            'nướng, rán',                          '動詞',     1,  '焼きます'),
  (sid, l46, 'わたします',                 'わたします',                 'watashimasu',         'trao, giao cho',                      '動詞',     2,  '渡します'),
  (sid, l46, 'かえってきます',             'かえってきます',             'kaette kimasu',       'quay về, trở lại',                    '動詞',     3,  '帰ってきます'),
  (sid, l46, 'でます [バスが～]',          'でます',                     'demasu [basu ga ~]',  'xuất phát, rời bến (xe buýt)',        '動詞',     4,  '出ます [バスが～]'),
  (sid, l46, 'るす',                       'るす',                       'rusu',                'vắng nhà',                            '名詞',     5,  '留守'),
  (sid, l46, 'たくはいびん',               'たくはいびん',               'takuhaibin',          'dịch vụ giao hàng tận nhà',           '名詞',     6,  '宅配便'),
  (sid, l46, 'げんいん',                   'げんいん',                   'gen''in',             'nguyên nhân',                         '名詞',     7,  '原因'),
  (sid, l46, 'ちゅうしゃ',                 'ちゅうしゃ',                 'chuusha',             'tiêm, sự tiêm',                       '名詞',     8,  '注射'),
  (sid, l46, 'しょくよく',                 'しょくよく',                 'shokuyoku',           'sự thèm ăn',                          '名詞',     9,  '食欲'),
  (sid, l46, 'パンフレット',               'パンフレット',               'panfuretto',          'tờ quảng cáo, tập gấp',               '名詞',     10, NULL),
  (sid, l46, 'ステレオ',                   'ステレオ',                   'sutereo',             'dàn âm thanh stereo',                 '名詞',     11, NULL),
  (sid, l46, 'こちら',                     'こちら',                     'kochira',             'phía (chúng tôi), bên (chúng tôi)',   '代名詞',   12, NULL),
  (sid, l46, '～のところ',                 '～のところ',                 '~ no tokoro',         'quanh chỗ ~, ở chỗ ~',                '表現',     13, '～の所'),
  (sid, l46, 'ちょうど',                   'ちょうど',                   'choudo',              'vừa đúng, vừa vặn',                   '副詞',     14, NULL),
  (sid, l46, 'たったいま',                 'たったいま',                 'tatta ima',           'vừa mới, mới ban nãy',                '副詞',     15, 'たった今'),
  (sid, l46, 'いまいいでしょうか',         'いまいいでしょうか',         'ima ii deshou ka',    'bây giờ có tiện không ạ?',            '表現',     16, '今いいでしょうか'),
  (sid, l46, 'ガスコンロ',                 'ガスコンロ',                 'gasukonro',           'bếp ga',                              '名詞',     17, NULL),
  (sid, l46, 'ぐあい',                     'ぐあい',                     'guai',                'trạng thái, tình trạng',              '名詞',     18, '具合'),
  (sid, l46, 'どちらさまでしょうか',       'どちらさまでしょうか',       'dochirasama deshou ka','xin hỏi là vị nào ạ?',               '表現',     19, 'どちら様でしょうか'),
  (sid, l46, 'むかいます',                 'むかいます',                 'mukaimasu',           'hướng về, đi về phía',                '動詞',     20, '向かいます'),
  (sid, l46, 'おまたせしました',           'おまたせしました',           'omatase shimashita',  'xin lỗi đã để (anh/chị) chờ lâu',     '表現',     21, 'お待たせしました'),
  (sid, l46, 'ちしき',                     'ちしき',                     'chishiki',            'tri thức, kiến thức',                 '名詞',     22, '知識'),
  (sid, l46, 'ほうこ',                     'ほうこ',                     'houko',               'kho báu',                             '名詞',     23, '宝庫'),
  (sid, l46, 'システム',                   'システム',                   'shisutemu',           'hệ thống',                            '名詞',     24, NULL),
  (sid, l46, 'キーワード',                 'キーワード',                 'kiiwaado',            'từ khóa, điểm then chốt',             '名詞',     25, NULL),
  (sid, l46, 'いちぶぶん',                 'いちぶぶん',                 'ichibubun',           'một bộ phận, một phần',               '名詞',     26, '一部分'),
  (sid, l46, 'にゅうりょくします',         'にゅうりょくします',         'nyuuryoku shimasu',   'nhập vào, nhập liệu',                 '動詞',     27, '入力します'),
  (sid, l46, 'びょう',                     'びょう',                     'byou',                'giây',                                '名詞',     28, '秒'),
  (sid, l46, 'でます [ほんが～]',          'でます',                     'demasu [hon ga ~]',   '(sách) được xuất bản',               '動詞',     29, '出ます [ほんが～]'),
  (sid, l46, 'ふきます',                   'ふきます',                   'fukimasu',            'thổi (gió thổi)',                     '動詞',     30, '吹きます'),
  (sid, l46, 'もえます',                   'もえます',                   'moemasu',             'cháy (đốt cháy được, rác)',           '動詞',     31, '燃えます'),
  (sid, l46, 'なくなります',               'なくなります',               'nakunarimasu',        'qua đời, mất',                        '動詞',     32, '亡くなります');

-- ════════════════════════════════════════
-- BÀI 47 — xóa và seed lại (31 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l47;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l47, 'あつまります',           'あつまります',           'atsumarimasu',   'tập trung, tụ họp',                        '動詞',     1,  '集まります'),
  (sid, l47, 'わかれます',             'わかれます',             'wakaremasu',     'chia ra, phân chia, tách ra',              '動詞',     2,  '分かれます'),
  (sid, l47, 'します',                 'します',                 'shimasu',        'có (âm thanh/mùi/vị)',                     '動詞',     3,  NULL),
  (sid, l47, 'さします',               'さします',               'sashimasu',      'che, giương (ô, dù)',                      '動詞',     4,  NULL),
  (sid, l47, 'ひどい',                 'ひどい',                 'hidoi',          'tồi tệ, quá đáng',                         'い形容詞', 5,  NULL),
  (sid, l47, 'こわい',                 'こわい',                 'kowai',          'sợ, đáng sợ',                              'い形容詞', 6,  '怖い'),
  (sid, l47, 'てんきよほう',           'てんきよほう',           'tenki yohou',    'dự báo thời tiết',                         '名詞',     7,  '天気予報'),
  (sid, l47, 'はっぴょう',             'はっぴょう',             'happyou',        'sự công bố, phát biểu',                    '名詞',     8,  '発表'),
  (sid, l47, 'じっけん',               'じっけん',               'jikken',         'thí nghiệm, thực nghiệm',                  '名詞',     9,  '実験'),
  (sid, l47, 'じんこう',               'じんこう',               'jinkou',         'dân số',                                   '名詞',     10, '人口'),
  (sid, l47, 'におい',                 'におい',                 'nioi',           'mùi',                                      '名詞',     11, NULL),
  (sid, l47, 'かがく',                 'かがく',                 'kagaku',         'khoa học',                                 '名詞',     12, '科学'),
  (sid, l47, 'いがく',                 'いがく',                 'igaku',          'y học, ngành y',                           '名詞',     13, '医学'),
  (sid, l47, 'ぶんがく',               'ぶんがく',               'bungaku',        'văn học',                                  '名詞',     14, '文学'),
  (sid, l47, 'パトカー',               'パトカー',               'patokaa',        'xe tuần tra (cảnh sát)',                   '名詞',     15, NULL),
  (sid, l47, 'きゅうきゅうしゃ',       'きゅうきゅうしゃ',       'kyuukyuusha',    'xe cứu thương',                            '名詞',     16, '救急車'),
  (sid, l47, 'さんせい',               'さんせい',               'sansei',         'tán thành, đồng ý',                        '名詞',     17, '賛成'),
  (sid, l47, 'はんたい',               'はんたい',               'hantai',         'phản đối',                                 '名詞',     18, '反対'),
  (sid, l47, 'だんせい',               'だんせい',               'dansei',         'phái nam, nam giới',                       '名詞',     19, '男性'),
  (sid, l47, 'じょせい',               'じょせい',               'josei',          'phái nữ, nữ giới',                         '名詞',     20, '女性'),
  (sid, l47, 'どうも',                 'どうも',                 'doumo',          'hình như, dường như (khi phán đoán)',      '副詞',     21, NULL),
  (sid, l47, '～によると',             '～によると',             '~ ni yoru to',   'theo ~, căn cứ theo ~ (nguồn tin)',        '表現',     22, NULL),
  (sid, l47, 'しりあいます',           'しりあいます',           'shiriaimasu',    'quen biết, làm quen',                      '動詞',     23, '知り合います'),
  (sid, l47, 'へいきんじゅみょう',     'へいきんじゅみょう',     'heikin jumyou',  'tuổi thọ trung bình',                      '名詞',     24, '平均寿命'),
  (sid, l47, 'くらべます',             'くらべます',             'kurabemasu',     'so sánh',                                  '動詞',     25, '比べます'),
  (sid, l47, 'はかせ',                 'はかせ',                 'hakase',         'tiến sĩ',                                  '名詞',     26, '博士'),
  (sid, l47, 'のう',                   'のう',                   'nou',            'não',                                      '名詞',     27, '脳'),
  (sid, l47, 'ホルモン',               'ホルモン',               'horumon',        'hormone, nội tiết tố',                     '名詞',     28, NULL),
  (sid, l47, 'けしょうひん',           'けしょうひん',           'keshouhin',      'mỹ phẩm',                                  '名詞',     29, '化粧品'),
  (sid, l47, 'しらべ',                 'しらべ',                 'shirabe',        'cuộc điều tra, khảo sát',                  '名詞',     30, '調べ'),
  (sid, l47, 'けしょう',               'けしょう',               'keshou',         'sự trang điểm',                            '名詞',     31, '化粧');

-- ════════════════════════════════════════
-- BÀI 48 — xóa và seed lại (27 từ) — bài cuối, kết thúc ở STT 1993 すがた
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l48;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l48, 'おろします',           'おろします',           'oroshimasu',       'cho xuống, hạ xuống',                       '動詞',     1,  '降ろします'),
  (sid, l48, 'とどけます',           'とどけます',           'todokemasu',       'gửi đến, giao đến',                         '動詞',     2,  '届けます'),
  (sid, l48, 'せわをします',         'せわをします',         'sewa wo shimasu',  'chăm sóc, giúp đỡ',                         '動詞',     3,  '世話をします'),
  (sid, l48, 'いや [な]',            'いや',                 'iya [na]',         'chán ghét, khó chịu',                       'な形容詞', 4,  NULL),
  (sid, l48, 'きびしい',             'きびしい',             'kibishii',         'nghiêm khắc, nghiêm ngặt',                  'い形容詞', 5,  '厳しい'),
  (sid, l48, 'スケジュール',         'スケジュール',         'sukejuuru',        'lịch trình, thời gian biểu',                '名詞',     6,  NULL),
  (sid, l48, 'せいと',               'せいと',               'seito',            'học sinh, học trò',                         '名詞',     7,  '生徒'),
  (sid, l48, 'もの',                 'もの',                 'mono',             'người (người nhà, cấp dưới của mình)',      '名詞',     8,  '者'),
  (sid, l48, 'にゅうかん',           'にゅうかん',           'nyuukan',          'sở nhập cảnh (viết tắt của 入国管理局)',    '名詞',     9,  '入管'),
  (sid, l48, 'じゆうに',             'じゆうに',             'jiyuu ni',         'một cách tự do',                            '副詞',     10, '自由に'),
  (sid, l48, '～かん',               '～かん',               '~ kan',            'trong khoảng ~ (chỉ thời lượng)',           '接尾辞',   11, '～間'),
  (sid, l48, 'いいことですね',       'いいことですね',       'ii koto desu ne',  'hay nhỉ, tốt đấy nhỉ',                      '表現',     12, NULL),
  (sid, l48, 'おいそがしいですか',   'おいそがしいですか',   'oisogashii desu ka','anh/chị đang bận à?',                      '表現',     13, 'お忙しいですか'),
  (sid, l48, 'ひさしぶり',           'ひさしぶり',           'hisashiburi',      'lâu rồi (mới), sau thời gian dài',          '名詞',     14, '久しぶり'),
  (sid, l48, 'えいぎょう',           'えいぎょう',           'eigyou',           'kinh doanh, buôn bán',                      '名詞',     15, '営業'),
  (sid, l48, 'それまでに',           'それまでに',           'sore made ni',     'trước thời điểm đó',                        '表現',     16, NULL),
  (sid, l48, 'かまいません',         'かまいません',         'kamaimasen',       'không sao, không hề gì',                    '表現',     17, NULL),
  (sid, l48, 'たのしみます',         'たのしみます',         'tanoshimimasu',    'thưởng thức, tận hưởng',                    '動詞',     18, '楽しみます'),
  (sid, l48, 'もともと',             'もともと',             'motomoto',         'vốn dĩ, ngay từ đầu',                       '副詞',     19, NULL),
  (sid, l48, '～せいき',             '～せいき',             '~ seiki',          'thế kỷ (thứ) ~',                            '接尾辞',   20, '～世紀'),
  (sid, l48, 'かわりをします',       'かわりをします',       'kawari wo shimasu','thay thế, làm thay',                        '動詞',     21, '代わりをします'),
  (sid, l48, 'スピード',             'スピード',             'supiido',          'tốc độ',                                    '名詞',     22, NULL),
  (sid, l48, 'きょうそうします',     'きょうそうします',     'kyousou shimasu',  'chạy đua, thi chạy',                        '動詞',     23, '競走します'),
  (sid, l48, 'サーカス',             'サーカス',             'saakasu',          'xiếc',                                      '名詞',     24, NULL),
  (sid, l48, 'げい',                 'げい',                 'gei',              'trò diễn, tài nghệ',                        '名詞',     25, '芸'),
  (sid, l48, 'うつくしい',           'うつくしい',           'utsukushii',       'đẹp',                                       'い形容詞', 26, '美しい'),
  (sid, l48, 'すがた',               'すがた',               'sugata',           'dáng vẻ, hình bóng, tư thế',                '名詞',     27, '姿');

END $$;
