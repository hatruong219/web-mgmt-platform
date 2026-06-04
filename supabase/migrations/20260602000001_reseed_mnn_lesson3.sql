-- Reseed: Minna no Nihongo I — Bài 1 + Bài 2 + Bài 3 + Bài 4 (correct vocabulary)
-- Quy tắc: word = kana, reading = kana, kanji = kanji (nếu có, không thì NULL)
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c

ALTER TABLE mnn_vocabulary ADD COLUMN IF NOT EXISTS kanji text;

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  l1  uuid;
  l2  uuid;
  l3  uuid;
  l4  uuid;
BEGIN

SELECT id INTO l1 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 1;
SELECT id INTO l2 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 2;
SELECT id INTO l3 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 3;
SELECT id INTO l4 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 4;

-- ════════════════════════════════════════
-- BÀI 1 — xóa và seed lại (44 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l1;

INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l1, 'わたし',                       'わたし',                       'watashi',              'Tôi',                                                 '代名詞',   1,  '私'),
  (sid, l1, 'わたしたち',                   'わたしたち',                   'watashitachi',         'Chúng tôi',                                           '代名詞',   2,  '私たち'),
  (sid, l1, 'あなた',                       'あなた',                       'anata',                'Anh/chị, ông/bà, bạn (ngôi thứ 2 số ít)',             '代名詞',   3,  NULL),
  (sid, l1, 'あのひと',                     'あのひと',                     'ano hito',             'Người kia',                                           '代名詞',   4,  'あの人'),
  (sid, l1, 'あのかた',                     'あのかた',                     'ano kata',             'Vị kia (lịch sự hơn あのひと)',                       '代名詞',   5,  'あの方'),
  (sid, l1, 'みなさん',                     'みなさん',                     'mina san',             'Các bạn, mọi người',                                  '名詞',     6,  NULL),
  (sid, l1, '～さん',                       '～さん',                       '~ san',                'Anh~, Chị~, Ông~, Bà~ (cách gọi lịch sự)',            '接尾辞',   7,  NULL),
  (sid, l1, '～ちゃん',                     '～ちゃん',                     '~ chan',               'Bé (dùng cho nữ) hoặc gọi thân mật trẻ con',         '接尾辞',   8,  NULL),
  (sid, l1, '～くん',                       '～くん',                       '~ kun',                'Bé (dùng cho nam) hoặc gọi thân mật',                '接尾辞',   9,  NULL),
  (sid, l1, '～じん',                       '～じん',                       '~ jin',                'Người nước ~',                                        '接尾辞',   10, '～人'),
  (sid, l1, 'せんせい',                     'せんせい',                     'sensei',               'Giáo viên',                                           '名詞',     11, '先生'),
  (sid, l1, 'きょうし',                     'きょうし',                     'kyoushi',              'Giáo viên (dùng để nói đến nghề nghiệp)',             '名詞',     12, '教師'),
  (sid, l1, 'がくせい',                     'がくせい',                     'gakusei',              'Học sinh, sinh viên',                                 '名詞',     13, '学生'),
  (sid, l1, 'かいしゃいん',                 'かいしゃいん',                 'kaishain',             'Nhân viên công ty',                                   '名詞',     14, '会社員'),
  (sid, l1, '～しゃいん',                   '～しゃいん',                   '~ shain',              'Nhân viên công ty ~',                                 '名詞',     15, '～社員'),
  (sid, l1, 'ぎんこういん',                 'ぎんこういん',                 'ginkouin',             'Nhân viên ngân hàng',                                 '名詞',     16, '銀行員'),
  (sid, l1, 'いしゃ',                       'いしゃ',                       'isha',                 'Bác sĩ',                                              '名詞',     17, '医者'),
  (sid, l1, 'けんきゅうしゃ',               'けんきゅうしゃ',               'kenkyuusha',           'Nhà nghiên cứu',                                      '名詞',     18, '研究者'),
  (sid, l1, 'エンジニア',                   'エンジニア',                   'enjinia',              'Kỹ sư',                                               '名詞',     19, NULL),
  (sid, l1, 'だいがく',                     'だいがく',                     'daigaku',              'Trường đại học',                                      '名詞',     20, '大学'),
  (sid, l1, 'びょういん',                   'びょういん',                   'byouin',               'Bệnh viện',                                           '名詞',     21, '病院'),
  (sid, l1, 'でんき',                       'でんき',                       'denki',                'Điện, đèn điện',                                      '名詞',     22, '電気'),
  (sid, l1, 'だれ（どなた）',               'だれ（どなた）',               'dare (donata)',         'Ai (ngài nào — lịch sự)',                             '疑問詞',   23, '誰'),
  (sid, l1, '～さい',                       '～さい',                       '~ sai',                'Tuổi',                                                '接尾辞',   24, '～歳'),
  (sid, l1, 'なんさい',                     'なんさい',                     'nansai',               'Mấy tuổi',                                            '疑問詞',   25, '何歳'),
  (sid, l1, 'はい',                         'はい',                         'hai',                  'Vâng',                                                '感動詞',   26, NULL),
  (sid, l1, 'いいえ',                       'いいえ',                       'iie',                  'Không',                                               '感動詞',   27, NULL),
  (sid, l1, 'しつれいですが',               'しつれいですが',               'shitsurei desu ga',    'Xin lỗi (khi muốn nhờ ai việc gì đó)',                '表現',     28, '失礼ですが'),
  (sid, l1, 'おなまえは？',                 'おなまえは？',                 'onamae wa',            'Bạn tên gì?',                                         '表現',     29, 'お名前は？'),
  (sid, l1, 'はじめまして',                 'はじめまして',                 'hajimemashite',        'Chào lần đầu gặp nhau',                               '挨拶',     30, '初めまして'),
  (sid, l1, 'どうぞよろしく[おねがいします]', 'どうぞよろしく[おねがいします]', 'douzo yoroshiku',  'Rất hân hạnh được làm quen',                         '挨拶',     31, 'どうぞよろしく[お願いします]'),
  (sid, l1, 'こちらは～さんです',           'こちらは～さんです',           'kochira wa ~ san desu','Đây là ngài ~',                                       '表現',     32, NULL),
  (sid, l1, '～からきました',               '～からきました',               '~ kara kimashita',     'Đến từ ~',                                            '表現',     33, '～から来ました'),
  (sid, l1, 'アメリカ',                     'アメリカ',                     'Amerika',              'Mỹ',                                                  '固有名詞', 34, NULL),
  (sid, l1, 'イギリス',                     'イギリス',                     'Igirisu',              'Anh',                                                 '固有名詞', 35, NULL),
  (sid, l1, 'インド',                       'インド',                       'Indo',                 'Ấn Độ',                                               '固有名詞', 36, NULL),
  (sid, l1, 'インドネシア',                 'インドネシア',                 'Indoneshia',           'Indonesia',                                           '固有名詞', 37, NULL),
  (sid, l1, 'かんこく',                     'かんこく',                     'Kankoku',              'Hàn Quốc',                                            '固有名詞', 38, '韓国'),
  (sid, l1, 'タイ',                         'タイ',                         'Tai',                  'Thái Lan',                                            '固有名詞', 39, NULL),
  (sid, l1, 'ちゅうごく',                   'ちゅうごく',                   'Chuugoku',             'Trung Quốc',                                          '固有名詞', 40, '中国'),
  (sid, l1, 'ドイツ',                       'ドイツ',                       'Doitsu',               'Đức',                                                 '固有名詞', 41, NULL),
  (sid, l1, 'にほん',                       'にほん',                       'Nihon',                'Nhật',                                                '固有名詞', 42, '日本'),
  (sid, l1, 'フランス',                     'フランス',                     'Furansu',              'Pháp',                                                '固有名詞', 43, NULL),
  (sid, l1, 'ブラジル',                     'ブラジル',                     'Burajiru',             'Brazil',                                              '固有名詞', 44, NULL);

-- ════════════════════════════════════════
-- BÀI 2 — xóa và seed lại (47 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l2;

INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l2, 'これ',                         'これ',                         'kore',                 'Cái này, đây (vật ở gần người nói)',                  '指示語',   1,  NULL),
  (sid, l2, 'それ',                         'それ',                         'sore',                 'Cái đó, đó (vật ở gần người nghe)',                   '指示語',   2,  NULL),
  (sid, l2, 'あれ',                         'あれ',                         'are',                  'Cái kia, kia (vật ở xa cả hai)',                      '指示語',   3,  NULL),
  (sid, l2, 'この〜',                       'この〜',                       'kono',                 '~ này',                                               '連体詞',   4,  NULL),
  (sid, l2, 'その〜',                       'その〜',                       'sono',                 '~ đó',                                                '連体詞',   5,  NULL),
  (sid, l2, 'あの〜',                       'あの〜',                       'ano',                  '~ kia',                                               '連体詞',   6,  NULL),
  (sid, l2, 'ほん',                         'ほん',                         'hon',                  'Sách',                                                '名詞',     7,  '本'),
  (sid, l2, 'じしょ',                       'じしょ',                       'jisho',                'Từ điển',                                             '名詞',     8,  '辞書'),
  (sid, l2, 'ざっし',                       'ざっし',                       'zasshi',               'Tạp chí',                                             '名詞',     9,  '雑誌'),
  (sid, l2, 'しんぶん',                     'しんぶん',                     'shinbun',              'Báo',                                                 '名詞',     10, '新聞'),
  (sid, l2, 'ノート',                       'ノート',                       'nooto',                'Vở',                                                  '名詞',     11, NULL),
  (sid, l2, 'てちょう',                     'てちょう',                     'techou',               'Sổ tay',                                              '名詞',     12, '手帳'),
  (sid, l2, 'めいし',                       'めいし',                       'meishi',               'Danh thiếp',                                          '名詞',     13, '名刺'),
  (sid, l2, 'カード',                       'カード',                       'kaado',                'Thẻ, cạc',                                            '名詞',     14, NULL),
  (sid, l2, 'テレホンカード',               'テレホンカード',               'terehon kaado',        'Thẻ điện thoại',                                      '名詞',     15, NULL),
  (sid, l2, 'えんぴつ',                     'えんぴつ',                     'enpitsu',              'Bút chì',                                             '名詞',     16, '鉛筆'),
  (sid, l2, 'ボールペン',                   'ボールペン',                   'boorupen',             'Bút bi',                                              '名詞',     17, NULL),
  (sid, l2, 'シャープペンシル',             'シャープペンシル',             'shaapupenshiru',       'Bút chì kim, bút chì bấm',                            '名詞',     18, NULL),
  (sid, l2, 'かぎ',                         'かぎ',                         'kagi',                 'Chìa khóa',                                           '名詞',     19, NULL),
  (sid, l2, 'とけい',                       'とけい',                       'tokei',                'Đồng hồ',                                             '名詞',     20, '時計'),
  (sid, l2, 'かさ',                         'かさ',                         'kasa',                 'Ô, dù',                                               '名詞',     21, '傘'),
  (sid, l2, 'かばん',                       'かばん',                       'kaban',                'Cặp sách, túi sách',                                  '名詞',     22, NULL),
  (sid, l2, '[カセット]テープ',             '[カセット]テープ',             'kasetto teepu',        'Băng [cát-xét]',                                      '名詞',     23, NULL),
  (sid, l2, 'テープレコーダー',             'テープレコーダー',             'teepu rekoodaa',       'Máy ghi âm',                                          '名詞',     24, NULL),
  (sid, l2, 'テレビ',                       'テレビ',                       'terebi',               'Tivi',                                                '名詞',     25, NULL),
  (sid, l2, 'ラジオ',                       'ラジオ',                       'rajio',                'Radio',                                               '名詞',     26, NULL),
  (sid, l2, 'カメラ',                       'カメラ',                       'kamera',               'Máy ảnh',                                             '名詞',     27, NULL),
  (sid, l2, 'コンピュータ',                 'コンピュータ',                 'konpyuuta',            'Máy vi tính',                                         '名詞',     28, NULL),
  (sid, l2, 'じどうしゃ',                   'じどうしゃ',                   'jidousha',             'Ô tô, xe hơi',                                        '名詞',     29, '自動車'),
  (sid, l2, 'つくえ',                       'つくえ',                       'tsukue',               'Cái bàn',                                             '名詞',     30, '机'),
  (sid, l2, 'いす',                         'いす',                         'isu',                  'Ghế',                                                 '名詞',     31, NULL),
  (sid, l2, 'チョコレート',                 'チョコレート',                 'chokoreeto',           'Chocolate',                                           '名詞',     32, NULL),
  (sid, l2, 'コーヒー',                     'コーヒー',                     'koohii',               'Cà phê',                                              '名詞',     33, NULL),
  (sid, l2, 'えいご',                       'えいご',                       'eigo',                 'Tiếng Anh',                                           '名詞',     34, '英語'),
  (sid, l2, 'にほんご',                     'にほんご',                     'nihongo',              'Tiếng Nhật',                                          '名詞',     35, '日本語'),
  (sid, l2, '〜ご',                         '〜ご',                         '~ go',                 'Tiếng ~',                                             '接尾辞',   36, '〜語'),
  (sid, l2, 'なん',                         'なん',                         'nan',                  'Cái gì',                                              '疑問詞',   37, '何'),
  (sid, l2, 'そう',                         'そう',                         'soo',                  'Đúng vậy',                                            '副詞',     38, NULL),
  (sid, l2, 'ちがいます',                   'ちがいます',                   'chigaimasu',           'Nhầm rồi',                                            '動詞',     39, '違います'),
  (sid, l2, 'そうですか',                   'そうですか',                   'sou desu ka',          'Thế à?',                                              '表現',     40, NULL),
  (sid, l2, 'あのう',                       'あのう',                       'anou',                 'À… (thể hiện sự do dự)',                              '感動詞',   41, NULL),
  (sid, l2, 'ほんのきもちです',             'ほんのきもちです',             'hon no kimochi desu',  'Đây là chút quà nhỏ của tôi',                        '表現',     42, 'ほんの気持ちです'),
  (sid, l2, 'どうぞ',                       'どうぞ',                       'douzo',                'Xin mời',                                             '副詞',     43, NULL),
  (sid, l2, 'どうも',                       'どうも',                       'doumo',                'Cảm ơn',                                              '感動詞',   44, NULL),
  (sid, l2, '[どうも]ありがとう[ございます]', '[どうも]ありがとう[ございます]', 'arigatou gozaimasu', 'Cảm ơn nhiều',                                      '表現',     45, NULL),
  (sid, l2, 'これからおせわになります',     'これからおせわになります',     'kore kara osewa ni narimasu', 'Từ này mong được anh/chị giúp đỡ',            '表現',     46, 'これからお世話になります'),
  (sid, l2, 'こちらこそよろしく',           'こちらこそよろしく',           'kochira koso yoroshiku', 'Chính tôi mới mong được anh/chị giúp đỡ',          '表現',     47, NULL);

-- ════════════════════════════════════════
-- BÀI 3 — xóa và seed lại (43 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l3;

INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l3, 'ここ',                         'ここ',                         'koko',                 'chỗ này, đây',                                        '指示語',   1,  NULL),
  (sid, l3, 'そこ',                         'そこ',                         'soko',                 'chỗ đó, đó',                                          '指示語',   2,  NULL),
  (sid, l3, 'あそこ',                       'あそこ',                       'asoko',                'chỗ kia, kia',                                        '指示語',   3,  NULL),
  (sid, l3, 'どこ',                         'どこ',                         'doko',                 'chỗ nào, đâu',                                        '指示語',   4,  NULL),
  (sid, l3, 'こちら',                       'こちら',                       'kochira',              'phía này, đây (lịch sự của ここ)',                    '指示語',   5,  NULL),
  (sid, l3, 'そちら',                       'そちら',                       'sochira',              'phía đó, đó (lịch sự của そこ)',                      '指示語',   6,  NULL),
  (sid, l3, 'あちら',                       'あちら',                       'achira',               'phía kia, kia (lịch sự của あそこ)',                  '指示語',   7,  NULL),
  (sid, l3, 'どちら',                       'どちら',                       'dochira',              'phía nào, đâu (lịch sự của どこ)',                    '指示語',   8,  NULL),
  (sid, l3, 'きょうしつ',                   'きょうしつ',                   'kyoushitsu',           'lớp học, phòng học',                                  '名詞',     9,  '教室'),
  (sid, l3, 'しょくどう',                   'しょくどう',                   'shokudou',             'nhà ăn',                                              '名詞',     10, '食堂'),
  (sid, l3, 'じむしょ',                     'じむしょ',                     'jimusho',              'văn phòng',                                           '名詞',     11, '事務所'),
  (sid, l3, 'かいぎしつ',                   'かいぎしつ',                   'kaigishitsu',          'phòng họp',                                           '名詞',     12, '会議室'),
  (sid, l3, 'うけつけ',                     'うけつけ',                     'uketsuke',             'bộ phận tiếp tân, phòng thường trực, lễ tân',         '名詞',     13, '受付'),
  (sid, l3, 'ロビー',                       'ロビー',                       'robii',                'hành lang, đại sảnh',                                 '名詞',     14, NULL),
  (sid, l3, 'へや',                         'へや',                         'heya',                 'căn phòng',                                           '名詞',     15, '部屋'),
  (sid, l3, 'トイレ（おてあらい）',         'トイレ（おてあらい）',         'toire',                'nhà vệ sinh, phòng vệ sinh, toa-lét',                 '名詞',     16, 'トイレ（お手洗い）'),
  (sid, l3, 'かいだん',                     'かいだん',                     'kaidan',               'cầu thang',                                           '名詞',     17, '階段'),
  (sid, l3, 'エレベーター',                 'エレベーター',                 'erebeetaa',            'thang máy',                                           '名詞',     18, NULL),
  (sid, l3, 'エスカレーター',               'エスカレーター',               'esukareetaa',          'thang cuốn',                                          '名詞',     19, NULL),
  (sid, l3, '[お]くに',                     '[お]くに',                     'okuni',                'đất nước',                                            '名詞',     20, '[お]国'),
  (sid, l3, 'かいしゃ',                     'かいしゃ',                     'kaisha',               'công ty',                                             '名詞',     21, '会社'),
  (sid, l3, 'うち',                         'うち',                         'uchi',                 'nhà',                                                 '名詞',     22, NULL),
  (sid, l3, 'でんわ',                       'でんわ',                       'denwa',                'máy điện thoại, điện thoại',                          '名詞',     23, '電話'),
  (sid, l3, 'くつ',                         'くつ',                         'kutsu',                'giày',                                                '名詞',     24, '靴'),
  (sid, l3, 'ネクタイ',                     'ネクタイ',                     'nekutai',              'cà vạt',                                              '名詞',     25, NULL),
  (sid, l3, 'ワイン',                       'ワイン',                       'wain',                 'rượu vang',                                           '名詞',     26, NULL),
  (sid, l3, 'たばこ',                       'たばこ',                       'tabako',               'thuốc lá',                                            '名詞',     27, NULL),
  (sid, l3, 'うりば',                       'うりば',                       'uriba',                'quầy bán (trong cửa hàng bách hóa)',                  '名詞',     28, '売り場'),
  (sid, l3, 'ちか',                         'ちか',                         'chika',                'tầng hầm, dưới mặt đất',                              '名詞',     29, '地下'),
  (sid, l3, '〜かい',                       '〜かい',                       '~ kai',                'tầng thứ –',                                          '接尾辞',   30, '〜階'),
  (sid, l3, 'なんがい',                     'なんがい',                     'nangai',               'tầng mấy',                                            '疑問詞',   31, '何階'),
  (sid, l3, '〜えん',                       '〜えん',                       '~ en',                 'yên (đơn vị tiền tệ)',                                '接尾辞',   32, '〜円'),
  (sid, l3, 'いくら',                       'いくら',                       'ikura',                'bao nhiêu tiền',                                      '疑問詞',   33, NULL),
  (sid, l3, 'ひゃく',                       'ひゃく',                       'hyaku',                'trăm',                                                '名詞',     34, '百'),
  (sid, l3, 'せん',                         'せん',                         'sen',                  'nghìn',                                               '名詞',     35, '千'),
  (sid, l3, 'まん',                         'まん',                         'man',                  'mười nghìn, vạn',                                     '名詞',     36, '万'),
  (sid, l3, 'すみません',                   'すみません',                   'sumimasen',            'Xin lỗi',                                             '挨拶',     37, NULL),
  (sid, l3, '〜でございます',               '〜でございます',               'de gozaimasu',         'cách nói lịch sự của です',                           '表現',     38, NULL),
  (sid, l3, 'みせてください',               'みせてください',               'misete kudasai',       'cho tôi xem [~]',                                     '表現',     39, '見せてください'),
  (sid, l3, 'じゃ',                         'じゃ',                         'ja',                   'thế thì, vậy thì',                                    '接続詞',   40, NULL),
  (sid, l3, '[〜を]ください',               '[〜を]ください',               'kudasai',              'cho tôi [~]',                                         '表現',     41, NULL),
  (sid, l3, 'イタリア',                     'イタリア',                     'itaria',               'Ý (Italy)',                                            '固有名詞', 42, NULL),
  (sid, l3, 'スイス',                       'スイス',                       'suisu',                'Thụy Sĩ (Switzerland)',                               '固有名詞', 43, NULL);

-- ════════════════════════════════════════
-- BÀI 4 — xóa và seed lại (45 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l4;

INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l4, 'おきます',                     'おきます',                     'okimasu',              'thức dậy',                                            '動詞',     1,  NULL),
  (sid, l4, 'ねます',                       'ねます',                       'nemasu',               'ngủ',                                                 '動詞',     2,  '寝ます'),
  (sid, l4, 'はたらきます',                 'はたらきます',                 'hatarakimasu',         'làm việc',                                            '動詞',     3,  '働きます'),
  (sid, l4, 'やすみます',                   'やすみます',                   'yasumimasu',           'nghỉ ngơi',                                           '動詞',     4,  '休みます'),
  (sid, l4, 'べんきょうします',             'べんきょうします',             'benkyou shimasu',      'học tập',                                             '動詞',     5,  '勉強します'),
  (sid, l4, 'おわります',                   'おわります',                   'owarimasu',            'kết thúc',                                            '動詞',     6,  '終わります'),
  (sid, l4, 'デパート',                     'デパート',                     'depaato',              'cửa hàng bách hóa',                                   '名詞',     7,  NULL),
  (sid, l4, 'ぎんこう',                     'ぎんこう',                     'ginkou',               'ngân hàng',                                           '名詞',     8,  '銀行'),
  (sid, l4, 'ゆうびんきょく',               'ゆうびんきょく',               'yuubinkyoku',          'bưu điện',                                            '名詞',     9,  '郵便局'),
  (sid, l4, 'としょかん',                   'としょかん',                   'toshokan',             'thư viện',                                            '名詞',     10, '図書館'),
  (sid, l4, 'びじゅつかん',                 'びじゅつかん',                 'bijutsukan',           'viện bảo tàng',                                       '名詞',     11, '美術館'),
  (sid, l4, 'でんわばんごう',               'でんわばんごう',               'denwa bangou',         'số điện thoại',                                       '名詞',     12, '電話番号'),
  (sid, l4, 'なんばん',                     'なんばん',                     'nanban',               'số mấy',                                              '疑問詞',   13, '何番'),
  (sid, l4, 'いま',                         'いま',                         'ima',                  'bây giờ',                                             '副詞',     14, '今'),
  (sid, l4, '～じ',                         '～じ',                         '~ ji',                 '~giờ',                                                '接尾辞',   15, '～時'),
  (sid, l4, '～ふん / ～ぷん',               '～ふん / ～ぷん',               '~ fun / ~ pun',        '~phút',                                               '接尾辞',   16, '～分'),
  (sid, l4, 'はん',                         'はん',                         'han',                  'phân nửa (30 phút)',                                  '名詞',     17, '半'),
  (sid, l4, 'なんじ',                       'なんじ',                       'nanji',                'mấy giờ',                                             '疑問詞',   18, '何時'),
  (sid, l4, 'なんぷん',                     'なんぷん',                     'nanpun',               'mấy phút',                                            '疑問詞',   19, '何分'),
  (sid, l4, 'ごぜん',                       'ごぜん',                       'gozen',                'sáng (AM: trước 12 giờ)',                             '名詞',     20, '午前'),
  (sid, l4, 'ごご',                         'ごご',                         'gogo',                 'chiều (PM: sau 12 giờ)',                              '名詞',     21, '午後'),
  (sid, l4, 'あさ',                         'あさ',                         'asa',                  'sáng',                                                '名詞',     22, '朝'),
  (sid, l4, 'ひる',                         'ひる',                         'hiru',                 'trưa',                                                '名詞',     23, '昼'),
  (sid, l4, 'ばん',                         'ばん',                         'ban',                  'tối',                                                 '名詞',     24, '晩'),
  (sid, l4, 'よる',                         'よる',                         'yoru',                 'tối / đêm',                                           '名詞',     25, '夜'),
  (sid, l4, 'おととい',                     'おととい',                     'ototoi',               'ngày hôm kia',                                        '名詞',     26, NULL),
  (sid, l4, 'きのう',                       'きのう',                       'kinou',                'ngày hôm qua',                                        '名詞',     27, NULL),
  (sid, l4, 'きょう',                       'きょう',                       'kyou',                 'hôm nay',                                             '名詞',     28, '今日'),
  (sid, l4, 'あした',                       'あした',                       'ashita',               'ngày mai',                                            '名詞',     29, '明日'),
  (sid, l4, 'あさって',                     'あさって',                     'asatte',               'ngày mốt',                                            '名詞',     30, NULL),
  (sid, l4, 'けさ',                         'けさ',                         'kesa',                 'sáng nay',                                            '名詞',     31, '今朝'),
  (sid, l4, 'こんばん',                     'こんばん',                     'konban',               'tối nay',                                             '名詞',     32, NULL),
  (sid, l4, 'ゆうべ',                       'ゆうべ',                       'yuube',                'tối hôm qua',                                         '名詞',     33, NULL),
  (sid, l4, 'やすみ',                       'やすみ',                       'yasumi',               'nghỉ ngơi (danh từ)',                                 '名詞',     34, '休み'),
  (sid, l4, 'ひるやすみ',                   'ひるやすみ',                   'hiruyasumi',           'nghỉ trưa',                                           '名詞',     35, '昼休み'),
  (sid, l4, 'まいあさ',                     'まいあさ',                     'maiasa',               'mỗi sáng',                                            '副詞',     36, '毎朝'),
  (sid, l4, 'まいばん',                     'まいばん',                     'maiban',               'mỗi tối',                                             '副詞',     37, '毎晩'),
  (sid, l4, 'まいにち',                     'まいにち',                     'mainichi',             'mỗi ngày',                                            '副詞',     38, '毎日'),
  (sid, l4, 'ペキン',                       'ペキン',                       'Pekin',                'Bắc Kinh',                                            '固有名詞', 39, NULL),
  (sid, l4, 'バンコク',                     'バンコク',                     'Bankoku',              'Bangkok',                                             '固有名詞', 40, NULL),
  (sid, l4, 'ロンドン',                     'ロンドン',                     'Rondon',               'Luân Đôn',                                            '固有名詞', 41, NULL),
  (sid, l4, 'ロサンゼルス',                 'ロサンゼルス',                 'Rosanzerusu',          'Los Angeles',                                         '固有名詞', 42, NULL),
  (sid, l4, 'たいへんですね',               'たいへんですね',               'taihen desu ne',       'vất vả nhỉ',                                          '表現',     43, '大変ですね'),
  (sid, l4, 'ばんごうあんない',             'ばんごうあんない',             'bangou annai',         'dịch vụ 116 (hỏi số điện thoại)',                     '表現',     44, NULL),
  (sid, l4, 'おといあわせ',                 'おといあわせ',                 'otoiawase',            '(số điện thoại) bạn muốn biết / hỏi là',             '表現',     45, NULL);

END $$;
