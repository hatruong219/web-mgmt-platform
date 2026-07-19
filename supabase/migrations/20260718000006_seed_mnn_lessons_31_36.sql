-- Seed: Minna no Nihongo — Bài 31-36 (từ vựng)
-- Nguồn: PDF Minato Dorimu, đối chiếu + sửa lỗi theo danh mục từ vựng MNN chuẩn
-- Quy tắc: word = kana (+ chú thích sách), reading = CHỈ kana + ～, kanji = kanji (NULL nếu không có)
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c
--
-- Sửa lỗi PDF đáng chú ý:
--   Bài 31: 1238 続ける → 続けます (chuẩn hóa thể ます); 1239 kanji 見つめます → 見つけます (đúng nghĩa "tìm thấy")
--   Bài 32: 1286 なおります tách 2 dòng: 治ります (khỏi bệnh) / 直ります (sửa đồ vật); chuẩn hóa （な） → [な]
--   Bài 33: 1333 投げま → 投げます; 1352 非常字口 → 非常口
--   Bài 34: 1416 今夜先に → 先に (bỏ 今夜 lẫn từ dòng trên); 1424 グラマ → グラム; 1428 なべ nghĩa "nắp" → "cái nồi"
--   Bài 35: 1474 交わります (PDF mất kanji, chỉ in "GIAO" ở cột kanji)
--   Bài 36: chuẩn hóa （な） → [な]

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  l31 uuid; l32 uuid; l33 uuid; l34 uuid; l35 uuid; l36 uuid;
BEGIN
SELECT id INTO l31 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 31;
SELECT id INTO l32 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 32;
SELECT id INTO l33 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 33;
SELECT id INTO l34 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 34;
SELECT id INTO l35 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 35;
SELECT id INTO l36 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 36;
IF l31 IS NULL OR l32 IS NULL OR l33 IS NULL OR l34 IS NULL OR l35 IS NULL OR l36 IS NULL THEN
  RAISE EXCEPTION 'mnn_lessons 31-36 chưa được seed';
END IF;

-- ════════════════════════════════════════
-- BÀI 31 — xóa và seed lại (40 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l31;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l31, 'はじまります [式が～]', 'はじまります', 'hajimarimasu [shiki ga ~]', 'bắt đầu (buổi lễ ~)',                  '動詞',     1,  '始まります [式が～]'),
  (sid, l31, 'つづけます',           'つづけます',   'tsuzukemasu',              'tiếp tục',                              '動詞',     2,  '続けます'),
  (sid, l31, 'みつけます',           'みつけます',   'mitsukemasu',              'tìm thấy, tìm ra',                      '動詞',     3,  '見つけます'),
  (sid, l31, 'うけます',             'うけます',     'ukemasu',                  'dự thi, nhận (thi cử)',                 '動詞',     4,  '受けます'),
  (sid, l31, 'にゅうがくします',     'にゅうがくします', 'nyuugaku shimasu',      'nhập học',                              '動詞',     5,  '入学します'),
  (sid, l31, 'そつぎょうします',     'そつぎょうします', 'sotsugyou shimasu',     'tốt nghiệp',                            '動詞',     6,  '卒業します'),
  (sid, l31, 'きゅうけいします',     'きゅうけいします', 'kyuukei shimasu',       'nghỉ giải lao',                         '動詞',     7,  '休憩します'),
  (sid, l31, 'れんきゅう',           'れんきゅう',   'renkyuu',                  'kỳ nghỉ dài (nghỉ liền nhau)',          '名詞',     8,  '連休'),
  (sid, l31, 'さくぶん',             'さくぶん',     'sakubun',                  'bài văn, bài tập làm văn',              '名詞',     9,  '作文'),
  (sid, l31, 'てんらんかい',         'てんらんかい', 'tenrankai',                'buổi triển lãm',                        '名詞',     10, '展覧会'),
  (sid, l31, 'けっこんしき',         'けっこんしき', 'kekkonshiki',              'lễ cưới, đám cưới',                     '名詞',     11, '結婚式'),
  (sid, l31, '[お]そうしき',         'おそうしき',   '[o]soushiki',              'lễ tang, đám tang',                     '名詞',     12, '[お]葬式'),
  (sid, l31, 'しき',                 'しき',         'shiki',                    'nghi lễ, buổi lễ',                      '名詞',     13, '式'),
  (sid, l31, 'ほんしゃ',             'ほんしゃ',     'honsha',                   'trụ sở chính',                          '名詞',     14, '本社'),
  (sid, l31, 'してん',               'してん',       'shiten',                   'chi nhánh',                             '名詞',     15, '支店'),
  (sid, l31, 'きょうかい',           'きょうかい',   'kyoukai',                  'nhà thờ',                               '名詞',     16, '教会'),
  (sid, l31, 'だいがくいん',         'だいがくいん', 'daigakuin',                'cao học (sau đại học)',                 '名詞',     17, '大学院'),
  (sid, l31, 'どうぶつえん',         'どうぶつえん', 'doubutsuen',               'sở thú, vườn bách thú',                 '名詞',     18, '動物園'),
  (sid, l31, 'おんせん',             'おんせん',     'onsen',                    'suối nước nóng',                        '名詞',     19, '温泉'),
  (sid, l31, 'おきゃく [さん]',      'おきゃくさん', 'okyaku [san]',             'khách, khách hàng',                     '名詞',     20, 'お客 [さん]'),
  (sid, l31, 'だれか',               'だれか',       'dareka',                   'ai đó, có ai đó',                       '代名詞',   21, NULL),
  (sid, l31, '～のほう',             '～のほう',     '~ no hou',                 'phía ~, hướng ~',                       '名詞',     22, '～の方'),
  (sid, l31, 'ずっと',               'ずっと',       'zutto',                    'suốt, liên tục; hơn hẳn',               '副詞',     23, NULL),
  (sid, l31, 'のこります',           'のこります',   'nokorimasu',               'ở lại; còn lại',                        '動詞',     24, '残ります'),
  (sid, l31, 'つきに',               'つきに',       'tsuki ni',                 'mỗi tháng, trong một tháng',            '表現',     25, '月に'),
  (sid, l31, 'ふつうの',             'ふつうの',     'futsuu no',                'bình thường, thông thường',             '名詞',     26, '普通の'),
  (sid, l31, 'インターネット',       'インターネット', 'intaanetto',             'internet, mạng internet',               '名詞',     27, NULL),
  (sid, l31, 'むら',                 'むら',         'mura',                     'làng, thôn',                            '名詞',     28, '村'),
  (sid, l31, 'えいがかん',           'えいがかん',   'eigakan',                  'rạp chiếu phim',                        '名詞',     29, '映画館'),
  (sid, l31, 'そら',                 'そら',         'sora',                     'bầu trời',                              '名詞',     30, '空'),
  (sid, l31, 'とじます',             'とじます',     'tojimasu',                 'nhắm (mắt), đóng lại',                  '動詞',     31, '閉じます'),
  (sid, l31, 'とかい',               'とかい',       'tokai',                    'thành phố, đô thị',                     '名詞',     32, '都会'),
  (sid, l31, 'こどもたち',           'こどもたち',   'kodomotachi',              'bọn trẻ, lũ trẻ',                       '名詞',     33, '子供たち'),
  (sid, l31, 'じゆうに',             'じゆうに',     'jiyuu ni',                 'một cách tự do, tự do',                 '副詞',     34, '自由に'),
  (sid, l31, 'せかいじゅう',         'せかいじゅう', 'sekaijuu',                 'khắp thế giới, toàn thế giới',          '名詞',     35, '世界中'),
  (sid, l31, 'あつまります',         'あつまります', 'atsumarimasu',             'tụ họp, tập hợp',                       '動詞',     36, '集まります'),
  (sid, l31, 'うつくしい',           'うつくしい',   'utsukushii',               'đẹp, xinh đẹp',                         'い形容詞', 37, '美しい'),
  (sid, l31, 'しぜん',               'しぜん',       'shizen',                   'thiên nhiên, tự nhiên',                 '名詞',     38, '自然'),
  (sid, l31, 'すばらしさ',           'すばらしさ',   'subarashisa',              'sự tuyệt vời, vẻ tuyệt diệu',           '名詞',     39, NULL),
  (sid, l31, 'きがつきます',         'きがつきます', 'ki ga tsukimasu',          'để ý, nhận ra',                         '動詞',     40, '気が付きます');

-- ════════════════════════════════════════
-- BÀI 32 — xóa và seed lại (54 từ; 1286 なおります tách 治ります/直ります)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l32;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l32, 'うんどうします',       'うんどうします', 'undou shimasu',          'vận động, tập thể thao',                '動詞',     1,  '運動します'),
  (sid, l32, 'せいこうします',       'せいこうします', 'seikou shimasu',         'thành công',                            '動詞',     2,  '成功します'),
  (sid, l32, 'しっぱいします',       'しっぱいします', 'shippai shimasu',        'thất bại',                              '動詞',     3,  '失敗します'),
  (sid, l32, 'ごうかくします',       'ごうかくします', 'goukaku shimasu',        'đỗ, đạt (trúng tuyển)',                 '動詞',     4,  '合格します'),
  (sid, l32, 'もどります',           'もどります',   'modorimasu',               'quay lại, trở lại',                     '動詞',     5,  '戻ります'),
  (sid, l32, 'やみます',             'やみます',     'yamimasu',                 'tạnh (mưa), ngừng, dừng',               '動詞',     6,  NULL),
  (sid, l32, 'はれます',             'はれます',     'haremasu',                 'trời nắng, quang đãng',                 '動詞',     7,  '晴れます'),
  (sid, l32, 'くもります',           'くもります',   'kumorimasu',               'có mây, trời âm u',                     '動詞',     8,  '曇ります'),
  (sid, l32, 'ふきます',             'ふきます',     'fukimasu',                 'thổi (gió thổi)',                       '動詞',     9,  '吹きます'),
  (sid, l32, 'なおります',           'なおります',   'naorimasu',                'khỏi (bệnh), lành lại',                 '動詞',     10, '治ります'),
  (sid, l32, 'なおります',           'なおります',   'naorimasu',                'được sửa, được sửa chữa (đồ vật)',      '動詞',     11, '直ります'),
  (sid, l32, 'つづきます',           'つづきます',   'tsuzukimasu',              'tiếp tục, tiếp diễn, kéo dài',          '動詞',     12, NULL),
  (sid, l32, 'ひやします',           'ひやします',   'hiyashimasu',              'làm lạnh, ướp lạnh',                    '動詞',     13, '冷やします'),
  (sid, l32, 'しんぱい [な]',        'しんぱい',     'shinpai [na]',             'lo lắng, lo âu',                        'な形容詞', 14, '心配 [な]'),
  (sid, l32, 'じゅうぶん [な]',      'じゅうぶん',   'juubun [na]',              'đủ, đầy đủ',                            'な形容詞', 15, '十分 [な]'),
  (sid, l32, 'おかしい',             'おかしい',     'okashii',                  'kỳ lạ, không bình thường; buồn cười',   'い形容詞', 16, NULL),
  (sid, l32, 'うるさい',             'うるさい',     'urusai',                   'ồn ào, ầm ĩ',                           'い形容詞', 17, NULL),
  (sid, l32, 'やけど',               'やけど',       'yakedo',                   'bỏng, vết bỏng',                        '名詞',     18, NULL),
  (sid, l32, 'けが',                 'けが',         'kega',                     'bị thương, vết thương',                 '名詞',     19, NULL),
  (sid, l32, 'せき',                 'せき',         'seki',                     'ho, cơn ho',                            '名詞',     20, NULL),
  (sid, l32, 'インフルエンザ',       'インフルエンザ', 'infuruenza',             'cúm, cúm dịch',                         '名詞',     21, NULL),
  (sid, l32, 'そら',                 'そら',         'sora',                     'bầu trời',                              '名詞',     22, '空'),
  (sid, l32, 'たいよう',             'たいよう',     'taiyou',                   'mặt trời',                              '名詞',     23, '太陽'),
  (sid, l32, 'ほし',                 'ほし',         'hoshi',                    'ngôi sao',                              '名詞',     24, '星'),
  (sid, l32, 'つき',                 'つき',         'tsuki',                    'mặt trăng',                             '名詞',     25, '月'),
  (sid, l32, 'かぜ',                 'かぜ',         'kaze',                     'gió',                                   '名詞',     26, '風'),
  (sid, l32, 'きた',                 'きた',         'kita',                     'phía bắc, hướng bắc',                   '名詞',     27, '北'),
  (sid, l32, 'みなみ',               'みなみ',       'minami',                   'phía nam, hướng nam',                   '名詞',     28, '南'),
  (sid, l32, 'にし',                 'にし',         'nishi',                    'phía tây, hướng tây',                   '名詞',     29, '西'),
  (sid, l32, 'ひがし',               'ひがし',       'higashi',                  'phía đông, hướng đông',                 '名詞',     30, '東'),
  (sid, l32, 'すいどう',             'すいどう',     'suidou',                   'nước máy, đường ống nước',              '名詞',     31, '水道'),
  (sid, l32, 'エンジン',             'エンジン',     'enjin',                    'động cơ',                               '名詞',     32, NULL),
  (sid, l32, 'チーム',               'チーム',       'chiimu',                   'đội, nhóm (team)',                      '名詞',     33, NULL),
  (sid, l32, 'こんや',               'こんや',       'kon''ya',                  'tối nay, đêm nay',                      '名詞',     34, '今夜'),
  (sid, l32, 'ゆうがた',             'ゆうがた',     'yuugata',                  'chiều tối',                             '名詞',     35, '夕方'),
  (sid, l32, 'まえ',                 'まえ',         'mae',                      'trước, phía trước',                     '名詞',     36, '前'),
  (sid, l32, 'おそく',               'おそく',       'osoku',                    'muộn, khuya',                           '副詞',     37, '遅く'),
  (sid, l32, 'こんなに',             'こんなに',     'konna ni',                 'như thế này, đến mức này',              '副詞',     38, NULL),
  (sid, l32, 'そんなに',             'そんなに',     'sonna ni',                 'như thế đó, đến mức đó',                '副詞',     39, NULL),
  (sid, l32, 'あんなに',             'あんなに',     'anna ni',                  'như thế kia, đến mức kia',              '副詞',     40, NULL),
  (sid, l32, 'もしかしたら',         'もしかしたら', 'moshika shitara',          'có thể, biết đâu, có khả năng',         '副詞',     41, NULL),
  (sid, l32, 'それはいけませんね',   'それはいけませんね', 'sore wa ikemasen ne', 'thế thì gay quá, thế thì không ổn rồi', '表現',    42, NULL),
  (sid, l32, 'オリンピック',         'オリンピック', 'orinpikku',                'Olympic, thế vận hội',                  '名詞',     43, NULL),
  (sid, l32, 'げんき',               'げんき',       'genki',                    'khỏe mạnh, khỏe khoắn',                 'な形容詞', 44, '元気'),
  (sid, l32, 'い',                   'い',           'i',                        'dạ dày',                                '名詞',     45, '胃'),
  (sid, l32, 'はたらきすぎ',         'はたらきすぎ', 'hataraki sugi',            'làm việc quá sức',                      '名詞',     46, '働きすぎ'),
  (sid, l32, 'ストレス',             'ストレス',     'sutoresu',                 'stress, căng thẳng tâm lý',             '名詞',     47, NULL),
  (sid, l32, 'むりをします',         'むりをします', 'muri o shimasu',           'làm quá sức, gắng sức quá mức',         '動詞',     48, '無理をします'),
  (sid, l32, 'ゆっくりします',       'ゆっくりします', 'yukkuri shimasu',        'nghỉ ngơi, thư giãn, thong thả',        '動詞',     49, NULL),
  (sid, l32, 'こまります',           'こまります',   'komarimasu',               'gặp rắc rối, khó xử, lúng túng',        '動詞',     50, '困ります'),
  (sid, l32, 'たからくじ',           'たからくじ',   'takarakuji',               'xổ số, vé số',                          '名詞',     51, '宝くじ'),
  (sid, l32, 'けんこう',             'けんこう',     'kenkou',                   'sức khỏe',                              '名詞',     52, '健康'),
  (sid, l32, 'れんあい',             'れんあい',     'ren''ai',                  'tình yêu, yêu đương',                   '名詞',     53, '恋愛'),
  (sid, l32, 'こいびと',             'こいびと',     'koibito',                  'người yêu',                             '名詞',     54, '恋人');

-- ════════════════════════════════════════
-- BÀI 33 — xóa và seed lại (54 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l33;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l33, 'にげます',             'にげます',     'nigemasu',                 'chạy trốn, bỏ chạy',                    '動詞',     1,  '逃げます'),
  (sid, l33, 'さわぎます',           'さわぎます',   'sawagimasu',               'làm ồn, làm ầm ĩ',                      '動詞',     2,  '騒ぎます'),
  (sid, l33, 'あきらめます',         'あきらめます', 'akiramemasu',              'từ bỏ, bỏ cuộc',                        '動詞',     3,  NULL),
  (sid, l33, 'なげます',             'なげます',     'nagemasu',                 'ném, quăng',                            '動詞',     4,  '投げます'),
  (sid, l33, 'まもります',           'まもります',   'mamorimasu',               'bảo vệ; tuân thủ, giữ',                 '動詞',     5,  '守ります'),
  (sid, l33, 'あげます',             'あげます',     'agemasu',                  'nâng lên, tăng lên',                    '動詞',     6,  '上げます'),
  (sid, l33, 'さげます',             'さげます',     'sagemasu',                 'hạ xuống, giảm xuống',                  '動詞',     7,  '下げます'),
  (sid, l33, 'つたえます',           'つたえます',   'tsutaemasu',               'truyền đạt, nhắn lại',                  '動詞',     8,  '伝えます'),
  (sid, l33, 'ちゅういします',       'ちゅういします', 'chuui shimasu',          'chú ý, lưu ý; nhắc nhở',                '動詞',     9,  '注意します'),
  (sid, l33, 'はずします',           'はずします',   'hazushimasu',              'rời khỏi (chỗ), vắng mặt; tháo ra',     '動詞',     10, '外します'),
  (sid, l33, 'だめ',                 'だめ',         'dame',                     'không được, không thể; hỏng',           'な形容詞', 11, NULL),
  (sid, l33, 'せき',                 'せき',         'seki',                     'chỗ ngồi, ghế',                         '名詞',     12, '席'),
  (sid, l33, 'ファイト',             'ファイト',     'faito',                    'cố lên!, quyết chiến!',                 '感動詞',   13, NULL),
  (sid, l33, 'マーク',               'マーク',       'maaku',                    'kí hiệu, dấu',                          '名詞',     14, NULL),
  (sid, l33, 'ボール',               'ボール',       'booru',                    'quả bóng, banh',                        '名詞',     15, NULL),
  (sid, l33, 'せんたくき',           'せんたくき',   'sentakuki',                'máy giặt',                              '名詞',     16, '洗濯機'),
  (sid, l33, '～き',                 '～き',         '~ ki',                     'máy ~ (hậu tố chỉ máy móc)',            '接尾辞',   17, '～機'),
  (sid, l33, 'きそく',               'きそく',       'kisoku',                   'quy tắc, quy định, nội quy',            '名詞',     18, '規則'),
  (sid, l33, 'しようきんし',         'しようきんし', 'shiyou kinshi',            'cấm sử dụng',                           '名詞',     19, '使用禁止'),
  (sid, l33, 'たちいりきんし',       'たちいりきんし', 'tachiiri kinshi',        'cấm vào, cấm xâm nhập',                 '名詞',     20, '立ち入り禁止'),
  (sid, l33, 'いりぐち',             'いりぐち',     'iriguchi',                 'lối vào, cửa vào',                      '名詞',     21, '入口'),
  (sid, l33, 'でぐち',               'でぐち',       'deguchi',                  'lối ra, cửa ra',                        '名詞',     22, '出口'),
  (sid, l33, 'ひじょうぐち',         'ひじょうぐち', 'hijouguchi',               'cửa thoát hiểm, lối thoát hiểm',        '名詞',     23, '非常口'),
  (sid, l33, 'むりょう',             'むりょう',     'muryou',                   'miễn phí',                              '名詞',     24, '無料'),
  (sid, l33, 'ほんじつきゅうぎょう', 'ほんじつきゅうぎょう', 'honjitsu kyuugyou', 'hôm nay đóng cửa/nghỉ (bảng hiệu)',    '表現',    25, '本日休業'),
  (sid, l33, 'えいぎょうちゅう',     'えいぎょうちゅう', 'eigyou chuu',          'đang mở cửa (đang kinh doanh)',         '名詞',     26, '営業中'),
  (sid, l33, 'しようちゅう',         'しようちゅう', 'shiyou chuu',              'đang sử dụng',                          '名詞',     27, '使用中'),
  (sid, l33, '～ちゅう',             '～ちゅう',     '~ chuu',                   'đang ~, trong lúc ~',                   '接尾辞',   28, '～中'),
  (sid, l33, 'どういう～',           'どういう～',   'douiu ~',                  '~ như thế nào, ~ gì',                   '連体詞',   29, NULL),
  (sid, l33, 'もう',                 'もう',         'mou',                      'không ~ nữa (với thể phủ định)',        '副詞',     30, NULL),
  (sid, l33, 'あと',                 'あと',         'ato',                      'còn ~ (nữa)',                           '副詞',     31, NULL),
  (sid, l33, 'ちゅうしゃいはん',     'ちゅうしゃいはん', 'chuusha ihan',         'đỗ xe trái phép, vi phạm đỗ xe',        '名詞',     32, '駐車違反'),
  (sid, l33, 'そりゃあ',             'そりゃあ',     'soryaa',                   'thế thì, vậy thì (nói tắt của それは)', '表現',   33, NULL),
  (sid, l33, '～いない',             '～いない',     '~ inai',                   'trong vòng ~, trong khoảng ~',          '名詞',     34, '～以内'),
  (sid, l33, 'けいさつ',             'けいさつ',     'keisatsu',                 'cảnh sát',                              '名詞',     35, '警察'),
  (sid, l33, 'ばっきん',             'ばっきん',     'bakkin',                   'tiền phạt',                             '名詞',     36, '罰金'),
  (sid, l33, 'でんぽう',             'でんぽう',     'denpou',                   'điện báo, điện tín',                    '名詞',     37, '電報'),
  (sid, l33, 'ひとびと',             'ひとびと',     'hitobito',                 'nhiều người, mọi người',               '名詞',     38, '人々'),
  (sid, l33, 'きゅうよう',           'きゅうよう',   'kyuuyou',                  'việc gấp, việc khẩn',                   '名詞',     39, '急用'),
  (sid, l33, 'うちます',             'うちます',     'uchimasu',                 'đánh, gõ; gửi (điện báo)',              '動詞',     40, '打ちます'),
  (sid, l33, 'でんぽうだい',         'でんぽうだい', 'denpoudai',                'phí điện báo, tiền gửi điện tín',       '名詞',     41, '電報代'),
  (sid, l33, 'できるだけ',           'できるだけ',   'dekiru dake',              'hết sức có thể, trong khả năng',        '副詞',     42, NULL),
  (sid, l33, 'みじかく',             'みじかく',     'mijikaku',                 'ngắn, ngắn gọn',                        '副詞',     43, '短く'),
  (sid, l33, 'また',                 'また',         'mata',                     'lại, thêm nữa; ngoài ra',               '副詞',     44, NULL),
  (sid, l33, 'たとえば',             'たとえば',     'tatoeba',                  'ví dụ, chẳng hạn như',                  '副詞',     45, '例えば'),
  (sid, l33, 'キトク',               'キトク',       'kitoku',                   'tình trạng nguy kịch, bệnh hiểm nghèo', '名詞',     46, NULL),
  (sid, l33, 'おもいびょうき',       'おもいびょうき', 'omoi byouki',            'bệnh nặng',                             '名詞',     47, '重い病気'),
  (sid, l33, 'あす',                 'あす',         'asu',                      'ngày mai',                              '名詞',     48, '明日'),
  (sid, l33, 'るす',                 'るす',         'rusu',                     'vắng nhà, đi vắng',                     '名詞',     49, '留守'),
  (sid, l33, 'るすばん',             'るすばん',     'rusuban',                  'trông nhà, giữ nhà',                    '名詞',     50, '留守番'),
  (sid, l33, '[お]いわい',           'おいわい',     '[o]iwai',                  'việc chúc mừng, quà mừng',              '名詞',     51, NULL),
  (sid, l33, 'なくなります',         'なくなります', 'nakunarimasu',             'mất, qua đời',                          '動詞',     52, NULL),
  (sid, l33, 'かなしい',             'かなしい',     'kanashii',                 'buồn, đau buồn',                        'い形容詞', 53, '悲しい'),
  (sid, l33, 'りようします',         'りようします', 'riyou shimasu',            'sử dụng, tận dụng',                     '動詞',     54, '利用します');

-- ════════════════════════════════════════
-- BÀI 34 — xóa và seed lại (50 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l34;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l34, 'みがきます',           'みがきます',   'migakimasu',               'đánh (răng), mài, đánh bóng',           '動詞',     1,  '磨きます'),
  (sid, l34, 'くみたてます',         'くみたてます', 'kumitatemasu',             'lắp ráp, lắp đặt',                      '動詞',     2,  '組み立てます'),
  (sid, l34, 'おります',             'おります',     'orimasu',                  'gấp, gập; bẻ gãy',                      '動詞',     3,  '折ります'),
  (sid, l34, 'きがつきます',         'きがつきます', 'ki ga tsukimasu',          'nhận thấy, nhận ra, phát hiện',         '動詞',     4,  '気が付きます'),
  (sid, l34, 'つけます',             'つけます',     'tsukemasu',                'chấm (vào); gắn vào, thêm',             '動詞',     5,  '付けます'),
  (sid, l34, 'みつかります',         'みつかります', 'mitsukarimasu',            'được tìm thấy, tìm ra được',            '動詞',     6,  '見つかります'),
  (sid, l34, 'します [ネクタイを～]', 'します',      'shimasu [nekutai o ~]',    'đeo, thắt (cà vạt)',                    '動詞',     7,  NULL),
  (sid, l34, 'しつもんします',       'しつもんします', 'shitsumon shimasu',      'hỏi, đặt câu hỏi',                      '動詞',     8,  '質問します'),
  (sid, l34, 'ほそい',               'ほそい',       'hosoi',                    'nhỏ, mảnh, hẹp; thon',                  'い形容詞', 9,  '細い'),
  (sid, l34, 'ふとい',               'ふとい',       'futoi',                    'to, dày; mập',                          'い形容詞', 10, '太い'),
  (sid, l34, 'ぼんおどり',           'ぼんおどり',   'bon odori',                'múa Bon (điệu múa lễ Obon)',            '名詞',     11, '盆踊り'),
  (sid, l34, 'スポーツクラブ',       'スポーツクラブ', 'supootsu kurabu',        'câu lạc bộ thể thao',                   '名詞',     12, NULL),
  (sid, l34, 'かぐ',                 'かぐ',         'kagu',                     'đồ nội thất, đồ dùng trong nhà',        '名詞',     13, '家具'),
  (sid, l34, 'キー',                 'キー',         'kii',                      'chìa khóa (key)',                       '名詞',     14, NULL),
  (sid, l34, 'シートベルト',         'シートベルト', 'shiitoberuto',             'dây an toàn',                           '名詞',     15, NULL),
  (sid, l34, 'せつめいしょ',         'せつめいしょ', 'setsumeisho',              'bản hướng dẫn sử dụng',                 '名詞',     16, '説明書'),
  (sid, l34, 'ず',                   'ず',           'zu',                       'sơ đồ, hình vẽ, bản vẽ',                '名詞',     17, '図'),
  (sid, l34, 'せん',                 'せん',         'sen',                      'đường (kẻ), đường thẳng, tuyến',        '名詞',     18, '線'),
  (sid, l34, 'やじるし',             'やじるし',     'yajirushi',                'dấu mũi tên',                           '名詞',     19, '矢印'),
  (sid, l34, 'くろ',                 'くろ',         'kuro',                     'màu đen',                               '名詞',     20, '黒'),
  (sid, l34, 'しろ',                 'しろ',         'shiro',                    'màu trắng',                             '名詞',     21, '白'),
  (sid, l34, 'あか',                 'あか',         'aka',                      'màu đỏ',                                '名詞',     22, '赤'),
  (sid, l34, 'あお',                 'あお',         'ao',                       'màu xanh (xanh dương)',                 '名詞',     23, '青'),
  (sid, l34, 'こん',                 'こん',         'kon',                      'màu xanh lam, xanh đậm',                '名詞',     24, '紺'),
  (sid, l34, 'きいろ',               'きいろ',       'kiiro',                    'màu vàng',                              '名詞',     25, '黄色'),
  (sid, l34, 'ちゃいろ',             'ちゃいろ',     'chairo',                   'màu nâu',                               '名詞',     26, '茶色'),
  (sid, l34, 'しょうゆ',             'しょうゆ',     'shouyu',                   'xì dầu, nước tương',                    '名詞',     27, NULL),
  (sid, l34, 'ソース',               'ソース',       'soosu',                    'nước xốt, sốt (sauce)',                 '名詞',     28, NULL),
  (sid, l34, 'ゆうべ',               'ゆうべ',       'yuube',                    'tối qua, đêm qua',                      '名詞',     29, NULL),
  (sid, l34, 'さっき',               'さっき',       'sakki',                    'vừa rồi, lúc nãy',                      '副詞',     30, NULL),
  (sid, l34, 'さどう',               'さどう',       'sadou',                    'trà đạo',                               '名詞',     31, '茶道'),
  (sid, l34, 'おちゃをたてます',     'おちゃをたてます', 'ocha o tatemasu',      'pha trà (theo nghi thức trà đạo)',      '動詞',     32, 'お茶をたてます'),
  (sid, l34, 'さきに',               'さきに',       'saki ni',                  'trước, trước tiên',                     '副詞',     33, '先に'),
  (sid, l34, 'のせます',             'のせます',     'nosemasu',                 'đặt lên, để lên; đăng (bài)',           '動詞',     34, '載せます'),
  (sid, l34, 'これでいいですか',     'これでいいですか', 'kore de ii desu ka',   'Thế này được không / đã được chưa?',    '表現',     35, NULL),
  (sid, l34, 'にがい',               'にがい',       'nigai',                    'đắng',                                  'い形容詞', 36, '苦い'),
  (sid, l34, 'おやこどんぶり',       'おやこどんぶり', 'oyako donburi',          'món oyakodon (cơm gà trứng)',           '名詞',     37, '親子どんぶり'),
  (sid, l34, 'ざいりょう',           'ざいりょう',   'zairyou',                  'nguyên liệu, vật liệu',                 '名詞',     38, '材料'),
  (sid, l34, '～ぶん',               '～ぶん',       '~ bun',                    'phần ~ (suất / cho ~ người)',           '接尾辞',   39, '～分'),
  (sid, l34, 'とりにく',             'とりにく',     'toriniku',                 'thịt gà',                               '名詞',     40, '鶏肉'),
  (sid, l34, '～グラム',             '～グラム',     '~ guramu',                 '~ gam (đơn vị gram)',                   '接尾辞',   41, NULL),
  (sid, l34, 'たまねぎ',             'たまねぎ',     'tamanegi',                 'hành tây',                              '名詞',     42, NULL),
  (sid, l34, 'よんぶんの１',         'よんぶんのいち', 'yon bun no ichi',        'một phần tư (1/4)',                     '名詞',     43, '四分の１'),
  (sid, l34, 'ちょうみりょう',       'ちょうみりょう', 'choumiryou',             'gia vị, đồ gia vị',                     '名詞',     44, '調味料'),
  (sid, l34, 'なべ',                 'なべ',         'nabe',                     'cái nồi, nồi (nấu ăn)',                 '名詞',     45, NULL),
  (sid, l34, 'ひ',                   'ひ',           'hi',                       'lửa',                                   '名詞',     46, '火'),
  (sid, l34, 'ひにかけます',         'ひにかけます', 'hi ni kakemasu',           'bắc lên bếp, đun (trên lửa)',           '動詞',     47, '火にかけます'),
  (sid, l34, 'にます',               'にます',       'nimasu',                   'nấu, ninh, hầm',                        '動詞',     48, '煮ます'),
  (sid, l34, 'にえます',             'にえます',     'niemasu',                  'chín (được nấu chín), sôi',             '動詞',     49, '煮えます'),
  (sid, l34, 'どんぶり',             'どんぶり',     'donburi',                  'bát to, tô (đựng cơm)',                 '名詞',     50, NULL);

-- ════════════════════════════════════════
-- BÀI 35 — xóa và seed lại (44 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l35;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l35, 'さきます',             'さきます',     'sakimasu',                 'nở (hoa nở)',                           '動詞',     1,  '咲きます'),
  (sid, l35, 'かわります',           'かわります',   'kawarimasu',               'thay đổi, biến đổi',                    '動詞',     2,  '変わります'),
  (sid, l35, 'こまります',           'こまります',   'komarimasu',               'gặp rắc rối, khó xử',                   '動詞',     3,  '困ります'),
  (sid, l35, 'つけます',             'つけます',     'tsukemasu',                'đánh dấu, ghi vào',                     '動詞',     4,  '付けます'),
  (sid, l35, 'ひろいます',           'ひろいます',   'hiroimasu',                'nhặt lên, lượm',                        '動詞',     5,  '拾います'),
  (sid, l35, 'かかります',           'かかります',   'kakarimasu',               '(điện thoại) gọi đến, đổ chuông',       '動詞',     6,  NULL),
  (sid, l35, 'らく [な]',            'らく',         'raku [na]',                'thoải mái, thảnh thơi, dễ dàng',        'な形容詞', 7,  '楽 [な]'),
  (sid, l35, 'ただしい',             'ただしい',     'tadashii',                 'đúng, chính xác',                       'い形容詞', 8,  '正しい'),
  (sid, l35, 'めずらしい',           'めずらしい',   'mezurashii',               'hiếm có, hiếm gặp, quý hiếm',           'い形容詞', 9,  '珍しい'),
  (sid, l35, 'かた',                 'かた',         'kata',                     'vị, người (cách nói lịch sự của 人)',   '名詞',     10, '方'),
  (sid, l35, 'むこう',               'むこう',       'mukou',                    'bên kia, phía đối diện, đằng kia',      '名詞',     11, '向こう'),
  (sid, l35, 'しま',                 'しま',         'shima',                    'đảo, hòn đảo',                          '名詞',     12, '島'),
  (sid, l35, 'むら',                 'むら',         'mura',                     'làng, thôn',                            '名詞',     13, '村'),
  (sid, l35, 'みなと',               'みなと',       'minato',                   'cảng, bến cảng',                        '名詞',     14, '港'),
  (sid, l35, 'きんじょ',             'きんじょ',     'kinjo',                    'hàng xóm, khu lân cận, gần nhà',        '名詞',     15, '近所'),
  (sid, l35, 'おくじょう',           'おくじょう',   'okujou',                   'sân thượng, nóc nhà',                   '名詞',     16, '屋上'),
  (sid, l35, 'かいがい',             'かいがい',     'kaigai',                   'nước ngoài, hải ngoại',                 '名詞',     17, '海外'),
  (sid, l35, 'やまのぼり',           'やまのぼり',   'yama nobori',              'leo núi',                               '名詞',     18, '山登り'),
  (sid, l35, 'ハイキング',           'ハイキング',   'haikingu',                 'đi bộ dã ngoại (hiking)',               '名詞',     19, NULL),
  (sid, l35, 'きかい',               'きかい',       'kikai',                    'cơ hội, dịp',                           '名詞',     20, '機会'),
  (sid, l35, 'きょか',               'きょか',       'kyoka',                    'sự cho phép, giấy phép',                '名詞',     21, '許可'),
  (sid, l35, 'まる',                 'まる',         'maru',                     'vòng tròn, dấu tròn (đúng)',            '名詞',     22, '丸'),
  (sid, l35, 'そうさ',               'そうさ',       'sousa',                    'thao tác, vận hành',                    '名詞',     23, '操作'),
  (sid, l35, 'ほうほう',             'ほうほう',     'houhou',                   'phương pháp, cách thức',                '名詞',     24, '方法'),
  (sid, l35, 'せつび',               'せつび',       'setsubi',                  'thiết bị, trang thiết bị',              '名詞',     25, '設備'),
  (sid, l35, 'カーテン',             'カーテン',     'kaaten',                   'rèm cửa',                               '名詞',     26, NULL),
  (sid, l35, 'ひも',                 'ひも',         'himo',                     'sợi dây, dây buộc',                     '名詞',     27, NULL),
  (sid, l35, 'ふた',                 'ふた',         'futa',                     'cái nắp (đậy)',                         '名詞',     28, NULL),
  (sid, l35, 'は',                   'は',           'ha',                       'lá (cây)',                              '名詞',     29, '葉'),
  (sid, l35, 'きょく',               'きょく',       'kyoku',                    'bản nhạc, ca khúc, bài hát',            '名詞',     30, '曲'),
  (sid, l35, 'たのしみ',             'たのしみ',     'tanoshimi',                'niềm vui, sự mong chờ',                 '名詞',     31, '楽しみ'),
  (sid, l35, 'もっと',               'もっと',       'motto',                    'hơn nữa, thêm nữa',                     '副詞',     32, NULL),
  (sid, l35, 'はじめに',             'はじめに',     'hajime ni',                'đầu tiên, trước hết',                   '副詞',     33, '初めに'),
  (sid, l35, 'これでおわります',     'これでおわります', 'kore de owarimasu',    'đến đây là kết thúc, chúng ta dừng ở đây', '表現', 34, 'これで終わります'),
  (sid, l35, 'それなら',             'それなら',     'sore nara',                'nếu vậy thì, vậy thì',                  '接続詞',   35, NULL),
  (sid, l35, 'やこうバス',           'やこうバス',   'yakou basu',               'xe buýt chạy đêm, xe khách đêm',        '名詞',     36, '夜行バス'),
  (sid, l35, 'りょこうしゃ',         'りょこうしゃ', 'ryokousha',                'công ty du lịch',                       '名詞',     37, '旅行社'),
  (sid, l35, 'くわしい',             'くわしい',     'kuwashii',                 'chi tiết, tường tận, rành rẽ',          'い形容詞', 38, '詳しい'),
  (sid, l35, 'スキーじょう',         'スキーじょう', 'sukii jou',                'khu trượt tuyết, bãi trượt tuyết',      '名詞',     39, 'スキー場'),
  (sid, l35, 'しゅ',                 'しゅ',         'shu',                      'màu đỏ son, màu chu sa',                '名詞',     40, '朱'),
  (sid, l35, 'まじわります',         'まじわります', 'majiwarimasu',             'giao lưu, giao thiệp, kết giao',        '動詞',     41, '交わります'),
  (sid, l35, 'ことわざ',             'ことわざ',     'kotowaza',                 'tục ngữ, thành ngữ',                    '名詞',     42, NULL),
  (sid, l35, 'なかよくします',       'なかよくします', 'naka yoku shimasu',      'chơi thân, hòa thuận với',              '動詞',     43, '仲よくします'),
  (sid, l35, 'ひつよう [な]',        'ひつよう',     'hitsuyou [na]',            'cần thiết, cần',                        'な形容詞', 44, '必要 [な]');

-- ════════════════════════════════════════
-- BÀI 36 — xóa và seed lại (46 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l36;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l36, 'とどきます',           'とどきます',   'todokimasu',               '(hàng) được gửi đến, đến nơi',          '動詞',     1,  '届きます'),
  (sid, l36, 'でます',               'でます',       'demasu',                   'tham gia, tham dự',                     '動詞',     2,  '出ます'),
  (sid, l36, 'うちます',             'うちます',     'uchimasu',                 'đánh, đập, gõ',                         '動詞',     3,  '打ちます'),
  (sid, l36, 'ちょきんします',       'ちょきんします', 'chokin shimasu',         'tiết kiệm tiền, gửi tiết kiệm',         '動詞',     4,  '貯金します'),
  (sid, l36, 'ふとります',           'ふとります',   'futorimasu',               'béo lên, tăng cân, mập ra',             '動詞',     5,  '太ります'),
  (sid, l36, 'やせます',             'やせます',     'yasemasu',                 'gầy đi, giảm cân, sút cân',             '動詞',     6,  NULL),
  (sid, l36, 'すぎます',             'すぎます',     'sugimasu',                 'quá, vượt quá; trôi qua',               '動詞',     7,  '過ぎます'),
  (sid, l36, 'なれます',             'なれます',     'naremasu',                 'quen, làm quen (với)',                  '動詞',     8,  NULL),
  (sid, l36, 'かたい',               'かたい',       'katai',                    'cứng, rắn chắc',                        'い形容詞', 9,  '固い'),
  (sid, l36, 'やわらかい',           'やわらかい',   'yawarakai',                'mềm, mềm mại',                          'い形容詞', 10, '軟らかい'),
  (sid, l36, 'でんし～',             'でんし～',     'denshi ~',                 '~ điện tử',                             '名詞',     11, '電子～'),
  (sid, l36, 'けいたい～',           'けいたい～',   'keitai ~',                 '~ cầm tay, di động',                    '名詞',     12, '携帯～'),
  (sid, l36, 'こうじょう',           'こうじょう',   'koujou',                   'nhà máy, phân xưởng',                   '名詞',     13, '工場'),
  (sid, l36, 'けんこう',             'けんこう',     'kenkou',                   'sức khỏe',                              '名詞',     14, '健康'),
  (sid, l36, 'けんどう',             'けんどう',     'kendou',                   'kiếm đạo (kendo)',                      '名詞',     15, '剣道'),
  (sid, l36, 'まいしゅう',           'まいしゅう',   'maishuu',                  'hàng tuần, mỗi tuần',                   '名詞',     16, '毎週'),
  (sid, l36, 'まいつき',             'まいつき',     'maitsuki',                 'hàng tháng, mỗi tháng',                 '名詞',     17, '毎月'),
  (sid, l36, 'まいとし',             'まいとし',     'maitoshi',                 'hàng năm, mỗi năm',                     '名詞',     18, '毎年'),
  (sid, l36, 'やっと',               'やっと',       'yatto',                    'cuối cùng thì, mãi rồi cũng',           '副詞',     19, NULL),
  (sid, l36, 'かなり',               'かなり',       'kanari',                   'khá, tương đối, đáng kể',               '副詞',     20, NULL),
  (sid, l36, 'かならず',             'かならず',     'kanarazu',                 'nhất định, chắc chắn',                  '副詞',     21, '必ず'),
  (sid, l36, 'ぜったいに',           'ぜったいに',   'zettai ni',                'tuyệt đối, nhất quyết',                 '副詞',     22, '絶対に'),
  (sid, l36, 'じょうずに',           'じょうずに',   'jouzu ni',                 'giỏi, khéo léo, thành thạo',            '副詞',     23, '上手に'),
  (sid, l36, 'できるだけ',           'できるだけ',   'dekiru dake',              'hết sức có thể, trong khả năng',        '副詞',     24, NULL),
  (sid, l36, 'このごろ',             'このごろ',     'kono goro',                'gần đây, dạo này',                      '副詞',     25, NULL),
  (sid, l36, 'そのほうが～',         'そのほうが～', 'sono hou ga ~',            'cái đó ~ hơn, như thế thì ~ hơn',       '表現',     26, NULL),
  (sid, l36, 'おきゃくさま',         'おきゃくさま', 'okyakusama',               'khách hàng, quý khách',                 '名詞',     27, 'お客様'),
  (sid, l36, 'とくべつ [な]',        'とくべつ',     'tokubetsu [na]',           'đặc biệt',                              'な形容詞', 28, '特別 [な]'),
  (sid, l36, 'していらっしゃいます', 'していらっしゃいます', 'shite irasshaimasu', 'đang làm (kính ngữ của しています)',    '表現',    29, NULL),
  (sid, l36, 'すいえい',             'すいえい',     'suiei',                    'môn bơi, bơi lội',                      '名詞',     30, '水泳'),
  (sid, l36, '～とか、～とか',        '～とか～とか', '~ toka ~ toka',            'nào là ~ nào là ~ (khi liệt kê)',       '助詞',     31, NULL),
  (sid, l36, 'タンゴ',               'タンゴ',       'tango',                    'điệu nhảy tango',                       '名詞',     32, NULL),
  (sid, l36, 'チャレンジします',     'チャレンジします', 'charenji shimasu',     'thử thách, thử sức',                    '動詞',     33, NULL),
  (sid, l36, 'きもち',               'きもち',       'kimochi',                  'cảm giác, tâm trạng, cảm xúc',          '名詞',     34, '気持ち'),
  (sid, l36, 'のりもの',             'のりもの',     'norimono',                 'phương tiện đi lại, phương tiện giao thông', '名詞', 35, '乗り物'),
  (sid, l36, 'れきし',               'れきし',       'rekishi',                  'lịch sử',                               '名詞',     36, '歴史'),
  (sid, l36, '～せいき',             '～せいき',     '~ seiki',                  'thế kỉ ~',                              '名詞',     37, '～世紀'),
  (sid, l36, 'とおく',               'とおく',       'tooku',                    'nơi xa, đằng xa',                       '名詞',     38, '遠く'),
  (sid, l36, 'きしゃ',               'きしゃ',       'kisha',                    'tàu hỏa (chạy bằng hơi nước)',          '名詞',     39, '汽車'),
  (sid, l36, 'きせん',               'きせん',       'kisen',                    'tàu thủy (chạy bằng hơi nước)',         '名詞',     40, '汽船'),
  (sid, l36, 'おおぜいの [ひと]',    'おおぜいの',   'oozei no [hito]',          'nhiều (người), đông người',             '名詞',     41, '大勢の [人]'),
  (sid, l36, 'はこびます',           'はこびます',   'hakobimasu',               'vận chuyển, chuyển, khiêng',            '動詞',     42, '運びます'),
  (sid, l36, 'あんぜん [な]',        'あんぜん',     'anzen [na]',               'an toàn',                               'な形容詞', 43, '安全 [な]'),
  (sid, l36, 'とびます',             'とびます',     'tobimasu',                 'bay',                                   '動詞',     44, '飛びます'),
  (sid, l36, 'うちゅう',             'うちゅう',     'uchuu',                    'vũ trụ',                                '名詞',     45, '宇宙'),
  (sid, l36, 'ちきゅう',             'ちきゅう',     'chikyuu',                  'trái đất, địa cầu',                     '名詞',     46, '地球');

END $$;
