-- Seed: writing_prompts
-- Thay SITE_ID bằng giá trị NEXT_PUBLIC_SITE_ID thực tế trước khi chạy
-- VD: SELECT id FROM sites LIMIT 1;

DO $$
DECLARE
  v_site_id UUID;
BEGIN
  -- Lấy site_id đầu tiên có trong DB
  SELECT id INTO v_site_id FROM sites LIMIT 1;

  IF v_site_id IS NULL THEN
    RAISE EXCEPTION 'Không tìm thấy site nào trong bảng sites. Hãy seed sites trước.';
  END IF;

  INSERT INTO writing_prompts (site_id, title, prompt_vi, prompt_ja, category, jlpt_level, min_words, order_index)
  VALUES
    (
      v_site_id,
      'Mô tả bản thân',
      'Hãy viết một đoạn văn tiếng Nhật giới thiệu về bản thân bạn: tên, tuổi, quê quán, nghề nghiệp hoặc là học sinh/sinh viên.',
      '自己紹介をしてください。名前、年齢、出身地、仕事や学校について書いてください。',
      'self', 'N5', 50, 1
    ),
    (
      v_site_id,
      'Mô tả gia đình',
      'Hãy viết một đoạn văn tiếng Nhật mô tả gia đình bạn: số thành viên, nghề nghiệp, tính cách của từng người.',
      '家族について教えてください。何人家族ですか？家族の仕事や性格を教えてください。',
      'family', 'N5', 60, 2
    ),
    (
      v_site_id,
      'Sở thích cá nhân',
      'Hãy viết một đoạn văn tiếng Nhật về sở thích của bạn: bạn thích làm gì vào thời gian rảnh và tại sao bạn yêu thích điều đó.',
      '趣味について書いてください。暇な時間に何をしますか？なぜそれが好きですか？',
      'hobby', 'N4', 80, 3
    ),
    (
      v_site_id,
      'Ngày cuối tuần của bạn',
      'Hãy viết một đoạn văn tiếng Nhật mô tả bạn thường làm gì vào cuối tuần. Bạn đi đâu, gặp ai, làm gì?',
      '週末は何をしますか？どこに行きますか？誰と会いますか？',
      'general', 'N4', 80, 4
    ),
    (
      v_site_id,
      'Mô tả nơi bạn sống',
      'Hãy viết một đoạn văn tiếng Nhật mô tả thành phố hoặc khu vực bạn đang sống: vị trí, đặc điểm nổi bật, những gì bạn thích/không thích.',
      'あなたが住んでいる町や都市について教えてください。',
      'general', 'N3', 100, 5
    ),
    (
      v_site_id,
      'Kế hoạch tương lai',
      'Hãy viết một đoạn văn tiếng Nhật về kế hoạch hoặc ước mơ của bạn trong tương lai. Bạn muốn làm gì? Tại sao?',
      '将来の夢や計画について書いてください。何をしたいですか？なぜですか？',
      'self', 'N3', 100, 6
    )
  ON CONFLICT DO NOTHING;

  RAISE NOTICE 'Đã seed % writing_prompts cho site %', 6, v_site_id;
END $$;
