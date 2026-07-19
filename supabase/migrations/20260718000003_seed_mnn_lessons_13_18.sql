-- Seed: Minna no Nihongo — Bài 13-18 (từ vựng)
-- Nguồn: PDF Minato Dorimu, đối chiếu + sửa lỗi theo danh mục từ vựng MNN chuẩn
-- Quy tắc: word = kana (+ chú thích sách), reading = CHỈ kana + ～, kanji = kanji (NULL nếu không có)
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c

DO $$
DECLARE
  sid uuid := '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
  l13 uuid; l14 uuid; l15 uuid; l16 uuid; l17 uuid; l18 uuid;
BEGIN
SELECT id INTO l13 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 13;
SELECT id INTO l14 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 14;
SELECT id INTO l15 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 15;
SELECT id INTO l16 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 16;
SELECT id INTO l17 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 17;
SELECT id INTO l18 FROM mnn_lessons WHERE site_id = sid AND lesson_number = 18;

-- ════════════════════════════════════════
-- BÀI 13 — xóa và seed lại (40 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l13;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l13, 'あそびます', 'あそびます', 'asobimasu', 'chơi', '動詞', 1, '遊びます'),
  (sid, l13, 'およぎます', 'およぎます', 'oyogimasu', 'bơi', '動詞', 2, '泳ぎます'),
  (sid, l13, 'むかえます', 'むかえます', 'mukaemasu', 'đón', '動詞', 3, '迎えます'),
  (sid, l13, 'つかれます', 'つかれます', 'tsukaremasu', 'mệt', '動詞', 4, '疲れます'),
  (sid, l13, 'だします [てがみを～]', 'だします', 'dashimasu', 'gửi [thư]', '動詞', 5, '出します [手紙を～]'),
  (sid, l13, 'はいります [きっさてんに～]', 'はいります', 'hairimasu', 'vào [quán giải khát]', '動詞', 6, '入ります [喫茶店に～]'),
  (sid, l13, 'でます [きっさてんを～]', 'でます', 'demasu', 'ra, ra khỏi [quán giải khát]', '動詞', 7, '出ます [喫茶店を～]'),
  (sid, l13, 'けっこんします', 'けっこんします', 'kekkon shimasu', 'kết hôn, lập gia đình, cưới', '動詞', 8, '結婚します'),
  (sid, l13, 'かいものします', 'かいものします', 'kaimono shimasu', 'mua hàng', '動詞', 9, '買い物します'),
  (sid, l13, 'しょくじします', 'しょくじします', 'shokuji shimasu', 'ăn cơm', '動詞', 10, '食事します'),
  (sid, l13, 'さんぽします [こうえんを～]', 'さんぽします', 'sanpo shimasu', 'đi dạo [ở công viên]', '動詞', 11, '散歩します [公園を～]'),
  (sid, l13, 'たいへん [な]', 'たいへん', 'taihen', 'vất vả, khó khăn, khổ', 'な形容詞', 12, '大変 [な]'),
  (sid, l13, 'ほしい', 'ほしい', 'hoshii', 'muốn có', 'い形容詞', 13, '欲しい'),
  (sid, l13, 'さびしい', 'さびしい', 'sabishii', 'buồn, cô đơn', 'い形容詞', 14, '寂しい'),
  (sid, l13, 'ひろい', 'ひろい', 'hiroi', 'rộng', 'い形容詞', 15, '広い'),
  (sid, l13, 'せまい', 'せまい', 'semai', 'chật, hẹp', 'い形容詞', 16, '狭い'),
  (sid, l13, 'しやくしょ', 'しやくしょ', 'shiyakusho', 'văn phòng hành chính quận, thành phố', '名詞', 17, '市役所'),
  (sid, l13, 'プール', 'プール', 'puuru', 'bể bơi', '名詞', 18, NULL),
  (sid, l13, 'かわ', 'かわ', 'kawa', 'sông', '名詞', 19, '川'),
  (sid, l13, 'けいざい', 'けいざい', 'keizai', 'kinh tế', '名詞', 20, '経済'),
  (sid, l13, 'びじゅつ', 'びじゅつ', 'bijutsu', 'mỹ thuật', '名詞', 21, '美術'),
  (sid, l13, 'つり', 'つり', 'tsuri', 'việc câu cá (～をします: câu cá)', '名詞', 22, '釣り'),
  (sid, l13, 'スキー', 'スキー', 'sukii', 'việc trượt tuyết (～をします: trượt tuyết)', '名詞', 23, NULL),
  (sid, l13, 'かいぎ', 'かいぎ', 'kaigi', 'họp, cuộc họp (～をします)', '名詞', 24, '会議'),
  (sid, l13, 'とうろく', 'とうろく', 'touroku', 'việc đăng ký (～をします)', '名詞', 25, '登録'),
  (sid, l13, 'しゅうまつ', 'しゅうまつ', 'shuumatsu', 'cuối tuần', '名詞', 26, '週末'),
  (sid, l13, '～ごろ', '～ごろ', '~ goro', 'khoảng ~ (dùng cho thời gian)', '接尾辞', 27, NULL),
  (sid, l13, 'なにか', 'なにか', 'nanika', 'cái gì đó', '代名詞', 28, '何か'),
  (sid, l13, 'どこか', 'どこか', 'dokoka', 'đâu đó, chỗ nào đó', '代名詞', 29, NULL),
  (sid, l13, 'おなかが すきました', 'おなかがすきました', 'onaka ga sukimashita', '(tôi) đói rồi', '表現', 30, NULL),
  (sid, l13, 'おなかが いっぱいです', 'おなかがいっぱいです', 'onaka ga ippai desu', '(tôi) no rồi', '表現', 31, NULL),
  (sid, l13, 'のどが かわきました', 'のどがかわきました', 'nodo ga kawakimashita', '(tôi) khát', '表現', 32, NULL),
  (sid, l13, 'そうですね', 'そうですね', 'sou desu ne', 'Đúng thế. (câu nói khi muốn tỏ thái độ tán thành với người cùng nói chuyện)', '表現', 33, NULL),
  (sid, l13, 'ロシア', 'ロシア', 'Roshia', 'Nga', '固有名詞', 34, NULL),
  (sid, l13, 'そうしましょう', 'そうしましょう', 'sou shimashou', 'Nhất trí./ Chúng ta làm như thế đi', '表現', 35, NULL),
  (sid, l13, 'ていしょく', 'ていしょく', 'teishoku', 'cơm suất, cơm phần', '名詞', 36, '定食'),
  (sid, l13, 'ごちゅうもんは', 'ごちゅうもんは', 'gochuumon wa', 'Mời anh/chị gọi món', '表現', 37, 'ご注文は'),
  (sid, l13, 'ぎゅうどん', 'ぎゅうどん', 'gyuudon', 'món cơm thịt bò', '名詞', 38, '牛どん'),
  (sid, l13, 'しょうしょう おまちください', 'しょうしょうおまちください', 'shoushou omachi kudasai', 'xin vui lòng đợi một chút', '表現', 39, '少々お待ちください'),
  (sid, l13, 'べつべつに', 'べつべつに', 'betsubetsu ni', 'để riêng ra (tính tiền riêng)', '副詞', 40, '別々に');

-- ════════════════════════════════════════
-- BÀI 14 — xóa và seed lại (39 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l14;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l14, 'つけます', 'つけます', 'tsukemasu', 'bật (điện, máy điều hòa)', '動詞', 1, NULL),
  (sid, l14, 'けします', 'けします', 'keshimasu', 'tắt (điện, máy điều hòa)', '動詞', 2, '消します'),
  (sid, l14, 'あけます', 'あけます', 'akemasu', 'mở (cửa, cửa sổ)', '動詞', 3, '開けます'),
  (sid, l14, 'しめます', 'しめます', 'shimemasu', 'đóng (cửa, cửa sổ)', '動詞', 4, '閉めます'),
  (sid, l14, 'いそぎます', 'いそぎます', 'isogimasu', 'vội, gấp', '動詞', 5, '急ぎます'),
  (sid, l14, 'まちます', 'まちます', 'machimasu', 'đợi, chờ', '動詞', 6, '待ちます'),
  (sid, l14, 'とめます', 'とめます', 'tomemasu', 'dừng (băng, ô tô), đỗ (ô tô)', '動詞', 7, '止めます'),
  (sid, l14, 'まがります [みぎへ～]', 'まがります', 'magarimasu', 'rẽ, quẹo [phải]', '動詞', 8, '曲がります [右へ～]'),
  (sid, l14, 'もちます', 'もちます', 'mochimasu', 'mang, cầm', '動詞', 9, '持ちます'),
  (sid, l14, 'とります', 'とります', 'torimasu', 'lấy (muối)', '動詞', 10, '取ります'),
  (sid, l14, 'てつだいます', 'てつだいます', 'tetsudaimasu', 'giúp (làm việc)', '動詞', 11, '手伝います'),
  (sid, l14, 'よびます', 'よびます', 'yobimasu', 'gọi (taxi, tên)', '動詞', 12, '呼びます'),
  (sid, l14, 'はなします', 'はなします', 'hanashimasu', 'nói, nói chuyện', '動詞', 13, '話します'),
  (sid, l14, 'みせます', 'みせます', 'misemasu', 'cho xem, trình', '動詞', 14, '見せます'),
  (sid, l14, 'おしえます', 'おしえます', 'oshiemasu', 'nói, cho biết (địa chỉ)', '動詞', 15, '教えます'),
  (sid, l14, 'はじめます', 'はじめます', 'hajimemasu', 'bắt đầu', '動詞', 16, '始めます'),
  (sid, l14, 'ふります [あめが～]', 'ふります', 'furimasu', 'rơi [mưa, tuyết rơi]', '動詞', 17, '降ります [雨が～]'),
  (sid, l14, 'コピーします', 'コピーします', 'kopii shimasu', 'copy', '動詞', 18, NULL),
  (sid, l14, 'エアコン', 'エアコン', 'eakon', 'máy điều hòa', '名詞', 19, NULL),
  (sid, l14, 'パスポート', 'パスポート', 'pasupooto', 'hộ chiếu', '名詞', 20, NULL),
  (sid, l14, 'なまえ', 'なまえ', 'namae', 'tên', '名詞', 21, '名前'),
  (sid, l14, 'じゅうしょ', 'じゅうしょ', 'juusho', 'địa chỉ', '名詞', 22, '住所'),
  (sid, l14, 'ちず', 'ちず', 'chizu', 'bản đồ', '名詞', 23, '地図'),
  (sid, l14, 'しお', 'しお', 'shio', 'muối', '名詞', 24, '塩'),
  (sid, l14, 'さとう', 'さとう', 'satou', 'đường', '名詞', 25, '砂糖'),
  (sid, l14, 'よみかた', 'よみかた', 'yomikata', 'cách đọc', '名詞', 26, '読み方'),
  (sid, l14, '～かた', '～かた', '~ kata', 'cách ~', '接尾辞', 27, '～方'),
  (sid, l14, 'ゆっくり', 'ゆっくり', 'yukkuri', 'chậm, thong thả, thoải mái', '副詞', 28, NULL),
  (sid, l14, 'すぐ', 'すぐ', 'sugu', 'ngay, lập tức', '副詞', 29, NULL),
  (sid, l14, 'また', 'また', 'mata', 'lại (~ đến)', '副詞', 30, NULL),
  (sid, l14, 'あとで', 'あとで', 'ato de', 'sau', '副詞', 31, NULL),
  (sid, l14, 'もう すこし', 'もうすこし', 'mou sukoshi', 'thêm một chút nữa thôi', '副詞', 32, 'もう少し'),
  (sid, l14, 'もう～', 'もう～', 'mou ~', 'thêm ~', '副詞', 33, NULL),
  (sid, l14, 'いいですよ', 'いいですよ', 'ii desu yo', 'Được chứ./ Được ạ', '表現', 34, NULL),
  (sid, l14, 'さあ', 'さあ', 'saa', 'thôi, nào (thúc giục hoặc khuyến khích ai làm gì)', '感動詞', 35, NULL),
  (sid, l14, 'あれ？', 'あれ', 'are', 'Ô! (câu cảm thán khi phát hiện hoặc thấy cái gì đó lạ, hoặc bất ngờ)', '感動詞', 36, NULL),
  (sid, l14, 'まっすぐ', 'まっすぐ', 'massugu', 'thẳng', '副詞', 37, NULL),
  (sid, l14, 'これでおねがいします', 'これでおねがいします', 'kore de onegai shimasu', 'gửi anh tiền này (khi thanh toán)', '表現', 38, 'これでお願いします'),
  (sid, l14, 'おつり', 'おつり', 'otsuri', 'tiền thừa trả lại, tiền thối lại', '名詞', 39, 'お釣り'); -- PDF ghi "tiền lẻ" — sửa theo nghĩa chuẩn おつり

-- ════════════════════════════════════════
-- BÀI 15 — xóa và seed lại (29 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l15;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l15, 'たちます', 'たちます', 'tachimasu', 'đứng', '動詞', 1, '立ちます'),
  (sid, l15, 'すわります', 'すわります', 'suwarimasu', 'ngồi', '動詞', 2, '座ります'),
  (sid, l15, 'つかいます', 'つかいます', 'tsukaimasu', 'dùng, sử dụng', '動詞', 3, '使います'),
  (sid, l15, 'おきます', 'おきます', 'okimasu', 'đặt, để', '動詞', 4, '置きます'),
  (sid, l15, 'つくります', 'つくります', 'tsukurimasu', 'làm, chế tạo, sản xuất', '動詞', 5, '作ります、造ります'),
  (sid, l15, 'うります', 'うります', 'urimasu', 'bán', '動詞', 6, '売ります'),
  (sid, l15, 'しります', 'しります', 'shirimasu', 'biết', '動詞', 7, '知ります'),
  (sid, l15, 'すみます', 'すみます', 'sumimasu', 'sống, ở', '動詞', 8, '住みます'),
  (sid, l15, 'けんきゅうします', 'けんきゅうします', 'kenkyuu shimasu', 'nghiên cứu', '動詞', 9, '研究します'),
  (sid, l15, 'しって います', 'しっています', 'shitte imasu', 'biết', '動詞', 10, '知って います'),
  (sid, l15, 'すんで います [おおさかに～]', 'すんでいます', 'sunde imasu', 'sống [ở Osaka]', '動詞', 11, '住んで います [大阪に～]'),
  (sid, l15, 'しりょう', 'しりょう', 'shiryou', 'tài liệu, tư liệu', '名詞', 12, '資料'),
  (sid, l15, 'カタログ', 'カタログ', 'katarogu', 'ca-ta-lô', '名詞', 13, NULL),
  (sid, l15, 'じこくひょう', 'じこくひょう', 'jikokuhyou', 'bảng giờ tàu chạy', '名詞', 14, '時刻表'),
  (sid, l15, 'ふく', 'ふく', 'fuku', 'quần áo', '名詞', 15, '服'),
  (sid, l15, 'せいひん', 'せいひん', 'seihin', 'sản phẩm', '名詞', 16, '製品'),
  (sid, l15, 'ソフト', 'ソフト', 'sofuto', 'phần mềm', '名詞', 17, NULL),
  (sid, l15, 'せんもん', 'せんもん', 'senmon', 'chuyên môn', '名詞', 18, '専門'),
  (sid, l15, 'はいしゃ', 'はいしゃ', 'haisha', 'nha sĩ', '名詞', 19, '歯医者'),
  (sid, l15, 'とこや', 'とこや', 'tokoya', 'hiệu cắt tóc', '名詞', 20, '床屋'),
  (sid, l15, 'プレイガイド', 'プレイガイド', 'purei gaido', 'quầy bán vé trước (vé xem kịch, hòa nhạc...)', '名詞', 21, NULL),
  (sid, l15, 'どくしん', 'どくしん', 'dokushin', 'độc thân', '名詞', 22, '独身'),
  (sid, l15, 'とくに', 'とくに', 'toku ni', 'đặc biệt', '副詞', 23, '特に'),
  (sid, l15, 'おもいだします', 'おもいだします', 'omoidashimasu', 'nhớ lại, hồi tưởng', '動詞', 24, '思い出します'),
  (sid, l15, 'ごかぞく', 'ごかぞく', 'gokazoku', 'gia đình (dùng cho người khác)', '名詞', 25, 'ご家族'),
  (sid, l15, 'いらっしゃいます', 'いらっしゃいます', 'irasshaimasu', 'có, ở (thể kính trọng của います)', '動詞', 26, NULL),
  (sid, l15, 'こうこう', 'こうこう', 'koukou', 'trường trung học phổ thông', '名詞', 27, '高校'),
  (sid, l15, 'のります [でんしゃに～]', 'のります', 'norimasu', 'đi, lên [tàu]', '動詞', 28, '乗ります [電車に～]'),
  (sid, l15, 'おります [でんしゃを～]', 'おります', 'orimasu', 'xuống [tàu]', '動詞', 29, '降ります [電車を～]'); -- PDF ghi [でんしゃに～] — sửa trợ từ đúng là を

-- ════════════════════════════════════════
-- BÀI 16 — xóa và seed lại (43 từ; PDF lặp nguyên khối STT 756-762 = 743-749 nên bỏ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l16;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l16, 'のりかえます', 'のりかえます', 'norikaemasu', 'chuyển, đổi (tàu)', '動詞', 1, '乗り換えます'),
  (sid, l16, 'あびます [シャワーを～]', 'あびます', 'abimasu', 'tắm [vòi hoa sen]', '動詞', 2, '浴びます [シャワーを～]'),
  (sid, l16, 'いれます', 'いれます', 'iremasu', 'cho vào, bỏ vào', '動詞', 3, '入れます'),
  (sid, l16, 'だします', 'だします', 'dashimasu', 'lấy ra, rút (tiền)', '動詞', 4, '出します'),
  (sid, l16, 'はいります [だいがくに～]', 'はいります', 'hairimasu', 'vào, nhập học [đại học]', '動詞', 5, '入ります [大学に～]'),
  (sid, l16, 'でます [だいがくを～]', 'でます', 'demasu', 'ra, tốt nghiệp [đại học]', '動詞', 6, '出ます [大学を～]'),
  (sid, l16, 'やめます [かいしゃを～]', 'やめます', 'yamemasu', 'bỏ, thôi [việc công ty]', '動詞', 7, '辞めます [会社を～]'),
  (sid, l16, 'おします', 'おします', 'oshimasu', 'bấm, ấn (nút)', '動詞', 8, '押します'),
  (sid, l16, 'わかい', 'わかい', 'wakai', 'trẻ', 'い形容詞', 9, '若い'),
  (sid, l16, 'ながい', 'ながい', 'nagai', 'dài', 'い形容詞', 10, '長い'),
  (sid, l16, 'みじかい', 'みじかい', 'mijikai', 'ngắn', 'い形容詞', 11, '短い'),
  (sid, l16, 'あかるい', 'あかるい', 'akarui', 'sáng', 'い形容詞', 12, '明るい'),
  (sid, l16, 'くらい', 'くらい', 'kurai', 'tối', 'い形容詞', 13, '暗い'),
  (sid, l16, 'せが たかい', 'せがたかい', 'se ga takai', 'cao (dùng cho người)', 'い形容詞', 14, '背が 高い'),
  (sid, l16, 'あたまが いい', 'あたまがいい', 'atama ga ii', 'thông minh', 'い形容詞', 15, '頭が いい'),
  (sid, l16, 'からだ', 'からだ', 'karada', 'người, cơ thể', '名詞', 16, '体'),
  (sid, l16, 'あたま', 'あたま', 'atama', 'đầu', '名詞', 17, '頭'),
  (sid, l16, 'かみ', 'かみ', 'kami', 'tóc', '名詞', 18, '髪'),
  (sid, l16, 'なまえ', 'なまえ', 'namae', 'tên', '名詞', 19, '名前'),
  (sid, l16, 'かお', 'かお', 'kao', 'mặt', '名詞', 20, '顔'),
  (sid, l16, 'め', 'め', 'me', 'mắt', '名詞', 21, '目'),
  (sid, l16, 'みみ', 'みみ', 'mimi', 'tai', '名詞', 22, '耳'),
  (sid, l16, 'は', 'は', 'ha', 'răng', '名詞', 23, '歯'),
  (sid, l16, 'おなか', 'おなか', 'onaka', 'bụng', '名詞', 24, NULL),
  (sid, l16, 'あし', 'あし', 'ashi', 'chân', '名詞', 25, '足'),
  (sid, l16, 'サービス', 'サービス', 'saabisu', 'dịch vụ', '名詞', 26, NULL),
  (sid, l16, 'ジョギング', 'ジョギング', 'jogingu', 'việc chạy bộ (～をします: chạy bộ)', '名詞', 27, NULL),
  (sid, l16, 'シャワー', 'シャワー', 'shawaa', 'vòi hoa sen', '名詞', 28, NULL),
  (sid, l16, 'みどり', 'みどり', 'midori', 'màu xanh lá cây', '名詞', 29, '緑'),
  (sid, l16, '[お]てら', 'おてら', 'otera', 'chùa', '名詞', 30, '[お]寺'),
  (sid, l16, 'じんじゃ', 'じんじゃ', 'jinja', 'đền thờ đạo thần', '名詞', 31, '神社'),
  (sid, l16, 'りゅうがくせい', 'りゅうがくせい', 'ryuugakusei', 'lưu học sinh, du học sinh', '名詞', 32, '留学生'),
  (sid, l16, '～ばん', '～ばん', '~ ban', 'số ~', '接尾辞', 33, '～番'),
  (sid, l16, 'どうやって', 'どうやって', 'dou yatte', 'làm thế nào, bằng cách nào', '疑問詞', 34, NULL),
  (sid, l16, 'どの～', 'どの～', 'dono ~', 'cái nào ~ (dùng với trường hợp từ ba thứ trở lên)', '疑問詞', 35, NULL),
  (sid, l16, '[いいえ、]まだまだです', 'いいえまだまだです', 'iie madamada desu', '[không,] tôi còn kém lắm. (cách nói khiêm nhường khi ai đó khen)', '表現', 36, NULL),
  (sid, l16, 'まず', 'まず', 'mazu', 'trước hết, đầu tiên', '副詞', 37, NULL),
  (sid, l16, 'キャッシュカード', 'キャッシュカード', 'kyasshu kaado', 'thẻ ngân hàng, thẻ ATM', '名詞', 38, NULL),
  (sid, l16, 'あんしょうばんごう', 'あんしょうばんごう', 'anshou bangou', 'mã số bí mật (mật khẩu)', '名詞', 39, '暗証番号'),
  (sid, l16, 'つぎに', 'つぎに', 'tsugi ni', 'tiếp theo', '副詞', 40, '次に'),
  (sid, l16, 'かくにん', 'かくにん', 'kakunin', 'sự xác nhận, sự kiểm tra (～します: xác nhận)', '名詞', 41, '確認'),
  (sid, l16, 'きんがく', 'きんがく', 'kingaku', 'số tiền, khoản tiền', '名詞', 42, '金額'),
  (sid, l16, 'ボタン', 'ボタン', 'botan', 'nút', '名詞', 43, NULL);

-- ════════════════════════════════════════
-- BÀI 17 — xóa và seed lại (38 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l17;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l17, 'おぼえます', 'おぼえます', 'oboemasu', 'nhớ', '動詞', 1, '覚えます'),
  (sid, l17, 'わすれます', 'わすれます', 'wasuremasu', 'quên', '動詞', 2, '忘れます'),
  (sid, l17, 'なくします', 'なくします', 'nakushimasu', 'mất, đánh mất', '動詞', 3, NULL),
  (sid, l17, 'だします [レポートを～]', 'だします', 'dashimasu', 'nộp [báo cáo]', '動詞', 4, '出します [レポートを～]'),
  (sid, l17, 'はらいます', 'はらいます', 'haraimasu', 'trả tiền', '動詞', 5, '払います'),
  (sid, l17, 'かえします', 'かえします', 'kaeshimasu', 'trả lại', '動詞', 6, '返します'),
  (sid, l17, 'でかけます', 'でかけます', 'dekakemasu', 'ra ngoài', '動詞', 7, '出かけます'),
  (sid, l17, 'ぬぎます', 'ぬぎます', 'nugimasu', 'cởi (quần áo, giày)', '動詞', 8, '脱ぎます'),
  (sid, l17, 'もっていきます', 'もっていきます', 'motte ikimasu', 'mang đi', '動詞', 9, '持って行きます'),
  (sid, l17, 'もってきます', 'もってきます', 'motte kimasu', 'mang đến', '動詞', 10, '持って来ます'),
  (sid, l17, 'しんぱいします', 'しんぱいします', 'shinpai shimasu', 'lo lắng', '動詞', 11, '心配します'),
  (sid, l17, 'ざんぎょうします', 'ざんぎょうします', 'zangyou shimasu', 'làm thêm giờ', '動詞', 12, '残業します'),
  (sid, l17, 'しゅっちょうします', 'しゅっちょうします', 'shutchou shimasu', 'đi công tác', '動詞', 13, '出張します'),
  (sid, l17, 'のみます [くすりを～]', 'のみます', 'nomimasu', 'uống [thuốc]', '動詞', 14, '飲みます [薬を～]'),
  (sid, l17, 'はいります [おふろに～]', 'はいります', 'hairimasu', 'tắm bồn', '動詞', 15, '入ります [おふろに～]'),
  (sid, l17, 'たいせつ [な]', 'たいせつ', 'taisetsu', 'quan trọng', 'な形容詞', 16, '大切 [な]'),
  (sid, l17, 'だいじょうぶ [な]', 'だいじょうぶ', 'daijoubu', 'không sao, không có vấn đề gì', 'な形容詞', 17, '大丈夫 [な]'),
  (sid, l17, 'あぶない', 'あぶない', 'abunai', 'nguy hiểm', 'い形容詞', 18, '危ない'),
  (sid, l17, 'もんだい', 'もんだい', 'mondai', 'vấn đề', '名詞', 19, '問題'),
  (sid, l17, 'こたえ', 'こたえ', 'kotae', 'câu trả lời', '名詞', 20, '答え'),
  (sid, l17, 'きんえん', 'きんえん', 'kin''en', 'cấm hút thuốc', '名詞', 21, '禁煙'),
  (sid, l17, '[けんこう]ほけんしょう', 'けんこうほけんしょう', 'kenkou hokenshou', 'thẻ bảo hiểm (y tế)', '名詞', 22, '[健康]保険証'),
  (sid, l17, 'かぜ', 'かぜ', 'kaze', 'cảm, cúm', '名詞', 23, '風邪'), -- PDF ghi kanji 風 — sửa: 風邪
  (sid, l17, 'ねつ', 'ねつ', 'netsu', 'sốt', '名詞', 24, '熱'),
  (sid, l17, 'びょうき', 'びょうき', 'byouki', 'ốm, bệnh', '名詞', 25, '病気'),
  (sid, l17, 'くすり', 'くすり', 'kusuri', 'thuốc', '名詞', 26, '薬'),
  (sid, l17, '[お]ふろ', 'おふろ', 'ofuro', 'bồn tắm', '名詞', 27, '[お]風呂'),
  (sid, l17, 'うわぎ', 'うわぎ', 'uwagi', 'áo khoác', '名詞', 28, '上着'),
  (sid, l17, 'したぎ', 'したぎ', 'shitagi', 'quần áo lót', '名詞', 29, '下着'),
  (sid, l17, 'せんせい', 'せんせい', 'sensei', 'bác sĩ (cách gọi bác sĩ)', '名詞', 30, '先生'),
  (sid, l17, '２、３にち', 'にさんにち', 'ni san nichi', 'vài ngày (2, 3 ngày)', '名詞', 31, '２、３日'),
  (sid, l17, '２、３～', 'にさん～', 'ni san ~', 'vài ~', '名詞', 32, NULL),
  (sid, l17, '～までに', '～までに', '~ made ni', 'trước ~ (chỉ thời gian)', '助詞', 33, NULL),
  (sid, l17, 'ですから', 'ですから', 'desukara', 'vì thế, vì vậy, do đó', '接続詞', 34, NULL),
  (sid, l17, 'どうしましたか', 'どうしましたか', 'dou shimashita ka', 'Có vấn đề gì?/ Anh/chị bị làm sao?', '表現', 35, NULL),
  (sid, l17, '[～が] いたいです', 'いたいです', 'itai desu', 'Tôi bị đau ~', '表現', 36, '[～が] 痛いです'),
  (sid, l17, 'のど', 'のど', 'nodo', 'họng', '名詞', 37, NULL),
  (sid, l17, 'おだいじに', 'おだいじに', 'odaiji ni', 'Anh/chị nhớ giữ gìn sức khỏe. (nói với người bị ốm)', '挨拶', 38, 'お大事に');

-- ════════════════════════════════════════
-- BÀI 18 — xóa và seed lại (27 từ)
-- ════════════════════════════════════════
DELETE FROM mnn_vocabulary WHERE lesson_id = l18;
INSERT INTO mnn_vocabulary (site_id, lesson_id, word, reading, romanization, meaning_vi, part_of_speech, order_index, kanji) VALUES
  (sid, l18, 'できます', 'できます', 'dekimasu', 'có thể', '動詞', 1, NULL),
  (sid, l18, 'あらいます', 'あらいます', 'araimasu', 'rửa', '動詞', 2, '洗います'),
  (sid, l18, 'ひきます', 'ひきます', 'hikimasu', 'chơi (chơi 1 loại nhạc cụ)', '動詞', 3, '弾きます'),
  (sid, l18, 'うたいます', 'うたいます', 'utaimasu', 'hát', '動詞', 4, '歌います'),
  (sid, l18, 'あつめます', 'あつめます', 'atsumemasu', 'sưu tập', '動詞', 5, '集めます'),
  (sid, l18, 'すてます', 'すてます', 'sutemasu', 'vứt, bỏ đi', '動詞', 6, '捨てます'),
  (sid, l18, 'かえます', 'かえます', 'kaemasu', 'đổi', '動詞', 7, '換えます'),
  (sid, l18, 'うんてんします', 'うんてんします', 'unten shimasu', 'lái xe', '動詞', 8, '運転します'),
  (sid, l18, 'よやくします', 'よやくします', 'yoyaku shimasu', 'đặt chỗ trước', '動詞', 9, '予約します'),
  (sid, l18, 'けんがくします', 'けんがくします', 'kengaku shimasu', 'tham quan (với mục đích học tập)', '動詞', 10, '見学します'), -- PDF ghi けんかくします — sửa: けんがくします
  (sid, l18, 'ピアノ', 'ピアノ', 'piano', 'đàn piano', '名詞', 11, NULL),
  (sid, l18, '～メートル', '～メートル', '~ meetoru', '~ mét', '接尾辞', 12, NULL),
  (sid, l18, 'こくさい～', 'こくさい～', 'kokusai ~', 'quốc tế ~', '名詞', 13, '国際～'),
  (sid, l18, 'げんきん', 'げんきん', 'genkin', 'tiền mặt', '名詞', 14, '現金'),
  (sid, l18, 'しゅみ', 'しゅみ', 'shumi', 'sở thích', '名詞', 15, '趣味'),
  (sid, l18, 'にっき', 'にっき', 'nikki', 'nhật kí', '名詞', 16, '日記'),
  (sid, l18, '[お]いのり', 'おいのり', 'oinori', 'cầu nguyện (～をします: cầu nguyện)', '名詞', 17, '[お]祈り'),
  (sid, l18, 'かちょう', 'かちょう', 'kachou', 'tổ trưởng', '名詞', 18, '課長'),
  (sid, l18, 'ぶちょう', 'ぶちょう', 'buchou', 'trưởng phòng', '名詞', 19, '部長'),
  (sid, l18, 'しゃちょう', 'しゃちょう', 'shachou', 'giám đốc', '名詞', 20, '社長'),
  (sid, l18, 'どうぶつ', 'どうぶつ', 'doubutsu', 'động vật', '名詞', 21, '動物'),
  (sid, l18, 'うま', 'うま', 'uma', 'ngựa', '名詞', 22, '馬'),
  (sid, l18, 'へえ', 'へえ', 'hee', 'thế à (tỏ sự ngạc nhiên)', '感動詞', 23, NULL),
  (sid, l18, 'それは おもしろいですね', 'それはおもしろいですね', 'sore wa omoshiroi desu ne', 'Hay nhỉ.', '表現', 24, NULL),
  (sid, l18, 'ぼくじょう', 'ぼくじょう', 'bokujou', 'trang trại', '名詞', 25, '牧場'),
  (sid, l18, 'ほんとうですか', 'ほんとうですか', 'hontou desu ka', 'Thật không?', '表現', 26, '本当ですか'),
  (sid, l18, 'ぜひ', 'ぜひ', 'zehi', 'nhất định, rất', '副詞', 27, NULL);
END $$;
