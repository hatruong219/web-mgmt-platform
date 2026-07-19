-- Seed: Minna no Nihongo — Bài 37-42 (từ vựng)
-- Nguồn: PDF Minato Dorimu, đối chiếu + sửa lỗi theo danh mục từ vựng MNN chuẩn
-- Quy tắc: word = kana (+ chú thích sách), reading = CHỈ kana + ～, kanji = kanji (NULL nếu không có)
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c
--
-- Sửa lỗi / xử lý PDF đáng chú ý:
--   Bài 37: ほめます cột Âm Hán ghi "BAO" (sai) → nghĩa đúng "khen"; cột Âm Hán bỏ qua
--   Bài 38: 5年生 → reading ごねんせい (word có số nên reading là kana đầy đủ)
--           あ、いけない → reading あいけない (bỏ dấu 、 khỏi reading)
--           けんかします (STT 1609) + ふしぎ[な] (1610) PDF xếp cuối block Bài 38;
--           けんかします lặp lại trong Bài 39 (1621) đúng theo bố cục PDF — giữ ở cả hai bài
--   Bài 39: DEDUPE ĐƯỜNG NỐI p65/p66 — 7 dòng はずかしい/じしん/たいふう/かじ/じこ/みあい/でんわだい
--           (p65 STT 1628-1634) trùng (p66 STT 1609-1615) → chỉ lấy 1 lần
--           あいます 会います PDF ghi nghĩa "vừa, hợp" (của 合います) → sửa "gặp gỡ"
--           Gồm cả 7 từ mục đọc thêm 成人式 ở p67 (STT 1628-1634) → tổng 43 từ distinct
--   Bài 40: はかります 測ります/量ります → tách thành 2 dòng (đo chiều dài / cân trọng lượng)
--           ゆうに (PDF ghi nhầm) → きゅうに 急に "đột nhiên"
--   Bài 41: おととし PDF "năm ngoái" → "năm kia"; せんじつ "ngày kia" → "hôm trước"
--           ［お］みまい / ［お］城 dấu ngoặc vuông = phần お tùy chọn → giữ 1 dòng, reading đầy đủ
--   Bài 42: bỏ ký hiệu nhóm động từ I/II/III ở cột từ vựng (chỉ là metadata phân nhóm)

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  l37 uuid; l38 uuid; l39 uuid; l40 uuid; l41 uuid; l42 uuid;
BEGIN
SELECT id INTO l37 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 37;
SELECT id INTO l38 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 38;
SELECT id INTO l39 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 39;
SELECT id INTO l40 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 40;
SELECT id INTO l41 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 41;
SELECT id INTO l42 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 42;
IF l37 IS NULL OR l38 IS NULL OR l39 IS NULL OR l40 IS NULL OR l41 IS NULL OR l42 IS NULL THEN
  RAISE EXCEPTION 'mnn_lessons 37-42 chưa được seed';
END IF;

-- ════════════════════════════════════════
-- BÀI 37 — xóa và seed lại (46 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l37;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l37, 'ほめます',             'ほめます',             'homemasu',           'khen',                                       '動詞',   1,  '褒めます'),
  (sid, l37, 'しかります',           'しかります',           'shikarimasu',        'mắng',                                       '動詞',   2,  NULL),
  (sid, l37, 'さそいます',           'さそいます',           'sasoimasu',          'mời, rủ rê',                                 '動詞',   3,  '誘います'),
  (sid, l37, 'おこします',           'おこします',           'okoshimasu',         'đánh thức',                                  '動詞',   4,  '起こします'),
  (sid, l37, 'しょうたいします',     'しょうたいします',     'shoutai shimasu',    'mời (chính thức)',                           '動詞',   5,  '招待します'),
  (sid, l37, 'たのみます',           'たのみます',           'tanomimasu',         'nhờ',                                        '動詞',   6,  '頼みます'),
  (sid, l37, 'ちゅういします',       'ちゅういします',       'chuui shimasu',      'chú ý, nhắc nhở',                            '動詞',   7,  '注意します'),
  (sid, l37, 'とります',             'とります',             'torimasu',           'lấy trộm, lấy cắp',                          '動詞',   8,  NULL),
  (sid, l37, 'ふみます',             'ふみます',             'fumimasu',           'giẫm, giẫm lên',                             '動詞',   9,  '踏みます'),
  (sid, l37, 'こわします',           'こわします',           'kowashimasu',        'phá, làm hỏng',                              '動詞',   10, '壊します'),
  (sid, l37, 'よごします',           'よごします',           'yogoshimasu',        'làm bẩn',                                    '動詞',   11, '汚します'),
  (sid, l37, 'おこないます',         'おこないます',         'okonaimasu',         'thực hiện, tiến hành',                       '動詞',   12, '行います'),
  (sid, l37, 'ゆしゅつします',       'ゆしゅつします',       'yushutsu shimasu',   'xuất khẩu',                                  '動詞',   13, '輸出します'),
  (sid, l37, 'ゆにゅうします',       'ゆにゅうします',       'yunyuu shimasu',     'nhập khẩu',                                  '動詞',   14, '輸入します'),
  (sid, l37, 'ほんやくします',       'ほんやくします',       'honyaku shimasu',    'dịch (sách, tài liệu)',                      '動詞',   15, '翻訳します'),
  (sid, l37, 'はつめいします',       'はつめいします',       'hatsumei shimasu',   'phát minh',                                  '動詞',   16, '発明します'),
  (sid, l37, 'はっけんします',       'はっけんします',       'hakken shimasu',     'phát hiện, tìm ra',                          '動詞',   17, '発見します'),
  (sid, l37, 'せっけいします',       'せっけいします',       'sekkei shimasu',     'thiết kế',                                   '動詞',   18, '設計します'),
  (sid, l37, 'こめ',                 'こめ',                 'kome',               'gạo',                                        '名詞',   19, '米'),
  (sid, l37, 'むぎ',                 'むぎ',                 'mugi',               'lúa mạch',                                   '名詞',   20, '麦'),
  (sid, l37, 'せきゆ',               'せきゆ',               'sekiyu',             'dầu mỏ',                                     '名詞',   21, '石油'),
  (sid, l37, 'げんりょう',           'げんりょう',           'genryou',            'nguyên liệu',                                '名詞',   22, '原料'),
  (sid, l37, 'デート',               'デート',               'deeto',              'cuộc hẹn hò (nam nữ)',                       '名詞',   23, NULL),
  (sid, l37, 'どろぼう',             'どろぼう',             'dorobou',            'kẻ trộm',                                    '名詞',   24, '泥棒'),
  (sid, l37, 'けいかん',             'けいかん',             'keikan',             'cảnh sát',                                   '名詞',   25, '警官'),
  (sid, l37, 'けんちくか',           'けんちくか',           'kenchikuka',         'kiến trúc sư',                               '名詞',   26, '建築家'),
  (sid, l37, 'かがくしゃ',           'かがくしゃ',           'kagakusha',          'nhà khoa học',                               '名詞',   27, '科学者'),
  (sid, l37, 'まんが',               'まんが',               'manga',              'truyện tranh',                               '名詞',   28, '漫画'),
  (sid, l37, 'せかいじゅう',         'せかいじゅう',         'sekaijuu',           'khắp thế giới, toàn thế giới',               '名詞',   29, '世界中'),
  (sid, l37, '～じゅう',             '～じゅう',             '~ juu',              'khắp ~, suốt ~',                             '接尾辞', 30, '～中'),
  (sid, l37, '～によって',           '～によって',           '~ ni yotte',         'tùy theo ~, do ~',                           '表現',   31, NULL),
  (sid, l37, 'よかったですね',       'よかったですね',       'yokatta desu ne',    'may quá nhỉ, thật tốt nhỉ',                  '表現',   32, NULL),
  (sid, l37, 'うめたてます',         'うめたてます',         'umetatemasu',        'lấp, san lấp',                               '動詞',   33, '埋め立てます'),
  (sid, l37, 'ぎじゅつ',             'ぎじゅつ',             'gijutsu',            'kỹ thuật',                                   '名詞',   34, '技術'),
  (sid, l37, 'とち',                 'とち',                 'tochi',              'đất, diện tích đất',                         '名詞',   35, '土地'),
  (sid, l37, 'そうおん',             'そうおん',             'souon',              'tiếng ồn',                                   '名詞',   36, '騒音'),
  (sid, l37, 'りようします',         'りようします',         'riyou shimasu',      'sử dụng',                                    '動詞',   37, '利用します'),
  (sid, l37, 'アクセス',             'アクセス',             'akusesu',            'sự tiếp cận (giao thông); lối vào',          '名詞',   38, NULL),
  (sid, l37, 'ごうか [な]',          'ごうか',               'gouka [na]',         'sang trọng, xa hoa',                         'な形容詞', 39, '豪華 [な]'),
  (sid, l37, 'ちょうこく',           'ちょうこく',           'choukoku',           'điêu khắc',                                  '名詞',   40, '彫刻'),
  (sid, l37, 'ねむります',           'ねむります',           'nemurimasu',         'ngủ',                                        '動詞',   41, '眠ります'),
  (sid, l37, 'ほります',             'ほります',             'horimasu',           'khắc, chạm khắc',                            '動詞',   42, '彫ります'),
  (sid, l37, 'なかま',               'なかま',               'nakama',             'bạn bè, đồng nghiệp',                        '名詞',   43, '仲間'),
  (sid, l37, 'そのあと',             'そのあと',             'sono ato',           'sau đó',                                     '副詞',   44, NULL),
  (sid, l37, 'いっしょうけんめい',   'いっしょうけんめい',   'isshoukenmei',       'cố gắng hết sức',                            '副詞',   45, '一生懸命'),
  (sid, l37, 'ねずみ',               'ねずみ',               'nezumi',             'chuột',                                      '名詞',   46, NULL);

-- ════════════════════════════════════════
-- BÀI 38 — xóa và seed lại (41 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l38;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l38, 'そだてます',           'そだてます',           'sodatemasu',         'nuôi, trồng',                                '動詞',   1,  '育てます'),
  (sid, l38, 'はこびます',           'はこびます',           'hakobimasu',         'chở, vận chuyển',                            '動詞',   2,  '運びます'),
  (sid, l38, 'なくなります',         'なくなります',         'nakunarimasu',       'mất, qua đời',                               '動詞',   3,  '亡くなります'),
  (sid, l38, 'にゅういんします',     'にゅういんします',     'nyuuin shimasu',     'nhập viện',                                  '動詞',   4,  '入院します'),
  (sid, l38, 'たいいんします',       'たいいんします',       'taiin shimasu',      'xuất viện',                                  '動詞',   5,  '退院します'),
  (sid, l38, 'いれます',             'いれます',             'iremasu',            'bật (công tắc)',                             '動詞',   6,  '入れます'),
  (sid, l38, 'きります',             'きります',             'kirimasu',           'tắt (công tắc)',                             '動詞',   7,  '切ります'),
  (sid, l38, 'かけます',             'かけます',             'kakemasu',           'khóa (bằng chìa)',                           '動詞',   8,  '掛けます'),
  (sid, l38, 'きもちがいい',         'きもちがいい',         'kimochi ga ii',      'dễ chịu, thoải mái',                         '表現',   9,  '気持ちがいい'),
  (sid, l38, 'きもちがわるい',       'きもちがわるい',       'kimochi ga warui',   'khó chịu, khó ở',                            '表現',   10, '気持ちが悪い'),
  (sid, l38, 'おおきな～',           'おおきな～',           'ooki na ~',          'lớn (đứng trước danh từ)',                   '連体詞', 11, '大きな～'),
  (sid, l38, 'ちいさな～',           'ちいさな～',           'chiisa na ~',        'nhỏ, bé (đứng trước danh từ)',               '連体詞', 12, '小さな～'),
  (sid, l38, 'あかちゃん',           'あかちゃん',           'akachan',            'em bé',                                      '名詞',   13, '赤ちゃん'),
  (sid, l38, 'しょうがっこう',       'しょうがっこう',       'shougakkou',         'trường tiểu học',                            '名詞',   14, '小学校'),
  (sid, l38, 'ちゅうがっこう',       'ちゅうがっこう',       'chuugakkou',         'trường trung học cơ sở',                     '名詞',   15, '中学校'),
  (sid, l38, 'えきまえ',             'えきまえ',             'ekimae',             'khu vực trước nhà ga',                       '名詞',   16, '駅前'),
  (sid, l38, 'かいがん',             'かいがん',             'kaigan',             'bờ biển',                                    '名詞',   17, '海岸'),
  (sid, l38, 'うそ',                 'うそ',                 'uso',                'nói dối, lời nói dối',                       '名詞',   18, NULL),
  (sid, l38, 'しょるい',             'しょるい',             'shorui',             'giấy tờ, tài liệu',                          '名詞',   19, '書類'),
  (sid, l38, 'でんげん',             'でんげん',             'dengen',             'nguồn điện, công tắc điện',                  '名詞',   20, '電源'),
  (sid, l38, '～せい',               '～せい',               '~ sei',              'sản xuất tại ~, chế tạo ở ~',                '接尾辞', 21, '～製'),
  (sid, l38, 'あ、いけない',         'あいけない',           'a ikenai',           'Ối, hỏng mất rồi! / Ối, chết rồi!',          '表現',   22, NULL),
  (sid, l38, 'おさきに',             'おさきに',             'osaki ni',           'Tôi xin phép về trước',                      '表現',   23, 'お先に'),
  (sid, l38, 'かいらん',             'かいらん',             'kairan',             'sự chuyền tay xem, tập thông báo',           '名詞',   24, '回覧'),
  (sid, l38, 'けんきゅうしつ',       'けんきゅうしつ',       'kenkyuushitsu',      'phòng nghiên cứu',                           '名詞',   25, '研究室'),
  (sid, l38, 'きちんと',             'きちんと',             'kichinto',           'nghiêm chỉnh, hẳn hoi, đàng hoàng',          '副詞',   26, NULL),
  (sid, l38, 'せいりします',         'せいりします',         'seiri shimasu',      'sắp xếp, chỉnh lý',                          '動詞',   27, '整理します'),
  (sid, l38, 'はんこ',               'はんこ',               'hanko',              'con dấu',                                    '名詞',   28, NULL),
  (sid, l38, 'おします',             'おします',             'oshimasu',           'đóng (dấu), ấn, nhấn',                       '動詞',   29, '押します'),
  (sid, l38, 'ふたご',               'ふたご',               'futago',             'cặp sinh đôi',                               '名詞',   30, '双子'),
  (sid, l38, 'しまい',               'しまい',               'shimai',             'chị em gái',                                 '名詞',   31, '姉妹'),
  (sid, l38, '5ねんせい',            'ごねんせい',           'go nensei',          'học sinh lớp 5, học sinh năm thứ 5',         '名詞',   32, '5年生'),
  (sid, l38, 'にています',           'にています',           'nite imasu',         'giống, giống nhau',                          '動詞',   33, '似ています'),
  (sid, l38, 'せいかく',             'せいかく',             'seikaku',            'tính cách',                                  '名詞',   34, '性格'),
  (sid, l38, 'おとなしい',           'おとなしい',           'otonashii',          'hiền lành, trầm tính, ngoan',                'い形容詞', 35, NULL),
  (sid, l38, 'せわをします',         'せわをします',         'sewa o shimasu',     'chăm sóc, chăm nom',                         '動詞',   36, '世話をします'),
  (sid, l38, 'じかんがたちます',     'じかんがたちます',     'jikan ga tachimasu', 'thời gian trôi qua',                         '表現',   37, '時間がたちます'),
  (sid, l38, 'だいすき',             'だいすき',             'daisuki',            'rất thích, thích mê',                        'な形容詞', 38, '大好き'),
  (sid, l38, 'クラス',               'クラス',               'kurasu',             'lớp học, lớp',                               '名詞',   39, NULL),
  -- けんかします: PDF xếp nhầm ở cả Bài 38, đã bỏ (từ chuẩn thuộc Bài 39)
  (sid, l38, 'ふしぎ [な]',          'ふしぎ',               'fushigi [na]',       'kỳ lạ, khó hiểu, bí ẩn',                     'な形容詞', 40, '不思議 [な]');

-- ════════════════════════════════════════
-- BÀI 39 — xóa và seed lại (43 từ; đã dedupe 7 dòng đường nối p65/p66)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l39;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l39, 'こたえます',           'こたえます',           'kotaemasu',          'trả lời',                                    '動詞',   1,  '答えます'),
  (sid, l39, 'たおれます',           'たおれます',           'taoremasu',          'đổ, ngã',                                    '動詞',   2,  '倒れます'),
  (sid, l39, 'やけます',             'やけます',             'yakemasu',           'cháy',                                       '動詞',   3,  '焼けます'),
  (sid, l39, 'とおります',           'とおります',           'toorimasu',          'đi qua',                                     '動詞',   4,  '通ります'),
  (sid, l39, 'しにます',             'しにます',             'shinimasu',          'chết',                                       '動詞',   5,  '死にます'),
  (sid, l39, 'びっくりします',       'びっくりします',       'bikkuri shimasu',    'ngạc nhiên, giật mình',                      '動詞',   6,  NULL),
  (sid, l39, 'がっかりします',       'がっかりします',       'gakkari shimasu',    'thất vọng',                                  '動詞',   7,  NULL),
  (sid, l39, 'あんしんします',       'あんしんします',       'anshin shimasu',     'yên tâm',                                    '動詞',   8,  '安心します'),
  (sid, l39, 'ちこくします',         'ちこくします',         'chikoku shimasu',    'đến muộn, đến trễ',                          '動詞',   9,  '遅刻します'),
  (sid, l39, 'そうたいします',       'そうたいします',       'soutai shimasu',     'về sớm (giữa giờ)',                          '動詞',   10, '早退します'),
  (sid, l39, 'けんかします',         'けんかします',         'kenka shimasu',      'cãi nhau, đánh nhau',                        '動詞',   11, NULL),
  (sid, l39, 'りこんします',         'りこんします',         'rikon shimasu',      'ly dị, ly hôn',                              '動詞',   12, '離婚します'),
  (sid, l39, 'ふくざつ [な]',        'ふくざつ',             'fukuzatsu [na]',     'phức tạp',                                   'な形容詞', 13, '複雑 [な]'),
  (sid, l39, 'じゃま [な]',          'じゃま',               'jama [na]',          'cản trở, vướng víu',                         'な形容詞', 14, '邪魔 [な]'),
  (sid, l39, 'きたない',             'きたない',             'kitanai',            'bẩn',                                        'い形容詞', 15, '汚い'),
  (sid, l39, 'うれしい',             'うれしい',             'ureshii',            'vui mừng, vui sướng',                        'い形容詞', 16, NULL),
  (sid, l39, 'かなしい',             'かなしい',             'kanashii',           'buồn, đau buồn',                             'い形容詞', 17, '悲しい'),
  (sid, l39, 'はずかしい',           'はずかしい',           'hazukashii',         'xấu hổ, ngượng ngùng',                       'い形容詞', 18, '恥ずかしい'),
  (sid, l39, 'じしん',               'じしん',               'jishin',             'động đất',                                   '名詞',   19, '地震'),
  (sid, l39, 'たいふう',             'たいふう',             'taifuu',             'bão',                                        '名詞',   20, '台風'),
  (sid, l39, 'かじ',                 'かじ',                 'kaji',               'hỏa hoạn, cháy',                             '名詞',   21, '火事'),
  (sid, l39, 'じこ',                 'じこ',                 'jiko',               'tai nạn, sự cố',                             '名詞',   22, '事故'),
  (sid, l39, 'みあい',               'みあい',               'miai',               'buổi xem mặt (làm quen qua mai mối)',        '名詞',   23, '見合い'),
  (sid, l39, 'でんわだい',           'でんわだい',           'denwadai',           'tiền điện thoại',                            '名詞',   24, '電話代'),
  (sid, l39, '～だい',               '～だい',               '~ dai',              'tiền ~, phí ~',                              '接尾辞', 25, '～代'),
  (sid, l39, 'フロント',             'フロント',             'furonto',            'quầy lễ tân, bộ phận tiếp tân',              '名詞',   26, NULL),
  (sid, l39, '～ごうしつ',           '～ごうしつ',           '~ goushitsu',        'phòng số ~',                                 '接尾辞', 27, '～号室'),
  (sid, l39, 'あせ',                 'あせ',                 'ase',                'mồ hôi',                                     '名詞',   28, '汗'),
  (sid, l39, 'タオル',               'タオル',               'taoru',              'khăn lau, khăn tắm',                         '名詞',   29, NULL),
  (sid, l39, 'せっけん',             'せっけん',             'sekken',             'xà phòng',                                   '名詞',   30, NULL),
  (sid, l39, 'おおぜい',             'おおぜい',             'oozei',              'đông người, nhiều người',                    '名詞',   31, '大勢'),
  (sid, l39, 'おつかれさまでした',   'おつかれさまでした',   'otsukaresama deshita','Anh/chị đã vất vả rồi',                     '挨拶',   32, 'お疲れさまでした'),
  (sid, l39, 'うかがいます',         'うかがいます',         'ukagaimasu',         'đến thăm, hỏi (khiêm nhường ngữ)',           '動詞',   33, '伺います'),
  (sid, l39, 'とちゅうで',           'とちゅうで',           'tochuu de',          'giữa đường, giữa chừng',                     '表現',   34, '途中で'),
  (sid, l39, 'トラック',             'トラック',             'torakku',            'xe tải',                                     '名詞',   35, NULL),
  (sid, l39, 'ぶつかります',         'ぶつかります',         'butsukarimasu',      'va, đâm vào, va chạm',                       '動詞',   36, NULL),
  (sid, l39, 'ならびます',           'ならびます',           'narabimasu',         'xếp hàng',                                   '動詞',   37, '並びます'),
  (sid, l39, 'おとな',               'おとな',               'otona',              'người lớn',                                  '名詞',   38, '大人'),
  (sid, l39, 'ようふく',             'ようふく',             'youfuku',            'quần áo kiểu Âu, Âu phục',                   '名詞',   39, '洋服'),
  (sid, l39, 'せいようかします',     'せいようかします',     'seiyouka shimasu',   'Âu hóa, phương Tây hóa',                     '動詞',   40, '西洋化します'),
  (sid, l39, 'あいます',             'あいます',             'aimasu',             'gặp, gặp gỡ',                                '動詞',   41, '会います'),
  (sid, l39, 'いまでは',             'いまでは',             'ima de wa',          'bây giờ (thì), ngày nay',                    '副詞',   42, '今では'),
  (sid, l39, 'せいじんしき',         'せいじんしき',         'seijinshiki',        'lễ thành nhân, lễ trưởng thành',             '名詞',   43, '成人式');

-- ════════════════════════════════════════
-- BÀI 40 — xóa và seed lại (63 từ; はかります tách 測る/量る)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l40;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l40, 'かぞえます',           'かぞえます',           'kazoemasu',          'đếm',                                        '動詞',   1,  '数えます'),
  (sid, l40, 'はかります',           'はかります',           'hakarimasu',         'đo (chiều dài, khoảng cách)',                '動詞',   2,  '測ります'),
  (sid, l40, 'はかります',           'はかります',           'hakarimasu',         'cân (trọng lượng)',                          '動詞',   3,  '量ります'),
  (sid, l40, 'たしかめます',         'たしかめます',         'tashikamemasu',      'xác nhận, kiểm chứng',                       '動詞',   4,  '確かめます'),
  (sid, l40, 'あいます',             'あいます',             'aimasu',             'vừa, hợp, khớp',                             '動詞',   5,  '合います'),
  (sid, l40, 'しゅっぱつします',     'しゅっぱつします',     'shuppatsu shimasu',  'xuất phát, khởi hành',                       '動詞',   6,  '出発します'),
  (sid, l40, 'とうちゃくします',     'とうちゃくします',     'touchaku shimasu',   'đến, đến nơi',                               '動詞',   7,  '到着します'),
  (sid, l40, 'よいます',             'よいます',             'yoimasu',            'say (rượu, xe)',                             '動詞',   8,  '酔います'),
  (sid, l40, 'きけん [な]',          'きけん',               'kiken [na]',         'nguy hiểm',                                  'な形容詞', 9,  '危険 [な]'),
  (sid, l40, 'ひつよう [な]',        'ひつよう',             'hitsuyou [na]',      'cần thiết',                                  'な形容詞', 10, '必要 [な]'),
  (sid, l40, 'うちゅう',             'うちゅう',             'uchuu',              'vũ trụ',                                     '名詞',   11, '宇宙'),
  (sid, l40, 'ちきゅう',             'ちきゅう',             'chikyuu',            'trái đất',                                   '名詞',   12, '地球'),
  (sid, l40, 'ぼうねんかい',         'ぼうねんかい',         'bounenkai',          'tiệc tất niên',                              '名詞',   13, '忘年会'),
  (sid, l40, 'しんねんかい',         'しんねんかい',         'shinnenkai',         'tiệc tân niên',                              '名詞',   14, '新年会'),
  (sid, l40, 'にじかい',             'にじかい',             'nijikai',            'tiệc tăng hai',                              '名詞',   15, '二次会'),
  (sid, l40, 'たいかい',             'たいかい',             'taikai',             'đại hội, cuộc thi',                          '名詞',   16, '大会'),
  (sid, l40, 'マラソン',             'マラソン',             'marason',            'chạy marathon, chạy việt dã',                '名詞',   17, NULL),
  (sid, l40, 'コンテスト',           'コンテスト',           'kontesuto',          'cuộc thi',                                   '名詞',   18, NULL),
  (sid, l40, 'おもて',               'おもて',               'omote',              'phía trước, mặt trước',                      '名詞',   19, '表'),
  (sid, l40, 'うら',                 'うら',                 'ura',                'phía sau, mặt sau',                          '名詞',   20, '裏'),
  (sid, l40, 'へんじ',               'へんじ',               'henji',              'hồi âm, trả lời',                            '名詞',   21, '返事'),
  (sid, l40, 'もうしこみ',           'もうしこみ',           'moushikomi',         'sự đăng ký, đơn xin',                        '名詞',   22, '申し込み'),
  (sid, l40, 'ほんとう',             'ほんとう',             'hontou',             'thật, sự thật',                              '名詞',   23, '本当'),
  (sid, l40, 'まちがい',             'まちがい',             'machigai',           'sự nhầm lẫn, sai sót',                       '名詞',   24, NULL),
  (sid, l40, 'きず',                 'きず',                 'kizu',               'vết thương',                                 '名詞',   25, '傷'),
  (sid, l40, 'ズボン',               'ズボン',               'zubon',              'cái quần',                                   '名詞',   26, NULL),
  (sid, l40, 'ながさ',               'ながさ',               'nagasa',             'chiều dài, độ dài',                          '名詞',   27, '長さ'),
  (sid, l40, 'おもさ',               'おもさ',               'omosa',              'cân nặng, trọng lượng',                      '名詞',   28, '重さ'),
  (sid, l40, 'たかさ',               'たかさ',               'takasa',             'chiều cao',                                  '名詞',   29, '高さ'),
  (sid, l40, 'おおきさ',             'おおきさ',             'ookisa',             'cỡ, kích thước',                             '名詞',   30, '大きさ'),
  (sid, l40, '～びん',               '～びん',               '~ bin',              'chuyến bay số ~',                            '接尾辞', 31, '～便'),
  (sid, l40, '～ごう',               '～ごう',               '~ gou',              'số ~ (số hiệu)',                             '接尾辞', 32, '～号'),
  (sid, l40, '～こ',                 '～こ',                 '~ ko',               '~ cái, ~ viên (lượng từ đếm vật nhỏ)',       '接尾辞', 33, NULL),
  (sid, l40, '～ほん',               '～ほん',               '~ hon',              '~ cái (lượng từ đếm vật dài)',               '接尾辞', 34, '～本'),
  (sid, l40, '～はい',               '～はい',               '~ hai',              '~ chén, ~ cốc, ~ ly',                        '接尾辞', 35, NULL),
  (sid, l40, '～キロ',               '～キロ',               '~ kiro',             '~ ki-lô-gam; ~ ki-lô-mét',                   '接尾辞', 36, NULL),
  (sid, l40, '～グラム',             '～グラム',             '~ guramu',           '~ gam',                                      '接尾辞', 37, NULL),
  (sid, l40, '～センチ',             '～センチ',             '~ senchi',           '~ xăng-ti-mét',                              '接尾辞', 38, NULL),
  (sid, l40, '～ミリ',               '～ミリ',               '~ miri',             '~ mi-li-mét',                                '接尾辞', 39, NULL),
  (sid, l40, '～いじょう',           '～いじょう',           '~ ijou',             '~ trở lên',                                  '接尾辞', 40, '～以上'),
  (sid, l40, '～いか',               '～いか',               '~ ika',              '~ trở xuống',                                '接尾辞', 41, '～以下'),
  (sid, l40, 'さあ',                 'さあ',                 'saa',                'à, ồ (khi lưỡng lự, không rõ)',              '感動詞', 42, NULL),
  (sid, l40, 'どうでしょうか',       'どうでしょうか',       'dou deshou ka',      'thế nào ạ? (lịch sự của どうですか)',         '表現',   43, NULL),
  (sid, l40, 'クラス',               'クラス',               'kurasu',             'lớp học',                                    '名詞',   44, NULL),
  (sid, l40, 'テスト',               'テスト',               'tesuto',             'bài kiểm tra',                               '名詞',   45, NULL),
  (sid, l40, 'せいせき',             'せいせき',             'seiseki',            'kết quả, thành tích',                        '名詞',   46, '成績'),
  (sid, l40, 'ところで',             'ところで',             'tokoro de',          'nhân tiện, tiện đây',                        '接続詞', 47, NULL),
  (sid, l40, 'いらっしゃいます',     'いらっしゃいます',     'irasshaimasu',       'đến/đi/ở (kính ngữ của きます)',             '動詞',   48, NULL),
  (sid, l40, 'ようす',               'ようす',               'yousu',              'vẻ, dáng vẻ, tình hình',                     '名詞',   49, '様子'),
  (sid, l40, 'じけん',               'じけん',               'jiken',              'vụ việc, vụ án',                             '名詞',   50, '事件'),
  (sid, l40, 'オートバイ',           'オートバイ',           'ootobai',            'xe mô tô, xe máy',                           '名詞',   51, NULL),
  (sid, l40, 'ばくだん',             'ばくだん',             'bakudan',            'bom',                                        '名詞',   52, '爆弾'),
  (sid, l40, 'つみます',             'つみます',             'tsumimasu',          'chất lên, xếp lên',                          '動詞',   53, '積みます'),
  (sid, l40, 'うんてんしゅ',         'うんてんしゅ',         'untenshu',           'tài xế, người lái xe',                       '名詞',   54, '運転手'),
  (sid, l40, 'はなれた',             'はなれた',             'hanareta',           '(nơi) cách xa, tách rời',                    '動詞',   55, '離れた'),
  (sid, l40, 'が',                   'が',                   'ga',                 'nhưng',                                      '助詞',   56, NULL),
  (sid, l40, 'きゅうに',             'きゅうに',             'kyuu ni',            'đột nhiên, bỗng nhiên',                      '副詞',   57, '急に'),
  (sid, l40, 'うごかします',         'うごかします',         'ugokashimasu',       'làm chuyển động, khởi động, vận hành',       '動詞',   58, '動かします'),
  (sid, l40, 'いっしょけんめい',     'いっしょけんめい',     'isshokenmei',        'hết sức, dốc sức',                           '副詞',   59, '一所懸命'),
  (sid, l40, 'はんにん',             'はんにん',             'hannin',             'thủ phạm, phạm nhân',                        '名詞',   60, '犯人'),
  (sid, l40, 'てにいれます',         'てにいれます',         'te ni iremasu',      'có được, đạt được, giành được',              '動詞',   61, '手に入れます'),
  (sid, l40, 'いまでも',             'いまでも',             'ima demo',           'ngay cả bây giờ, đến giờ vẫn',               '副詞',   62, '今でも'),
  (sid, l40, 'うわさします',         'うわさします',         'uwasa shimasu',      'đồn đại, bàn tán',                           '動詞',   63, NULL);

-- ════════════════════════════════════════
-- BÀI 41 — xóa và seed lại (54 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l41;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l41, 'いただきます',         'いただきます',         'itadakimasu',        'nhận (khiêm nhường ngữ của もらいます)',      '動詞',   1,  NULL),
  (sid, l41, 'くださいます',         'くださいます',         'kudasaimasu',        'cho, tặng (kính ngữ của くれます)',          '動詞',   2,  NULL),
  (sid, l41, 'やります',             'やります',             'yarimasu',           'cho, tặng (cách nói suồng sã)',              '動詞',   3,  NULL),
  (sid, l41, 'よびます',             'よびます',             'yobimasu',           'gọi, mời',                                   '動詞',   4,  '呼びます'),
  (sid, l41, 'とりかえます',         'とりかえます',         'torikaemasu',        'đổi, thay thế',                              '動詞',   5,  '取り替えます'),
  (sid, l41, 'しんせつにします',     'しんせつにします',     'shinsetsu ni shimasu','đối xử tử tế, giúp đỡ ân cần',              '動詞',   6,  '親切にします'),
  (sid, l41, 'かわいい',             'かわいい',             'kawaii',             'dễ thương, đáng yêu, xinh',                  'い形容詞', 7,  NULL),
  (sid, l41, 'おいわい',             'おいわい',             'oiwai',              'quà mừng, sự chúc mừng',                     '名詞',   8,  'お祝い'),
  (sid, l41, 'おとしだま',           'おとしだま',           'otoshidama',         'tiền mừng tuổi (lì xì)',                     '名詞',   9,  'お年玉'),
  (sid, l41, '［お］みまい',         'おみまい',             '[o] mimai',          'sự thăm hỏi (người ốm)',                     '名詞',   10, '［お］見舞い'),
  (sid, l41, 'きょうみ',             'きょうみ',             'kyoumi',             'sự quan tâm, hứng thú',                      '名詞',   11, '興味'),
  (sid, l41, 'じょうほう',           'じょうほう',           'jouhou',             'thông tin',                                  '名詞',   12, '情報'),
  (sid, l41, 'ぶんぽう',             'ぶんぽう',             'bunpou',             'ngữ pháp',                                   '名詞',   13, '文法'),
  (sid, l41, 'はつおん',             'はつおん',             'hatsuon',            'phát âm',                                    '名詞',   14, '発音'),
  (sid, l41, 'さる',                 'さる',                 'saru',               'con khỉ',                                    '名詞',   15, '猿'),
  (sid, l41, 'えさ',                 'えさ',                 'esa',                'mồi, thức ăn (cho động vật)',                '名詞',   16, NULL),
  (sid, l41, 'おもちゃ',             'おもちゃ',             'omocha',             'đồ chơi',                                    '名詞',   17, NULL),
  (sid, l41, 'えほん',               'えほん',               'ehon',               'truyện tranh, sách tranh',                   '名詞',   18, '絵本'),
  (sid, l41, 'えはがき',             'えはがき',             'ehagaki',            'bưu thiếp có tranh, bưu ảnh',                '名詞',   19, '絵はがき'),
  (sid, l41, 'ドライバー',           'ドライバー',           'doraibaa',           'cái tua-vít, đồ vặn ốc',                     '名詞',   20, NULL),
  (sid, l41, 'ハンカチ',             'ハンカチ',             'hankachi',           'khăn tay',                                   '名詞',   21, NULL),
  (sid, l41, 'くつした',             'くつした',             'kutsushita',         'tất, vớ',                                    '名詞',   22, '靴下'),
  (sid, l41, 'てぶくろ',             'てぶくろ',             'tebukuro',           'găng tay',                                   '名詞',   23, '手袋'),
  (sid, l41, 'ゆびわ',               'ゆびわ',               'yubiwa',             'nhẫn (đeo tay)',                             '名詞',   24, '指輪'),
  (sid, l41, 'バッグ',               'バッグ',               'baggu',              'túi xách',                                   '名詞',   25, NULL),
  (sid, l41, 'そふ',                 'そふ',                 'sofu',               'ông (của mình)',                             '名詞',   26, '祖父'),
  (sid, l41, 'そぼ',                 'そぼ',                 'sobo',               'bà (của mình)',                              '名詞',   27, '祖母'),
  (sid, l41, 'まご',                 'まご',                 'mago',               'cháu (nội/ngoại)',                           '名詞',   28, '孫'),
  (sid, l41, 'おじ',                 'おじ',                 'oji',                'chú/bác/cậu (của mình)',                     '名詞',   29, NULL),
  (sid, l41, 'おじさん',             'おじさん',             'ojisan',             'chú/bác/cậu (của người khác)',               '名詞',   30, NULL),
  (sid, l41, 'おば',                 'おば',                 'oba',                'cô/dì/bác gái (của mình)',                   '名詞',   31, NULL),
  (sid, l41, 'おばさん',             'おばさん',             'obasan',             'cô/dì/bác gái (của người khác)',             '名詞',   32, NULL),
  (sid, l41, 'おととし',             'おととし',             'ototoshi',           'năm kia (năm trước năm ngoái)',              '名詞',   33, NULL),
  (sid, l41, 'はあ',                 'はあ',                 'haa',                'vâng, dạ (đáp lời)',                         '感動詞', 34, NULL),
  (sid, l41, 'もうしわけありません', 'もうしわけありません', 'moushiwake arimasen','thành thật xin lỗi',                         '表現',   35, '申し訳ありません'),
  (sid, l41, 'あずかります',         'あずかります',         'azukarimasu',        'giữ giùm, nhận giữ, bảo quản',               '動詞',   36, '預かります'),
  (sid, l41, 'せんじつ',             'せんじつ',             'senjitsu',           'hôm trước, mấy hôm trước',                   '名詞',   37, '先日'),
  (sid, l41, 'たすかります',         'たすかります',         'tasukarimasu',       'được cứu giúp, đỡ vất vả',                   '動詞',   38, '助かります'),
  (sid, l41, 'むかしばなし',         'むかしばなし',         'mukashibanashi',     'truyện cổ tích, chuyện xưa',                 '名詞',   39, '昔話'),
  (sid, l41, 'ある～',               'ある～',               'aru ~',              'một ~ nào đó',                               '連体詞', 40, NULL),
  (sid, l41, 'おとこ',               'おとこ',               'otoko',              'con trai, đàn ông',                          '名詞',   41, '男'),
  (sid, l41, 'こどもたち',           'こどもたち',           'kodomotachi',        'bọn trẻ, những đứa trẻ',                     '名詞',   42, '子どもたち'),
  (sid, l41, 'いじめます',           'いじめます',           'ijimemasu',          'bắt nạt, ức hiếp, trêu chọc',                '動詞',   43, NULL),
  (sid, l41, 'かめ',                 'かめ',                 'kame',               'con rùa',                                    '名詞',   44, '亀'),
  (sid, l41, 'たすけます',           'たすけます',           'tasukemasu',         'cứu, giúp đỡ',                               '動詞',   45, '助けます'),
  (sid, l41, '［お］しろ',           'おしろ',               '[o] shiro',          'lâu đài, thành',                             '名詞',   46, '［お］城'),
  (sid, l41, 'おひめさま',           'おひめさま',           'ohimesama',          'công chúa',                                  '名詞',   47, 'お姫様'),
  (sid, l41, 'たのしく',             'たのしく',             'tanoshiku',          'vui vẻ, vui sướng',                          '副詞',   48, '楽しく'),
  (sid, l41, 'くらします',           'くらします',           'kurashimasu',        'sống, sinh sống',                            '動詞',   49, '暮らします'),
  (sid, l41, 'りく',                 'りく',                 'riku',               'đất liền, lục địa',                          '名詞',   50, '陸'),
  (sid, l41, 'すると',               'すると',               'suruto',             'thế rồi, rồi thì',                           '接続詞', 51, NULL),
  (sid, l41, 'けむり',               'けむり',               'kemuri',             'khói',                                       '名詞',   52, '煙'),
  (sid, l41, 'まっしろ [な]',        'まっしろ',             'masshiro [na]',      'trắng xóa, trắng tinh',                      'な形容詞', 53, '真っ白 [な]'),
  (sid, l41, 'なかみ',               'なかみ',               'nakami',             'nội dung, phần bên trong',                   '名詞',   54, '中身');

-- ════════════════════════════════════════
-- BÀI 42 — xóa và seed lại (50 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l42;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l42, 'つつみます',           'つつみます',           'tsutsumimasu',       'bọc, gói',                                   '動詞',   1,  '包みます'),
  (sid, l42, 'わかします',           'わかします',           'wakashimasu',        'đun sôi',                                    '動詞',   2,  '沸かします'),
  (sid, l42, 'まぜます',             'まぜます',             'mazemasu',           'trộn, khuấy',                                '動詞',   3,  '混ぜます'),
  (sid, l42, 'けいさんします',       'けいさんします',       'keisan shimasu',     'tính toán',                                  '動詞',   4,  '計算します'),
  (sid, l42, 'あつい',               'あつい',               'atsui',              'dày',                                        'い形容詞', 5,  '厚い'),
  (sid, l42, 'うすい',               'うすい',               'usui',               'mỏng, nhạt',                                 'い形容詞', 6,  '薄い'),
  (sid, l42, 'べんごし',             'べんごし',             'bengoshi',           'luật sư',                                    '名詞',   7,  '弁護士'),
  (sid, l42, 'おんがくか',           'おんがくか',           'ongakuka',           'nhạc sĩ, nhà âm nhạc',                       '名詞',   8,  '音楽家'),
  (sid, l42, 'こどもたち',           'こどもたち',           'kodomotachi',        'trẻ em, những đứa trẻ',                      '名詞',   9,  '子どもたち'),
  (sid, l42, 'ふたり',               'ふたり',               'futari',             'hai người',                                  '名詞',   10, '二人'),
  (sid, l42, 'きょういく',           'きょういく',           'kyouiku',            'giáo dục',                                   '名詞',   11, '教育'),
  (sid, l42, 'れきし',               'れきし',               'rekishi',            'lịch sử',                                    '名詞',   12, '歴史'),
  (sid, l42, 'ぶんか',               'ぶんか',               'bunka',              'văn hóa',                                    '名詞',   13, '文化'),
  (sid, l42, 'しゃかい',             'しゃかい',             'shakai',             'xã hội',                                     '名詞',   14, '社会'),
  (sid, l42, 'ほうりつ',             'ほうりつ',             'houritsu',           'pháp luật, luật pháp',                       '名詞',   15, '法律'),
  (sid, l42, 'せんそう',             'せんそう',             'sensou',             'chiến tranh',                                '名詞',   16, '戦争'),
  (sid, l42, 'へいわ',               'へいわ',               'heiwa',              'hòa bình',                                   '名詞',   17, '平和'),
  (sid, l42, 'もくてき',             'もくてき',             'mokuteki',           'mục đích',                                   '名詞',   18, '目的'),
  (sid, l42, 'あんぜん',             'あんぜん',             'anzen',              'an toàn',                                    '名詞',   19, '安全'),
  (sid, l42, 'ろんぶん',             'ろんぶん',             'ronbun',             'luận văn, luận án',                          '名詞',   20, '論文'),
  (sid, l42, 'かんけい',             'かんけい',             'kankei',             'quan hệ, mối quan hệ',                       '名詞',   21, '関係'),
  (sid, l42, 'ミキサ',               'ミキサ',               'mikisa',             'máy xay, máy trộn',                          '名詞',   22, NULL),
  (sid, l42, 'やかん',               'やかん',               'yakan',              'ấm đun nước',                                '名詞',   23, NULL),
  (sid, l42, 'せんぬき',             'せんぬき',             'sennuki',            'cái mở nút chai',                            '名詞',   24, '栓抜き'),
  (sid, l42, 'かんきり',             'かんきり',             'kankiri',            'đồ mở hộp, cái khui đồ hộp',                 '名詞',   25, '缶切り'),
  (sid, l42, 'かんづめ',             'かんづめ',             'kanzume',            'đồ hộp, thực phẩm đóng hộp',                 '名詞',   26, '缶詰'),
  (sid, l42, 'ふろしき',             'ふろしき',             'furoshiki',          'khăn gói (vải bọc đồ)',                      '名詞',   27, NULL),
  (sid, l42, 'そろばん',             'そろばん',             'soroban',            'bàn tính',                                   '名詞',   28, NULL),
  (sid, l42, 'たいおんけい',         'たいおんけい',         'taionkei',           'nhiệt kế, cặp nhiệt độ',                     '名詞',   29, '体温計'),
  (sid, l42, 'ざいりょう',           'ざいりょう',           'zairyou',            'vật liệu, nguyên liệu',                      '名詞',   30, '材料'),
  (sid, l42, 'いし',                 'いし',                 'ishi',               'đá, hòn đá, sỏi',                            '名詞',   31, '石'),
  (sid, l42, 'ピラミッド',           'ピラミッド',           'piramiddo',          'kim tự tháp',                                '名詞',   32, NULL),
  (sid, l42, 'データ',               'データ',               'deeta',              'dữ liệu',                                    '名詞',   33, NULL),
  (sid, l42, 'ファイル',             'ファイル',             'fairu',              'tập tin, file',                              '名詞',   34, NULL),
  (sid, l42, 'ある～',               'ある～',               'aru ~',              'một ~ nào đó',                               '連体詞', 35, NULL),
  (sid, l42, 'いっしょうけんめい',   'いっしょうけんめい',   'isshoukenmei',       'cố gắng hết sức',                            '副詞',   36, '一生懸命'),
  (sid, l42, 'なぜ',                 'なぜ',                 'naze',               'tại sao, vì sao',                            '疑問詞', 37, NULL),
  (sid, l42, 'ローン',               'ローン',               'roon',               'tiền vay, khoản vay, trả góp',               '名詞',   38, NULL),
  (sid, l42, 'セット',               'セット',               'setto',              'bộ, set',                                    '名詞',   39, NULL),
  (sid, l42, 'あとは',               'あとは',               'ato wa',             'phần còn lại, còn lại thì',                  '表現',   40, NULL),
  (sid, l42, 'カップラーメン',       'カップラーメン',       'kappuraamen',        'mì ly, mì ăn liền',                          '名詞',   41, NULL),
  (sid, l42, 'なべ',                 'なべ',                 'nabe',               'nồi, lẩu',                                   '名詞',   42, NULL),
  (sid, l42, 'どんぶり',             'どんぶり',             'donburi',            'tô lớn, bát to',                             '名詞',   43, NULL),
  (sid, l42, 'しょくひん',           'しょくひん',           'shokuhin',           'thực phẩm',                                  '名詞',   44, '食品'),
  (sid, l42, 'ちょうさ',             'ちょうさ',             'chousa',             'điều tra, khảo sát',                         '名詞',   45, '調査'),
  (sid, l42, 'カップ',               'カップ',               'kappu',              'tách, cốc, chén',                            '名詞',   46, NULL),
  (sid, l42, 'また',                 'また',                 'mata',               'lại, ngoài ra, hơn nữa',                     '接続詞', 47, NULL),
  (sid, l42, '～のかわりに',         '～のかわりに',         '~ no kawari ni',     'thay cho, thay vì ~',                        '表現',   48, '～の代わりに'),
  (sid, l42, 'どこででも',           'どこででも',           'doko de demo',       'bất cứ nơi nào, ở đâu cũng',                 '表現',   49, NULL),
  (sid, l42, 'いまでは',             'いまでは',             'ima de wa',          'bây giờ, hiện nay',                          '副詞',   50, '今では');

END $$;
