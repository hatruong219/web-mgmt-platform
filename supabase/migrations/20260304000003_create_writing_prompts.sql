-- Create writing_prompts table
CREATE TABLE writing_prompts (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id     UUID NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
    title       TEXT NOT NULL,                          -- VD: "Mô tả bản thân"
    prompt_vi   TEXT NOT NULL,                          -- Đề bài tiếng Việt
    prompt_ja   TEXT,                                   -- Đề bài tiếng Nhật (optional hint)
    category    TEXT NOT NULL DEFAULT 'general',        -- self / family / hobby / general
    jlpt_level  TEXT,                                   -- N5, N4, N3...
    min_words   INT NOT NULL DEFAULT 50,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    order_index INT NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_writing_prompts_site ON writing_prompts(site_id);
CREATE INDEX idx_writing_prompts_category ON writing_prompts(category);

-- Seed prompts mẫu (thay SITE_ID bằng UUID thật khi chạy migrate)
-- INSERT INTO writing_prompts (site_id, title, prompt_vi, category, jlpt_level, min_words) VALUES
--   ('00000000-0000-0000-0000-000000000000', 'Mô tả bản thân', 'Hãy viết một đoạn văn tiếng Nhật giới thiệu về bản thân bạn (tên, tuổi, quê quán, công việc).', 'self', 'N5', 50),
--   ('00000000-0000-0000-0000-000000000000', 'Mô tả gia đình', 'Hãy viết một đoạn văn tiếng Nhật mô tả gia đình bạn (số thành viên, nghề nghiệp, tính cách).', 'family', 'N5', 60),
--   ('00000000-0000-0000-0000-000000000000', 'Sở thích cá nhân', 'Hãy viết một đoạn văn tiếng Nhật về sở thích của bạn và lý do bạn yêu thích nó.', 'hobby', 'N4', 80);