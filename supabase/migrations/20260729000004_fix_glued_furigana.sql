-- Gỡ furigana bị dính vào bản kanji của 23 câu ví dụ.
--
-- Riki ghi furigana hai kiểu lẫn lộn. Kiểu ngoặc 私（わたし）đã xử lý lúc rút
-- dữ liệu; kiểu VIẾT LIỀN thì lọt qua:
--
--     京都きょうとへ行きます。   →   京都へ行きます。
--     このかばんは便利べんりです。 →  このかばんは便利です。
--
-- Cách nhận: ghép âm đọc của TỪNG CHỮ trong cụm kanji rồi so với chuỗi kana
-- ngay sau (tools/strip-glued-furigana.py). Ghép được mới cắt — đuôi động từ
-- và trợ từ không bao giờ ghép thành âm đọc của cả cụm nên chúng an toàn.
--
-- ja_kana KHÔNG đổi: bản toàn kana vốn đã đúng, chỗ hỏng chỉ ở bản kanji.
-- has_furigana tính lại vì có câu sau khi cắt thì hai bản bằng nhau.
--
-- Bản đóng gói trong app đã sửa rồi (assets/grammar.json). Migration này để
-- bản TẢI VỀ khớp với bản đóng gói — lệch nhau thì bấm đồng bộ xong câu ví dụ
-- lại hỏng như cũ, và không ai hiểu vì sao.
--
-- Chạy lại nhiều lần vô hại: WHERE khớp đúng văn bản CŨ, sửa rồi thì không
-- khớp nữa.

BEGIN;


UPDATE mnn_sentences SET
  ja_kanji = '６時半におきます。',
  has_furigana = ('６時半におきます。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '６時半じはんにおきます。';

UPDATE mnn_sentences SET
  ja_kanji = 'ちょっと気分が悪いんです。',
  has_furigana = ('ちょっと気分が悪いんです。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = 'ちょっと気分きぶんが悪いんです。';

UPDATE mnn_sentences SET
  ja_kanji = '京都へ行きます。大阪おおさかへ行きません。',
  has_furigana = ('京都へ行きます。大阪おおさかへ行きません。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '京都きょうとへ行きます。大阪おおさかへ行きません。';

UPDATE mnn_sentences SET
  ja_kanji = '京都へは行きますが、大阪おおさかへは行きません。',
  has_furigana = ('京都へは行きますが、大阪おおさかへは行きません。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '京都きょうとへは行きますが、大阪おおさかへは行きません。';

UPDATE mnn_sentences SET
  ja_kanji = '5．手紙の重さは２５グラムぐらむ以下ですか。量はかってください',
  has_furigana = ('5．手紙の重さは２５グラムぐらむ以下ですか。量はかってください' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '5．手紙の重さは２５グラムぐらむ以下いかですか。量はかってください';

UPDATE mnn_sentences SET
  ja_kanji = '6．この答えは正しいですか。もう一度考えてください',
  has_furigana = ('6．この答えは正しいですか。もう一度考えてください' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '6．この答えは正しいですか。もう一度考いちどかんがえてください';

UPDATE mnn_sentences SET
  ja_kanji = '私は犬を散歩に連つれて行ってやりました。',
  has_furigana = ('私は犬を散歩に連つれて行ってやりました。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '私は犬を散歩さんぽに連つれて行ってやりました。';

UPDATE mnn_sentences SET
  ja_kanji = '田中先生に英語を教えていただきました。',
  has_furigana = ('田中先生に英語を教えていただきました。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '田中たなか先生に英語を教えていただきました。';

UPDATE mnn_sentences SET
  ja_kanji = '田中さんが結婚けっこんの祝いわいにこのお皿をくださいました。',
  has_furigana = ('田中さんが結婚けっこんの祝いわいにこのお皿をくださいました。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '田中たなかさんが結婚けっこんの祝いわいにこのお皿をくださいました。';

UPDATE mnn_sentences SET
  ja_kanji = '私は北海道のお土産みやげに人形を買いました。',
  has_furigana = ('私は北海道のお土産みやげに人形を買いました。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '私は北海道ほっかいどうのお土産みやげに人形を買いました。';

UPDATE mnn_sentences SET
  ja_kanji = '弁護士になるように、法律を勉強しています。（X）日本語が上手になるように、毎日勉強しています。（O）',
  has_furigana = ('弁護士になるように、法律を勉強しています。（X）日本語が上手になるように、毎日勉強しています。（O）' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '弁護士になるように、法律を勉強しています。（X）日本語が上手じょうずになるように、毎日勉強しています。（O）';

UPDATE mnn_sentences SET
  ja_kanji = 'このかばんは大きくて、旅行に便利です。',
  has_furigana = ('このかばんは大きくて、旅行に便利です。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = 'このかばんは大きくて、旅行に便利べんりです。';

UPDATE mnn_sentences SET
  ja_kanji = '塩の量を半分にしました。',
  has_furigana = ('塩の量を半分にしました。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '塩の量を半分はんふんにしました。';

UPDATE mnn_sentences SET
  ja_kanji = 'ハイさんは親切に道を教えてくれまし。',
  has_furigana = ('ハイさんは親切に道を教えてくれまし。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = 'ハイさんは親切しんせつに道を教えてくれまし。';

UPDATE mnn_sentences SET
  ja_kanji = '会議に間に合わない場合は、連絡れんらくしてください。',
  has_furigana = ('会議に間に合わない場合は、連絡れんらくしてください。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '会議に間に合わない場合ばあいは、連絡れんらくしてください。';

UPDATE mnn_sentences SET
  ja_kanji = '時間に遅れた場合は、会場に入れません。',
  has_furigana = ('時間に遅れた場合は、会場に入れません。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '時間に遅れた場合ばあいは、会場かいじょうに入れません。';

UPDATE mnn_sentences SET
  ja_kanji = 'ファクスの調子が悪い場合は、どうしたらいいですか。',
  has_furigana = ('ファクスの調子が悪い場合は、どうしたらいいですか。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = 'ファクスの調子が悪い場合ばあいは、どうしたらいいですか。';

UPDATE mnn_sentences SET
  ja_kanji = '領収書が必要ひつような場合は、係に言ってください。',
  has_furigana = ('領収書が必要ひつような場合は、係に言ってください。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '領収書が必要ひつような場合ばあいは、係かかりに言ってください。';

UPDATE mnn_sentences SET
  ja_kanji = '火事や地震の場合は、エレベーターを使わないでください。',
  has_furigana = ('火事や地震の場合は、エレベーターを使わないでください。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '火事や地震の場合ばあいは、エレベーターを使わないでください。';

UPDATE mnn_sentences SET
  ja_kanji = '例2：木村さんは先月この会社に入ったばかりです。',
  has_furigana = ('例2：木村さんは先月この会社に入ったばかりです。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '例2：木村きむらさんは先月この会社に入ったばかりです。';

UPDATE mnn_sentences SET
  ja_kanji = '田中さんの息子さんは今年ことし12歳のはずです。',
  has_furigana = ('田中さんの息子さんは今年ことし12歳のはずです。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '田中たなかさんの息子さんは今年ことし12歳のはずです。';

UPDATE mnn_sentences SET
  ja_kanji = '彼は料理の勉強をしていましたから、料理が上手なはずです。',
  has_furigana = ('彼は料理の勉強をしていましたから、料理が上手なはずです。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = '彼は料理の勉強をしていましたから、料理が上手じょうずなはずです。';

UPDATE mnn_sentences SET
  ja_kanji = 'ハイさんは3時に家をでたそうですから、ここには4時前に着くはずなのに、まだついていませんね。',
  has_furigana = ('ハイさんは3時に家をでたそうですから、ここには4時前に着くはずなのに、まだついていませんね。' <> ja_kana)
WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c' AND ja_kanji = 'ハイさんは3時に家をでたそうですから、ここには4時前じまえに着くはずなのに、まだついていませんね。';


-- Kiểm: không còn câu nào mang văn bản cũ.
DO $$
DECLARE leftover integer;
BEGIN
  SELECT count(*) INTO leftover FROM mnn_sentences
   WHERE site_id = '1219bda2-aa1e-4288-ab7e-caff011cdf5c'
     AND ja_kanji IN ('６時半じはんにおきます。', 'ちょっと気分きぶんが悪いんです。', '京都きょうとへ行きます。大阪おおさかへ行きません。', '京都きょうとへは行きますが、大阪おおさかへは行きません。', '5．手紙の重さは２５グラムぐらむ以下いかですか。量はかってください', '6．この答えは正しいですか。もう一度考いちどかんがえてください', '私は犬を散歩さんぽに連つれて行ってやりました。', '田中たなか先生に英語を教えていただきました。', '田中たなかさんが結婚けっこんの祝いわいにこのお皿をくださいました。', '私は北海道ほっかいどうのお土産みやげに人形を買いました。', '弁護士になるように、法律を勉強しています。（X）日本語が上手じょうずになるように、毎日勉強しています。（O）', 'このかばんは大きくて、旅行に便利べんりです。', '塩の量を半分はんふんにしました。', 'ハイさんは親切しんせつに道を教えてくれまし。', '会議に間に合わない場合ばあいは、連絡れんらくしてください。', '時間に遅れた場合ばあいは、会場かいじょうに入れません。', 'ファクスの調子が悪い場合ばあいは、どうしたらいいですか。', '領収書が必要ひつような場合ばあいは、係かかりに言ってください。', '火事や地震の場合ばあいは、エレベーターを使わないでください。', '例2：木村きむらさんは先月この会社に入ったばかりです。', '田中たなかさんの息子さんは今年ことし12歳のはずです。', '彼は料理の勉強をしていましたから、料理が上手じょうずなはずです。', 'ハイさんは3時に家をでたそうですから、ここには4時前じまえに着くはずなのに、まだついていませんね。');
  IF leftover > 0 THEN
    RAISE EXCEPTION 'Còn % câu chưa sửa — dữ liệu DB lệch với bản đóng gói', leftover;
  END IF;
END $$;

COMMIT;
