-- Create writing_submissions table
CREATE TABLE writing_submissions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id         UUID NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
    prompt_id       UUID NOT NULL REFERENCES writing_prompts(id) ON DELETE CASCADE,
    -- user_id nullable vì chưa có auth; dùng session_id để track anonymous
    user_id         UUID,
    session_id      TEXT,                               -- anonymous tracking
    response        TEXT NOT NULL,
    word_count      INT GENERATED ALWAYS AS (array_length(string_to_array(trim(response), ' '), 1)) STORED,
    -- AI grading results
    score           INT CHECK (score >= 0 AND score <= 100),
    score_grammar   INT CHECK (score_grammar >= 0 AND score_grammar <= 40),
    score_vocab     INT CHECK (score_vocab >= 0 AND score_vocab <= 30),
    score_content   INT CHECK (score_content >= 0 AND score_content <= 30),
    feedback_vi     TEXT,                               -- nhận xét tiếng Việt
    errors          JSONB DEFAULT '[]'::JSONB,          -- danh sách lỗi cụ thể
    is_valid_lang   BOOLEAN,                            -- true nếu viết đúng tiếng Nhật
    graded_at       TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_writing_submissions_prompt ON writing_submissions(prompt_id);
CREATE INDEX idx_writing_submissions_site ON writing_submissions(site_id);
CREATE INDEX idx_writing_submissions_session ON writing_submissions(session_id);