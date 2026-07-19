-- Seed: Minna no Nihongo — bản ghi bài học 6..50 (chỉ metadata, chưa có từ vựng)
-- Kiểu dữ liệu giống bài 1-5: title_vi = tiêu đề/ngữ pháp tiếng Nhật, situation_vi = mô tả tiếng Việt
-- Nguồn: card bài học trên app (tên bài + câu ví dụ)
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c
-- Idempotent: ON CONFLICT (site_id, lesson_number) DO NOTHING

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
BEGIN

INSERT INTO mnn_lessons (site_id, lesson_number, title_vi, situation_vi, order_index) VALUES
  (sid, 6,  '～を ～ます',                 'Ngoại động từ (tân ngữ + を), rủ mời làm gì',            6),
  (sid, 7,  'あげます・もらいます',        'Cách nói cho - nhận (đồ vật), phương tiện で',           7),
  (sid, 8,  'い/な けいようし',            'Tính từ (miêu tả tính chất, trạng thái)',               8),
  (sid, 9,  '～が すきです',               'Sở thích, năng lực (thích/giỏi/hiểu)',                  9),
  (sid, 10, 'います・あります',            'Cách nói sự tồn tại của người, sự vật',                 10),
  (sid, 11, 'かぞえかた（助数詞）',        'Lượng từ, cách đếm trong tiếng Nhật',                   11),
  (sid, 12, '～かったです／でした',         'Tính từ ở quá khứ, so sánh',                            12),
  (sid, 13, '～が ほしいです／～たいです',  'Mong muốn cái gì, muốn làm gì',                         13),
  (sid, 14, '～てform／～てください',       'Động từ thể て, nhờ vả, đang làm',                      14),
  (sid, 15, '～てもいいです',              'Mẫu câu được / không được làm gì',                      15),
  (sid, 16, '～て、～ます',                'Nối nhiều hành động (động từ thể て)',                  16),
  (sid, 17, '～ないform',                  'Thể ない, nghĩa vụ / cấm đoán',                         17),
  (sid, 18, 'じしょform／～ことができます', 'Động từ khả năng (thể từ điển)',                        18),
  (sid, 19, '～たform／～たり～たり',       'Thể た, liệt kê hành động, kinh nghiệm',                19),
  (sid, 20, 'ふつうけい（普通形）',        'Thể thông thường và thể lịch sự',                       20),
  (sid, 21, '～とおもいます／～といいます',  'Nêu quan điểm, suy nghĩ, trích dẫn',                    21),
  (sid, 22, 'めいししゅうしょく（連体修飾）','Định ngữ (mệnh đề bổ nghĩa danh từ)',                   22),
  (sid, 23, '～とき、～',                  'Khi ~, lúc ~ (thời điểm hành động)',                    23),
  (sid, 24, 'あげます・くれます・もらいます','Mẫu câu cho, tặng (cho - nhận hành động)',              24),
  (sid, 25, '～たら／～ても',              'Mẫu câu giả định, giả sử',                              25),
  (sid, 26, '～んです',                    'Cách hình thành và dùng thể ～んです',                  26),
  (sid, 27, 'かのうどうし（可能動詞）',     'Động từ thể khả năng',                                  27),
  (sid, 28, '～ながら',                    'Diễn tả 2 hành động song song, cùng lúc',               28),
  (sid, 29, '～ています（状態）',           'Diễn tả trạng thái đồ vật',                             29),
  (sid, 30, '～てあります',                'Diễn tả trạng thái / kết quả của hành động',            30),
  (sid, 31, 'いこうけい／～ようとおもいます','Động từ thể ý chí, dự định',                            31),
  (sid, 32, '～ほうがいいです／～でしょう',  'Lời khuyên và suy đoán',                                32),
  (sid, 33, 'めいれいけい／きんしけい',     'Thể mệnh lệnh, cấm đoán',                               33),
  (sid, 34, '～とおりに／～てから',          'Cách nói "theo như", tuần tự hành động',                34),
  (sid, 35, 'じょうけんけい（～ば/なら）',   'Thể điều kiện',                                         35),
  (sid, 36, '～ように',                    'Mục đích của hành động (～ように)',                     36),
  (sid, 37, 'うけみ（受身）',              'Thể bị động',                                           37),
  (sid, 38, 'どうしの めいしか（の/こと）',  'Danh từ hoá động từ',                                   38),
  (sid, 39, '～て、～で（原因）',           'Nguyên nhân và kết quả',                                39),
  (sid, 40, '～か どうか',                 'Câu hỏi lồng (trợ từ nghi vấn)',                        40),
  (sid, 41, 'くれます・いただきます・やります','Cách nói cho, nhận (kính ngữ)',                        41),
  (sid, 42, '～のに／～ために',             'Cấu trúc thể hiện mục đích',                            42),
  (sid, 43, '～そうです（様態）',           'Suy đoán qua quan sát (có vẻ như ～そうです)',           43),
  (sid, 44, '～すぎます／～やすい・にくい',  'Cách nói quá dễ / quá khó để làm',                      44),
  (sid, 45, '～のに',                      'Diễn tả sự tiếc nuối, trái ngược',                      45),
  (sid, 46, '～たところ／～たばかり',        'Thời điểm của hành động',                               46),
  (sid, 47, '～そうです（伝聞）／～ようです', 'Nghe nói / có vẻ (truyền đạt, suy đoán)',               47),
  (sid, 48, 'しえき（使役）',              'Thể sai khiến',                                         48),
  (sid, 49, 'そんけいご（尊敬語）',         'Tôn kính ngữ',                                          49),
  (sid, 50, 'けんじょうご（謙譲語）',       'Khiêm nhường ngữ',                                      50)
ON CONFLICT (site_id, lesson_number) DO NOTHING;

END $$;
