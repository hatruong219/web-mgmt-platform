-- Gỡ nốt 3 câu dính furigana mà migration 000004 bỏ sót.
--
-- 000004 khớp âm đọc của CẢ CỤM kanji liền nhau, nên trượt những chỗ từ được
-- chú âm dính liền chữ đứng trước nó:
--
--     ハイさんは明日京都きょうとへ行くそうです。
--                  ^^^^^^^^  cụm liền nhau là 明日京都, nhưng きょうと chỉ là
--                            âm của 京都 — khớp cả cụm thì không ra
--
-- Script giờ thử thêm phần ĐUÔI của cụm (明日京都 → 日京都 → 京都), lấy cụm
-- dài nhất khớp được. Xem tools/strip-glued-furigana.py bên app.
--
-- Danh sách dưới đây KHÔNG ghép bảng: lấy thẳng văn bản đang có trên
-- /api/kotoba/grammar rồi chạy chính script đó lên nó, nên "cũ" và "mới" luôn
-- là của cùng một câu. Bản nháp đầu tiên ghép theo (bài, bản dịch) và sinh ra
-- 52 dòng UPDATE ghép nhầm câu với nhau — khoá đó không duy nhất.
--
-- Chạy lại vô hại: WHERE khớp văn bản CŨ, sửa rồi thì không khớp nữa.

BEGIN;


UPDATE mnn_sentences SET
  ja_kanji = 'ハイさんは明日京都へ行くそうです。',
  has_furigana = ('ハイさんは明日京都へ行くそうです。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = 'ハイさんは明日京都きょうとへ行くそうです。';

UPDATE mnn_sentences SET
  ja_kanji = 'ハイさんは明日京都へ行くと言っていました。',
  has_furigana = ('ハイさんは明日京都へ行くと言っていました。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = 'ハイさんは明日京都きょうとへ行くと言っていました。';

UPDATE mnn_sentences SET
  ja_kanji = '今仕事をやっているところなので、後で行ってもいいですか。',
  has_furigana = ('今仕事をやっているところなので、後で行ってもいいですか。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '今仕事しごとをやっているところなので、後で行ってもいいですか。';


DO $$
DECLARE leftover integer;
BEGIN
  SELECT count(*) INTO leftover FROM mnn_sentences
   WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c'
     AND ja_kanji IN ('ハイさんは明日京都きょうとへ行くそうです。', 'ハイさんは明日京都きょうとへ行くと言っていました。', '今仕事しごとをやっているところなので、後で行ってもいいですか。');
  IF leftover > 0 THEN
    RAISE EXCEPTION 'Còn % câu chưa sửa', leftover;
  END IF;
END $$;

COMMIT;
