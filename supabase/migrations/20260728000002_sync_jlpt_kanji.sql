-- Kanji theo lộ trình JLPT N5 → N4.
--
-- Không gắn với Minna no Nihongo: đây là dữ liệu theo cấp độ thi, dùng
-- độc lập với mnn_vocabulary. Từ vựng MNN chỉ đóng vai ví dụ minh hoạ
-- khi app ghép hai bên lại.
--
-- ═══ HAI CỘT CẤP ĐỘ, ĐỪNG LẪN ═══
--
-- jlpt_level      thang HỌC — app lọc bài theo cột này. N5 104, N4 260.
--                 N5 lấy từ danh sách ôn thi tiếng Việt (103 chữ, rộng
--                 hơn), còn lại xếp N4. Học sớm một chữ hoá ra thuộc N4
--                 thì không mất gì; bỏ sót một chữ thật sự ra ở N5 thì
--                 mất điểm. Nên chọn cách rộng.
--
-- jlpt_level_ref  cấp thi KIỂM CHỨNG ĐƯỢC: N1 3, N2 38, N3 75, N4 166, N5 80, ngoài JLPT 2.
--                 Lấy từ jlpt_new (thang 5 mức sau kỳ đổi đề 2010).
--                 Cột này nói thật: có chữ trong bộ nằm ngoài phạm vi
--                 thi N4, xuất hiện ở đây vì giáo trình N5/N4 dạy chúng
--                 sớm (部屋 là từ N5 nhưng 部 và 屋 là chữ cấp N3).
--                 Giữ lại để sau lên N3/N2 còn dùng.
--
-- VÌ SAO KHÔNG DÙNG <jlpt> CỦA KANJIDIC2: thẻ đó dùng thang CŨ 4 mức,
-- ra trước khi kỳ 2010 chèn thêm N3 vào giữa. Đối chiếu thấy nó rải:
--     cũ 4  →  N5 79, N4 22, N3 1
--     cũ 3  →  N4 143, N3 25, N2 12, N1 1
-- Quy đổi cũ-4→N5 và cũ-3→N4 gán sai cấp cho 39 chữ. Đã bỏ cách đó.
--
-- in_course       287 chữ có trong giáo trình N5/N4 tiếng Việt.
--
-- ═══ PHẦN TIẾNG VIỆT ═══
--
-- han_viet đã LỌC BỎ ÂM NÔM. Trường `vietnam` của KANJIDIC2 trộn lẫn âm
-- Hán-Việt với âm Nôm mà không gắn nhãn: chữ 強 nó trả 11 âm, chỉ cường
-- và cưỡng là Hán-Việt, 9 âm còn lại (càng, gắng, gượng, ngượng...) là
-- âm Nôm. Bước lọc đã bỏ 131 âm Nôm khỏi bộ này.
-- Nguồn âm: minato 287, thieu-chuu 76, kanjidic2-unverified 1.
--
-- meaning_vi CHỈ nhận nguồn theo cách dùng TIẾNG NHẬT (giáo trình N5/N4
-- tiếng Việt và từ vựng Minna no Nihongo). Hết nguồn thì ĐỂ NULL, điền
-- dần qua trang quản trị. Nghĩa trống thì người học biết là chưa có;
-- nghĩa sai thì họ tin rồi nhớ sai cả năm.
--
-- meaning_classic là nghĩa HÁN CỔ (Thiều Chửu), cột RIÊNG, dùng như TỪ
-- NGUYÊN chứ không phải nghĩa. Cụ ghi 学 'Bắt chước', 時 'Mùa', 住
-- 'Thôi' — sai với tiếng Nhật, nhưng đúng với chữ Hán cổ và soi sáng
-- được mặt chữ cho người đã biết Hán-Việt. Đừng hiển thị nó ở ô nghĩa.
-- Nguồn nghĩa: None 234, minna-no-nihongo 58, minato 72.
--
-- kyujitai: tự dạng CỰU (旧字体) khi tra từ điển Hán phải đi qua nó —
-- 学→學, 気→氣, 楽→樂. NULL nghĩa là tra thẳng được.
-- site_id: 1219bda2-aa1e-4288-ab7e-caff011cdf5c

CREATE TABLE IF NOT EXISTS jlpt_kanji (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  site_id           uuid NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  character         text NOT NULL,
  jlpt_level        text NOT NULL,
  jlpt_level_ref    text,
  in_course         boolean NOT NULL DEFAULT false,
  kyujitai          text,
  on_readings       text[],
  kun_readings      text[],
  han_viet          text[],
  han_viet_source   text,
  meaning_en        text[],
  meaning_vi        text,
  meaning_vi_source text,
  meaning_classic   text,
  stroke_count      smallint,
  school_grade      smallint,
  radical_number    smallint,
  frequency         integer,
  parts             text[],
  order_index       integer DEFAULT 0,
  created_at        timestamptz DEFAULT now(),
  UNIQUE(site_id, character)
);

-- Kéo jlpt_kanji về đúng schema hiện tại. Bảng mới thì đây là no-op.
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS character text;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS jlpt_level text;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS jlpt_level_ref text;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS in_course boolean;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS kyujitai text;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS on_readings text[];
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS kun_readings text[];
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS han_viet text[];
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS han_viet_source text;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS meaning_en text[];
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS meaning_vi text;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS meaning_vi_source text;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS meaning_classic text;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS stroke_count smallint;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS school_grade smallint;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS radical_number smallint;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS frequency integer;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS parts text[];
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS order_index integer DEFAULT 0;
ALTER TABLE jlpt_kanji ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now();

-- Mảnh cấu tạo. Thứ tự học lấy theo unlocks_count: mảnh nào có mặt trong
-- nhiều chữ nhất thì học trước, mỗi bước mở khoá được nhiều nhất.
-- Đếm trên chính tập chữ của bảng này, không theo bảng chung.
--
-- han_viet ở bảng này là TÊN BỘ THỦ theo cách người Việt gọi — 宀 là
-- 'bộ Miên', 氵 là 'bộ Thuỷ'. Lấy từ bảng 214 bộ thủ Kangxi. Trước đây
-- bước sinh dữ liệu tra tên trong CHÍNH tập 364 chữ nên 94/181 mảnh mất
-- tên oan: bộ thủ phần lớn không nằm trong phạm vi N5/N4.
--
-- CÓ BỘ THỦ CHỈ CÓ TÊN, KHÔNG CÓ NGHĨA — 亠 tên là 'Đầu' và hết, nguồn
-- gốc ghi thẳng '(không có nghĩa)'. meaning_vi NULL ở dòng đó là ĐÚNG.
--
-- is_shape = true: KRADFILE mượn katakana làm chỗ đứng cho hình nét (ハ,
-- マ). Không phải chữ, không có âm, không có nghĩa. Giao diện nên gọi
-- chúng là 'hình nét' chứ đừng để ô trống trông như khuyết dữ liệu.
--
-- radical_of: dạng GỐC khi mảnh này là biến thể — 氵 co lại từ 水, 忄 từ
-- 心. NULL nghĩa là mảnh này chính là dạng gốc.
--
-- in_set = true: mảnh này bản thân cũng là một chữ trong bảng jlpt_kanji,
-- nên học nó là được cả hai.
CREATE TABLE IF NOT EXISTS jlpt_kanji_parts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  site_id         uuid NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  part            text NOT NULL,
  unlocks_count   integer NOT NULL DEFAULT 0,
  in_set          boolean NOT NULL DEFAULT false,
  is_shape        boolean NOT NULL DEFAULT false,
  radical_of      text,
  radical_strokes smallint,
  han_viet        text,
  meaning_vi      text,
  meaning_en      text,
  meaning_classic text,
  source          text,
  order_index     integer DEFAULT 0,
  created_at      timestamptz DEFAULT now(),
  UNIQUE(site_id, part)
);

-- Kéo jlpt_kanji_parts về đúng schema hiện tại. Bảng mới thì đây là no-op.
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS part text;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS unlocks_count integer;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS in_set boolean;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS is_shape boolean;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS radical_of text;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS radical_strokes smallint;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS han_viet text;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS meaning_vi text;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS meaning_en text;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS meaning_classic text;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS source text;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS order_index integer DEFAULT 0;
ALTER TABLE jlpt_kanji_parts ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now();
ALTER TABLE jlpt_kanji_parts DROP COLUMN IF EXISTS is_kanji;

CREATE INDEX IF NOT EXISTS jlpt_kanji_level_idx
  ON jlpt_kanji (site_id, jlpt_level, order_index);
CREATE INDEX IF NOT EXISTS jlpt_kanji_course_idx
  ON jlpt_kanji (site_id, in_course, order_index);
CREATE INDEX IF NOT EXISTS jlpt_kanji_parts_order_idx
  ON jlpt_kanji_parts (site_id, order_index);

-- Dòng nào nghĩa còn lấy từ từ điển Hán cổ thì cần người duyệt lại.
-- Trang quản trị dùng view này làm hàng đợi việc.
DROP VIEW IF EXISTS jlpt_kanji_need_review;
CREATE VIEW jlpt_kanji_need_review AS
SELECT site_id, character, jlpt_level, han_viet, meaning_en, meaning_classic
  FROM jlpt_kanji
 WHERE meaning_vi IS NULL
 ORDER BY jlpt_level, order_index;

-- RLS: chỉ cho đọc công khai, giống các bảng mnn_*
ALTER TABLE jlpt_kanji       ENABLE ROW LEVEL SECURITY;
ALTER TABLE jlpt_kanji_parts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public read jlpt_kanji" ON jlpt_kanji;
DROP POLICY IF EXISTS "public read jlpt_kanji_parts" ON jlpt_kanji_parts;
CREATE POLICY "public read jlpt_kanji"       ON jlpt_kanji       FOR SELECT USING (true);
CREATE POLICY "public read jlpt_kanji_parts" ON jlpt_kanji_parts FOR SELECT USING (true);

-- Chạy lại được nhiều lần: xoá sạch rồi seed lại.
DELETE FROM jlpt_kanji       WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c';
DELETE FROM jlpt_kanji_parts WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c';

INSERT INTO jlpt_kanji (site_id, character, jlpt_level, jlpt_level_ref, in_course, kyujitai, on_readings, kun_readings, han_viet, han_viet_source, meaning_en, meaning_vi, meaning_vi_source, meaning_classic, stroke_count, school_grade, radical_number, frequency, parts, order_index) VALUES
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '一', 'N5', 'N5', true, NULL, '{"イチ","イツ"}', '{"ひと-","ひと.つ"}', '{"nhất"}', 'minato', '{"one","one radical (no.1)"}', NULL, NULL, 'Một, là số đứng đầu các số đếm', 1, 1, 1, 2, '{"一"}', 0),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '人', 'N5', 'N5', true, NULL, '{"ジン","ニン"}', '{"ひと","-り","-と"}', '{"nhân"}', 'minato', '{"person"}', 'người', 'minna-no-nihongo', 'Người', 2, 1, 9, 5, '{"人"}', 1),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '十', 'N5', 'N5', false, NULL, '{"ジュウ","ジッ","ジュッ"}', '{"とお","と","そ"}', '{"thập"}', 'thieu-chuu', '{"ten"}', NULL, NULL, 'Mười', 2, 1, 24, 8, '{"十"}', 2),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '二', 'N5', 'N5', false, NULL, '{"ニ","ジ"}', '{"ふた","ふた.つ","ふたたび"}', '{"nhị"}', 'thieu-chuu', '{"two","two radical (no. 7)"}', NULL, NULL, 'Hai, tên số đếm', 2, 1, 7, 9, '{"二"}', 3),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '九', 'N5', 'N5', false, NULL, '{"キュウ","ク"}', '{"ここの","ここの.つ"}', '{"cửu","cưu"}', 'thieu-chuu', '{"nine"}', NULL, NULL, 'Chín, tên số đếm', 2, 1, 5, 55, '{"九"}', 4),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '入', 'N5', 'N5', true, NULL, '{"ニュウ","ジュ"}', '{"い.る","-い.る","-い.り","い.れる","-い.れ","はい.る"}', '{"nhập"}', 'minato', '{"enter","insert"}', NULL, NULL, 'Vào, đối lại với chữ xuất ra', 2, 1, 11, 56, '{"入"}', 5),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '力', 'N5', 'N4', true, NULL, '{"リョク","リキ","リイ"}', '{"ちから"}', '{"lực"}', 'minato', '{"power","strength","strong","strain"}', 'sức mạnh, sức lực', 'minna-no-nihongo', 'Sức', 2, 1, 19, 62, '{"力"}', 6),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '八', 'N5', 'N5', false, NULL, '{"ハチ","ハツ"}', '{"や","や.つ","やっ.つ","よう"}', '{"bát"}', 'thieu-chuu', '{"eight","eight radical (no. 12)"}', NULL, NULL, 'Tám, số đếm', 2, 1, 12, 92, '{"ハ"}', 7),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '七', 'N5', 'N5', false, NULL, '{"シチ"}', '{"なな","なな.つ","なの"}', '{"thất"}', 'thieu-chuu', '{"seven"}', NULL, NULL, 'Bảy, tên số đếm', 2, 1, 1, 115, '{"乙","匕","ノ"}', 8),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '大', 'N5', 'N5', true, NULL, '{"ダイ","タイ"}', '{"おお-","おお.きい","-おお.いに"}', '{"đại"}', 'minato', '{"large","big"}', NULL, NULL, 'Lớn', 3, 1, 37, 7, '{"大"}', 9),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '三', 'N5', 'N5', false, NULL, '{"サン","ゾウ"}', '{"み","み.つ","みっ.つ"}', '{"tam","tám"}', 'thieu-chuu', '{"three"}', NULL, NULL, 'Ba, tên số đếm', 3, 1, 1, 14, '{"一","二"}', 10),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '上', 'N5', 'N5', false, NULL, '{"ジョウ","ショウ","シャン"}', '{"うえ","-うえ","うわ-","かみ","あ.げる","-あ.げる","あ.がる","-あ.がる","あ.がり","-あ.がり","のぼ.る","のぼ.り","のぼ.せる","のぼ.す","たてまつ.る"}', '{"thượng","thướng"}', 'thieu-chuu', '{"above","up"}', 'trên, phía trên', 'minna-no-nihongo', 'Trên', 3, 1, 1, 35, '{"一","卜"}', 11),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '子', 'N5', 'N5', true, NULL, '{"シ","ス","ツ"}', '{"こ","-こ","ね"}', '{"tử"}', 'minato', '{"child","sign of the rat","11PM-1AM","first sign of Chinese zodiac"}', NULL, NULL, 'Con', 3, 1, 39, 72, '{"子"}', 12),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '下', 'N5', 'N5', true, NULL, '{"カ","ゲ"}', '{"した","しも","もと","さ.げる","さ.がる","くだ.る","くだ.り","くだ.す","-くだ.す","くだ.さる","お.ろす","お.りる"}', '{"hạ"}', 'minato', '{"below","down","descend","give"}', 'dưới, phía dưới', 'minna-no-nihongo', 'Dưới, đối lại với chữ thượng', 3, 1, 1, 97, '{"｜","一","卜"}', 13),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '小', 'N5', 'N5', false, NULL, '{"ショウ"}', '{"ちい.さい","こ-","お-","さ-"}', '{"tiểu"}', 'thieu-chuu', '{"little","small"}', NULL, NULL, 'Nhỏ', 3, 1, 42, 114, '{"小"}', 14),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '山', 'N5', 'N5', true, NULL, '{"サン","セン"}', '{"やま"}', '{"san"}', 'minato', '{"mountain"}', 'núi', 'minna-no-nihongo', 'Núi', 3, 1, 46, 131, '{"山"}', 15),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '女', 'N5', 'N5', true, NULL, '{"ジョ","ニョ","ニョウ"}', '{"おんな","め"}', '{"nữ"}', 'minato', '{"woman","female"}', NULL, NULL, 'Con gái', 3, 1, 38, 151, '{"女"}', 16),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '川', 'N5', 'N5', true, NULL, '{"セン"}', '{"かわ"}', '{"xuyên"}', 'minato', '{"stream","river","river or three-stroke river radical (no. 47)"}', 'sông', 'minna-no-nihongo', 'Dòng nước', 3, 1, 47, 181, '{"川"}', 17),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '千', 'N5', 'N5', true, NULL, '{"セン"}', '{"ち"}', '{"thiên"}', 'minato', '{"thousand"}', 'nghìn', 'minna-no-nihongo', 'Nghìn, mười trăm là một nghìn', 3, 1, 24, 195, '{"ノ","十"}', 18),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '口', 'N5', 'N4', false, NULL, '{"コウ","ク"}', '{"くち"}', '{"khẩu"}', 'thieu-chuu', '{"mouth"}', NULL, NULL, 'Cái miệng', 3, 1, 30, 284, '{"囗","口"}', 19),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '土', 'N5', 'N5', false, NULL, '{"ド","ト"}', '{"つち"}', '{"thổ","độ","đỗ"}', 'thieu-chuu', '{"soil","earth","ground","Turkey"}', NULL, NULL, 'Ðất', 3, 1, 32, 307, '{"土"}', 20),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '万', 'N5', 'N5', false, NULL, '{"マン","バン"}', '{"よろず"}', '{"vạn"}', 'thieu-chuu', '{"ten thousand","10,000"}', 'mười nghìn, vạn', 'minna-no-nihongo', 'Muôn, mười nghìn là một vạn', 3, 2, 1, 375, '{"｜","ノ","一"}', 21),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '日', 'N5', 'N5', true, NULL, '{"ニチ","ジツ"}', '{"ひ","-び","-か"}', '{"nhật"}', 'minato', '{"day","sun","Japan","counter for days"}', 'ngày', 'minna-no-nihongo', 'Mặt trời', 4, 1, 72, 1, '{"日"}', 22),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '中', 'N5', 'N5', true, NULL, '{"チュウ"}', '{"なか","うち","あた.る"}', '{"trung"}', 'minato', '{"in","inside","middle","mean"}', 'trong, bên trong, giữa', 'minna-no-nihongo', 'Giữa, chỉ vào bộ vị trong vật thể', 4, 1, 2, 11, '{"｜","口"}', 23),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '月', 'N5', 'N5', false, NULL, '{"ゲツ","ガツ"}', '{"つき"}', '{"nguyệt"}', 'thieu-chuu', '{"month","moon"}', 'mặt trăng', 'minna-no-nihongo', 'Mặt trăng', 4, 1, 74, 23, '{"月"}', 24),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '分', 'N5', 'N5', true, NULL, '{"ブン","フン","ブ"}', '{"わ.ける","わ.け","わ.かれる","わ.かる","わ.かつ"}', '{"phân"}', 'minato', '{"part","minute of time","segment","share"}', NULL, NULL, 'Chia', 4, 2, 18, 24, '{"刀","ハ"}', 25),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '五', 'N5', 'N5', false, NULL, '{"ゴ"}', '{"いつ","いつ.つ"}', '{"ngũ"}', 'thieu-chuu', '{"five"}', NULL, NULL, 'Năm, tên số đếm', 4, 1, 7, 31, '{"五"}', 26),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '内', 'N5', 'N3', true, NULL, '{"ナイ","ダイ"}', '{"うち"}', '{"nội"}', 'minato', '{"inside","within","between","among"}', NULL, NULL, 'Ở trong, đối với chữ ngoại ngoài', 4, 2, 13, 44, '{"人","冂"}', 27),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '今', 'N5', 'N5', true, NULL, '{"コン","キン"}', '{"いま"}', '{"kim"}', 'minato', '{"now"}', 'bây giờ', 'minna-no-nihongo', 'Nay, hiện nay, bây giờ gọi là kim', 4, 2, 9, 49, '{"个","一"}', 28),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '手', 'N5', 'N4', true, NULL, '{"シュ","ズ"}', '{"て","て-","-て","た-"}', '{"thủ"}', 'minato', '{"hand"}', 'tay', 'minna-no-nihongo', 'Tay', 4, 1, 64, 60, '{"手"}', 29),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '円', 'N5', 'N5', false, '圓', '{"エン"}', '{"まる.い","まる","まど","まど.か","まろ.やか"}', '{"viên"}', 'thieu-chuu', '{"circle","yen","round"}', NULL, NULL, 'Chỉ về hình-thể', 4, 1, 13, 69, '{"冂","亠","一","｜"}', 30),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '六', 'N5', 'N5', false, NULL, '{"ロク","リク"}', '{"む","む.つ","むっ.つ","むい"}', '{"lục"}', 'thieu-chuu', '{"six"}', NULL, NULL, 'Sáu, số đếm', 4, 1, 12, 93, '{"ハ","亠"}', 31),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '午', 'N5', 'N5', true, NULL, '{"ゴ"}', '{"うま"}', '{"ngọ"}', 'minato', '{"noon","sign of the horse","11AM-1PM","seventh sign of Chinese zodiac"}', NULL, NULL, 'Chi ngọ, chi thứ bảy trong 12 chi', 4, 2, 24, 154, '{"ノ","干","十","乞"}', 32),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '水', 'N5', 'N5', true, NULL, '{"スイ"}', '{"みず","みず-"}', '{"thủy"}', 'minato', '{"water"}', 'nước', 'minna-no-nihongo', 'Nước', 4, 1, 85, 223, '{"水"}', 33),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '木', 'N5', 'N5', false, NULL, '{"ボク","モク"}', '{"き","こ-"}', '{"mộc"}', 'thieu-chuu', '{"tree","wood"}', 'cây, gỗ', 'minna-no-nihongo', 'Cây', 4, 1, 75, 317, '{"木"}', 34),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '天', 'N5', 'N5', true, NULL, '{"テン"}', '{"あまつ","あめ","あま-"}', '{"thiên"}', 'minato', '{"heavens","sky","imperial"}', NULL, NULL, 'Bầu trời', 4, 1, 37, 512, '{"一","大","二"}', 35),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '火', 'N5', 'N5', false, NULL, '{"カ"}', '{"ひ","-び","ほ-"}', '{"hỏa"}', 'thieu-chuu', '{"fire"}', 'lửa', 'minna-no-nihongo', 'Lửa', 4, 1, 86, 574, '{"火"}', 36),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '友', 'N5', 'N5', false, NULL, '{"ユウ"}', '{"とも"}', '{"hữu"}', 'thieu-chuu', '{"friend"}', NULL, NULL, 'Bạn', 4, 2, 29, 622, '{"ノ","一","又"}', 37),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '父', 'N5', 'N5', false, NULL, '{"フ"}', '{"ちち"}', '{"phụ","phủ"}', 'thieu-chuu', '{"father"}', 'bố (của mình)', 'minna-no-nihongo', 'Cha, bố', 4, 2, 88, 646, '{"父"}', 38),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '本', 'N5', 'N5', true, NULL, '{"ホン"}', '{"もと"}', '{"bổn"}', 'minato', '{"book","present","main","origin"}', 'Sách', 'minna-no-nihongo', 'Gốc, một cây gọi là nhất bổn', 5, 1, 75, 10, '{"一","木"}', 39),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '出', 'N5', 'N5', true, NULL, '{"シュツ","スイ"}', '{"で.る","-で","だ.す","-だ.す","い.でる","い.だす"}', '{"xuất"}', 'minato', '{"exit","leave","go out","come out"}', NULL, NULL, 'Ra ngoài, đối lại với chữ nhập vào', 5, 1, 17, 13, '{"｜","山","凵"}', 40),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '生', 'N5', 'N5', false, NULL, '{"セイ","ショウ"}', '{"い.きる","い.かす","い.ける","う.まれる","うま.れる","う.まれ","うまれ","う.む","お.う","は.える","は.やす","き","なま","なま-","な.る","な.す","む.す","-う"}', '{"sanh","sinh"}', 'thieu-chuu', '{"life","genuine","birth"}', NULL, NULL, 'Sống, đối lại với tử', 5, 1, 100, 29, '{"生"}', 41),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '四', 'N5', 'N5', false, NULL, '{"シ"}', '{"よ","よ.つ","よっ.つ","よん"}', '{"tứ"}', 'thieu-chuu', '{"four"}', NULL, NULL, 'Bốn (tên số đếm)', 5, 1, 31, 47, '{"儿","囗"}', 42),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '目', 'N5', 'N4', true, NULL, '{"モク","ボク"}', '{"め","-め","ま-"}', '{"mục"}', 'minato', '{"eye","class","look","insight"}', 'mắt', 'minna-no-nihongo', 'Con mắt', 5, 1, 109, 76, '{"目"}', 43),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '外', 'N5', 'N5', true, NULL, '{"ガイ","ゲ"}', '{"そと","ほか","はず.す","はず.れる","と-"}', '{"ngoại"}', 'minato', '{"outside"}', 'ngoài, bên ngoài', 'minna-no-nihongo', 'Ngoài', 5, 2, 36, 81, '{"卜","夕"}', 44),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '田', 'N5', 'N4', false, NULL, '{"デン"}', '{"た"}', '{"điền"}', 'thieu-chuu', '{"rice field","rice paddy"}', NULL, NULL, 'Ruộng đất cầy cấy được gọi là điền', 5, 1, 102, 90, '{"田"}', 45),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '北', 'N5', 'N5', false, NULL, '{"ホク"}', '{"きた"}', '{"bắc"}', 'thieu-chuu', '{"north"}', 'phía bắc, hướng bắc', 'minna-no-nihongo', 'Phương bắc', 5, 2, 21, 153, '{"匕","爿"}', 46),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '半', 'N5', 'N5', true, NULL, '{"ハン"}', '{"なか.ば"}', '{"bán"}', 'minato', '{"half","middle","odd number","semi-"}', 'phân nửa (30 phút)', 'minna-no-nihongo', 'Nửa', 5, 2, 24, 224, '{"｜","二","并","十"}', 47),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '石', 'N5', 'N3', true, NULL, '{"セキ","シャク","コク"}', '{"いし"}', '{"thạch"}', 'minato', '{"stone"}', 'đá, hòn đá, sỏi', 'minna-no-nihongo', 'Ðá', 5, 1, 112, 342, '{"口","石"}', 48),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '白', 'N5', 'N5', true, NULL, '{"ハク","ビャク"}', '{"しろ","しら-","しろ.い"}', '{"bạch"}', 'minato', '{"white"}', 'màu trắng', 'minna-no-nihongo', 'Sắc trắng', 5, 1, 106, 483, '{"白"}', 49),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '母', 'N5', 'N5', false, NULL, '{"ボ"}', '{"はは","も"}', '{"mẫu"}', 'thieu-chuu', '{"mother"}', 'mẹ (của mình)', 'minna-no-nihongo', 'Mẹ', 5, 2, 80, 570, '{"母","毋"}', 50),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '右', 'N5', 'N5', false, NULL, '{"ウ","ユウ"}', '{"みぎ"}', '{"hữu"}', 'thieu-chuu', '{"right"}', 'phải, bên phải', 'minna-no-nihongo', 'Bên phải', 5, 1, 30, 602, '{"ノ","一","口"}', 51),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '左', 'N5', 'N5', false, NULL, '{"サ","シャ"}', '{"ひだり"}', '{"tả","tá"}', 'thieu-chuu', '{"left"}', 'trái, bên trái', 'minna-no-nihongo', 'Bên trái', 5, 1, 48, 630, '{"ノ","一","工"}', 52),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '兄', 'N5', 'N4', true, NULL, '{"ケイ","キョウ"}', '{"あに"}', '{"huynh"}', 'minato', '{"elder brother","big brother"}', 'Anh trai', 'minato', 'Anh', 5, 2, 10, 1219, '{"口","儿"}', 53),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '会', 'N5', 'N4', true, NULL, '{"カイ","エ"}', '{"あ.う","あ.わせる","あつ.まる"}', '{"hội"}', 'minato', '{"meeting","meet","party","association"}', NULL, NULL, 'Họp', 6, 2, 9, 4, '{"二","个","厶"}', 54),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '年', 'N5', 'N5', true, NULL, '{"ネン"}', '{"とし"}', '{"niên"}', 'minato', '{"year","counter for years"}', NULL, NULL, 'Năm', 6, 1, 51, 6, '{"ノ","一","干","乞"}', 55),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '行', 'N5', 'N5', true, NULL, '{"コウ","ギョウ","アン"}', '{"い.く","ゆ.く","-ゆ.き","-ゆき","-い.き","-いき","おこな.う","おこ.なう"}', '{"hành"}', 'minato', '{"going","journey","carry out","conduct"}', NULL, NULL, 'Bước đi, bước chân đi', 6, 2, 144, 20, '{"行","彳"}', 56),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '気', 'N5', 'N5', true, '氣', '{"キ","ケ"}', '{"いき","き"}', '{"khí"}', 'minato', '{"spirit","mind","air","atmosphere"}', NULL, NULL, 'Hơi thở', 6, 1, 84, 113, '{"气","丶","ノ","乞"}', 57),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '百', 'N5', 'N5', false, NULL, '{"ヒャク","ビャク"}', '{"もも"}', '{"bách","bá","mạch"}', 'thieu-chuu', '{"hundred"}', 'trăm', 'minna-no-nihongo', 'Trăm', 6, 1, 106, 163, '{"一","白"}', 58),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '先', 'N5', 'N5', false, NULL, '{"セン"}', '{"さき","ま.ず"}', '{"tiên","tiến"}', 'thieu-chuu', '{"before","ahead","previous","future"}', NULL, NULL, 'Trước', 6, 1, 10, 173, '{"ノ","土","儿"}', 59),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '名', 'N5', 'N5', true, NULL, '{"メイ","ミョウ"}', '{"な","-な"}', '{"danh"}', 'minato', '{"name","noted","distinguished","reputation"}', NULL, NULL, 'Danh, đối lại với chữ thực', 6, 1, 30, 177, '{"口","夕"}', 60),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '西', 'N5', 'N5', true, NULL, '{"セイ","サイ","ス"}', '{"にし"}', '{"tây"}', 'minato', '{"west","Spain"}', 'phía tây, hướng tây', 'minna-no-nihongo', 'Phương tây', 6, 2, 146, 259, '{"西"}', 61),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '好', 'N5', 'N3', false, NULL, '{"コウ"}', '{"この.む","す.く","よ.い","い.い"}', '{"hảo","hiếu"}', 'thieu-chuu', '{"fond","pleasing","like something"}', NULL, NULL, 'Tốt, hay', 6, 4, 38, 423, '{"子","女"}', 62),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '毎', 'N5', 'N5', true, '每', '{"マイ"}', '{"ごと","-ごと.に"}', '{"mỗi"}', 'minato', '{"every"}', NULL, NULL, 'Thường', 6, 2, 80, 436, '{"母","毋","乞"}', 63),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '休', 'N5', 'N5', false, NULL, '{"キュウ"}', '{"やす.む","やす.まる","やす.める"}', '{"hưu"}', 'thieu-chuu', '{"rest","day off","retire","sleep"}', NULL, NULL, 'Tốt lành', 6, 1, 9, 642, '{"化","木"}', 64),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '耳', 'N5', 'N3', false, NULL, '{"ジ"}', '{"みみ"}', '{"nhĩ"}', 'thieu-chuu', '{"ear"}', 'tai', 'minna-no-nihongo', 'Tai, dùng để nghe', 6, 1, 128, 1328, '{"耳"}', 65),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '見', 'N5', 'N5', false, NULL, '{"ケン"}', '{"み.る","み.える","み.せる"}', '{"kiến","hiện"}', 'thieu-chuu', '{"see","hopes","chances","idea"}', NULL, NULL, 'Thấy, mắt trông thấy', 7, 1, 147, 22, '{"見","目","儿"}', 66),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '体', 'N5', 'N4', true, NULL, '{"タイ","テイ"}', '{"からだ","かたち"}', '{"thể"}', 'minato', '{"body","substance","object","reality"}', 'người, cơ thể', 'minna-no-nihongo', 'Thân thể', 7, 2, 9, 88, '{"木","一","化"}', 67),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '来', 'N5', 'N5', true, NULL, '{"ライ","タイ"}', '{"く.る","きた.る","きた.す","き.たす","き.たる","き","こ"}', '{"lai"}', 'minato', '{"come","due","next","cause"}', NULL, NULL, 'Lại', 7, 2, 75, 102, '{"｜","二","米","亠","木"}', 68),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '男', 'N5', 'N5', false, NULL, '{"ダン","ナン"}', '{"おとこ","お"}', '{"nam"}', 'thieu-chuu', '{"male"}', 'con trai, đàn ông', 'minna-no-nihongo', 'Con trai', 7, 1, 102, 240, '{"田","力"}', 69),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '私', 'N5', 'N4', true, NULL, '{"シ"}', '{"わたくし","わたし"}', '{"tư"}', 'minato', '{"private","I","me"}', 'Tôi', 'minato', 'Riêng', 7, 6, 115, 242, '{"禾","厶"}', 70),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '車', 'N5', 'N5', true, NULL, '{"シャ"}', '{"くるま"}', '{"xa"}', 'minato', '{"car"}', 'xe ô tô, xe hơi', 'minna-no-nihongo', 'Cái xe', 7, 1, 159, 333, '{"車"}', 71),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '何', 'N5', 'N5', false, NULL, '{"カ"}', '{"なに","なん","なに-","なん-"}', '{"hà"}', 'thieu-chuu', '{"what"}', 'Cái gì', 'minna-no-nihongo', 'Sao, gì, lời nói vặn lại', 7, 2, 9, 340, '{"化","口","亅","一"}', 72),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '足', 'N5', 'N4', false, NULL, '{"ソク"}', '{"あし","た.りる","た.る","た.す"}', '{"túc"}', 'thieu-chuu', '{"leg","foot","be sufficient","counter for pairs of footwear"}', 'chân', 'minna-no-nihongo', 'Chân', 7, 1, 157, 343, '{"口","足","止"}', 73),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '弟', 'N5', 'N4', true, NULL, '{"テイ","ダイ","デ"}', '{"おとうと"}', '{"đệ"}', 'minato', '{"younger brother","faithful service to elders"}', 'Em trai', 'minato', 'Em trai', 7, 2, 57, 1161, '{"｜","ノ","弓","并"}', 74),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '国', 'N5', 'N5', true, NULL, '{"コク"}', '{"くに"}', '{"quốc"}', 'minato', '{"country"}', 'Đất nước', 'minato', 'Nước', 8, 2, 31, 3, '{"王","囗","丶"}', 75),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '長', 'N5', 'N5', true, NULL, '{"チョウ"}', '{"なが.い","おさ"}', '{"trường","trưởng"}', 'minato', '{"long","leader","superior","senior"}', NULL, NULL, 'Dài', 8, 2, 168, 12, '{"長"}', 76),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '東', 'N5', 'N5', true, NULL, '{"トウ"}', '{"ひがし"}', '{"đông"}', 'minato', '{"east"}', 'phía đông, hướng đông', 'minna-no-nihongo', 'Phương đông', 8, 2, 75, 37, '{"｜","一","日","木","田"}', 77),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '金', 'N5', 'N5', true, NULL, '{"キン","コン","ゴン"}', '{"かね","かな-","-がね"}', '{"kim"}', 'minato', '{"gold"}', NULL, NULL, 'Loài kim', 8, 1, 167, 53, '{"金","王","ハ","个","并"}', 78),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '学', 'N5', 'N5', true, NULL, '{"ガク"}', '{"まな.ぶ"}', '{"học"}', 'minato', '{"study","learning","science"}', NULL, NULL, 'Bắt chước', 8, 1, 39, 63, '{"子","尚","冖"}', 79),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '明', 'N5', 'N4', true, NULL, '{"メイ","ミョウ","ミン"}', '{"あ.かり","あか.るい","あか.るむ","あか.らむ","あき.らか","あ.ける","-あ.け","あ.く","あ.くる","あ.かす"}', '{"minh"}', 'minato', '{"bright","light"}', NULL, NULL, 'Sáng', 8, 2, 72, 67, '{"月","日"}', 80),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '門', 'N5', 'N2', false, NULL, '{"モン"}', '{"かど","と"}', '{"môn"}', 'thieu-chuu', '{"gate","counter for cannons"}', NULL, NULL, 'Cửa', 8, 2, 169, 452, '{"門"}', 81),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '林', 'N5', 'N2', false, NULL, '{"リン"}', '{"はやし"}', '{"lâm"}', 'thieu-chuu', '{"grove","forest"}', NULL, NULL, 'Rừng', 8, 1, 75, 656, '{"木"}', 82),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '岩', 'N5', 'N2', false, NULL, '{"ガン"}', '{"いわ"}', '{"nham"}', 'thieu-chuu', '{"boulder","rock","cliff"}', NULL, NULL, 'Ðá nham', 8, 2, 46, 787, '{"口","山","石"}', 83),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '雨', 'N5', 'N5', false, NULL, '{"ウ"}', '{"あめ","あま-","-さめ"}', '{"vũ","vú"}', 'thieu-chuu', '{"rain"}', 'mưa', 'minna-no-nihongo', 'Mưa', 8, 1, 173, 950, '{"雨"}', 84),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '妹', 'N5', 'N4', true, NULL, '{"マイ"}', '{"いもうと"}', '{"muội"}', 'minato', '{"younger sister"}', 'Em gái', 'minato', NULL, 8, 2, 38, 1446, '{"｜","女","二","ハ","木","亠"}', 85),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '姉', 'N5', 'N4', true, '姊', '{"シ"}', '{"あね","はは"}', '{"tỉ"}', 'minato', '{"elder sister"}', 'Chị gái', 'minato', 'Chị gái', 8, 2, 38, 1473, '{"巾","女","亠"}', 86),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '後', 'N5', 'N5', true, NULL, '{"ゴ","コウ"}', '{"のち","うし.ろ","うしろ","あと","おく.れる"}', '{"hậu"}', 'minato', '{"behind","back","later"}', 'Sau', 'minato', 'Sau', 9, 2, 60, 26, '{"夂","幺","彳"}', 87),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '前', 'N5', 'N5', true, NULL, '{"ゼン"}', '{"まえ","-まえ"}', '{"tiền"}', 'minato', '{"in front","before"}', 'Phía trước', 'minato', 'Trước', 9, 2, 18, 27, '{"一","刈","月","并"}', 88),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '食', 'N5', 'N5', true, NULL, '{"ショク","ジキ"}', '{"く.う","く.らう","た.べる","は.む"}', '{"thực"}', 'minato', '{"eat","food"}', NULL, NULL, 'Đồ để ăn', 9, 2, 184, 328, '{"食"}', 89),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '南', 'N5', 'N5', false, NULL, '{"ナン","ナ"}', '{"みなみ"}', '{"nam"}', 'thieu-chuu', '{"south"}', 'phía nam, hướng nam', 'minna-no-nihongo', 'Phương nam', 9, 2, 24, 341, '{"干","十","并","冂"}', 90),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '畑', 'N5', 'ngoài JLPT', false, NULL, NULL, '{"はた","はたけ","-ばたけ"}', '{"đèn"}', 'kanjidic2-unverified', '{"farm","field","garden","one''s specialty"}', NULL, NULL, NULL, 9, 3, 102, 1176, '{"火","田"}', 91),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '時', 'N5', 'N5', true, NULL, '{"ジ"}', '{"とき","-どき"}', '{"thì"}', 'minato', '{"time","hour"}', NULL, NULL, 'Mùa', 10, 2, 72, 16, '{"寸","土","日"}', 92),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '高', 'N5', 'N5', true, NULL, '{"コウ"}', '{"たか.い","たか","-だか","たか.まる","たか.める"}', '{"cao"}', 'minato', '{"tall","high","expensive"}', NULL, NULL, 'Cao', 10, 2, 189, 65, '{"口","高","亠","冂"}', 93),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '書', 'N5', 'N5', true, NULL, '{"ショ"}', '{"か.く","-が.き","-がき"}', '{"thư"}', 'minato', '{"write"}', NULL, NULL, 'Sách', 10, 2, 73, 169, '{"日","聿"}', 94),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '校', 'N5', 'N5', false, NULL, '{"コウ","キョウ"}', NULL, '{"giáo","hiệu","hào"}', 'thieu-chuu', '{"exam","school","printing","proof"}', NULL, NULL, 'Cái cùm chân', 10, 1, 75, 294, '{"父","木","亠"}', 95),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '間', 'N5', 'N5', false, NULL, '{"カン","ケン"}', '{"あいだ","ま","あい"}', '{"gian"}', 'thieu-chuu', '{"interval","space"}', 'giữa (khoảng giữa hai vật)', 'minna-no-nihongo', 'Chữ gian nghĩa là khoảng thì thường viết là', 12, 2, 169, 33, '{"日","門"}', 96),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '森', 'N5', 'N2', false, NULL, '{"シン"}', '{"もり"}', '{"sâm"}', 'thieu-chuu', '{"forest","woods"}', NULL, NULL, 'Rậm rạp', 12, 1, 75, 609, '{"木"}', 97),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '話', 'N5', 'N5', true, NULL, '{"ワ"}', '{"はな.す","はなし"}', '{"thoại"}', 'minato', '{"tale","talk"}', 'câu chuyện, bài nói chuyện', 'minna-no-nihongo', 'Lời nói', 13, 2, 149, 134, '{"言","口","舌"}', 98),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '電', 'N5', 'N5', true, NULL, '{"デン"}', NULL, '{"điện"}', 'minato', '{"electricity"}', NULL, NULL, 'Chớp, điện', 13, 2, 173, 268, '{"雨","田","乙"}', 99),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '語', 'N5', 'N5', true, NULL, '{"ゴ"}', '{"かた.る","かた.らう"}', '{"ngữ"}', 'minato', '{"word","speech","language"}', NULL, NULL, 'Nói, nói nhỏ', 14, 2, 149, 301, '{"言","口","五"}', 100),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '聞', 'N5', 'N5', false, NULL, '{"ブン","モン"}', '{"き.く","き.こえる"}', '{"văn","vấn","vặn"}', 'thieu-chuu', '{"hear","ask","listen"}', NULL, NULL, 'Nghe thấy', 14, 2, 128, 319, '{"耳","門"}', 101),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '読', 'N5', 'N5', false, '讀', '{"ドク","トク","トウ"}', '{"よ.む","-よ.み"}', '{"độc","đậu"}', 'thieu-chuu', '{"read"}', NULL, NULL, 'Đọc', 14, 2, 149, 618, '{"言","士","儿","冖"}', 102),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '駅', 'N5', 'N4', true, '驛', '{"エキ"}', NULL, '{"dịch"}', 'minato', '{"station"}', 'Nhà ga', 'minato', 'Ngựa trạm, dùng ngựa đưa thư', 14, 3, 187, 724, '{"馬","尸","杰","丶"}', 103),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '工', 'N4', 'N4', true, NULL, '{"コウ","ク","グ"}', NULL, '{"công"}', 'minato', '{"craft","construction","katakana e radical (no. 48)"}', NULL, NULL, 'Khéo, làm việc khéo gọi là công', 3, 2, 48, 299, '{"工"}', 104),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '丸', 'N4', 'N2', true, NULL, '{"ガン"}', '{"まる","まる.める","まる.い"}', '{"hoàn"}', 'minato', '{"round","full (month)","perfection","-ship"}', 'vòng tròn, dấu tròn (đúng)', 'minna-no-nihongo', 'Viên', 3, 2, 3, 542, '{"九","丶"}', 105),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '夕', 'N4', 'N4', false, NULL, '{"セキ"}', '{"ゆう"}', '{"tịch"}', 'thieu-chuu', '{"evening"}', NULL, NULL, 'Buổi tối', 3, 1, 36, 924, '{"夕"}', 106),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '才', 'N4', 'N3', true, NULL, '{"サイ"}', NULL, '{"tài"}', 'minato', '{"genius","years old","cubic shaku"}', NULL, NULL, 'Tài, làm việc giỏi gọi là tài', 3, 2, 64, 1497, '{"ノ","一","亅"}', 107),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '方', 'N4', 'N4', false, NULL, '{"ホウ"}', '{"かた","-かた","-がた"}', '{"phương"}', 'thieu-chuu', '{"direction","person","alternative"}', 'vị, người (cách nói lịch sự của 人)', 'minna-no-nihongo', 'Vuông', 4, 2, 70, 46, '{"方"}', 108),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '化', 'N4', 'N3', true, NULL, '{"カ","ケ"}', '{"ば.ける","ば.かす","ふ.ける","け.する"}', '{"hóa"}', 'minato', '{"change","take the form of","influence","enchant"}', NULL, NULL, 'Biến hóa', 4, 3, 21, 89, '{"化","匕"}', 109),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '不', 'N4', 'N4', true, NULL, '{"フ","ブ"}', NULL, '{"bất"}', 'minato', '{"negative","non-","bad","ugly"}', NULL, NULL, 'Chẳng', 4, 4, 1, 101, '{"｜","ノ","一","丶"}', 110),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '公', 'N4', 'N4', true, NULL, '{"コウ","ク"}', '{"おおやけ"}', '{"công"}', 'minato', '{"public","prince","official","governmental"}', 'Công cộng', 'minato', 'Công, không tư túi gì, gọi là công', 4, 2, 12, 118, '{"ハ","厶"}', 111),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '区', 'N4', 'N2', true, NULL, '{"ク","オウ","コウ"}', NULL, '{"khu"}', 'minato', '{"ward","district"}', 'Khu vực, quận', 'minato', 'Chia từng loài', 4, 3, 23, 137, '{"匚","丶","ノ"}', 112),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '心', 'N4', 'N4', true, NULL, '{"シン"}', '{"こころ","-ごころ"}', '{"tâm"}', 'minato', '{"heart","mind","spirit","heart radical (no. 61)"}', 'Tim', 'minato', 'Tim', 4, 2, 61, 157, '{"心"}', 113),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '支', 'N4', 'N3', true, NULL, '{"シ"}', '{"ささ.える","つか.える","か.う"}', '{"chi"}', 'minato', '{"branch","support","sustain","branch radical (no. 65)"}', NULL, NULL, 'Chi, thứ', 4, 5, 65, 159, '{"支","十","又"}', 114),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '文', 'N4', 'N4', true, NULL, '{"ブン","モン"}', '{"ふみ","あや"}', '{"văn"}', 'minato', '{"sentence","literature","style","art"}', NULL, NULL, 'Văn vẻ', 4, 1, 67, 190, '{"文"}', 115),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '元', 'N4', 'N4', false, NULL, '{"ゲン","ガン"}', '{"もと"}', '{"nguyên"}', 'thieu-chuu', '{"beginning","former time","origin"}', NULL, NULL, 'Mới', 4, 2, 10, 192, '{"二","儿","元"}', 116),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '少', 'N4', 'N4', false, NULL, '{"ショウ"}', '{"すく.ない","すこ.し"}', '{"thiểu","thiếu"}', 'thieu-chuu', '{"few","little"}', NULL, NULL, 'Ít', 4, 2, 42, 287, '{"ノ","小"}', 117),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '止', 'N4', 'N4', true, NULL, '{"シ"}', '{"と.まる","-ど.まり","と.める","-と.める","-ど.め","とど.める","とど.め","とど.まる","や.める","や.む","-や.む","よ.す","-さ.す","-さ.し"}', '{"chỉ"}', 'minato', '{"stop","halt"}', NULL, NULL, 'Dừng lại', 4, 2, 77, 310, '{"止"}', 118),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '切', 'N4', 'N4', true, NULL, '{"セツ","サイ"}', '{"き.る","-き.る","き.り","-き.り","-ぎ.り","き.れる","-き.れる","き.れ","-き.れ","-ぎ.れ"}', '{"thiết"}', 'minato', '{"cut","cutoff","be sharp"}', NULL, NULL, 'Cắt', 4, 2, 18, 324, '{"刀","匕"}', 119),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '夫', 'N4', 'N3', true, NULL, '{"フ","フウ","ブ"}', '{"おっと","それ"}', '{"phu"}', 'minato', '{"husband","man"}', 'Chồng', 'minato', 'Ðàn ông', 4, 4, 37, 335, '{"人","二","大","亠"}', 120),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '太', 'N4', 'N3', true, NULL, '{"タイ","タ"}', '{"ふと.い","ふと.る"}', '{"thái"}', 'minato', '{"plump","thick","big around"}', NULL, NULL, 'To lắm', 4, 2, 37, 552, '{"大","丶"}', 121),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '王', 'N4', 'N3', true, NULL, '{"オウ","-ノウ"}', NULL, '{"vương"}', 'minato', '{"king","rule","magnate"}', NULL, NULL, 'Vua', 4, 1, 96, 684, '{"王"}', 122),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '毛', 'N4', 'N2', true, NULL, '{"モウ"}', '{"け"}', '{"mao"}', 'minato', '{"fur","hair","feather","down"}', 'Lông', 'minato', 'Lông', 4, 2, 82, 1179, '{"毛"}', 123),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '牛', 'N4', 'N4', false, NULL, '{"ギュウ"}', '{"うし"}', '{"ngưu"}', 'thieu-chuu', '{"cow"}', NULL, NULL, 'Con trâu', 4, 2, 93, 1202, '{"牛"}', 124),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '犬', 'N4', 'N4', false, NULL, '{"ケン"}', '{"いぬ","いぬ-"}', '{"khuyển"}', 'thieu-chuu', '{"dog"}', 'chó', 'minna-no-nihongo', 'Con chó', 4, 1, 94, 1326, '{"犬","大","丶"}', 125),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '市', 'N4', 'N3', true, NULL, '{"シ"}', '{"いち"}', '{"thị"}', 'minato', '{"market","city","town"}', NULL, NULL, 'Chợ, chỗ để mua bán gọi là thị', 5, 2, 50, 42, '{"巾","亠"}', 126),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '立', 'N4', 'N4', true, NULL, '{"リツ","リュウ","リットル"}', '{"た.つ","-た.つ","た.ち-","た.てる","-た.てる","た.て-","たて-","-た.て","-だ.て","-だ.てる"}', '{"lập"}', 'minato', '{"stand up","rise","set up","erect"}', NULL, NULL, 'Ðứng thẳng', 5, 1, 117, 58, '{"立"}', 127),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '代', 'N4', 'N4', true, NULL, '{"ダイ","タイ"}', '{"か.わる","かわ.る","かわ.り","か.わり","-がわ.り","-が.わり","か.える","よ","しろ"}', '{"đại"}', 'minato', '{"substitute","change","convert","replace"}', NULL, NULL, 'Ðổi', 5, 3, 9, 66, '{"化","弋"}', 128),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '主', 'N4', 'N4', true, NULL, '{"シュ","ス","シュウ"}', '{"ぬし","おも","あるじ"}', '{"chủ"}', 'minato', '{"lord","chief","master","main thing"}', 'Chủ', 'minato', 'Vua', 5, 3, 3, 95, '{"王","丶"}', 129),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '用', 'N4', 'N4', true, NULL, '{"ヨウ"}', '{"もち.いる"}', '{"dụng"}', 'minato', '{"utilize","business","service","use"}', NULL, NULL, 'Công dùng, đối lại với chữ thể', 5, 2, 101, 107, '{"用"}', 130),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '以', 'N4', 'N4', false, NULL, '{"イ"}', '{"もっ.て"}', '{"dĩ"}', 'thieu-chuu', '{"by means of","because","in view of","compared with"}', NULL, NULL, 'Lấy', 5, 4, 9, 126, '{"｜","人","丶"}', 131),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '世', 'N4', 'N4', true, NULL, '{"セイ","セ","ソウ"}', '{"よ"}', '{"thế"}', 'minato', '{"generation","world","society","public"}', NULL, NULL, 'Ðời', 5, 3, 1, 135, '{"｜","一","世"}', 132),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '正', 'N4', 'N4', true, NULL, '{"セイ","ショウ"}', '{"ただ.しい","ただ.す","まさ","まさ.に"}', '{"chính"}', 'minato', '{"correct","justice","righteous","10**40"}', NULL, NULL, 'Phải, là chánh đáng', 5, 1, 77, 143, '{"一","止"}', 133),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '台', 'N4', 'N4', true, NULL, '{"ダイ","タイ"}', '{"うてな","われ","つかさ"}', '{"đài","thai"}', 'minato', '{"pedestal","a stand","counter for machines and vehicles"}', NULL, NULL, 'Sao thai', 5, 2, 30, 262, '{"口","厶"}', 134),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '広', 'N4', 'N4', false, '廣', '{"コウ"}', '{"ひろ.い","ひろ.まる","ひろ.める","ひろ.がる","ひろ.げる"}', '{"quảng","quáng"}', 'thieu-chuu', '{"wide","broad","spacious"}', NULL, NULL, 'Rộng', 5, 2, 53, 263, '{"厶","广"}', 135),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '辺', 'N4', 'N2', true, '邊', '{"ヘン"}', '{"あた.り","ほと.り","-べ"}', '{"biên"}', 'minato', '{"environs","boundary","border","vicinity"}', 'chỗ, vùng', 'minna-no-nihongo', 'Ven bờ', 5, 4, 162, 428, '{"込","刀"}', 136),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '仕', 'N4', 'N4', false, NULL, '{"シ","ジ"}', '{"つか.える"}', '{"sĩ"}', 'thieu-chuu', '{"attend","doing","official","serve"}', NULL, NULL, 'Quan', 5, 3, 9, 439, '{"化","士"}', 137),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '去', 'N4', 'N4', true, NULL, '{"キョ","コ"}', '{"さ.る","-さ.る"}', '{"khứ"}', 'minato', '{"gone","past","quit","leave"}', NULL, NULL, 'Ði', 5, 3, 28, 440, '{"土","厶"}', 138),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '写', 'N4', 'N4', true, NULL, '{"シャ","ジャ"}', '{"うつ.す","うつ.る","うつ-","うつ.し"}', '{"tả"}', 'minato', '{"copy","be photographed","describe"}', NULL, NULL, 'Dốc hết ra, tháo ra', 5, 3, 14, 453, '{"一","冖","勹"}', 139),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '末', 'N4', 'N3', true, NULL, '{"マツ","バツ"}', '{"すえ","うら","うれ"}', '{"mạt"}', 'minato', '{"end","close","tip","powder"}', NULL, NULL, 'Ngọn', 5, 4, 75, 456, '{"｜","一","ハ","木","亠"}', 140),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '古', 'N4', 'N4', false, NULL, '{"コ"}', '{"ふる.い","ふる-","-ふる.す"}', '{"cổ"}', 'thieu-chuu', '{"old"}', NULL, NULL, 'Ngày xưa', 5, 2, 30, 509, '{"口","十"}', 141),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '史', 'N4', 'N2', true, NULL, '{"シ"}', NULL, '{"sử"}', 'minato', '{"history","chronicle"}', NULL, NULL, 'Quan sử', 5, 5, 30, 511, '{"ノ","口"}', 142),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '号', 'N4', 'N3', true, NULL, '{"ゴウ"}', '{"さけ.ぶ","よびな"}', '{"hiệu"}', 'minato', '{"nickname","number","item","title"}', NULL, NULL, 'Kêu gào, gào khóc', 5, 3, 30, 585, '{"一","口","勹"}', 143),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '弁', 'N4', 'N1', true, NULL, '{"ベン","ヘン"}', '{"かんむり","わきま.える","わ.ける","はなびら","あらそ.う"}', '{"biện"}', 'minato', '{"valve","petal","braid","speech"}', NULL, NULL, 'Cái mũ lớn đời xưa', 5, 5, 55, 619, '{"厶","廾"}', 144),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '玉', 'N4', 'N2', true, NULL, '{"ギョク"}', '{"たま","たま-","-だま"}', '{"ngọc"}', 'minato', '{"jewel","ball"}', 'Đá quý', 'minato', 'Ngọc, đá báu', 5, 1, 96, 737, '{"王","丶"}', 145),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '冬', 'N4', 'N4', true, NULL, '{"トウ"}', '{"ふゆ"}', '{"đông"}', 'minato', '{"winter"}', 'Mùa đông', 'minato', 'Mùa đông', 5, 2, 15, 1090, '{"夂","丶","攵"}', 146),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '皿', 'N4', 'N2', true, NULL, '{"ベイ"}', '{"さら"}', '{"mãnh"}', 'minato', '{"dish","a helping","plate"}', 'Đĩa', 'minato', 'Ðồ, các đồ bát đĩa đều gọi là mãnh', 5, 3, 108, 1812, '{"皿"}', 147),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '同', 'N4', 'N4', true, NULL, '{"ドウ"}', '{"おな.じ"}', '{"đồng"}', 'minato', '{"same","agree","equal"}', NULL, NULL, 'Cùng như một', 6, 2, 30, 15, '{"口","冂","一"}', 148),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '自', 'N4', 'N4', true, NULL, '{"ジ","シ"}', '{"みずか.ら","おの.ずから","おの.ずと"}', '{"tự"}', 'minato', '{"oneself"}', NULL, NULL, 'Bởi, từ', 6, 2, 132, 19, '{"自","目"}', 149),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '地', 'N4', 'N4', true, NULL, '{"チ","ジ"}', NULL, '{"địa"}', 'minato', '{"ground","earth"}', NULL, NULL, 'Ðất', 6, 2, 32, 40, '{"土","也"}', 150),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '合', 'N4', 'N3', true, NULL, '{"ゴウ","ガッ","カッ"}', '{"あ.う","-あ.う","あ.い","あい-","-あ.い","-あい","あ.わす","あ.わせる","-あ.わせる"}', '{"hợp"}', 'minato', '{"fit","suit","join","0.1"}', NULL, NULL, 'Hợp', 6, 2, 30, 41, '{"口","个","一"}', 151),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '回', 'N4', 'N3', true, NULL, '{"カイ","エ"}', '{"まわ.る","-まわ.る","-まわ.り","まわ.す","-まわ.す","まわ.し-","-まわ.し","もとお.る","か.える"}', '{"hồi"}', 'minato', '{"-times","round","game","revolve"}', NULL, NULL, 'Về, đi rồi trở lại gọi là hồi', 6, 2, 31, 50, '{"口","囗"}', 152),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '全', 'N4', 'N3', true, NULL, '{"ゼン"}', '{"まった.く","すべ.て"}', '{"toàn"}', 'minato', '{"whole","entire","all","complete"}', NULL, NULL, 'Xong, đủ', 6, 3, 11, 75, '{"王","ハ","个"}', 153),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '当', 'N4', 'N3', true, NULL, '{"トウ"}', '{"あ.たる","あ.たり","あ.てる","あ.て","まさ.に","まさ.にべし"}', '{"đương"}', 'minato', '{"hit","right","appropriate","himself"}', NULL, NULL, 'Ðang', 6, 2, 58, 91, '{"ヨ","尚"}', 154),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '多', 'N4', 'N4', false, NULL, '{"タ"}', '{"おお.い","まさ.に","まさ.る"}', '{"đa"}', 'thieu-chuu', '{"many","frequent","much"}', NULL, NULL, 'Nhiều', 6, 2, 36, 139, '{"夕"}', 155),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '安', 'N4', 'N4', true, NULL, '{"アン"}', '{"やす.い","やす.まる","やす","やす.らか"}', '{"an"}', 'minato', '{"relax","cheap","low","quiet"}', NULL, NULL, 'Yên', 6, 3, 40, 144, '{"女","宀"}', 156),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '交', 'N4', 'N3', true, NULL, '{"コウ"}', '{"まじ.わる","まじ.える","ま.じる","まじ.る","ま.ざる","ま.ぜる","-か.う","か.わす","かわ.す","こもごも"}', '{"giao"}', 'minato', '{"mingle","mixing","association","coming & going"}', NULL, NULL, 'Chơi', 6, 2, 8, 178, '{"父","亠"}', 157),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '考', 'N4', 'N4', true, NULL, '{"コウ"}', '{"かんが.える","かんが.え"}', '{"khảo"}', 'minato', '{"consider","think over"}', NULL, NULL, 'Thọ khảo, già nua', 6, 2, 125, 196, '{"老","勹"}', 158),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '死', 'N4', 'N4', false, NULL, '{"シ"}', '{"し.ぬ","し.に-"}', '{"tử"}', 'thieu-chuu', '{"death","die"}', NULL, NULL, 'Chết', 6, 3, 78, 229, '{"一","夕","匕","歹"}', 159),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '有', 'N4', 'N4', true, NULL, '{"ユウ","ウ"}', '{"あ.る"}', '{"hữu"}', 'minato', '{"possess","have","exist","happen"}', NULL, NULL, 'Có', 6, 3, 74, 282, '{"ノ","一","月"}', 160),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '宅', 'N4', 'N3', true, NULL, '{"タク"}', NULL, '{"trạch"}', 'minato', '{"home","house","residence","our house"}', 'Nhà ở', 'minato', 'Nhà ở, ở vào đấy cũng gọi là trạch', 6, 6, 40, 357, '{"ノ","一","乙","宀"}', 161),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '早', 'N4', 'N4', true, NULL, '{"ソウ","サッ"}', '{"はや.い","はや","はや-","はや.まる","はや.める","さ-"}', '{"tảo"}', 'minato', '{"early","fast"}', NULL, NULL, 'Sớm ngày', 6, 1, 72, 402, '{"十","日"}', 162),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '字', 'N4', 'N4', true, NULL, '{"ジ"}', '{"あざ","あざな","-な"}', '{"tự"}', 'minato', '{"character","letter","word","section of village"}', 'chữ', 'minna-no-nihongo', 'Văn tự', 6, 1, 39, 485, '{"子","宀"}', 163),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '光', 'N4', 'N3', true, NULL, '{"コウ"}', '{"ひか.る","ひかり"}', '{"quang"}', 'minato', '{"ray","light"}', 'Ánh sáng', 'minato', 'Sáng', 6, 2, 10, 527, '{"一","尚","儿"}', 164),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '色', 'N4', 'N4', true, NULL, '{"ショク","シキ"}', '{"いろ"}', '{"sắc"}', 'minato', '{"color"}', 'Màu sắc', 'minato', 'Sắc, màu', 6, 2, 139, 621, '{"色","巴","勹"}', 165),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '羽', 'N4', 'N2', true, NULL, '{"ウ"}', '{"は","わ","はね"}', '{"vũ"}', 'minato', '{"feathers","counter for birds, rabbits"}', 'Cánh', 'minato', 'Lông chim', 6, 2, 124, 748, '{"羽","冫"}', 166),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '池', 'N4', 'N2', true, NULL, '{"チ"}', '{"いけ"}', '{"trì"}', 'minato', '{"pond","cistern","pool","reservoir"}', 'Cái ao', 'minato', 'Thành trì', 6, 2, 85, 827, '{"汁","也"}', 167),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '肉', 'N4', 'N4', false, NULL, '{"ニク"}', '{"しし"}', '{"nhục","nhụ","nậu"}', 'thieu-chuu', '{"meat"}', 'thịt', 'minna-no-nihongo', 'Thịt', 6, 2, 130, 986, '{"肉","冂","人"}', 168),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '衣', 'N4', 'N2', true, NULL, '{"イ","エ"}', '{"ころも","きぬ","-ぎ"}', '{"y"}', 'minato', '{"garment","clothes","dressing"}', 'Trang phục', 'minato', 'Áo', 6, 4, 145, 1214, '{"衣","亠"}', 169),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '虫', 'N4', 'N2', true, NULL, '{"チュウ","キ"}', '{"むし"}', '{"trùng"}', 'minato', '{"insect","bug","temper"}', 'Côn trùng', 'minato', 'Nguyên là chữ', 6, 1, 142, 1351, '{"虫"}', 170),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '糸', 'N4', 'N2', true, NULL, '{"シ"}', '{"いと"}', '{"mịch"}', 'minato', '{"thread"}', 'Sợi tơ', 'minato', 'Sợi tơ nhỏ', 6, 1, 120, 1488, '{"糸","幺","小"}', 171),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '社', 'N4', 'N4', true, NULL, '{"シャ"}', '{"やしろ"}', '{"xã"}', 'minato', '{"company","firm","office","association"}', NULL, NULL, 'Ðền thờ thổ địa', 7, 2, 113, 21, '{"土","礼"}', 172),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '言', 'N4', 'N4', false, NULL, '{"ゲン","ゴン"}', '{"い.う","こと"}', '{"ngôn","ngân"}', 'thieu-chuu', '{"say","word"}', NULL, NULL, 'Nói, tự mình nói ra gọi là ngôn', 7, 2, 149, 83, '{"言"}', 173),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '作', 'N4', 'N4', true, NULL, '{"サク","サ"}', '{"つく.る","つく.り","-づく.り"}', '{"tác"}', 'minato', '{"make","production","prepare","build"}', NULL, NULL, 'Nhấc lên', 7, 2, 9, 103, '{"｜","ノ","化","一","乞"}', 174),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '初', 'N4', 'N3', true, NULL, '{"ショ"}', '{"はじ.め","はじ.めて","はつ","はつ-","うい-","-そ.める","-ぞ.め"}', '{"sơ"}', 'minato', '{"first time","beginning"}', NULL, NULL, 'Mới, trước', 7, 4, 18, 152, '{"初","刀"}', 175),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '近', 'N4', 'N4', true, NULL, '{"キン","コン"}', '{"ちか.い"}', '{"cận"}', 'minato', '{"near","early","akin","tantamount"}', NULL, NULL, 'Gần', 7, 2, 162, 194, '{"斤","込"}', 176),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '売', 'N4', 'N4', true, '賣', '{"バイ"}', '{"う.る","う.れる"}', '{"mại"}', 'minato', '{"sell"}', NULL, NULL, 'Bán', 7, 2, 33, 202, '{"士","儿","冖"}', 177),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '利', 'N4', 'N3', true, NULL, '{"リ"}', '{"き.く"}', '{"lợi"}', 'minato', '{"profit","advantage","benefit"}', NULL, NULL, 'Sắc', 7, 4, 18, 203, '{"禾","刈"}', 178),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '別', 'N4', 'N4', true, NULL, '{"ベツ"}', '{"わか.れる","わ.ける"}', '{"biệt"}', 'minato', '{"separate","branch off","diverge","fork"}', NULL, NULL, 'Chia', 7, 4, 18, 214, '{"刈","口","力","勹"}', 179),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '村', 'N4', 'N2', true, NULL, '{"ソン"}', '{"むら"}', '{"thôn"}', 'minato', '{"village","town"}', 'Làng', 'minato', 'Làng, xóm', 7, 1, 75, 253, '{"寸","木"}', 180),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '住', 'N4', 'N4', true, NULL, '{"ジュウ","ヂュウ","チュウ"}', '{"す.む","す.まう","-ず.まい"}', '{"trụ","trú"}', 'minato', '{"dwell","reside","live","inhabit"}', NULL, NULL, 'Thôi', 7, 3, 9, 270, '{"王","化","丶"}', 181),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '町', 'N4', 'N4', false, NULL, '{"チョウ"}', '{"まち"}', '{"đinh"}', 'thieu-chuu', '{"town","village","block","street"}', 'thành phố, thị trấn, khu phố', 'minna-no-nihongo', 'Mốc ruộng, bờ cõi ruộng', 7, 1, 102, 292, '{"一","田","亅"}', 182),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '究', 'N4', 'N4', true, NULL, '{"キュウ","ク"}', '{"きわ.める"}', '{"cứu"}', 'minato', '{"research","study"}', NULL, NULL, 'Cùng cực, kết cục', 7, 3, 116, 368, '{"穴","九","儿","宀"}', 183),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '声', 'N4', 'N3', true, NULL, '{"セイ","ショウ"}', '{"こえ","こわ-"}', '{"thanh"}', 'minato', '{"voice"}', 'Giọng nói', 'minato', 'Tiếng', 7, 2, 33, 388, '{"士","尸"}', 184),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '労', 'N4', 'N3', true, '勞', '{"ロウ"}', '{"ろう.する","いたわ.る","いた.ずき","ねぎら","つか.れる","ねぎら.う"}', '{"lao"}', 'minato', '{"labor","thank for","reward for","toil"}', NULL, NULL, 'Nhọc', 7, 4, 19, 398, '{"尚","力","冖"}', 185),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '医', 'N4', 'N4', true, NULL, '{"イ"}', '{"い.やす","い.する","くすし"}', '{"y"}', 'minato', '{"doctor","medicine"}', NULL, NULL, 'Chữa bệnh', 7, 3, 23, 437, '{"矢","匚","乞"}', 186),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '谷', 'N4', 'N2', true, NULL, '{"コク"}', '{"たに","きわ.まる"}', '{"cốc"}', 'minato', '{"valley"}', 'Thung lũng', 'minato', 'Lũng', 7, 2, 150, 508, '{"口","谷","ハ","个"}', 187),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '図', 'N4', 'N4', true, '圖', '{"ズ","ト"}', '{"え","はか.る"}', '{"đồ"}', 'minato', '{"map","drawing","plan","extraordinary"}', 'sơ đồ, hình vẽ, bản vẽ', 'minna-no-nihongo', 'Cái tranh vẽ', 7, 2, 31, 539, '{"斗","囗"}', 188),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '花', 'N4', 'N4', false, NULL, '{"カ","ケ"}', '{"はな"}', '{"hoa"}', 'thieu-chuu', '{"flower"}', 'hoa', 'minna-no-nihongo', 'Hoa, hoa của cây cỏ', 7, 1, 140, 578, '{"化","匕","艾"}', 189),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '赤', 'N4', 'N4', true, NULL, '{"セキ","シャク"}', '{"あか","あか-","あか.い","あか.らむ","あか.らめる"}', '{"xích"}', 'minato', '{"red"}', 'màu đỏ', 'minna-no-nihongo', 'Sắc đỏ', 7, 1, 155, 584, '{"赤","土"}', 190),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '走', 'N4', 'N4', true, NULL, '{"ソウ"}', '{"はし.る"}', '{"tẩu"}', 'minato', '{"run"}', NULL, NULL, 'Chạy', 7, 2, 156, 626, '{"走","土"}', 191),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '里', 'N4', 'ngoài JLPT', true, NULL, '{"リ"}', '{"さと"}', '{"lý"}', 'minato', '{"ri","village","parent''s home","league"}', 'Làng, quê hương', 'minato', 'Làng', 7, 2, 166, 1096, '{"里"}', 192),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '麦', 'N4', 'N2', true, NULL, '{"バク"}', '{"むぎ"}', '{"mạch"}', 'minato', '{"barley","wheat"}', 'Lúa mạch', 'minato', 'Tục dùng như chữ mạch', 7, 2, 199, 1615, '{"麦","夂","土","二","亠"}', 193),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '事', 'N4', 'N4', false, NULL, '{"ジ","ズ"}', '{"こと","つか.う","つか.える"}', '{"sự"}', 'thieu-chuu', '{"matter","thing","fact","business"}', NULL, NULL, 'Việc', 8, 3, 6, 18, '{"一","口","亅","ヨ"}', 194),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '者', 'N4', 'N4', true, NULL, '{"シャ"}', '{"もの"}', '{"giả"}', 'minato', '{"someone","person"}', 'người (người nhà, cấp dưới của mình)', 'minna-no-nihongo', 'Lời phân biệt', 8, 3, 125, 38, '{"日","老"}', 195),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '実', 'N4', 'N3', true, '實', '{"ジツ","シツ"}', '{"み","みの.る","まこと","みの","みち.る"}', '{"thực"}', 'minato', '{"reality","truth","seed","fruit"}', NULL, NULL, 'Giàu, đầy ních', 8, 3, 40, 68, '{"士","大","宀"}', 196),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '京', 'N4', 'N4', true, NULL, '{"キョウ","ケイ","キン"}', '{"みやこ"}', '{"kinh"}', 'minato', '{"capital","10**16"}', NULL, NULL, 'To', 8, 2, 8, 74, '{"口","小","亠"}', 197),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '性', 'N4', 'N3', true, NULL, '{"セイ","ショウ"}', '{"さが"}', '{"tính"}', 'minato', '{"sex","gender","nature"}', NULL, NULL, 'Tính', 8, 5, 61, 104, '{"生","忙"}', 198),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '治', 'N4', 'N3', true, NULL, '{"ジ","チ"}', '{"おさ.める","おさ.まる","なお.る","なお.す"}', '{"trị"}', 'minato', '{"reign","be at peace","calm down","subdue"}', NULL, NULL, 'Sửa', 8, 4, 85, 109, '{"口","汁","厶"}', 199);

INSERT INTO jlpt_kanji (site_id, character, jlpt_level, jlpt_level_ref, in_course, kyujitai, on_readings, kun_readings, han_viet, han_viet_source, meaning_en, meaning_vi, meaning_vi_source, meaning_classic, stroke_count, school_grade, radical_number, frequency, parts, order_index) VALUES
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '府', 'N4', 'N2', true, NULL, '{"フ"}', NULL, '{"phủ"}', 'minato', '{"borough","urban prefecture","govt office","representative body"}', NULL, NULL, 'Tủ chứa sách vở tờ bồi', 8, 4, 53, 170, '{"化","寸","广"}', 200),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '画', 'N4', 'N4', true, NULL, '{"ガ","カク","エ","カイ"}', '{"えが.く","かく.する","かぎ.る","はかりごと","はか.る"}', '{"họa","hoạch"}', 'minato', '{"brush-stroke","picture"}', NULL, NULL, 'Vạch, vẽ', 8, 2, 102, 199, '{"一","田","凵"}', 201),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '知', 'N4', 'N4', true, NULL, '{"チ"}', '{"し.る","し.らせる"}', '{"tri"}', 'minato', '{"know","wisdom"}', NULL, NULL, 'Biết, tri thức', 8, 2, 111, 205, '{"口","矢","乞"}', 202),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '物', 'N4', 'N4', true, NULL, '{"ブツ","モツ"}', '{"もの","もの-"}', '{"vật"}', 'minato', '{"thing","object","matter"}', 'vật, đồ vật', 'minna-no-nihongo', 'Các loài sinh ở trong trời đất đều gọi là vật cả', 8, 3, 93, 215, '{"勿","牛","勹","ノ"}', 203),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '使', 'N4', 'N4', true, NULL, '{"シ"}', '{"つか.う","つか.い","-つか.い","-づか.い"}', '{"sử"}', 'minato', '{"use","send on a mission","order","messenger"}', NULL, NULL, 'Khiến', 8, 3, 9, 219, '{"ノ","一","化","口"}', 204),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '所', 'N4', 'N3', true, NULL, '{"ショ"}', '{"ところ","-ところ","どころ","とこ"}', '{"sở"}', 'minato', '{"place","extent"}', 'Nơi', 'minato', 'Xứ sở', 8, 3, 63, 221, '{"斤","戸","一","尸"}', 205),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '始', 'N4', 'N4', true, NULL, '{"シ"}', '{"はじ.める","-はじ.める","はじ.まる"}', '{"thủy"}', 'minato', '{"commence","begin"}', NULL, NULL, 'Mới, trước', 8, 3, 38, 244, '{"口","女","厶"}', 206),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '空', 'N4', 'N4', true, NULL, '{"クウ"}', '{"そら","あ.く","あ.き","あ.ける","から","す.く","す.かす","むな.しい"}', '{"không"}', 'minato', '{"empty","sky","void","vacant"}', 'Bầu trời', 'minato', 'Rỗng không, hư không', 8, 1, 116, 304, '{"穴","工","儿","宀"}', 207),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '育', 'N4', 'N3', true, NULL, '{"イク"}', '{"そだ.つ","そだ.ち","そだ.てる","はぐく.む"}', '{"dục"}', 'minato', '{"bring up","grow up","raise","rear"}', NULL, NULL, 'Nuôi, nuôi cho khôn lớn gọi là dục', 8, 3, 130, 369, '{"月","亠","厶"}', 208),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '店', 'N4', 'N4', true, NULL, '{"テン"}', '{"みせ","たな"}', '{"điếm"}', 'minato', '{"store","shop"}', 'Cửa hàng', 'minato', 'Tiệm', 8, 2, 53, 378, '{"口","卜","广"}', 209),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '英', 'N4', 'N4', true, NULL, '{"エイ"}', '{"はなぶさ"}', '{"anh"}', 'minato', '{"England","English","hero","outstanding"}', NULL, NULL, 'Hoa các loài cây cỏ', 8, 4, 140, 430, '{"ノ","艾","大","冖"}', 210),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '味', 'N4', 'N4', true, NULL, '{"ミ"}', '{"あじ","あじ.わう"}', '{"vị"}', 'minato', '{"flavor","taste"}', 'Vị', 'minato', 'Mùi', 8, 3, 30, 442, '{"｜","口","二","ハ","木","亠"}', 211),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '若', 'N4', 'N3', true, NULL, '{"ジャク","ニャク","ニャ"}', '{"わか.い","わか-","も.しくわ","も.し","も.しくは","ごと.し"}', '{"nhược"}', 'minato', '{"young","if","perhaps","possibly"}', NULL, NULL, 'Thuận', 8, 6, 140, 458, '{"ノ","一","口","艾"}', 212),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '夜', 'N4', 'N4', true, NULL, '{"ヤ"}', '{"よ","よる"}', '{"dạ"}', 'minato', '{"night","evening"}', 'Đêm', 'minato', 'Ban đêm', 8, 2, 36, 487, '{"化","夕","亠"}', 213),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '注', 'N4', 'N4', true, NULL, '{"チュウ"}', '{"そそ.ぐ","さ.す","つ.ぐ"}', '{"chú"}', 'minato', '{"pour","irrigate","shed (tears)","flow into"}', NULL, NULL, 'Rót', 8, 3, 85, 497, '{"王","汁","丶"}', 214),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '歩', 'N4', 'N4', true, '步', '{"ホ","ブ","フ"}', '{"ある.く","あゆ.む"}', '{"bộ"}', 'minato', '{"walk","counter for steps"}', NULL, NULL, NULL, 8, 2, 77, 554, '{"ノ","止","小"}', 215),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '青', 'N4', 'N4', true, NULL, '{"セイ","ショウ"}', '{"あお","あお-","あお.い"}', '{"thanh"}', 'minato', '{"blue","green"}', 'màu xanh (xanh dương)', 'minna-no-nihongo', 'Màu xanh', 8, 1, 174, 589, '{"月","青","土","二","亠"}', 216),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '油', 'N4', 'N2', true, NULL, '{"ユ","ユウ"}', '{"あぶら"}', '{"du"}', 'minato', '{"oil","fat"}', 'Dầu', 'minato', 'Dầu', 8, 3, 85, 690, '{"｜","汁","日","田"}', 217),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '妻', 'N4', 'N3', true, NULL, '{"サイ"}', '{"つま"}', '{"thê"}', 'minato', '{"wife","spouse"}', 'Vợ', 'minato', 'Vợ cả', 8, 5, 38, 691, '{"｜","ヨ","一","女"}', 218),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '刻', 'N4', 'N3', true, NULL, '{"コク"}', '{"きざ.む","きざ.み"}', '{"khắc"}', 'minato', '{"engrave","cut fine","chop","hash"}', NULL, NULL, 'Khắc', 8, 6, 18, 866, '{"刈","亠","人","ノ","丶"}', 219),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '服', 'N4', 'N4', true, NULL, '{"フク"}', NULL, '{"phục"}', 'minato', '{"clothing","admit","obey","discharge"}', 'quần áo', 'minna-no-nihongo', 'Áo mặc', 8, 3, 74, 873, '{"月","又","卩"}', 220),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '泳', 'N4', 'N3', true, NULL, '{"エイ"}', '{"およ.ぐ"}', '{"vịnh"}', 'minato', '{"swim"}', NULL, NULL, 'Lặn, đi ngầm dưới đáy nước', 8, 3, 85, 1223, '{"汁","水","丶"}', 221),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '政', 'N4', 'N3', true, NULL, '{"セイ","ショウ"}', '{"まつりごと","まん"}', '{"chính"}', 'minato', '{"politics","government"}', NULL, NULL, 'Làm cho chính', 9, 5, 66, 17, '{"一","止","攵","乞"}', 222),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '発', 'N4', 'N4', true, '發', '{"ハツ","ホツ"}', '{"た.つ","あば.く","おこ.る","つか.わす","はな.つ"}', '{"phát"}', 'minato', '{"departure","discharge","publish","emit"}', NULL, NULL, 'Bắn ra', 9, 3, 105, 32, '{"二","儿","癶"}', 223),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '度', 'N4', 'N4', false, NULL, '{"ド","ト","タク"}', '{"たび","-た.い"}', '{"độ","đạc"}', 'thieu-chuu', '{"degrees","occurrence","time","counter for occurrences"}', NULL, NULL, 'Chia góc đồ tròn gọi là độ', 9, 3, 53, 110, '{"又","广","一","凵"}', 224),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '持', 'N4', 'N4', true, NULL, '{"ジ"}', '{"も.つ","-も.ち","も.てる"}', '{"trì"}', 'minato', '{"hold","have"}', NULL, NULL, 'Cầm, giữ', 9, 3, 64, 119, '{"寸","土","扎"}', 225),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '思', 'N4', 'N4', true, NULL, '{"シ"}', '{"おも.う","おもえら.く","おぼ.す"}', '{"tư"}', 'minato', '{"think"}', NULL, NULL, 'Nghĩ ngợi', 9, 2, 61, 132, '{"心","田"}', 226),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '県', 'N4', 'N2', true, '縣', '{"ケン"}', '{"か.ける"}', '{"huyện"}', 'minato', '{"prefecture"}', 'Huyện (tương đương', 'minato', 'Treo, cùng nghĩa với chữ huyền', 9, 3, 109, 140, '{"小","目"}', 227),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '界', 'N4', 'N4', true, NULL, '{"カイ"}', NULL, '{"giới"}', 'minato', '{"world","boundary"}', NULL, NULL, 'Cõi, mốc', 9, 3, 102, 158, '{"田","个","儿"}', 228),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '重', 'N4', 'N4', true, NULL, '{"ジュウ","チョウ"}', '{"え","おも.い","おも.り","おも.なう","かさ.ねる","かさ.なる","おも"}', '{"trọng"}', 'minato', '{"heavy","important","esteem","respect"}', NULL, NULL, 'Nặng', 9, 3, 166, 193, '{"｜","ノ","一","日","里"}', 229),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '海', 'N4', 'N4', true, NULL, '{"カイ"}', '{"うみ"}', '{"hải"}', 'minato', '{"sea","ocean"}', 'Biển', 'minato', 'Bể', 9, 2, 85, 200, '{"汁","母","毋","乞"}', 230),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '信', 'N4', 'N3', true, NULL, '{"シン"}', NULL, '{"tín"}', 'minato', '{"faith","truth","fidelity","trust"}', NULL, NULL, 'Tin, không sai lời hẹn là tín', 9, 4, 9, 208, '{"化","言"}', 231),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '品', 'N4', 'N4', true, NULL, '{"ヒン","ホン"}', '{"しな"}', '{"phẩm"}', 'minato', '{"goods","refinement","dignity","article"}', 'Hàng hoá', 'minato', 'Nhiều thứ', 9, 3, 30, 225, '{"口","品"}', 232),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '計', 'N4', 'N4', true, NULL, '{"ケイ"}', '{"はか.る","はか.らう"}', '{"kế"}', 'minato', '{"plot","plan","scheme","measure"}', NULL, NULL, 'Tính', 9, 2, 149, 228, '{"言","十"}', 233),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '変', 'N4', 'N3', true, '變', '{"ヘン"}', '{"か.わる","か.わり","か.える"}', '{"biến"}', 'minato', '{"unusual","change","strange"}', NULL, NULL, 'Biến đổi', 9, 4, 34, 238, '{"亠","夂"}', 234),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '建', 'N4', 'N4', false, NULL, '{"ケン","コン"}', '{"た.てる","た.て","-だ.て","た.つ"}', '{"kiến","kiển"}', 'thieu-chuu', '{"build"}', NULL, NULL, 'Dựng lên, đặt', 9, 4, 54, 300, '{"廴","聿"}', 235),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '急', 'N4', 'N4', true, NULL, '{"キュウ"}', '{"いそ.ぐ","いそ.ぎ","せ.く"}', '{"cấp"}', 'minato', '{"hurry","emergency","sudden","steep"}', NULL, NULL, 'Kíp', 9, 3, 61, 309, '{"ヨ","心","勹"}', 236),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '送', 'N4', 'N4', true, NULL, '{"ソウ"}', '{"おく.る"}', '{"tống"}', 'minato', '{"escort","send"}', NULL, NULL, 'Đưa đi', 9, 3, 162, 311, '{"込","并","大","一","二"}', 237),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '研', 'N4', 'N4', true, '揅', '{"ケン"}', '{"と.ぐ"}', '{"nghiên"}', 'minato', '{"polish","study of","sharpen"}', NULL, NULL, 'Xoa bóp', 9, 3, 112, 336, '{"｜","口","石","亅","廾","ノ","二","一"}', 238),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '乗', 'N4', 'N3', true, '乘', '{"ジョウ","ショウ"}', '{"の.る","-の.り","の.せる"}', '{"thừa"}', 'minato', '{"ride","power","multiplication","record"}', NULL, NULL, 'Cưỡi, đóng', 9, 3, 4, 377, '{"｜","ノ","一","禾","ハ"}', 239),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '待', 'N4', 'N4', true, NULL, '{"タイ"}', '{"ま.つ","-ま.ち"}', '{"đãi"}', 'minato', '{"wait","depend on"}', NULL, NULL, 'Ðợi', 9, 3, 60, 391, '{"寸","土","彳"}', 240),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '映', 'N4', 'N4', true, NULL, '{"エイ"}', '{"うつ.る","うつ.す","は.える","-ば.え"}', '{"ánh"}', 'minato', '{"reflect","reflection","projection"}', NULL, NULL, 'Ánh sáng giọi lại', 9, 6, 72, 404, '{"ノ","日","大","冖"}', 241),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '音', 'N4', 'N4', true, NULL, '{"オン","イン","-ノン"}', '{"おと","ね"}', '{"âm"}', 'minato', '{"sound","noise"}', 'âm thanh, tiếng', 'minna-no-nihongo', 'Tiếng', 9, 1, 180, 491, '{"音","日","立"}', 242),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '科', 'N4', 'N3', true, NULL, '{"カ"}', NULL, '{"khoa"}', 'minato', '{"department","course","section"}', NULL, NULL, 'Trình độ', 9, 2, 115, 531, '{"禾","斗"}', 243),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '室', 'N4', 'N4', true, NULL, '{"シツ"}', '{"むろ"}', '{"thất"}', 'minato', '{"room","apartment","chamber","greenhouse"}', NULL, NULL, 'Cái nhà', 9, 2, 40, 550, '{"至","土","厶","宀"}', 244),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '客', 'N4', 'N3', true, NULL, '{"キャク","カク"}', NULL, '{"khách"}', 'minato', '{"guest","visitor","customer","client"}', 'Khách hàng', 'minato', 'Khách, đối lại với chủ', 9, 3, 40, 557, '{"口","夂","宀"}', 245),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '風', 'N4', 'N4', true, NULL, '{"フウ","フ"}', '{"かぜ","かざ-"}', '{"phong"}', 'minato', '{"wind","air","style","manner"}', 'Gió', 'minato', 'Gió', 9, 2, 182, 558, '{"風","几","虫","ノ"}', 246),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '春', 'N4', 'N4', true, NULL, '{"シュン"}', '{"はる"}', '{"xuân"}', 'minato', '{"springtime","spring (season)"}', 'Mùa xuân', 'minato', 'Mùa xuân', 9, 2, 72, 579, '{"一","二","日","人","大"}', 247),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '屋', 'N4', 'N4', true, NULL, '{"オク"}', '{"や"}', '{"ốc"}', 'minato', '{"roof","house","shop","dealer"}', NULL, NULL, 'Nhà ở', 9, 3, 44, 616, '{"至","土","厶","尸"}', 248),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '秋', 'N4', 'N4', true, NULL, '{"シュウ"}', '{"あき","とき"}', '{"thu"}', 'minato', '{"autumn"}', 'Mùa thu', 'minato', 'Mùa thu', 9, 2, 115, 635, '{"火","禾"}', 249),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '便', 'N4', 'N3', true, NULL, '{"ベン","ビン"}', '{"たよ.り"}', '{"tiện"}', 'minato', '{"convenience","facility","excrement","feces"}', NULL, NULL, 'Tiện', 9, 4, 9, 729, '{"｜","ノ","一","化","日","田"}', 250),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '洋', 'N4', 'N4', true, NULL, '{"ヨウ"}', NULL, '{"dương"}', 'minato', '{"ocean","sea","foreign","Western style"}', NULL, NULL, 'Bể lớn', 9, 3, 85, 763, '{"王","汁","并","羊"}', 251),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '紀', 'N4', 'N1', true, NULL, '{"キ"}', NULL, '{"kỉ"}', 'minato', '{"chronicle","account","narrative","history"}', NULL, NULL, 'Gỡ sợi tơ', 9, 5, 120, 780, '{"糸","幺","小","已"}', 252),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '星', 'N4', 'N2', true, NULL, '{"セイ","ショウ"}', '{"ほし","-ぼし"}', '{"tinh"}', 'minato', '{"star","spot","dot","mark"}', 'Ngôi sao', 'minato', 'Sao', 9, 2, 72, 844, '{"生","日"}', 253),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '草', 'N4', 'N3', true, NULL, '{"ソウ"}', '{"くさ","くさ-","-ぐさ"}', '{"thảo"}', 'minato', '{"grass","weeds","herbs","pasture"}', 'Cỏ', 'minato', 'Cỏ', 9, 1, 140, 967, '{"十","日","艾"}', 254),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '昼', 'N4', 'N4', true, NULL, '{"チュウ"}', '{"ひる"}', '{"trú"}', 'minato', '{"daytime","noon"}', 'Trưa', 'minato', 'Ban ngày', 9, 2, 72, 1115, '{"一","日","尸","丶"}', 255),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '茶', 'N4', 'N4', true, NULL, '{"チャ","サ"}', NULL, '{"trà"}', 'minato', '{"tea"}', NULL, NULL, 'Cây chè (trà)', 9, 2, 140, 1116, '{"个","艾","木"}', 256),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '員', 'N4', 'N4', true, NULL, '{"イン"}', NULL, '{"viên"}', 'minato', '{"employee","member","number","the one in charge"}', NULL, NULL, 'Số quan', 10, 3, 30, 54, '{"貝","目","ハ","口"}', 257),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '通', 'N4', 'N4', true, NULL, '{"ツウ","ツ"}', '{"とお.る","とお.り","-とお.り","-どお.り","とお.す","とお.し","-どお.し","かよ.う"}', '{"thông"}', 'minato', '{"traffic","pass through","avenue","commute"}', NULL, NULL, 'Thông suốt', 10, 2, 162, 80, '{"込","用","マ"}', 258),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '家', 'N4', 'N4', true, NULL, '{"カ","ケ"}', '{"いえ","や","うち"}', '{"gia"}', 'minato', '{"house","home","family","professional"}', 'Nhà', 'minato', 'Ở', 10, 2, 40, 133, '{"宀","豕"}', 259),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '院', 'N4', 'N4', true, NULL, '{"イン"}', NULL, '{"viện"}', 'minato', '{"Inst.","institution","temple","mansion"}', NULL, NULL, 'Tường bao chung quanh', 10, 3, 170, 150, '{"二","儿","宀","阡","元"}', 260),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '原', 'N4', 'N3', true, NULL, '{"ゲン"}', '{"はら"}', '{"nguyên"}', 'minato', '{"meadow","original","primitive","field"}', 'Cánh đồng', 'minato', 'Cánh đồng', 10, 2, 27, 172, '{"小","白","厂"}', 261),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '特', 'N4', 'N4', true, NULL, '{"トク"}', NULL, '{"đặc"}', 'minato', '{"special"}', NULL, NULL, 'Con trâu đực', 10, 4, 93, 234, '{"牛","寸","土"}', 262),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '能', 'N4', 'N3', true, NULL, '{"ノウ"}', '{"よ.く","あた.う"}', '{"năng"}', 'minato', '{"ability","talent","skill","capacity"}', NULL, NULL, 'Tài năng', 10, 5, 130, 273, '{"月","匕","厶"}', 263),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '真', 'N4', 'N4', true, NULL, '{"シン"}', '{"ま","ま-","まこと"}', '{"chân"}', 'minato', '{"true","reality","Buddhist sect"}', NULL, NULL, 'Dùng như chữ chân', 10, 3, 109, 279, '{"一","十","ハ","目"}', 264),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '料', 'N4', 'N4', true, NULL, '{"リョウ"}', NULL, '{"liệu"}', 'minato', '{"fee","materials"}', NULL, NULL, 'Ðo đắn, lường tính, liệu', 10, 4, 68, 295, '{"斗","米"}', 265),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '起', 'N4', 'N4', false, NULL, '{"キ"}', '{"お.きる","お.こる","お.こす","おこ.す","た.つ"}', '{"khởi"}', 'thieu-chuu', '{"rouse","wake up","get up"}', NULL, NULL, 'Dậy, cất mình lên, trổi dậy', 10, 3, 156, 374, '{"走","土","已"}', 266),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '病', 'N4', 'N4', true, NULL, '{"ビョウ","ヘイ"}', '{"や.む","-や.み","やまい"}', '{"bệnh"}', 'minato', '{"ill","sick"}', NULL, NULL, 'Ốm', 10, 3, 104, 384, '{"一","人","冂","疔"}', 267),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '帰', 'N4', 'N4', true, '歸', '{"キ"}', '{"かえ.る","かえ.す","おく.る","とつ.ぐ"}', '{"quy"}', 'minato', '{"homecoming","arrive at","lead to","result in"}', NULL, NULL, 'Về', 10, 2, 50, 504, '{"ヨ","刈","巾","冖"}', 268),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '紙', 'N4', 'N4', true, NULL, '{"シ"}', '{"かみ"}', '{"chỉ"}', 'minato', '{"paper"}', 'Giấy', 'minato', 'Giấy', 10, 2, 120, 559, '{"氏","糸","幺","小"}', 269),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '速', 'N4', 'N3', true, NULL, '{"ソク"}', '{"はや.い","はや-","はや.める","すみ.やか"}', '{"tốc"}', 'minato', '{"quick","fast"}', NULL, NULL, 'Nhanh chóng', 10, 3, 162, 576, '{"｜","一","口","込","ハ","木"}', 270),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '降', 'N4', 'N3', true, NULL, '{"コウ","ゴ"}', '{"お.りる","お.ろす","ふ.る","ふ.り","くだ.る","くだ.す"}', '{"giáng"}', 'minato', '{"descend","precipitate","fall","surrender"}', NULL, NULL, 'Rụng xuống', 10, 6, 170, 596, '{"夂","阡","十"}', 271),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '馬', 'N4', 'N3', true, NULL, '{"バ"}', '{"うま","うま-","ま"}', '{"mã"}', 'minato', '{"horse"}', 'Con ngựa', 'minato', 'Con ngựa', 10, 2, 187, 639, '{"馬","杰"}', 272),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '夏', 'N4', 'N4', true, NULL, '{"カ","ガ","ゲ"}', '{"なつ"}', '{"hạ"}', 'minato', '{"summer"}', 'Mùa hạ', 'minato', 'Mùa hè', 10, 2, 35, 659, '{"一","自","夂","目"}', 273),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '旅', 'N4', 'N4', true, NULL, '{"リョ"}', '{"たび"}', '{"lữ"}', 'minato', '{"trip","travel"}', 'Chuyến đi', 'minato', 'Lữ', 10, 3, 70, 783, '{"ノ","方","乞"}', 274),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '借', 'N4', 'N4', false, NULL, '{"シャク"}', '{"か.りる"}', '{"tá"}', 'thieu-chuu', '{"borrow","rent"}', NULL, NULL, 'Vay mượn', 10, 4, 9, 932, '{"化","日","廾","二"}', 275),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '弱', 'N4', 'N2', true, NULL, '{"ジャク"}', '{"よわ.い","よわ.る","よわ.まる","よわ.める"}', '{"nhược"}', 'minato', '{"weak","frail"}', NULL, NULL, 'Yếu, suy', 10, 2, 57, 958, '{"弓","冫"}', 276),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '酒', 'N4', 'N3', true, NULL, '{"シュ"}', '{"さけ","さか-"}', '{"tửu"}', 'minato', '{"sake","alcohol"}', 'Rượu', 'minato', 'Rượu', 10, 3, 164, 1006, '{"汁","酉"}', 277),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '勉', 'N4', 'N4', true, NULL, '{"ベン"}', '{"つと.める"}', '{"miễn"}', 'minato', '{"exertion","endeavour","encourage","strive"}', NULL, NULL, 'Cố sức', 10, 3, 19, 1066, '{"力","免","儿","勹"}', 278),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '荷', 'N4', 'N2', true, NULL, '{"カ"}', '{"に"}', '{"hà"}', 'minato', '{"baggage","shoulder-pole load","bear (a burden)","shoulder (a gun)"}', NULL, NULL, 'Hoa sen', 10, 3, 140, 1230, '{"化","口","亅","艾","一"}', 279),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '部', 'N4', 'N3', true, NULL, '{"ブ"}', '{"-べ"}', '{"bộ"}', 'minato', '{"section","bureau","dept","class"}', NULL, NULL, NULL, 11, 3, 163, 36, '{"口","邦","立"}', 280),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '問', 'N4', 'N4', true, NULL, '{"モン"}', '{"と.う","と.い","とん"}', '{"vấn"}', 'minato', '{"question","ask","problem"}', NULL, NULL, 'Hỏi', 11, 3, 30, 64, '{"口","門"}', 281),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '動', 'N4', 'N4', true, NULL, '{"ドウ"}', '{"うご.く","うご.かす"}', '{"động"}', 'minato', '{"move","motion","change","confusion"}', NULL, NULL, 'Ðộng', 11, 3, 19, 73, '{"｜","一","日","力","里","ノ"}', 282),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '経', 'N4', 'N3', true, '經', '{"ケイ","キョウ","キン"}', '{"へ.る","た.つ","たていと","はか.る","のり"}', '{"kinh"}', 'minato', '{"sutra","longitude","pass thru","expire"}', NULL, NULL, 'Thường', 11, 5, 120, 79, '{"糸","幺","小","土","又"}', 283),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '理', 'N4', 'N4', true, NULL, '{"リ"}', '{"ことわり"}', '{"lý"}', 'minato', '{"logic","arrangement","reason","justice"}', NULL, NULL, 'Sửa ngọc, làm ngọc', 11, 2, 96, 86, '{"王","里"}', 284),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '強', 'N4', 'N4', true, '强', '{"キョウ","ゴウ"}', '{"つよ.い","つよ.まる","つよ.める","し.いる","こわ.い"}', '{"cường"}', 'minato', '{"strong"}', NULL, NULL, 'Mạnh, cũng như chữ cường', 11, 2, 57, 112, '{"弓","虫","厶"}', 285),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '野', 'N4', 'N4', true, NULL, '{"ヤ","ショ"}', '{"の","の-"}', '{"dã"}', 'minato', '{"plains","field","rustic","civilian life"}', NULL, NULL, 'Ðồng', 11, 2, 166, 120, '{"矛","里","亅"}', 286),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '都', 'N4', 'N3', true, NULL, '{"ト","ツ"}', '{"みやこ"}', '{"đô"}', 'minato', '{"metropolis","capital","all","everything"}', 'Thủ đô', 'minato', 'Kinh đô, kẻ chợ', 11, 3, 163, 123, '{"日","邦","老"}', 287),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '教', 'N4', 'N4', true, NULL, '{"キョウ"}', '{"おし.える","おそ.わる"}', '{"giáo"}', 'minato', '{"teach","faith","doctrine"}', NULL, NULL, 'Cũng như chữ giáo', 11, 2, 66, 166, '{"子","老","攵","乞"}', 288),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '済', 'N4', 'N3', true, '濟', '{"サイ","セイ"}', '{"す.む","-ず.み","-ずみ","す.まない","す.ます","-す.ます","すく.う","な.す","わたし","わた.る"}', '{"tế"}', 'minato', '{"settle (debt, etc.)","relieve (burden)","finish","come to an end"}', NULL, NULL, 'Sông Tể', 11, 6, 85, 168, '{"｜","ノ","汁","文","廾","斉"}', 289),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '終', 'N4', 'N4', true, NULL, '{"シュウ"}', '{"お.わる","-お.わる","おわ.る","お.える","つい","つい.に"}', '{"chung"}', 'minato', '{"end","finish"}', NULL, NULL, 'Hết', 11, 3, 120, 256, '{"糸","幺","小","夂"}', 290),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '球', 'N4', 'N3', true, NULL, '{"キュウ"}', '{"たま"}', '{"cầu"}', 'minato', '{"ball","sphere"}', NULL, NULL, 'Cái khánh ngọc', 11, 3, 96, 302, '{"王","水","丶"}', 291),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '転', 'N4', 'N4', false, '轉', '{"テン"}', '{"ころ.がる","ころ.げる","ころ.がす","ころ.ぶ","まろ.ぶ","うたた","うつ.る","くる.めく"}', '{"chuyển","chuyến"}', 'thieu-chuu', '{"revolve","turn around","change"}', NULL, NULL, 'Quay vòng', 11, 3, 159, 327, '{"車","二","厶"}', 292),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '族', 'N4', 'N4', true, NULL, '{"ゾク"}', NULL, '{"tộc"}', 'minato', '{"tribe","family"}', NULL, NULL, 'Loài', 11, 3, 70, 393, '{"方","矢","乞"}', 293),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '悪', 'N4', 'N4', false, '惡', '{"アク","オ"}', '{"わる.い","わる-","あ.し","にく.い","-にく.い","ああ","いずくに","いずくんぞ","にく.む"}', '{"ác","ố","ô"}', 'thieu-chuu', '{"bad","vice","rascal","false"}', NULL, NULL, 'Ác', 11, 3, 61, 530, '{"｜","一","口","心"}', 294),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '細', 'N4', 'N2', true, NULL, '{"サイ"}', '{"ほそ.い","ほそ.る","こま.か","こま.かい"}', '{"tế"}', 'minato', '{"dainty","get thin","taper","slender"}', NULL, NULL, 'Nhỏ', 11, 2, 120, 537, '{"糸","幺","小","田"}', 295),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '週', 'N4', 'N4', true, NULL, '{"シュウ"}', NULL, '{"chu"}', 'minato', '{"week"}', NULL, NULL, 'Vòng khắp', 11, 2, 162, 540, '{"口","込","土","冂"}', 296),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '黒', 'N4', 'N4', true, '黑', '{"コク"}', '{"くろ","くろ.ずむ","くろ.い"}', '{"hắc"}', 'minato', '{"black"}', 'màu đen', 'minna-no-nihongo', 'Sắc đen, đen kịt', 11, 2, 203, 573, '{"黒","里","杰"}', 297),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '婦', 'N4', 'N3', true, NULL, '{"フ"}', '{"よめ"}', '{"phụ"}', 'minato', '{"lady","woman","wife","bride"}', NULL, NULL, 'Vợ', 11, 5, 38, 671, '{"ヨ","巾","女","冖"}', 298),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '宿', 'N4', 'N3', true, NULL, '{"シュク"}', '{"やど","やど.る","やど.す"}', '{"túc"}', 'minato', '{"inn","lodging","relay station","dwell"}', 'Chỗ trọ', 'minato', 'Ðỗ', 11, 3, 40, 701, '{"化","白","宀"}', 299),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '習', 'N4', 'N4', true, NULL, '{"シュウ","ジュ"}', '{"なら.う","なら.い"}', '{"tập"}', 'minato', '{"learn"}', NULL, NULL, 'Học đi học lại', 11, 3, 124, 706, '{"羽","白","冫"}', 300),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '船', 'N4', 'N3', true, NULL, '{"セン"}', '{"ふね","ふな-"}', '{"thuyền","chu"}', 'minato', '{"ship","boat"}', 'Thuyền', 'minato', 'Cái thuyền', 11, 2, 137, 713, '{"口","舟","ハ"}', 301),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '閉', 'N4', 'N3', true, NULL, '{"ヘイ"}', '{"と.じる","と.ざす","し.める","し.まる","た.てる"}', '{"bế"}', 'minato', '{"closed","shut"}', NULL, NULL, 'Ðóng cửa', 11, 6, 169, 951, '{"ノ","一","門","亅"}', 302),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '堂', 'N4', 'N4', false, NULL, '{"ドウ"}', NULL, '{"đường"}', 'thieu-chuu', '{"public chamber","hall"}', NULL, NULL, 'Gian nhà chính giữa', 11, 5, 32, 1010, '{"口","尚","土","冖"}', 303),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '鳥', 'N4', 'N4', true, NULL, '{"チョウ"}', '{"とり"}', '{"điểu"}', 'minato', '{"bird","chicken"}', 'chim', 'minna-no-nihongo', 'Loài chim, con chim', 11, 2, 196, 1043, '{"鳥","杰"}', 304),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '雪', 'N4', 'N3', true, NULL, '{"セツ"}', '{"ゆき"}', '{"tuyết"}', 'minato', '{"snow"}', 'Tuyết', 'minato', 'Tuyết', 11, 2, 173, 1131, '{"ヨ","雨"}', 305),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '魚', 'N4', 'N4', false, NULL, '{"ギョ"}', '{"うお","さかな","-ざかな"}', '{"ngư"}', 'thieu-chuu', '{"fish"}', 'cá', 'minna-no-nihongo', 'Con cá', 11, 2, 195, 1208, '{"魚","田","杰"}', 306),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '黄', 'N4', 'N2', true, NULL, '{"コウ","オウ"}', '{"き","こ-"}', '{"hoàng"}', 'minato', '{"yellow"}', NULL, NULL, 'Cũng như chữ hoàng', 11, 2, 201, 1240, '{"黄","田","ハ"}', 307),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '菜', 'N4', 'N2', true, NULL, '{"サイ"}', '{"な"}', '{"thái"}', 'minato', '{"vegetable","side dish","greens"}', NULL, NULL, 'Rau', 11, 4, 140, 1327, '{"爪","木","艾"}', 308),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '場', 'N4', 'N4', true, NULL, '{"ジョウ","チョウ"}', '{"ば"}', '{"tràng","trường"}', 'minato', '{"location","place"}', NULL, NULL, 'Sân', 12, 2, 32, 52, '{"土","日","一","勿"}', 309),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '開', 'N4', 'N4', true, NULL, '{"カイ"}', '{"ひら.く","ひら.き","-びら.き","ひら.ける","あ.く","あ.ける"}', '{"khai"}', 'minato', '{"open","unfold","unseal"}', NULL, NULL, 'Mở', 12, 3, 169, 59, '{"一","門","廾","二","ノ"}', 310),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '最', 'N4', 'N3', true, NULL, '{"サイ","シュ"}', '{"もっと.も","つま"}', '{"tối"}', 'minato', '{"utmost","most","extreme"}', NULL, NULL, 'Rất', 12, 4, 73, 82, '{"一","耳","日","又"}', 311),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '道', 'N4', 'N4', true, NULL, '{"ドウ","トウ"}', '{"みち","いう"}', '{"đạo","giả"}', 'minato', '{"road-way","street","district","journey"}', 'Đường', 'minato', 'Đường cái thẳng', 12, 2, 162, 207, '{"込","自","并","首"}', 312),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '集', 'N4', 'N4', true, NULL, '{"シュウ"}', '{"あつ.まる","あつ.める","つど.う"}', '{"tập"}', 'minato', '{"gather","meet","congregate","swarm"}', NULL, NULL, 'Đậu', 12, 3, 172, 210, '{"木","隹"}', 313),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '朝', 'N4', 'N4', true, NULL, '{"チョウ"}', '{"あさ"}', '{"triều"}', 'minato', '{"morning","dynasty","regime","epoch"}', 'Sáng', 'minato', 'Sớm, sáng mai', 12, 2, 74, 248, '{"月","十","日"}', 314),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '運', 'N4', 'N4', true, NULL, '{"ウン"}', '{"はこ.ぶ"}', '{"vận"}', 'minato', '{"carry","luck","destiny","fate"}', NULL, NULL, 'Xoay vần', 12, 3, 162, 255, '{"込","車","冖"}', 315),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '過', 'N4', 'N3', true, NULL, '{"カ"}', '{"す.ぎる","す.ごす","あやま.ち","あやま.つ","よぎ.る","よ.ぎる"}', '{"quá"}', 'minato', '{"overdo","exceed","go beyond","error"}', NULL, NULL, 'Vượt', 12, 5, 162, 285, '{"口","込","冂"}', 316),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '番', 'N4', 'N3', true, NULL, '{"バン"}', '{"つが.い"}', '{"phiên"}', 'minato', '{"turn","number in a series"}', NULL, NULL, 'Lần lượt', 12, 2, 102, 348, '{"田","釆","米"}', 317),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '着', 'N4', 'N4', true, NULL, '{"チャク","ジャク"}', '{"き.る","き.せる","つ.く","つ.ける"}', '{"trứ"}', 'minato', '{"don","arrive","wear","counter for suits of clothing"}', NULL, NULL, 'Tục dùng như chữ khán', 12, 3, 109, 376, '{"ノ","王","并","目","羊"}', 318),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '然', 'N4', 'N3', true, NULL, '{"ゼン","ネン"}', '{"しか","しか.り","しか.し","さ"}', '{"nhiên"}', 'minato', '{"sort of thing","so","if so","in that case"}', NULL, NULL, 'Ðốt cháy', 12, 4, 86, 401, '{"犬","夕","杰"}', 319),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '答', 'N4', 'N4', true, NULL, '{"トウ"}', '{"こた.える","こた.え"}', '{"đáp"}', 'minato', '{"solution","answer"}', NULL, NULL, 'Báo đáp, đáp lại', 12, 2, 118, 486, '{"口","竹","个","一","乞"}', 320),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '買', 'N4', 'N4', false, NULL, '{"バイ"}', '{"か.う"}', '{"mãi"}', 'thieu-chuu', '{"buy"}', NULL, NULL, 'Mua, lấy tiền đổi lấy đồ là mãi', 12, 2, 154, 520, '{"貝","目","ハ","買"}', 321),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '短', 'N4', 'N2', true, NULL, '{"タン"}', '{"みじか.い"}', '{"đoản"}', 'minato', '{"short","brevity","fault","defect"}', NULL, NULL, 'Ngắn', 12, 3, 111, 689, '{"口","豆","并","矢","乞"}', 322),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '散', 'N4', 'N3', true, NULL, '{"サン"}', '{"ち.る","ち.らす","-ち.らす","ち.らかす","ち.らかる","ち.らばる","ばら","ばら.ける"}', '{"tản"}', 'minato', '{"scatter","disperse","spend","squander"}', NULL, NULL, 'Tan', 12, 4, 66, 758, '{"月","攵","廾","二","乞"}', 323),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '軽', 'N4', 'N2', true, '輕', '{"ケイ","キョウ","キン"}', '{"かる.い","かろ.やか","かろ.んじる"}', '{"khinh"}', 'minato', '{"lightly","trifling","unimportant"}', NULL, NULL, 'Nhẹ', 12, 3, 159, 790, '{"車","土","又"}', 324),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '遅', 'N4', 'N3', true, NULL, '{"チ"}', '{"おく.れる","おく.らす","おそ.い"}', '{"trì"}', 'minato', '{"slow","late","back","later"}', NULL, NULL, 'Tục dùng như chữ trì', 12, 8, 162, 833, '{"王","込","并","羊","尸"}', 325),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '飲', 'N4', 'N4', false, '飮', '{"イン","オン"}', '{"の.む","-の.み"}', '{"ẩm","ấm"}', 'thieu-chuu', '{"drink","smoke","take"}', NULL, NULL, 'Đồ uống', 12, 3, 184, 969, '{"欠","食"}', 326),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '貸', 'N4', 'N4', false, NULL, '{"タイ"}', '{"か.す","か.し-","かし-"}', '{"thải","thắc"}', 'thieu-chuu', '{"lend"}', NULL, NULL, 'Vay, cho vay', 12, 5, 154, 995, '{"化","貝","目","ハ","弋"}', 327),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '奥', 'N4', 'N2', true, NULL, '{"オウ"}', '{"おく","おく.まる","くま"}', '{"áo"}', 'minato', '{"heart","interior"}', 'Bên trong', 'minato', 'Thần áo', 12, 8, 37, 1018, '{"大","米","冂"}', 328),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '晴', 'N4', 'N3', true, NULL, '{"セイ"}', '{"は.れる","は.れ","は.れ-","-ば.れ","は.らす"}', '{"tình"}', 'minato', '{"clear up"}', NULL, NULL, 'Tạnh, lúc không mưa gọi là tình', 12, 2, 72, 1022, '{"月","青","土","二","日","亠"}', 329),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '飯', 'N4', 'N4', true, NULL, '{"ハン"}', '{"めし"}', '{"phạn"}', 'minato', '{"meal","boiled rice"}', 'Cơm', 'minato', 'Cơm', 12, 4, 184, 1046, '{"食","又","厂"}', 330),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '雲', 'N4', 'N2', true, NULL, '{"ウン"}', '{"くも","-ぐも"}', '{"vân"}', 'minato', '{"cloud"}', NULL, NULL, 'Mây', 12, 2, 173, 1256, '{"一","雨","二","厶"}', 331),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '湖', 'N4', 'N2', true, NULL, '{"コ"}', '{"みずうみ"}', '{"hồ"}', 'minato', '{"lake"}', 'Cái hồ', 'minato', 'Cái hồ', 12, 3, 85, 1344, '{"月","口","十","汁"}', 332),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '晩', 'N4', 'N3', true, '晚', '{"バン"}', NULL, '{"vãn"}', 'minato', '{"nightfall","night"}', 'Tối', 'minato', 'Chiều, muộn', 12, 6, 72, 1424, '{"免","日","儿","勹"}', 333),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '暑', 'N4', 'N1', true, NULL, '{"ショ"}', '{"あつ.い"}', '{"thử"}', 'minato', '{"sultry","hot","summer heat"}', NULL, NULL, 'Nắng, nóng', 12, 3, 72, 1442, '{"日","老"}', 334),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '寒', 'N4', 'N3', true, NULL, '{"カン"}', '{"さむ.い"}', '{"hàn"}', 'minato', '{"cold"}', NULL, NULL, 'Rét, khí hậu mùa đông', 12, 3, 40, 1456, '{"一","ハ","宀","丶","井"}', 335),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '業', 'N4', 'N4', false, NULL, '{"ギョウ","ゴウ"}', '{"わざ"}', '{"nghiệp"}', 'thieu-chuu', '{"business","vocation","arts","performance"}', NULL, NULL, 'Nghiệp', 13, 3, 75, 43, '{"｜","一","王","并","木","羊","耒"}', 336),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '新', 'N4', 'N4', false, NULL, '{"シン"}', '{"あたら.しい","あら.た","あら-","にい-"}', '{"tân"}', 'thieu-chuu', '{"new"}', NULL, NULL, 'Mới', 13, 2, 69, 51, '{"斤","辛","并","木","立","亠"}', 337),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '意', 'N4', 'N4', true, NULL, '{"イ"}', NULL, '{"ý"}', 'minato', '{"idea","mind","heart","taste"}', NULL, NULL, 'Ý chí', 13, 3, 61, 99, '{"音","心","日","立"}', 338),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '数', 'N4', 'N3', true, NULL, '{"スウ","ス","サク","ソク","シュ"}', '{"かず","かぞ.える","しばしば","せ.める","わずらわ.しい"}', '{"số"}', 'minato', '{"number","strength","fate","law"}', 'Số', 'minato', 'Ðếm', 13, 2, 66, 148, '{"女","米","攵","夂","乞"}', 339),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '楽', 'N4', 'N4', true, '樂', '{"ガク","ラク","ゴウ"}', '{"たの.しい","たの.しむ","この.む"}', '{"lạc"}', 'minato', '{"music","comfort","ease"}', NULL, NULL, 'Nhạc', 13, 2, 75, 373, '{"白","木","冫"}', 340),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '想', 'N4', 'N3', true, NULL, '{"ソウ","ソ"}', '{"おも.う"}', '{"tưởng"}', 'minato', '{"idea","thought","conception","think"}', NULL, NULL, 'Tưởng tượng', 13, 3, 61, 381, '{"心","木","目"}', 341),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '試', 'N4', 'N4', true, NULL, '{"シ"}', '{"こころ.みる","ため.す"}', '{"thí"}', 'minato', '{"test","try","attempt","experiment"}', NULL, NULL, 'Thử', 13, 4, 149, 392, '{"言","工","弋"}', 342),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '働', 'N4', 'N3', true, NULL, '{"ドウ"}', '{"はたら.く"}', '{"động"}', 'minato', '{"work","(kokuji)"}', NULL, NULL, 'Tự mình vận động gọi là động', 13, 4, 9, 417, '{"｜","一","化","力","日","ノ"}', 343),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '園', 'N4', 'N3', true, NULL, '{"エン"}', '{"その"}', '{"viên"}', 'minato', '{"park","garden","yard","farm"}', NULL, NULL, 'Vườn', 13, 2, 31, 628, '{"衣","口","土","囗"}', 344),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '鉄', 'N4', 'N2', true, NULL, '{"テツ"}', '{"くろがね"}', '{"thiết"}', 'minato', '{"iron"}', 'Sắt thép', 'minato', 'Tục dùng như chữ thiết', 13, 3, 167, 672, '{"ノ","金","二","矢","大","乞"}', 345),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '遠', 'N4', 'N3', true, NULL, '{"エン","オン"}', '{"とお.い"}', '{"viễn"}', 'minato', '{"distant","far"}', NULL, NULL, 'Xa, trái lại với chữ cận', 13, 2, 162, 887, '{"衣","口","込","土"}', 346),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '漢', 'N4', 'N4', true, NULL, '{"カン"}', NULL, '{"hán"}', 'minato', '{"Sino-","China"}', NULL, NULL, 'Sông Hán', 13, 3, 85, 1487, '{"汁","艾","口","一","大","二"}', 347),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '銀', 'N4', 'N4', true, NULL, '{"ギン"}', '{"しろがね"}', '{"ngân"}', 'minato', '{"silver"}', NULL, NULL, 'Bạc (Argentum', 14, 3, 167, 395, '{"金","艮"}', 348),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '様', 'N4', 'N3', true, '樣', '{"ヨウ","ショウ"}', '{"さま","さん"}', '{"dạng"}', 'minato', '{"Esq.","way","manner","situation"}', 'Khách', 'minato', 'Hình dạng', 14, 3, 75, 493, '{"王","水","并","木","羊"}', 349),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '歌', 'N4', 'N4', true, NULL, '{"カ"}', '{"うた","うた.う"}', '{"ca"}', 'minato', '{"song","sing"}', 'Bài hát', 'minato', 'Ngợi hát', 14, 2, 76, 519, '{"一","欠","口","亅"}', 350),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '歴', 'N4', 'N2', true, '曆', '{"レキ","レッキ"}', NULL, '{"lịch"}', 'minato', '{"curriculum","continuation","passage of time"}', NULL, NULL, 'Cái vòng của mặt trời', 14, 5, 77, 632, '{"止","麻","木","厂","广"}', 351),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '練', 'N4', 'N2', true, NULL, '{"レン"}', '{"ね.る","ね.り"}', '{"luyện"}', 'minato', '{"practice","gloss","train","drill"}', NULL, NULL, 'Lụa chuội trắng nõn', 14, 3, 120, 788, '{"｜","糸","幺","小","日","ハ","木","田"}', 352),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '緑', 'N4', 'N2', true, '綠', '{"リョク","ロク"}', '{"みどり"}', '{"lục"}', 'minato', '{"green"}', 'Xanh lá', 'minato', 'Sắc xanh biếc', 14, 3, 120, 1180, '{"ヨ","糸","幺","小","水","隶"}', 353),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '鳴', 'N4', 'N3', true, NULL, '{"メイ"}', '{"な.く","な.る","な.らす"}', '{"minh"}', 'minato', '{"chirp","cry","bark","sound"}', NULL, NULL, 'Tiếng chim hót', 14, 2, 196, 1279, '{"口","鳥","杰"}', 354),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '確', 'N4', 'N3', true, NULL, '{"カク","コウ"}', '{"たし.か","たし.かめる"}', '{"xác"}', 'minato', '{"assurance","firm","tight","hard"}', NULL, NULL, 'Bền', 15, 5, 112, 252, '{"口","石","宀","隹"}', 355),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '質', 'N4', 'N4', true, NULL, '{"シツ","シチ","チ"}', '{"たち","ただ.す","もと","わりふ"}', '{"chất"}', 'minato', '{"substance","quality","matter","temperament"}', NULL, NULL, 'Thể chất', 15, 5, 154, 389, '{"貝","目","ハ","斤"}', 356),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '親', 'N4', 'N4', true, NULL, '{"シン"}', '{"おや","おや-","した.しい","した.しむ"}', '{"thân"}', 'minato', '{"parent","intimacy","relative","familiarity"}', 'Bố mẹ', 'minato', 'Tới luôn, quen', 16, 2, 147, 406, '{"見","辛","并","木","立","亠"}', 357),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '館', 'N4', 'N4', true, NULL, '{"カン"}', '{"やかた","たて"}', '{"quán"}', 'minato', '{"building","mansion","large building","palace"}', NULL, NULL, 'Quán trọ', 16, 3, 184, 613, '{"口","食","宀","｜"}', 358),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '薬', 'N4', 'N3', true, '藥', '{"ヤク"}', '{"くすり"}', '{"dược"}', 'minato', '{"medicine","chemical","enamel","gunpowder"}', 'Thuốc', 'minato', 'Thuốc', 16, 3, 140, 702, '{"日","木","冫","艾"}', 359),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '曇', 'N4', 'N2', true, NULL, '{"ドン"}', '{"くも.る"}', '{"đàm","vân"}', 'minato', '{"cloudy weather","cloud up"}', NULL, NULL, 'Mây chùm (mây bủa)', 16, 8, 72, 1899, '{"雨","二","日","厶"}', 360),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '題', 'N4', 'N4', true, NULL, '{"ダイ"}', NULL, '{"đề"}', 'minato', '{"topic","subject"}', NULL, NULL, 'Cái trán', 18, 3, 181, 96, '{"貝","目","ハ","日","疋","頁"}', 361),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '験', 'N4', 'N4', true, '驗', '{"ケン","ゲン"}', '{"あかし","しるし","ため.す","ためし"}', '{"nghiệm"}', 'minato', '{"verification","effect","testing"}', NULL, NULL, 'Chứng nghiệm', 18, 4, 187, 410, '{"口","人","馬","个","杰"}', 362),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '曜', 'N4', 'N4', false, NULL, '{"ヨウ"}', NULL, '{"diệu"}', 'thieu-chuu', '{"weekday"}', NULL, NULL, 'Bóng sáng mặt trời', 18, 2, 72, 940, '{"ヨ","日","隹"}', 363);

INSERT INTO jlpt_kanji_parts (site_id, part, unlocks_count, in_set, is_shape, radical_of, radical_strokes, han_viet, meaning_vi, meaning_en, meaning_classic, source, order_index) VALUES
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '一', 66, true, false, NULL, 1, 'nhất', 'số một', 'one', 'Một, là số đứng đầu các số đếm', 'kangxi-radical', 0),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '口', 54, true, false, NULL, 3, 'khẩu', 'cái miệng', 'mouth', 'Cái miệng', 'kangxi-radical', 1),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', 'ノ', 39, false, false, '丿', 1, 'phiệt', 'nét sổ xiên qua trái', NULL, NULL, 'kangxi-radical', 2),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '日', 33, true, false, NULL, 4, 'nhật', 'ngày, mặt trời', 'day', 'Mặt trời', 'kangxi-radical', 3),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '｜', 30, false, false, '〡', 1, 'cổn', 'nét sổ', NULL, NULL, 'kangxi-radical', 4),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '二', 26, true, false, NULL, 2, 'nhị', 'số hai', 'two', 'Hai, tên số đếm', 'kangxi-radical', 5),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '木', 26, true, false, NULL, 4, 'mộc', 'gỗ, cây cối', 'tree', 'Cây', 'kangxi-radical', 6),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '土', 24, true, false, NULL, 3, 'thổ', 'đất', 'soil', 'Ðất', 'kangxi-radical', 7),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '亠', 23, false, false, NULL, 2, 'đầu', NULL, 'kettle lid radical (no. 8)', 'Không có ý nghĩa gì', 'kangxi-radical', 8),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', 'ハ', 22, false, true, NULL, 0, NULL, NULL, NULL, NULL, NULL, 9),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '丶', 19, false, false, NULL, 1, 'chủ', 'điểm, chấm', 'dot', 'Phàm cái gì cần có phân biệt', 'kangxi-radical', 10),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '化', 19, true, false, NULL, 0, 'hóa', NULL, 'change', 'Biến hóa', 'thieu-chuu', 11),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '乞', 17, false, false, NULL, 0, 'khất', NULL, 'beg', 'Xin', 'thieu-chuu', 12),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '厶', 17, false, false, NULL, 2, 'khư, tư', 'riêng tư', 'I', 'Khư lư đồ ăn cơm', 'kangxi-radical', 13),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '田', 16, true, false, NULL, 5, 'điền', 'ruộng', 'rice field', 'Ruộng đất cầy cấy được gọi là điền', 'kangxi-radical', 14),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '儿', 15, false, false, NULL, 2, 'nhi', 'trẻ con', 'legs radical (no. 10)', 'Trẻ con', 'kangxi-radical', 15),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '王', 15, true, false, '玉', 5, 'ngọc', 'đá quý, ngọc', 'king', 'Vua', 'kangxi-radical', 16),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '并', 15, false, false, NULL, 0, 'tịnh', NULL, 'put together', 'Gồm, đều', 'thieu-chuu', 17),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '宀', 14, false, false, NULL, 3, 'miên', 'mái nhà, mái che', 'shaped crown', 'Lợp trùm nhà ngoài với nhà trong', 'kangxi-radical', 18),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '小', 14, true, false, NULL, 3, 'tiểu', 'nhỏ bé', 'little', 'Nhỏ', 'kangxi-radical', 19),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '十', 14, true, false, NULL, 2, 'thập', 'số mười', 'ten', 'Mười', 'kangxi-radical', 20),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '目', 13, true, false, NULL, 5, 'mục', 'mắt', 'eye', 'Con mắt', 'kangxi-radical', 21),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '大', 13, true, false, NULL, 3, 'đại', 'to lớn', 'large', 'Lớn', 'kangxi-radical', 22),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '月', 12, true, false, NULL, 4, 'nguyệt', 'tháng, mặt trăng', 'month', 'Mặt trăng', 'kangxi-radical', 23),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '冖', 11, false, false, NULL, 2, 'mịch', 'trùm khăn lên', 'wa-shaped crown radical (no. 14)', 'Trùm, lấy khăn trùm lên trên đồ', 'kangxi-radical', 24),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '込', 11, false, false, NULL, 0, 'liêu', NULL, 'crowded', NULL, 'kanjidic2-unverified', 25),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '汁', 11, false, false, NULL, 0, 'trấp', NULL, 'soup', 'Nước, nhựa', 'thieu-chuu', 26),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '冂', 10, false, false, NULL, 2, 'quynh', 'vùng biên giới xa; hoang địa', 'upside-down box radical (no. 13)', 'Ðất ở xa ngoài cõi nước', 'kangxi-radical', 27),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '个', 10, false, false, NULL, 0, 'cá', NULL, 'counter for articles', 'Tục dùng như chữ cá', 'thieu-chuu', 28),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '女', 9, true, false, NULL, 3, 'nữ', 'nữ giới, con gái, đàn bà', 'woman', 'Con gái', 'kangxi-radical', 29),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '人', 9, true, false, NULL, 2, 'nhân', 'người', 'person', 'Người', 'kangxi-radical', 30),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '艾', 9, false, false, NULL, 0, 'ngải', NULL, 'moxa', 'Cây ngải cứu', 'thieu-chuu', 31),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '亅', 9, false, false, NULL, 1, 'quyết', 'nét sổ có móc', 'feathered stick', 'Tức là cái nét xổ có móc', 'kangxi-radical', 32),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '夂', 9, false, false, NULL, 3, 'trĩ', 'đến ở phía sau', 'late', 'Bộ tri', 'kangxi-radical', 33),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', 'ヨ', 9, false, false, '彐', 3, 'kệ', 'đầu con nhím', NULL, NULL, 'kangxi-radical', 34),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '幺', 9, false, false, NULL, 3, 'yêu', 'nhỏ nhắn', 'short thread radical (no. 52)', 'Nhỏ', 'kangxi-radical', 35),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '勹', 9, false, false, NULL, 2, 'bao', 'bao bọc', 'wrapping enclosure', 'Bọc', 'kangxi-radical', 36),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '杰', 8, false, false, NULL, 0, 'kiệt', NULL, 'hero', 'Cũng như chữ kiệt', 'thieu-chuu', 37),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '糸', 8, true, false, NULL, 6, 'mịch', 'sợi tơ nhỏ', 'thread', 'Sợi tơ nhỏ', 'kangxi-radical', 38),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '又', 8, false, false, NULL, 2, 'hựu', 'lại nữa, một lần nữa', 'or again', 'Lại', 'kangxi-radical', 39),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '匕', 7, false, false, NULL, 2, 'chuỷ', 'cái thìa, cái muỗng', 'spoon', 'Cái thìa', 'kangxi-radical', 40),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '夕', 7, true, false, NULL, 3, 'tịch', 'đêm tối', 'evening', 'Buổi tối', 'kangxi-radical', 41),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '言', 7, true, false, NULL, 7, 'ngôn', 'nói', 'say', 'Nói, tự mình nói ra gọi là ngôn', 'kangxi-radical', 42),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '力', 7, true, false, NULL, 2, 'lực', 'sức mạnh', 'power', 'Sức', 'kangxi-radical', 43),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '心', 6, true, false, NULL, 4, 'tâm', 'quả tim, tâm trí, tấm lòng', 'heart', 'Tim', 'kangxi-radical', 44),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '立', 6, true, false, NULL, 5, 'lập', 'đứng, thành lập', 'stand up', 'Ðứng thẳng', 'kangxi-radical', 45),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '尸', 6, false, false, NULL, 3, 'thi', 'xác chết, thây ma', 'corpse', 'Thần thi', 'kangxi-radical', 46),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '囗', 6, false, false, NULL, 3, 'vi', 'vây quanh', 'box', 'Cổ văn là chữ vi', 'kangxi-radical', 47),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '廾', 6, false, false, NULL, 3, 'củng', 'chắp tay', 'twenty', 'Chắp tay', 'kangxi-radical', 48),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '門', 6, true, false, NULL, 8, 'môn', 'cửa hai cánh', 'gate', 'Cửa', 'kangxi-radical', 49),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '白', 6, true, false, NULL, 5, 'bạch', 'màu trắng', 'white', 'Sắc trắng', 'kangxi-radical', 50),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '里', 6, true, false, NULL, 7, 'lý', 'dặm; làng xóm', 'ri', 'Làng', 'kangxi-radical', 51),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '止', 6, true, false, NULL, 4, 'chỉ', 'dừng lại', 'stop', 'Dừng lại', 'kangxi-radical', 52),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '寸', 6, false, false, NULL, 3, 'thốn', 'đơn vị tấc (đo chiều dài)', 'measurement', 'Tấc, mười phân là một tấc', 'kangxi-radical', 53),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '矢', 5, false, false, NULL, 5, 'thỉ', 'cây tên, mũi tên', 'dart', 'Cái tên', 'kangxi-radical', 54),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '貝', 5, false, false, NULL, 7, 'bối', 'vật báu', 'shellfish', 'Con sò', 'kangxi-radical', 55),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '冫', 5, false, false, NULL, 2, 'băng', 'nước đá', 'two-stroke water radical or ice radical (no. 15)', 'Cùng nghĩa như chữ băng nước đá', 'kangxi-radical', 56),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '雨', 5, true, false, NULL, 8, 'vũ', 'mưa', 'rain', 'Mưa', 'kangxi-radical', 57),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '水', 5, true, false, NULL, 4, 'thuỷ', 'nước', 'water', 'Nước', 'kangxi-radical', 58),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '米', 5, false, false, NULL, 6, 'mễ', 'gạo', 'rice', 'Gạo', 'kangxi-radical', 59),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '禾', 5, false, false, NULL, 5, 'hòa', 'lúa', 'two-branch tree radical (no. 115)', 'Lúa', 'kangxi-radical', 60),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '尚', 5, false, false, NULL, 0, 'thượng', NULL, 'esteem', NULL, 'phienam', 61),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '子', 5, true, false, NULL, 3, 'tử', 'con', 'child', 'Con', 'kangxi-radical', 62),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '刈', 5, false, false, NULL, 0, 'ngải', NULL, 'reap', 'Cắt cỏ', 'thieu-chuu', 63),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '攵', 5, false, false, '攴', 4, 'phộc', 'đánh khẽ', 'strike', 'Ðánh sẽ', 'kangxi-radical', 64),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '老', 5, false, false, NULL, 6, 'lão', 'già', 'old man', 'Người già bảy mươi tuổi', 'kangxi-radical', 65),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '羊', 5, false, false, NULL, 6, 'dương', 'con dê', 'sheep', 'Con dê', 'kangxi-radical', 66),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '广', 5, false, false, NULL, 3, 'nghiễm', 'mái nhà', 'dotted cliff radical (no. 53)', 'Rộng', 'kangxi-radical', 67),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '士', 5, false, false, NULL, 3, 'sĩ', 'kẻ sĩ', 'gentleman', 'Học trò', 'kangxi-radical', 68),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '食', 4, true, false, NULL, 9, 'thực', 'ăn', 'eat', 'Đồ để ăn', 'kangxi-radical', 69),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '車', 4, true, false, NULL, 7, 'xa', 'chiếc xe', 'car', 'Cái xe', 'kangxi-radical', 70),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '卜', 4, false, false, NULL, 2, 'bốc', 'xem bói', 'divining', 'Bói rùa', 'kangxi-radical', 71),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '石', 4, true, false, NULL, 5, 'thạch', 'đá', 'stone', 'Ðá', 'kangxi-radical', 72),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '巾', 4, false, false, NULL, 3, 'cân', 'cái khăn', 'towel', 'Cái khăn', 'kangxi-radical', 73),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '斤', 4, false, false, NULL, 4, 'cân', 'cái búa, rìu', 'axe', 'Cái rìu', 'kangxi-radical', 74),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '工', 4, true, false, NULL, 3, 'công', 'người thợ, công việc', 'craft', 'Khéo, làm việc khéo gọi là công', 'kangxi-radical', 75),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '刀', 4, false, false, NULL, 2, 'đao', 'con dao, cây đao', 'sword', 'Con dao', 'kangxi-radical', 76),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '衣', 3, true, false, NULL, 6, 'y', 'áo', 'garment', 'Áo', 'kangxi-radical', 77),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '馬', 3, true, false, NULL, 10, 'mã', 'con ngựa', 'horse', 'Con ngựa', 'kangxi-radical', 78),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '自', 3, true, false, NULL, 6, 'tự', 'tự bản thân, kể từ', 'oneself', 'Bởi, từ', 'kangxi-radical', 79),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '斗', 3, false, false, NULL, 4, 'đẩu', 'cái đấu để đong', 'Big Dipper', 'Cái đấu', 'kangxi-radical', 80),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '火', 3, true, false, NULL, 4, 'hỏa', 'lửa', 'fire', 'Lửa', 'kangxi-radical', 81),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '凵', 3, false, false, NULL, 2, 'khảm', 'há miệng', 'open box enclosure', 'Há miệng', 'kangxi-radical', 82),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '毋', 3, false, false, NULL, 4, 'vô', 'chớ, đừng', 'do not', 'Chớ, đừng', 'kangxi-radical', 83),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '母', 3, true, false, NULL, 0, 'mẫu', NULL, 'mother', 'Mẹ', 'thieu-chuu', 84),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '隹', 3, false, false, NULL, 8, 'truy, chuy', 'chim đuôi ngắn', 'bird', 'Một cái tên chung để gọi giống chim đuôi ngắn', 'kangxi-radical', 85),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '九', 3, true, false, NULL, 0, 'cửu', NULL, 'nine', 'Chín, tên số đếm', 'thieu-chuu', 86),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '山', 3, true, false, NULL, 3, 'sơn', 'núi non', 'mountain', 'Núi', 'kangxi-radical', 87),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '牛', 3, true, false, NULL, 4, 'ngưu', 'trâu', 'cow', 'Con trâu', 'kangxi-radical', 88),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '虫', 3, true, false, NULL, 6, 'trùng', 'sâu bọ', 'insect', 'Nguyên là chữ', 'kangxi-radical', 89),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '弓', 3, false, false, NULL, 3, 'cung', 'cái cung (để bắn tên)', 'bow', 'Cái cung', 'kangxi-radical', 90),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '金', 3, true, false, NULL, 8, 'kim', 'kim loại; vàng', 'gold', 'Loài kim', 'kangxi-radical', 91),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '厂', 3, false, false, NULL, 2, 'hán, xưởng', 'sườn núi, vách đá', 'wild goose', 'Cái xưởng', 'kangxi-radical', 92),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '干', 3, false, false, NULL, 3, 'can', 'thiên can, can dự', 'dry', 'Phạm', 'kangxi-radical', 93),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '彳', 3, false, false, NULL, 3, 'xích', 'bước chân trái', 'stop', 'Bước ngắn', 'kangxi-radical', 94),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '父', 3, true, false, NULL, 4, 'phụ', 'cha', 'father', 'Cha, bố', 'kangxi-radical', 95),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '耳', 3, true, false, NULL, 6, 'nhĩ', 'tai (lỗ tai)', 'ear', 'Tai, dùng để nghe', 'kangxi-radical', 96),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '弋', 3, false, false, NULL, 3, 'dặc', 'bắn, chiếm lấy', 'piling', 'Bắn', 'kangxi-radical', 97),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '乙', 3, false, false, NULL, 1, 'ất', 'vị trí thứ 2 trong thiên can', 'the latter', 'Can ất, can thứ hai trong mười can', 'kangxi-radical', 98),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '生', 3, true, false, NULL, 5, 'sinh', 'sinh đẻ, sinh sống', 'life', 'Sống, đối lại với tử', 'kangxi-radical', 99),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '方', 3, true, false, NULL, 4, 'phương', 'vuông', 'direction', 'Vuông', 'kangxi-radical', 100),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '音', 2, true, false, NULL, 9, 'âm', 'âm thanh, tiếng', 'sound', 'Tiếng', 'kangxi-radical', 101),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '匚', 2, false, false, NULL, 2, 'phương', 'tủ đựng', 'box-on-side enclosure radical (no. 22)', 'Cái đồ để đựng đồ', 'kangxi-radical', 102),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '欠', 2, false, false, NULL, 4, 'khiếm', 'khiếm khuyết, thiếu vắng', 'lack', 'Ngáp', 'kangxi-radical', 103),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '阡', 2, false, false, NULL, 0, 'thiên', NULL, 'thousand', 'Thiên mạch bờ ruộng', 'thieu-chuu', 104),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '元', 2, true, false, NULL, 0, 'nguyên', NULL, 'beginning', 'Mới', 'thieu-chuu', 105),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '羽', 2, true, false, NULL, 6, 'vũ', 'lông vũ', 'feathers', 'Lông chim', 'kangxi-radical', 106),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '至', 2, false, false, NULL, 6, 'chí', 'đến', 'climax', 'Ðến', 'kangxi-radical', 107),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '已', 2, false, false, NULL, 0, 'dĩ', NULL, 'stop', 'Thôi', 'thieu-chuu', 108),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '走', 2, true, false, NULL, 7, 'tẩu', 'đi, chạy', 'run', 'Chạy', 'kangxi-radical', 109),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '穴', 2, false, false, NULL, 5, 'huyệt', 'hang lỗ', 'hole', 'Hang', 'kangxi-radical', 110),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '聿', 2, false, false, NULL, 6, 'duật', 'cây bút', 'brush', 'Bèn', 'kangxi-radical', 111),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '犬', 2, true, false, NULL, 4, 'khuyển', 'con chó', 'dog', 'Con chó', 'kangxi-radical', 112),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '見', 2, true, false, NULL, 7, 'kiến', 'trông thấy', 'see', 'Thấy, mắt trông thấy', 'kangxi-radical', 113),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '五', 2, true, false, NULL, 0, 'ngũ', NULL, 'five', 'Năm, tên số đếm', 'thieu-chuu', 114),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '文', 2, true, false, NULL, 4, 'văn', 'văn vẻ, văn chương, vẻ sáng', 'sentence', 'Văn vẻ', 'kangxi-radical', 115),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '勿', 2, false, false, NULL, 0, 'vật', NULL, 'not', 'Chớ', 'thieu-chuu', 116),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '辛', 2, false, false, NULL, 7, 'tân', 'cay', 'spicy', 'Can tân', 'kangxi-radical', 117),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '青', 2, true, false, NULL, 8, 'thanh', 'màu xanh', 'blue', 'Màu xanh', 'kangxi-radical', 118),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '也', 2, false, false, NULL, 0, 'dã', NULL, 'to be (classical)', 'Vậy, nhời nói hết câu', 'thieu-chuu', 119),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '鳥', 2, true, false, NULL, 11, 'điểu', 'con chim', 'bird', 'Loài chim, con chim', 'kangxi-radical', 120),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '用', 2, true, false, NULL, 5, 'dụng', 'dùng', 'utilize', 'Công dùng, đối lại với chữ thể', 'kangxi-radical', 121),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '邦', 2, false, false, NULL, 0, 'bang', NULL, 'home country', 'Nước', 'thieu-chuu', 122),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '免', 2, false, false, NULL, 0, 'miễn', NULL, 'excuse', 'Bỏ', 'thieu-chuu', 123),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '黄', 1, true, false, '黃', 12, 'hoàng', 'màu vàng', 'yellow', 'Cũng như chữ hoàng', 'kangxi-radical', 124),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '豕', 1, false, false, NULL, 7, 'thỉ', 'con heo, con lợn', 'pig', 'Con lợn', 'kangxi-radical', 125),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '井', 1, false, false, NULL, 0, 'tỉnh', NULL, 'well', 'Giếng', 'thieu-chuu', 126),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '气', 1, false, false, NULL, 4, 'khí', 'hơi nước', 'spirit', 'Hơi thở', 'kangxi-radical', 127),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '魚', 1, true, false, NULL, 11, 'ngư', 'con cá', 'fish', 'Con cá', 'kangxi-radical', 128),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '耒', 1, false, false, NULL, 6, 'lỗi', 'cái cày', 'come', 'Cái cầy', 'kangxi-radical', 129),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '艮', 1, false, false, NULL, 6, 'cấn', 'quẻ Cấn (Kinh Dịch); dừng, bền cứng', 'northeast (Oriental zodiac)', 'Quẻ cấn', 'kangxi-radical', 130),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '廴', 1, false, false, NULL, 3, 'dẫn', 'bước dài', 'long stride or stretching radical (no. 54)', 'Bước dài', 'kangxi-radical', 131),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '行', 1, true, false, NULL, 6, 'hành', 'đi, thi hành, làm được', 'going', 'Bước đi, bước chân đi', 'kangxi-radical', 132),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '高', 1, true, false, NULL, 10, 'cao', 'cao', 'tall', 'Cao', 'kangxi-radical', 133),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '黒', 1, true, false, '黑', 12, 'hắc', 'màu đen', 'black', 'Sắc đen, đen kịt', 'kangxi-radical', 134),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '斉', 1, false, false, '齊', 14, 'tề', 'ngang bằng, cùng nhau', 'adjusted', 'Chỉnh tề', 'kangxi-radical', 135),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '爪', 1, false, false, NULL, 4, 'trảo', 'móng vuốt cầm thú', 'claw', 'Móng chân, móng tay', 'kangxi-radical', 136),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '皿', 1, true, false, NULL, 5, 'mãnh', 'bát dĩa', 'dish', 'Ðồ, các đồ bát đĩa đều gọi là mãnh', 'kangxi-radical', 137),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '支', 1, true, false, NULL, 4, 'chi', 'cành nhánh', 'branch', 'Chi, thứ', 'kangxi-radical', 138),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '歹', 1, false, false, NULL, 4, 'đãi', 'xấu xa, tệ hại', 'bare bone', 'Xương tàn', 'kangxi-radical', 139),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '氏', 1, false, false, NULL, 4, 'thị', 'họ', 'family name', 'Họ, ngành họ', 'kangxi-radical', 140),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '扎', 1, false, false, NULL, 0, 'trát', NULL, 'pull', 'Tục dùng như chữ trát', 'thieu-chuu', 141),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '礼', 1, false, false, NULL, 0, 'lễ', NULL, 'salute', 'Lễ', 'thieu-chuu', 142),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '手', 1, true, false, NULL, 4, 'thủ', 'tay', 'hand', 'Tay', 'kangxi-radical', 143),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '酉', 1, false, false, NULL, 7, 'dậu', 'một trong 12 địa chi', 'west', 'Chi Dậu', 'kangxi-radical', 144),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '初', 1, true, false, NULL, 0, 'sơ', NULL, 'first time', 'Mới, trước', 'thieu-chuu', 145),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '戸', 1, false, false, '戶', 4, 'hộ', 'cửa một cánh', 'door', 'Cửa ngõ', 'kangxi-radical', 146),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '巴', 1, false, false, NULL, 0, 'ba', NULL, 'comma-design', 'Nước Ba, đất Ba', 'thieu-chuu', 147),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '色', 1, true, false, NULL, 6, 'sắc', 'màu, dáng vẻ, nữ sắc', 'color', 'Sắc, màu', 'kangxi-radical', 148),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '世', 1, true, false, NULL, 0, 'thế', NULL, 'generation', 'Ðời', 'thieu-chuu', 149),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '忙', 1, false, false, NULL, 0, 'mang', NULL, 'busy', 'Bộn rộn, trong lòng vội gấp', 'thieu-chuu', 150),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '西', 1, true, false, NULL, 0, 'tây', NULL, 'west', 'Phương tây', 'thieu-chuu', 151),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '赤', 1, true, false, NULL, 7, 'xích', 'màu đỏ', 'red', 'Sắc đỏ', 'kangxi-radical', 152),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '川', 1, true, false, NULL, 0, 'xuyên', NULL, 'stream', 'Dòng nước', 'thieu-chuu', 153),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '舟', 1, false, false, NULL, 6, 'chu', 'cái thuyền', 'boat', 'Thuyền', 'kangxi-radical', 154),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '足', 1, true, false, NULL, 7, 'túc', 'chân, đầy đủ', 'leg', 'Chân', 'kangxi-radical', 155),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '疋', 1, false, false, NULL, 5, 'thất', 'đơn vị đo chiều dài, tấm (vải)', 'head', 'Ðủ, chân', 'kangxi-radical', 156),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '頁', 1, false, false, NULL, 9, 'hiệt', 'đầu; trang giấy', 'page', 'Đầu', 'kangxi-radical', 157),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '谷', 1, true, false, NULL, 7, 'cốc', 'khe nước chảy giữa hai núi, thung lũng', 'valley', 'Lũng', 'kangxi-radical', 158),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '豆', 1, false, false, NULL, 7, 'đậu', 'hạt đậu, cây đậu', 'beans', 'Bát đậu', 'kangxi-radical', 159),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '長', 1, true, false, NULL, 8, 'trường', 'dài; lớn (trưởng)', 'long', 'Dài', 'kangxi-radical', 160),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', 'マ', 1, false, true, NULL, 0, NULL, NULL, NULL, NULL, NULL, 161),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '竹', 1, false, false, NULL, 6, 'trúc', 'tre trúc', 'bamboo', 'Cây trúc', 'kangxi-radical', 162),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '首', 1, false, false, NULL, 9, 'thủ', 'đầu', 'neck', 'Đầu', 'kangxi-radical', 163),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '肉', 1, true, false, NULL, 6, 'nhục', 'thịt', 'meat', 'Thịt', 'kangxi-radical', 164),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '入', 1, true, false, NULL, 2, 'nhập', 'vào', 'enter', 'Vào, đối lại với chữ xuất ra', 'kangxi-radical', 165),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '買', 1, true, false, NULL, 0, 'mãi', NULL, 'buy', 'Mua, lấy tiền đổi lấy đồ là mãi', 'thieu-chuu', 166),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '麦', 1, true, false, '麥', 11, 'mạch', 'lúa mạch', 'barley', 'Tục dùng như chữ mạch', 'kangxi-radical', 167),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '癶', 1, false, false, NULL, 5, 'bát', 'gạt ngược lại, trở lại', 'dotted tent radical (no. 105)', 'Gạt ra, đạp', 'kangxi-radical', 168),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '釆', 1, false, false, NULL, 7, 'biện', 'phân biệt', 'separate', 'Phân biệt rõ, biện biệt', 'kangxi-radical', 169),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '疔', 1, false, false, NULL, 0, 'đinh', NULL, 'carbuncle', NULL, 'phienam', 170),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '品', 1, true, false, NULL, 0, 'phẩm', NULL, 'goods', 'Nhiều thứ', 'thieu-chuu', 171),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '風', 1, true, false, NULL, 9, 'phong', 'gió', 'wind', 'Gió', 'kangxi-radical', 172),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '几', 1, false, false, NULL, 2, 'kỷ', 'ghế dựa', 'table', 'Nhỏ', 'kangxi-radical', 173),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '卩', 1, false, false, NULL, 2, 'tiết', 'đốt tre', 'seal radical (no. 26)', 'Bộ tiết', 'kangxi-radical', 174),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '爿', 1, false, false, NULL, 4, 'tường', 'mảnh gỗ, cái giường', 'left-side kata radical (no. 90)', 'Tấm ván', 'kangxi-radical', 175),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '毛', 1, true, false, NULL, 4, 'mao', 'lông', 'fur', 'Lông', 'kangxi-radical', 176),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '矛', 1, false, false, NULL, 5, 'mâu', 'cây giáo để đâm', 'halberd', 'Cái giáo', 'kangxi-radical', 177),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '隶', 1, false, false, NULL, 8, 'đãi', 'kịp, kịp đến', 'extend', 'Thuộc', 'kangxi-radical', 178),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '麻', 1, false, false, NULL, 11, 'ma', 'cây gai', 'hemp', 'Ðại ma cây gai', 'kangxi-radical', 179),
  ('1219bda2-aa1e-4288-ab7e-caff011cdf5c', '舌', 1, false, false, NULL, 6, 'thiệt', 'cái lưỡi', 'tongue', 'Lưỡi', 'kangxi-radical', 180);

-- Đặt lại NOT NULL cho jlpt_kanji — xem chú thích trong công cụ sinh.
ALTER TABLE jlpt_kanji ALTER COLUMN character SET NOT NULL;
ALTER TABLE jlpt_kanji ALTER COLUMN jlpt_level SET NOT NULL;
ALTER TABLE jlpt_kanji ALTER COLUMN in_course SET NOT NULL;

-- Đặt lại NOT NULL cho jlpt_kanji_parts — xem chú thích trong công cụ sinh.
ALTER TABLE jlpt_kanji_parts ALTER COLUMN part SET NOT NULL;
ALTER TABLE jlpt_kanji_parts ALTER COLUMN unlocks_count SET NOT NULL;
ALTER TABLE jlpt_kanji_parts ALTER COLUMN in_set SET NOT NULL;
ALTER TABLE jlpt_kanji_parts ALTER COLUMN is_shape SET NOT NULL;
