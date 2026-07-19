-- Patch: quiz-friendly — tách từ 2 biến thể thành 2 row + bổ sung từ thiếu (đối chiếu PDF Minato Dorimu + danh mục MNN chuẩn)
-- Bài 1: tách だれ（どなた）→ だれ + どなた; thêm おいくつ, さくらだいがく (44 → 47 từ) — reseed toàn bộ
-- Bài 3: tách トイレ（おてあらい）→ トイレ + おてあらい (43 → 44 từ) — vá tại chỗ
-- Bài 4: tách ～ふん / ～ぷん → 2 row; thêm 7 thứ trong tuần, なんようび, ばんごう, ～から, ～まで, ～と～, そちら, えーと, おねがいします, かしこまりました, ニューヨーク (45 → 63 từ) — reseed toàn bộ
-- Bài 6: ＣＤ thêm reading kana シーディー (reading cũ = ＣＤ khiến quiz không gõ kana được)
-- Quy tắc reading: chỉ kana + ～, không chứa / （） [] để popup quiz so đáp án được
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  l1 uuid; l3 uuid; l4 uuid; l6 uuid;
BEGIN

SELECT id INTO l1 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 1;
SELECT id INTO l3 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 3;
SELECT id INTO l4 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 4;
SELECT id INTO l6 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 6;

-- ════════════════════════════════════════
-- BÀI 1 — xóa và seed lại (47 từ)
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
  (sid, l1, '～くん',                       '～くん',                       '~ kun',                'Bé (dùng cho nam) hoặc gọi thân mật',                '接尾辞',   9,  '～君'),
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
  (sid, l1, 'だれ',                         'だれ',                         'dare',                 'Ai (hỏi người nào đó)',                               '疑問詞',   23, '誰'),
  (sid, l1, 'どなた',                       'どなた',                       'donata',               'Vị nào (cách nói lịch sự của だれ)',                  '疑問詞',   24, NULL),
  (sid, l1, '～さい',                       '～さい',                       '~ sai',                'Tuổi',                                                '接尾辞',   25, '～歳'),
  (sid, l1, 'なんさい',                     'なんさい',                     'nansai',               'Mấy tuổi',                                            '疑問詞',   26, '何歳'),
  (sid, l1, 'おいくつ',                     'おいくつ',                     'oikutsu',              'Mấy tuổi (cách nói lịch sự của なんさい)',            '疑問詞',   27, NULL),
  (sid, l1, 'はい',                         'はい',                         'hai',                  'Vâng',                                                '感動詞',   28, NULL),
  (sid, l1, 'いいえ',                       'いいえ',                       'iie',                  'Không',                                               '感動詞',   29, NULL),
  (sid, l1, 'しつれいですが',               'しつれいですが',               'shitsurei desu ga',    'Xin lỗi (khi muốn nhờ ai việc gì đó)',                '表現',     30, '失礼ですが'),
  (sid, l1, 'おなまえは？',                 'おなまえは',                   'onamae wa',            'Bạn tên gì?',                                         '表現',     31, 'お名前は？'),
  (sid, l1, 'はじめまして',                 'はじめまして',                 'hajimemashite',        'Chào lần đầu gặp nhau',                               '挨拶',     32, '初めまして'),
  (sid, l1, 'どうぞよろしく[おねがいします]', 'どうぞよろしくおねがいします', 'douzo yoroshiku',  'Rất hân hạnh được làm quen',                         '挨拶',     33, 'どうぞよろしく[お願いします]'),
  (sid, l1, 'こちらは～さんです',           'こちらは～さんです',           'kochira wa ~ san desu','Đây là ngài ~',                                       '表現',     34, NULL),
  (sid, l1, '～からきました',               '～からきました',               '~ kara kimashita',     'Đến từ ~',                                            '表現',     35, '～から来ました'),
  (sid, l1, 'アメリカ',                     'アメリカ',                     'Amerika',              'Mỹ',                                                  '固有名詞', 36, NULL),
  (sid, l1, 'イギリス',                     'イギリス',                     'Igirisu',              'Anh',                                                 '固有名詞', 37, NULL),
  (sid, l1, 'インド',                       'インド',                       'Indo',                 'Ấn Độ',                                               '固有名詞', 38, NULL),
  (sid, l1, 'インドネシア',                 'インドネシア',                 'Indoneshia',           'Indonesia',                                           '固有名詞', 39, NULL),
  (sid, l1, 'かんこく',                     'かんこく',                     'Kankoku',              'Hàn Quốc',                                            '固有名詞', 40, '韓国'),
  (sid, l1, 'タイ',                         'タイ',                         'Tai',                  'Thái Lan',                                            '固有名詞', 41, NULL),
  (sid, l1, 'ちゅうごく',                   'ちゅうごく',                   'Chuugoku',             'Trung Quốc',                                          '固有名詞', 42, '中国'),
  (sid, l1, 'ドイツ',                       'ドイツ',                       'Doitsu',               'Đức',                                                 '固有名詞', 43, NULL),
  (sid, l1, 'にほん',                       'にほん',                       'Nihon',                'Nhật',                                                '固有名詞', 44, '日本'),
  (sid, l1, 'フランス',                     'フランス',                     'Furansu',              'Pháp',                                                '固有名詞', 45, NULL),
  (sid, l1, 'ブラジル',                     'ブラジル',                     'Burajiru',             'Brazil',                                              '固有名詞', 46, NULL),
  (sid, l1, 'さくらだいがく',               'さくらだいがく',               'Sakura daigaku',       'Trường đại học Sakura (tên trường trong giáo trình)', '固有名詞', 47, 'さくら大学');

-- ════════════════════════════════════════
-- BÀI 3 — tách トイレ（おてあらい） thành 2 row (chỉ chạy khi row gộp còn tồn tại)
-- ════════════════════════════════════════
IF EXISTS (SELECT 1 FROM mnn_vocabulary WHERE lesson_id = l3 AND word = 'トイレ（おてあらい）') THEN
  UPDATE mnn_vocabulary SET order_index = order_index + 1
    WHERE lesson_id = l3 AND order_index > 16;
  UPDATE mnn_vocabulary
    SET word = 'トイレ', reading = 'トイレ', romanization = 'toire',
        meaning_vi = 'Nhà vệ sinh, toa-lét', kanji = NULL
    WHERE lesson_id = l3 AND word = 'トイレ（おてあらい）';
  INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
    (sid, l3, 'おてあらい', 'おてあらい', 'otearai', 'Nhà vệ sinh (cách nói lịch sự của トイレ)', '名詞', 17, 'お手洗い');
END IF;

-- ════════════════════════════════════════
-- BÀI 6 — ＣＤ: reading phải là kana để quiz gõ được
-- ════════════════════════════════════════
UPDATE mnn_vocabulary SET reading = 'シーディー', romanization = 'shiidii'
  WHERE lesson_id = l6 AND word = 'ＣＤ';

-- ════════════════════════════════════════
-- BÀI 4 — xóa và seed lại (63 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l4;

INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l4, 'おきます',                     'おきます',                     'okimasu',              'thức dậy',                                            '動詞',     1,  '起きます'),
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
  (sid, l4, 'ばんごう',                     'ばんごう',                     'bangou',               'số, số hiệu',                                         '名詞',     13, '番号'),
  (sid, l4, 'なんばん',                     'なんばん',                     'nanban',               'số mấy',                                              '疑問詞',   14, '何番'),
  (sid, l4, 'いま',                         'いま',                         'ima',                  'bây giờ',                                             '副詞',     15, '今'),
  (sid, l4, '～じ',                         '～じ',                         '~ ji',                 '~giờ',                                                '接尾辞',   16, '～時'),
  (sid, l4, '～ふん',                       '～ふん',                       '~ fun',                '~phút (sau 2, 5, 7, 9)',                              '接尾辞',   17, '～分'),
  (sid, l4, '～ぷん',                       '～ぷん',                       '~ pun',                '~phút (sau 1, 3, 4, 6, 8, 10)',                       '接尾辞',   18, '～分'),
  (sid, l4, 'はん',                         'はん',                         'han',                  'phân nửa (30 phút)',                                  '名詞',     19, '半'),
  (sid, l4, 'なんじ',                       'なんじ',                       'nanji',                'mấy giờ',                                             '疑問詞',   20, '何時'),
  (sid, l4, 'なんぷん',                     'なんぷん',                     'nanpun',               'mấy phút',                                            '疑問詞',   21, '何分'),
  (sid, l4, 'ごぜん',                       'ごぜん',                       'gozen',                'sáng (AM: trước 12 giờ)',                             '名詞',     22, '午前'),
  (sid, l4, 'ごご',                         'ごご',                         'gogo',                 'chiều (PM: sau 12 giờ)',                              '名詞',     23, '午後'),
  (sid, l4, 'あさ',                         'あさ',                         'asa',                  'sáng',                                                '名詞',     24, '朝'),
  (sid, l4, 'ひる',                         'ひる',                         'hiru',                 'trưa',                                                '名詞',     25, '昼'),
  (sid, l4, 'ばん',                         'ばん',                         'ban',                  'tối',                                                 '名詞',     26, '晩'),
  (sid, l4, 'よる',                         'よる',                         'yoru',                 'tối / đêm',                                           '名詞',     27, '夜'),
  (sid, l4, 'おととい',                     'おととい',                     'ototoi',               'ngày hôm kia',                                        '名詞',     28, NULL),
  (sid, l4, 'きのう',                       'きのう',                       'kinou',                'ngày hôm qua',                                        '名詞',     29, NULL),
  (sid, l4, 'きょう',                       'きょう',                       'kyou',                 'hôm nay',                                             '名詞',     30, '今日'),
  (sid, l4, 'あした',                       'あした',                       'ashita',               'ngày mai',                                            '名詞',     31, '明日'),
  (sid, l4, 'あさって',                     'あさって',                     'asatte',               'ngày mốt',                                            '名詞',     32, NULL),
  (sid, l4, 'けさ',                         'けさ',                         'kesa',                 'sáng nay',                                            '名詞',     33, '今朝'),
  (sid, l4, 'こんばん',                     'こんばん',                     'konban',               'tối nay',                                             '名詞',     34, '今晩'),
  (sid, l4, 'ゆうべ',                       'ゆうべ',                       'yuube',                'tối hôm qua',                                         '名詞',     35, NULL),
  (sid, l4, 'やすみ',                       'やすみ',                       'yasumi',               'nghỉ ngơi (danh từ), ngày nghỉ',                      '名詞',     36, '休み'),
  (sid, l4, 'ひるやすみ',                   'ひるやすみ',                   'hiruyasumi',           'nghỉ trưa',                                           '名詞',     37, '昼休み'),
  (sid, l4, 'まいあさ',                     'まいあさ',                     'maiasa',               'mỗi sáng',                                            '副詞',     38, '毎朝'),
  (sid, l4, 'まいばん',                     'まいばん',                     'maiban',               'mỗi tối',                                             '副詞',     39, '毎晩'),
  (sid, l4, 'まいにち',                     'まいにち',                     'mainichi',             'mỗi ngày',                                            '副詞',     40, '毎日'),
  (sid, l4, 'げつようび',                   'げつようび',                   'getsuyoubi',           'thứ Hai',                                             '名詞',     41, '月曜日'),
  (sid, l4, 'かようび',                     'かようび',                     'kayoubi',              'thứ Ba',                                              '名詞',     42, '火曜日'),
  (sid, l4, 'すいようび',                   'すいようび',                   'suiyoubi',             'thứ Tư',                                              '名詞',     43, '水曜日'),
  (sid, l4, 'もくようび',                   'もくようび',                   'mokuyoubi',            'thứ Năm',                                             '名詞',     44, '木曜日'),
  (sid, l4, 'きんようび',                   'きんようび',                   'kinyoubi',             'thứ Sáu',                                             '名詞',     45, '金曜日'),
  (sid, l4, 'どようび',                     'どようび',                     'doyoubi',              'thứ Bảy',                                             '名詞',     46, '土曜日'),
  (sid, l4, 'にちようび',                   'にちようび',                   'nichiyoubi',           'Chủ nhật',                                            '名詞',     47, '日曜日'),
  (sid, l4, 'なんようび',                   'なんようび',                   'nanyoubi',             'thứ mấy',                                             '疑問詞',   48, '何曜日'),
  (sid, l4, '～から',                       '～から',                       '~ kara',               'từ ~ (mốc bắt đầu)',                                  '助詞',     49, NULL),
  (sid, l4, '～まで',                       '～まで',                       '~ made',               'đến ~ (mốc kết thúc)',                                '助詞',     50, NULL),
  (sid, l4, '～と～',                       '～と～',                       '~ to ~',               'và (nối 2 danh từ)',                                  '助詞',     51, NULL),
  (sid, l4, 'そちら',                       'そちら',                       'sochira',              'phía đó, chỗ đó (phía người nghe — lịch sự)',         '指示語',   52, NULL),
  (sid, l4, 'たいへんですね',               'たいへんですね',               'taihen desu ne',       'vất vả nhỉ (bày tỏ thông cảm)',                       '表現',     53, '大変ですね'),
  (sid, l4, 'えーと',                       'えーと',                       'eeto',                 'ừm, à (từ đệm khi suy nghĩ)',                         '感動詞',   54, NULL),
  (sid, l4, 'おねがいします',               'おねがいします',               'onegai shimasu',       'xin vui lòng giúp đỡ, nhờ anh/chị',                   '表現',     55, 'お願いします'),
  (sid, l4, 'かしこまりました',             'かしこまりました',             'kashikomarimashita',   'tôi hiểu rồi ạ (lịch sự, nhân viên nói với khách)',   '表現',     56, NULL),
  (sid, l4, 'ニューヨーク',                 'ニューヨーク',                 'Nyuuyooku',            'New York',                                            '固有名詞', 57, NULL),
  (sid, l4, 'ペキン',                       'ペキン',                       'Pekin',                'Bắc Kinh',                                            '固有名詞', 58, NULL),
  (sid, l4, 'バンコク',                     'バンコク',                     'Bankoku',              'Bangkok',                                             '固有名詞', 59, NULL),
  (sid, l4, 'ロンドン',                     'ロンドン',                     'Rondon',               'Luân Đôn',                                            '固有名詞', 60, NULL),
  (sid, l4, 'ロサンゼルス',                 'ロサンゼルス',                 'Rosanzerusu',          'Los Angeles',                                         '固有名詞', 61, NULL),
  (sid, l4, 'ばんごうあんない',             'ばんごうあんない',             'bangou annai',         'dịch vụ 116 (hỏi số điện thoại)',                     '表現',     62, '番号案内'),
  (sid, l4, 'おといあわせ',                 'おといあわせ',                 'otoiawase',            '(số điện thoại) bạn muốn biết / hỏi là',             '表現',     63, 'お問い合わせ');

END $$;
