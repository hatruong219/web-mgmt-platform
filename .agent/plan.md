# 🗂️ Web Management Platform — Kế hoạch phát triển

> **Mục tiêu**: Xây dựng một nền tảng quản lý tập trung cho tất cả các web projects cá nhân.  
> **Stack chính**: Next.js 14 (App Router) · Supabase · Vercel  
> **Ngày tạo**: 2026-02-26

---

## 📌 Table of Contents

1. [Tổng quan dự án](#1-tổng-quan-dự-án)
2. [Tư vấn thiết kế Database](#2-tư-vấn-thiết-kế-database)
3. [Kiến trúc hệ thống](#3-kiến-trúc-hệ-thống)
4. [Phase 1 — UI & Blog CMS](#4-phase-1--ui--blog-cms)
5. [Phase 2 — API Gateway (Future)](#5-phase-2--api-gateway-future)
6. [Cấu trúc thư mục dự án](#6-cấu-trúc-thư-mục-dự-án)
7. [Tech Stack & Dependencies](#7-tech-stack--dependencies)
8. [Checklist triển khai](#8-checklist-triển-khai)

---

## 1. Tổng quan dự án

Đây là một **"control panel"** cho các website cá nhân. Thay vì mỗi website quản lý dữ liệu riêng lẻ, ta có một Supabase project duy nhất là **source of truth**, sau đó từng website sẽ consume dữ liệu thông qua API (Phase 2).

```
┌─────────────────────────────────────────────────────┐
│              Web Management Platform                │
│                  (Next.js + Vercel)                 │
│                                                     │
│  [Dashboard]  [Blog CMS]  [Analytics]  [Settings]   │
└──────────────────────┬──────────────────────────────┘
                       │
              ┌────────▼────────┐
              │   Supabase DB   │
              │  (PostgreSQL)   │
              └────────┬────────┘
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
   [Blog Site]    [Portfolio]   [Future Site]
```

---

## 2. Tư vấn thiết kế Database

### ❌ Vấn đề với cách tiếp cận Table Prefix (`blogsite_article`)

Cách bạn đang nghĩ (dùng prefix) **có thể hoạt động** nhưng gặp vấn đề về lâu dài:

| Vấn đề | Mô tả |
|--------|-------|
| **Schema pollution** | 10 websites × 5 tables = 50 tables trong 1 schema → khó quản lý |
| **Không có RLS thống nhất** | Phải viết lại policy cho từng table mới |
| **Khó query cross-site** | Không thể `JOIN` dữ liệu chung (tags, media, users) |
| **Migration phức tạp** | Thêm website mới = thêm nhiều table mới |

---

### ✅ Khuyến nghị: Multi-Site với `site_id` Foreign Key (Hybrid Approach)

Đây là pattern **được dùng rộng rãi trong SaaS** (Notion, Ghost, WordPress multisite):

#### Core Tables (dùng chung cho tất cả sites)

```sql
-- Bảng trung tâm: đăng ký tất cả các websites
CREATE TABLE sites (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name        TEXT NOT NULL,                -- "My Blog", "Portfolio"
  slug        TEXT UNIQUE NOT NULL,         -- "blog", "portfolio"
  domain      TEXT,                         -- "blog.example.com"
  description TEXT,
  status      TEXT DEFAULT 'active',        -- active | archived
  metadata    JSONB DEFAULT '{}',           -- flexible extra config
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Bảng content chung — mọi website đều có articles
CREATE TABLE articles (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  site_id     UUID REFERENCES sites(id) ON DELETE CASCADE,
  title       TEXT NOT NULL,
  slug        TEXT NOT NULL,
  content     TEXT,                         -- Markdown / MDX
  excerpt     TEXT,
  cover_image TEXT,
  status      TEXT DEFAULT 'draft',         -- draft | published | archived
  tags        TEXT[] DEFAULT '{}',
  metadata    JSONB DEFAULT '{}',           -- SEO, OG image, custom fields
  published_at TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(site_id, slug)                     -- slug unique per site
);

-- Media library — dùng chung hoặc per-site
CREATE TABLE media (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  site_id     UUID REFERENCES sites(id) ON DELETE CASCADE,
  filename    TEXT NOT NULL,
  url         TEXT NOT NULL,
  mime_type   TEXT,
  size        BIGINT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

#### Vì sao dùng `JSONB metadata`?

Đây là "escape hatch" cho **site-specific fields** mà không cần tạo table mới:

```jsonb
-- Blog site article metadata
{
  "reading_time": 5,
  "series": "React Fundamentals",
  "sponsor": null
}

-- Portfolio project metadata  
{
  "github_url": "https://github.com/...",
  "demo_url": "https://demo.com",
  "stack": ["React", "Node.js"],
  "featured": true
}
```

#### Lợi ích so sánh

| | Table Prefix | Multi-Schema | `site_id` FK (Đề xuất) |
|--|--|--|--|
| Dễ query chung | ❌ | ⚠️ | ✅ |
| RLS đơn giản | ❌ | ⚠️ | ✅ |
| Thêm site mới | Tạo nhiều table | Tạo schema | Chỉ INSERT vào `sites` |
| Migrate schema | Khó | Trung bình | Dễ |
| Phù hợp Supabase | ⚠️ | ⚠️ | ✅ |

#### Khi nào nên dùng site-specific table?

Chỉ tạo **table riêng** khi website có data model **hoàn toàn khác biệt**, không thể map vào `articles` + `metadata`:

```sql
-- Ví dụ: Site bán hàng cần table riêng vì cấu trúc khác hoàn toàn
CREATE TABLE ecommerce_products (
  id       UUID PRIMARY KEY,
  site_id  UUID REFERENCES sites(id),
  sku      TEXT,
  price    NUMERIC,
  stock    INTEGER
  -- ...nhiều fields đặc thù
);
```

---

## 3. Kiến trúc hệ thống

```
Next.js 14 App Router
├── /app
│   ├── (auth)/                    ← Login page
│   ├── (dashboard)/
│   │   ├── page.tsx               ← Tổng quan các sites
│   │   ├── sites/[siteId]/
│   │   │   ├── articles/          ← Quản lý bài viết
│   │   │   ├── media/             ← Media library
│   │   │   └── settings/          ← Cài đặt site
│   └── api/
│       └── v1/                    ← API routes (Phase 2)
│
Supabase
├── Auth                           ← Xác thực người dùng
├── Database (PostgreSQL)          ← sites, articles, media
├── Storage                        ← Upload image/file
└── Edge Functions (tương lai)     ← Custom logic

Vercel
├── Hosting Next.js
└── Environment Variables          ← SUPABASE_URL, SUPABASE_ANON_KEY
```

---

## 4. Phase 1 — UI & Blog CMS

### 4.1 Mục tiêu Phase 1

- [x] Setup project Next.js 14 với App Router
- [ ] Kết nối Supabase (Auth + Database)
- [ ] Trang Dashboard tổng quan sites
- [ ] CRUD bài viết cho Blog site
- [ ] Rich text editor (MDX hoặc Tiptap)
- [ ] Upload ảnh lên Supabase Storage
- [ ] Deploy lên Vercel

### 4.2 UI Screens cần xây dựng

#### Screen 1: Dashboard (`/`)
- Danh sách các websites đang quản lý
- Quick stats: số bài viết, lượt xem (nếu có analytics)
- Button: "Thêm site mới"

#### Screen 2: Site Overview (`/sites/[siteId]`)
- Thống kê của site cụ thể
- Recent articles
- Quick actions

#### Screen 3: Article List (`/sites/[siteId]/articles`)
- Bảng danh sách bài viết (title, status, published_at)
- Filter: Draft | Published | Archived
- Search theo title
- Sort theo ngày

#### Screen 4: Article Editor (`/sites/[siteId]/articles/[articleId]`)
- Rich text editor (đề xuất: **Tiptap** hoặc **Novel.sh**)
- Sidebar: SEO metadata, cover image, tags, publish settings
- Auto-save (debounce)
- Preview mode

#### Screen 5: Media Library (`/sites/[siteId]/media`)
- Grid view các files đã upload
- Drag & drop upload
- Copy URL

#### Screen 6: Settings (`/sites/[siteId]/settings`)
- Thông tin site (name, domain, description)
- Xóa site

### 4.3 Database Schema cho Phase 1

```sql
-- Chạy trong Supabase SQL Editor

-- BƯỚC 1: Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- BƯỚC 2: Bảng sites
CREATE TABLE sites (
  id          UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name        TEXT NOT NULL,
  slug        TEXT UNIQUE NOT NULL,
  domain      TEXT,
  description TEXT,
  status      TEXT DEFAULT 'active' CHECK (status IN ('active', 'archived')),
  metadata    JSONB DEFAULT '{}',
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- BƯỚC 3: Bảng articles
CREATE TABLE articles (
  id           UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  site_id      UUID NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  title        TEXT NOT NULL,
  slug         TEXT NOT NULL,
  content      TEXT DEFAULT '',
  excerpt      TEXT,
  cover_image  TEXT,
  status       TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  tags         TEXT[] DEFAULT '{}',
  metadata     JSONB DEFAULT '{}',
  published_at TIMESTAMPTZ,
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  updated_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(site_id, slug)
);

-- BƯỚC 4: Bảng media
CREATE TABLE media (
  id         UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  site_id    UUID REFERENCES sites(id) ON DELETE CASCADE,
  filename   TEXT NOT NULL,
  url        TEXT NOT NULL,
  mime_type  TEXT,
  size       BIGINT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- BƯỚC 5: Indexes để tăng tốc query
CREATE INDEX idx_articles_site_id ON articles(site_id);
CREATE INDEX idx_articles_status  ON articles(status);
CREATE INDEX idx_articles_slug    ON articles(site_id, slug);
CREATE INDEX idx_media_site_id    ON media(site_id);

-- BƯỚC 6: Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at_sites
  BEFORE UPDATE ON sites
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_updated_at_articles
  BEFORE UPDATE ON articles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- BƯỚC 7: Row Level Security (bật sau khi thêm Auth)
ALTER TABLE sites    ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE media    ENABLE ROW LEVEL SECURITY;

-- Tạm thời cho phép authenticated user (chỉ mình bạn dùng)
CREATE POLICY "Allow all for authenticated users" ON sites    FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all for authenticated users" ON articles FOR ALL TO authenticated USING (true);
CREATE POLICY "Allow all for authenticated users" ON media    FOR ALL TO authenticated USING (true);
```

### 4.4 Các bước implement Phase 1

```
Sprint 1 — Setup & Foundation (2-3 ngày)
├── [ ] Khởi tạo Next.js 14: npx create-next-app@latest
├── [ ] Cài dependencies: @supabase/supabase-js, @supabase/ssr
├── [ ] Setup Supabase project + chạy migration SQL ở trên
├── [ ] Config environment variables (.env.local)
├── [ ] Setup Supabase Auth (Email/Password hoặc GitHub OAuth)
└── [ ] Tạo middleware.ts để bảo vệ routes

Sprint 2 — Dashboard & Sites (2-3 ngày)
├── [ ] Layout chính (sidebar navigation)
├── [ ] Screen: Dashboard (danh sách sites)
├── [ ] Screen: Tạo site mới (modal/form)
└── [ ] Screen: Site overview

Sprint 3 — Blog CMS (4-5 ngày)
├── [ ] Screen: Danh sách bài viết
├── [ ] Tích hợp rich text editor (Tiptap hoặc Novel.sh)
├── [ ] Screen: Article editor với auto-save
├── [ ] Publish workflow (Draft → Published)
└── [ ] Upload cover image lên Supabase Storage

Sprint 4 — Media & Polish (2-3 ngày)
├── [ ] Screen: Media library
├── [ ] Drag & drop upload
├── [ ] UI polish (dark mode, responsive)
└── [ ] Deploy lên Vercel
```

---

## 5. Phase 2 — API Gateway (Future)

> **Mục tiêu**: Các website con (blog, portfolio...) sẽ fetch dữ liệu từ Management Platform thay vì query trực tiếp Supabase.

### Thiết kế API

```
GET  /api/v1/sites                          → Danh sách sites
GET  /api/v1/sites/:slug/articles           → Bài viết của site
GET  /api/v1/sites/:slug/articles/:slug     → Chi tiết bài viết
```

### Options để implement

| Option | Mô tả | Phù hợp khi |
|--------|-------|-------------|
| **Next.js Route Handlers** | `/app/api/v1/...` | Đơn giản, ít traffic |
| **Supabase Edge Functions** | Deploy tại Deno Edge | Cần low latency |
| **tRPC** | Type-safe API | Internal consumption |

### Authentication cho API

- Dùng **Supabase API Key** (anon key) cho public endpoints
- Dùng **Service Role Key** cho authenticated endpoints (server-to-server)

---

## 6. Cấu trúc thư mục dự án

```
web-management-platform/
├── app/
│   ├── (auth)/
│   │   └── login/page.tsx
│   ├── (dashboard)/
│   │   ├── layout.tsx                  ← Sidebar layout
│   │   ├── page.tsx                    ← Dashboard
│   │   └── sites/
│   │       └── [siteId]/
│   │           ├── page.tsx            ← Site overview
│   │           ├── articles/
│   │           │   ├── page.tsx        ← Article list
│   │           │   └── [articleId]/
│   │           │       └── page.tsx    ← Article editor
│   │           ├── media/
│   │           │   └── page.tsx
│   │           └── settings/
│   │               └── page.tsx
│   ├── api/
│   │   └── v1/                         ← Phase 2
│   ├── globals.css
│   └── layout.tsx
├── components/
│   ├── ui/                             ← shadcn/ui components
│   ├── editor/                         ← Tiptap editor
│   ├── sites/                          ← Site-related components
│   └── articles/                       ← Article-related components
├── lib/
│   ├── supabase/
│   │   ├── client.ts                   ← Browser client
│   │   ├── server.ts                   ← Server client
│   │   └── middleware.ts
│   └── utils.ts
├── types/
│   └── database.ts                     ← TypeScript types từ Supabase
├── middleware.ts
├── .env.local
└── package.json
```

---

## 7. Tech Stack & Dependencies

### Core
```json
{
  "next": "^14.x",
  "@supabase/supabase-js": "^2.x",
  "@supabase/ssr": "^0.x",
  "typescript": "^5.x"
}
```

### UI & Styling
```json
{
  "tailwindcss": "^3.x",
  "shadcn-ui": "latest",          // Component library
  "lucide-react": "latest",       // Icons
  "@radix-ui/react-*": "latest"   // Primitives
}
```

### Editor
```json
{
  "@tiptap/react": "^2.x",
  "@tiptap/starter-kit": "^2.x",
  "@tiptap/extension-image": "^2.x"
  // HOẶC dùng "novel": "latest" (Notion-style editor)
}
```

### Utilities
```json
{
  "date-fns": "latest",           // Format dates
  "slugify": "latest",            // Auto-generate slugs
  "zod": "latest",                // Schema validation
  "react-hook-form": "latest"     // Form management
}
```

### Dev & Deploy
- **Vercel**: Auto-deploy từ GitHub main branch
- **Supabase CLI**: Quản lý migrations locally
- **TypeScript**: Strict mode

---

## 8. Checklist triển khai

### Supabase Setup
- [ ] Tạo Supabase project tại [supabase.com](https://supabase.com)
- [ ] Chạy SQL migration (Section 4.3)
- [ ] Tạo Storage bucket: `media`
- [ ] Bật Auth → Email provider
- [ ] Copy `SUPABASE_URL` và `SUPABASE_ANON_KEY`
- [ ] (Tuỳ chọn) Generate TypeScript types: `npx supabase gen types typescript`

### Next.js Setup
- [ ] `npx create-next-app@latest web-mgmt-platform --typescript --tailwind --app --src-dir`
- [ ] Cài Supabase client: `npm i @supabase/supabase-js @supabase/ssr`
- [ ] Cài shadcn/ui: `npx shadcn-ui@latest init`
- [ ] Tạo `.env.local` với Supabase credentials
- [ ] Setup middleware auth guard

### Vercel Deploy
- [ ] Push code lên GitHub
- [ ] Connect Vercel với GitHub repo
- [ ] Add Environment Variables trên Vercel dashboard
- [ ] Enable Automatic Deployments từ `main` branch

---

## 💡 Ghi chú và quyết định kỹ thuật

### Về Editor
- **Novel.sh** (Notion-style, đơn giản hơn để setup)
- **Tiptap** (linh hoạt hơn, nhiều extension)
→ **Đề xuất**: Bắt đầu với `Novel` cho nhanh, migrate sang `Tiptap` khi cần customize sâu

### Về Content Storage
- Lưu content dạng **raw HTML** hoặc **JSON (Tiptap format)** trong cột `content`
- Nếu dùng MDX, xem xét lưu Markdown string và render phía client

### Về Image Upload
- Upload lên **Supabase Storage** → lấy public URL → lưu URL vào `articles.cover_image` hoặc embed trong `content`
- Bucket policy: public read, authenticated write

### Mở rộng tương lai
- **Analytics**: Thêm table `page_views(site_id, path, count, date)` theo dõi traffic
- **Comments**: Thêm table `comments(article_id, author, content, approved)`
- **Newsletter**: Thêm table `subscribers(site_id, email, subscribed_at)`

---

## 9. Phase 2 — User Management & Multi-tenant

> **Mục tiêu**: Hệ thống quản lý user đa cấp — Admin/Editor cho dashboard và Client users cho các site con.

### 9.1 Tổng quan User Types

```
┌─────────────────────────────────────────────────────────────────┐
│                    WEB MANAGEMENT PLATFORM                       │
├─────────────────────────────────────────────────────────────────┤
│  DASHBOARD USERS (Admin/Editor)                                  │
│  ├── Super Admin: Quản lý toàn bộ platform                      │
│  ├── Site Admin: Quản lý sites được assign                      │
│  └── Editor: Chỉ edit content của sites được assign             │
├─────────────────────────────────────────────────────────────────┤
│  SITE CLIENT USERS (End users của các site con)                  │
│  ├── Subscriber: Đăng ký nhận newsletter                        │
│  ├── Member: Đăng nhập để comment, like                         │
│  └── Premium: Truy cập nội dung premium (nếu có)                │
└─────────────────────────────────────────────────────────────────┘
```

### 9.2 Database Schema — User Management

```sql
-- ═══════════════════════════════════════════════════════════════
-- BẢNG 1: profiles — Thông tin user (extends Supabase auth.users)
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE profiles (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email       TEXT NOT NULL,
  full_name   TEXT,
  avatar_url  TEXT,
  role        TEXT DEFAULT 'editor' CHECK (role IN ('super_admin', 'admin', 'editor')),
  is_active   BOOLEAN DEFAULT true,
  metadata    JSONB DEFAULT '{}',
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Trigger tự động tạo profile khi user đăng ký
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, email, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ═══════════════════════════════════════════════════════════════
-- BẢNG 2: site_members — Assign users vào sites với role cụ thể
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE site_members (
  id         UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  site_id    UUID NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  user_id    UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  role       TEXT DEFAULT 'editor' CHECK (role IN ('admin', 'editor', 'viewer')),
  invited_by UUID REFERENCES profiles(id),
  invited_at TIMESTAMPTZ DEFAULT NOW(),
  accepted_at TIMESTAMPTZ,
  UNIQUE(site_id, user_id)
);

-- ═══════════════════════════════════════════════════════════════
-- BẢNG 3: site_clients — Users của các site con (subscribers, members)
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE site_clients (
  id            UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  site_id       UUID NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  email         TEXT NOT NULL,
  password_hash TEXT,                    -- NULL nếu chỉ là subscriber
  full_name     TEXT,
  avatar_url    TEXT,
  role          TEXT DEFAULT 'subscriber' CHECK (role IN ('subscriber', 'member', 'premium')),
  is_verified   BOOLEAN DEFAULT false,
  is_active     BOOLEAN DEFAULT true,
  metadata      JSONB DEFAULT '{}',      -- preferences, subscription info
  last_login_at TIMESTAMPTZ,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(site_id, email)
);

-- ═══════════════════════════════════════════════════════════════
-- BẢNG 4: invitations — Pending invites cho dashboard users
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE invitations (
  id          UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  email       TEXT NOT NULL,
  site_id     UUID REFERENCES sites(id) ON DELETE CASCADE,  -- NULL = platform invite
  role        TEXT NOT NULL,
  token       TEXT UNIQUE NOT NULL,
  invited_by  UUID REFERENCES profiles(id),
  expires_at  TIMESTAMPTZ NOT NULL,
  accepted_at TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════════════════════════
-- INDEXES
-- ═══════════════════════════════════════════════════════════════
CREATE INDEX idx_site_members_site ON site_members(site_id);
CREATE INDEX idx_site_members_user ON site_members(user_id);
CREATE INDEX idx_site_clients_site ON site_clients(site_id);
CREATE INDEX idx_site_clients_email ON site_clients(site_id, email);
CREATE INDEX idx_invitations_token ON invitations(token);
CREATE INDEX idx_invitations_email ON invitations(email);

-- ═══════════════════════════════════════════════════════════════
-- ROW LEVEL SECURITY POLICIES
-- ═══════════════════════════════════════════════════════════════
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE invitations ENABLE ROW LEVEL SECURITY;

-- Profiles: User có thể xem/sửa profile của mình, super_admin xem tất cả
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Super admin can view all profiles" ON profiles
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'super_admin')
  );

-- Site members: Chỉ admin của site hoặc super_admin mới quản lý được
CREATE POLICY "Site admins can manage members" ON site_members
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'super_admin'
    ) OR EXISTS (
      SELECT 1 FROM site_members sm
      WHERE sm.site_id = site_members.site_id
        AND sm.user_id = auth.uid()
        AND sm.role = 'admin'
    )
  );

-- Site clients: Site admin/editor có thể xem clients của site mình
CREATE POLICY "Site members can view clients" ON site_clients
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM site_members sm
      WHERE sm.site_id = site_clients.site_id
        AND sm.user_id = auth.uid()
    )
  );
```

### 9.3 UI Screens — User Management

#### Screen 1: Users List (`/users`)
- Danh sách tất cả dashboard users (chỉ Super Admin thấy)
- Filter by role: All / Super Admin / Admin / Editor
- Search by name/email
- Actions: Invite user, Edit role, Deactivate

#### Screen 2: Invite User Modal
- Form: Email, Role (Admin/Editor), Assign to sites (multi-select)
- Gửi email invitation với magic link
- Pending invitations list

#### Screen 3: Site Members (`/sites/[siteId]/members`)
- Danh sách users có quyền truy cập site này
- Add/Remove members
- Change member role (Admin/Editor/Viewer)

#### Screen 4: Site Clients (`/sites/[siteId]/clients`)
- Danh sách end-users của site (subscribers, members)
- Filter by role: Subscriber / Member / Premium
- Export to CSV
- Bulk actions: Send email, Upgrade role

#### Screen 5: User Profile (`/settings/profile`)
- Edit own profile: Name, Avatar
- Change password
- View assigned sites

### 9.4 Permission Matrix

| Action | Super Admin | Site Admin | Site Editor | Site Viewer |
|--------|-------------|------------|-------------|-------------|
| View all sites | ✅ | ❌ (chỉ sites được assign) | ❌ | ❌ |
| Create site | ✅ | ❌ | ❌ | ❌ |
| Delete site | ✅ | ❌ | ❌ | ❌ |
| View site clients | ✅ | ✅ | ✅ | ✅ |
| Export clients | ✅ | ✅ | ❌ | ❌ |
| Create article | ✅ | ✅ | ✅ | ❌ |
| Publish article | ✅ | ✅ | ✅ | ❌ |
| Delete article | ✅ | ✅ | ❌ | ❌ |
| Upload media | ✅ | ✅ | ✅ | ❌ |
| Site settings | ✅ | ✅ | ❌ | ❌ |
| **Add Site Admin** | ✅ | ❌ | ❌ | ❌ |
| **Add Editor** | ❌ | ✅ (own site only) | ❌ | ❌ |
| **Remove members** | ✅ (all) | ✅ (editors only) | ❌ | ❌ |

#### User Management Hierarchy

```
Super Admin
├── Tạo/Xóa sites
├── Add Site Admin cho từng site
├── Remove bất kỳ member nào
└── Xem tất cả sites

Site Admin (per site)
├── Add/Remove Editor cho site mình
├── Quản lý settings của site
├── Xem clients của site
└── KHÔNG thể add Site Admin khác

Editor (per site)
├── Tạo/Edit articles
├── Upload media
└── KHÔNG thể invite ai
```

### 9.5 Implementation Sprints

```
Sprint 7 — Database & Auth Foundation
├── [ ] Chạy migration SQL cho profiles, site_members, site_clients, invitations
├── [ ] Setup trigger tự động tạo profile khi signup
├── [ ] Cập nhật RLS policies
├── [ ] Tạo helper functions: getUserRole(), canAccessSite(), etc.
└── [ ] Update Supabase types: npx supabase gen types typescript

Sprint 8 — Dashboard User Management
├── [ ] Screen: Users list (/users) — Super Admin only
├── [ ] Component: InviteUserModal
├── [ ] Server Action: inviteUserAction() — gửi email invite
├── [ ] Screen: Accept invitation (/invite/[token])
├── [ ] Component: UserRoleBadge, UserAvatar
└── [ ] Update Sidebar: hiển thị menu theo role

Sprint 9 — Site Member Management
├── [ ] Screen: Site Members (/sites/[siteId]/members)
├── [ ] Component: AddMemberModal
├── [ ] Server Action: addSiteMember(), removeSiteMember(), updateMemberRole()
├── [ ] Update article/media actions: check permission trước khi thực hiện
└── [ ] Middleware: redirect nếu không có quyền truy cập site

Sprint 10 — Site Client Management
├── [ ] Screen: Site Clients (/sites/[siteId]/clients)
├── [ ] Component: ClientsTable với pagination, filter, search
├── [ ] Server Action: exportClientsCSV()
├── [ ] API endpoint: /api/v1/sites/[siteId]/clients/subscribe (public)
├── [ ] API endpoint: /api/v1/sites/[siteId]/clients/login (public)
└── [ ] Email templates: Welcome, Verify email

Sprint 11 — Profile & Settings
├── [ ] Screen: User Profile (/settings/profile)
├── [ ] Component: AvatarUpload
├── [ ] Server Action: updateProfileAction()
├── [ ] Screen: Change Password (/settings/security)
└── [ ] Activity log: track user actions
```

### 9.6 Site Client Authentication

> **Quan trọng**: Site con tự handle UI login/register bằng **Supabase Auth SDK** trực tiếp.
> Web Management Platform chỉ cần:
> 1. Cấu hình Supabase Auth (enable providers, redirect URLs)
> 2. Dashboard UI để quản lý clients đã đăng ký

#### Supabase Auth Setup (trong Supabase Dashboard)

```
Authentication → Providers:
├── Email: ✅ Enabled (confirm email, password recovery)
├── Google: ✅ Enabled (Client ID, Client Secret từ Google Cloud)
└── (Optional) Facebook, GitHub, etc.

Authentication → URL Configuration:
├── Site URL: https://your-site.com
├── Redirect URLs:
│   ├── https://site-a.com/auth/callback
│   ├── https://site-b.com/auth/callback
│   └── http://localhost:3000/auth/callback (dev)
```

#### Site con integrate (Example code)

```typescript
// Site con dùng Supabase Auth SDK trực tiếp
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)

// Đăng ký Email/Password
await supabase.auth.signUp({ email, password })

// Đăng nhập Email/Password  
await supabase.auth.signInWithPassword({ email, password })

// Đăng nhập Google
await supabase.auth.signInWithOAuth({ 
  provider: 'google',
  options: { redirectTo: 'https://your-site.com/auth/callback' }
})
```

#### Dashboard Endpoints (quản lý clients)

```
# Protected endpoints (dashboard users only)
GET  /api/v1/sites/:slug/clients              → List all clients của site
GET  /api/v1/sites/:slug/clients/export       → Export CSV
PATCH /api/v1/sites/:slug/clients/:id         → Update client info
DELETE /api/v1/sites/:slug/clients/:id        → Delete/ban client
```

### 9.8 Dashboard Admin Auth (Không thay đổi)

> **Lưu ý**: Dashboard (`/login`) chỉ có đăng nhập, KHÔNG có đăng ký public.
> Super Admin sẽ tạo account cho Admin/Editor thông qua màn **Invite User**.

```
Dashboard Auth Flow:
1. Super Admin invite user qua email
2. User nhận email với magic link
3. User click link → Set password → Account activated
4. User đăng nhập bằng Email/Password
```

---

## 10. Phase 3 — Public API & Site Integration

> **Mục tiêu**: Các website con có thể fetch content và authenticate users thông qua API.

### 10.1 API Design

```
# Content API (Public)
GET  /api/v1/sites/:slug                      → Site info
GET  /api/v1/sites/:slug/articles             → Published articles
GET  /api/v1/sites/:slug/articles/:slug       → Article detail
GET  /api/v1/sites/:slug/media                → Public media

# Client Auth API (Public)
POST /api/v1/sites/:slug/auth/register        → Register new client
POST /api/v1/sites/:slug/auth/login           → Login client
POST /api/v1/sites/:slug/auth/logout          → Logout
POST /api/v1/sites/:slug/auth/refresh         → Refresh token
GET  /api/v1/sites/:slug/auth/me              → Current client profile

# Webhook API
POST /api/v1/webhooks/article-published       → Notify site khi có bài mới
POST /api/v1/webhooks/client-registered       → Notify khi có client mới
```

### 10.2 Authentication Flow cho Site Clients

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────┐
│  Site Con   │         │  Management API  │         │  Supabase   │
│ (Frontend)  │         │   (Next.js)      │         │  Database   │
└──────┬──────┘         └────────┬─────────┘         └──────┬──────┘
       │                         │                          │
       │ POST /auth/login        │                          │
       │ {email, password}       │                          │
       ├────────────────────────►│                          │
       │                         │  Query site_clients      │
       │                         ├─────────────────────────►│
       │                         │  Return client data      │
       │                         │◄─────────────────────────┤
       │                         │                          │
       │                         │  Generate JWT token      │
       │  {token, client}        │                          │
       │◄────────────────────────┤                          │
       │                         │                          │
       │ GET /articles (+ token) │                          │
       ├────────────────────────►│                          │
       │                         │  Verify JWT              │
       │                         │  Query articles          │
       │                         ├─────────────────────────►│
       │  {articles}             │◄─────────────────────────┤
       │◄────────────────────────┤                          │
```

### 10.3 Implementation Sprints

```
Sprint 12 — Content API
├── [ ] Route Handler: GET /api/v1/sites/:slug
├── [ ] Route Handler: GET /api/v1/sites/:slug/articles
├── [ ] Route Handler: GET /api/v1/sites/:slug/articles/:slug
├── [ ] API Key authentication (optional)
├── [ ] Rate limiting
└── [ ] Caching với revalidate

Sprint 13 — Client Auth API
├── [ ] Route Handler: POST /api/v1/sites/:slug/auth/register
├── [ ] Route Handler: POST /api/v1/sites/:slug/auth/login
├── [ ] JWT token generation & verification
├── [ ] Password hashing với bcrypt
├── [ ] Email verification flow
└── [ ] Refresh token mechanism

Sprint 14 — SDK & Documentation
├── [ ] NPM package: @web-mgmt/client-sdk
├── [ ] API documentation (OpenAPI/Swagger)
├── [ ] Example: Next.js blog consuming API
├── [ ] Example: React app với client auth
└── [ ] Postman collection
```

---

## 11. Phase 4 — Analytics & Advanced Features

### 11.1 Analytics

```sql
CREATE TABLE page_views (
  id         UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  site_id    UUID REFERENCES sites(id) ON DELETE CASCADE,
  article_id UUID REFERENCES articles(id) ON DELETE SET NULL,
  path       TEXT NOT NULL,
  referrer   TEXT,
  user_agent TEXT,
  country    TEXT,
  client_id  UUID REFERENCES site_clients(id),  -- NULL if anonymous
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE analytics_daily (
  id          UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  site_id     UUID REFERENCES sites(id) ON DELETE CASCADE,
  date        DATE NOT NULL,
  page_views  INTEGER DEFAULT 0,
  unique_visitors INTEGER DEFAULT 0,
  new_clients INTEGER DEFAULT 0,
  UNIQUE(site_id, date)
);
```

### 11.2 Advanced Features Backlog

- [ ] **Comments system**: Moderated comments on articles
- [ ] **Newsletter**: Send emails to subscribers
- [ ] **Scheduled publishing**: Publish articles at specific time
- [ ] **Article series/categories**: Organize content
- [ ] **SEO tools**: Meta tags editor, sitemap generation
- [ ] **A/B testing**: Test different headlines
- [ ] **Content versioning**: Track article revisions
- [ ] **Multi-language**: i18n support for content
- [ ] **Custom domains**: CNAME setup for sites
- [ ] **Webhooks**: Notify external services on events
