# 📋 Product Specification — Web Management Platform

> **Version**: 1.2.0  
> **Status**: Phase 2 Planning  
> **Last Updated**: 2026-03-03  
> 
> 📁 Feature specs: [`docs/features/`](./features/)

---

## 1. Problem Statement

Managing multiple personal websites (blog, portfolio, etc.) is fragmented — each site has its own CMS, database, and admin panel. This leads to:
- Duplicate configuration and data management effort
- No unified view of content across sites
- Inconsistent publishing workflows

**Solution**: A single centralized management platform backed by one Supabase database, where all personal websites consume data through a shared API.

---

## 2. Target Users

| User | Description |
|------|-------------|
| **Owner (Primary)** | Single developer/owner who manages all sites. Full read/write access. |
| **API Consumers** | External websites (blog, portfolio) that read content via public API (Phase 2). Read-only access. |

> This is a **single-tenant** application. No multi-user support in Phase 1.

---

## 3. Core Features

### Phase 1 — Dashboard & Blog CMS *(Current)*

#### F-01: Authentication
- Email/password login via Supabase Auth
- Persistent sessions (refresh token)
- All dashboard routes protected by middleware
- Redirect unauthenticated users to `/login`

#### F-02: Site Management
- **List sites**: Dashboard shows all registered sites with name, domain, status, article count
- **Create site**: Form with name, slug (auto-generated), domain (optional), description
- **Edit site**: Update name, domain, description, metadata
- **Archive site**: Soft delete (status = 'archived'), not destructive
- **Delete site**: Hard delete with confirmation dialog (cascades to articles, media)

#### F-03: Article Management
- **List articles**: Table view with title, status badge, published date, tags
  - Filter by status: All | Draft | Published | Archived
  - Search by title (client-side for now)
  - Sort by created_at / published_at / title
- **Create article**: Auto-redirect to editor with blank article (draft)
- **Edit article**: Full-page rich text editor
  - **Editor**: Tiptap (preferred) or Novel.sh
  - Auto-save every 30 seconds (debounce on change)
  - Manual save button
  - Sidebar: SEO fields (meta title, meta description), cover image, tags, slug
- **Publish workflow**: Draft → Published (sets `published_at = NOW()`)
- **Archive article**: Move to archived state
- **Delete article**: Hard delete with confirmation

#### F-04: Media Library
- **Upload**: Drag & drop or click-to-upload (images: jpg, png, webp, gif; max 10MB)
- **List media**: Grid view with thumbnail, filename, size, upload date
- **Copy URL**: One-click copy public URL
- **Delete media**: Remove from Supabase Storage and DB record
- Storage: Supabase Storage bucket `media`, public read access

#### F-05: Site Settings
- Update site name, slug, domain, description
- View site metadata JSON (read-only display)
- Danger zone: Delete site (with typed confirmation)

---

### Phase 2 — Dynamic Module System *(Planned — prerequisite)*

#### F-11: Dynamic Site Modules
> 📄 Chi tiết: [`docs/features/F-11-dynamic-site-modules.md`](./features/F-11-dynamic-site-modules.md)

- **Module Registry** (`modules` table): danh sách tất cả module available trên platform
- **Per-site config** (`site_modules` table): từng site bật/tắt/sắp xếp module của mình
- **Settings > Modules tab**: UI để toggle, drag-reorder module trong sidebar
- **Dynamic Sidebar**: render nav items theo `site_modules` thay vì hardcode
- **Module Guard** (`requireSiteModule()`): mỗi route tự bảo vệ, 404 nếu module chưa bật

**Module categories:**

| Module | Category | Default sites |
|---|---|---|
| `settings` | system | Tất cả |
| `articles` | content | portfolio, blog |
| `media` | content | portfolio, blog |
| `members` | system | Tất cả |
| `clients` | system | Tất cả |
| `vocabulary` | learning | language-learning |
| `decks` | learning | language-learning |
| `vocabulary-import` | learning | language-learning |
| `lessons` | learning | language-learning |
| `user-progress` | learning | language-learning |

---

### Phase 2.5 — Language Learning Extension

#### F-10: Vocabulary CSV Import *(module: vocabulary-import)*
> 📄 Chi tiết: [`docs/features/F-10-vocabulary-csv-import.md`](./features/F-10-vocabulary-csv-import.md)

- **Tab "Import"** trong site navigation — chỉ hiển thị với site ID = `NEXT_PUBLIC_LANGUAGE_LEARNING_SITE_ID`
- Truy cập `/sites/[other-id]/import` → 404
- **Dropdown** chọn deck đích (lấy từ Supabase bảng `decks`)
- **Upload CSV** (drag & drop hoặc click), chỉ nhận `.csv` UTF-8, max 5MB
- **Preview** 5 dòng đầu trước khi xác nhận import
- **Import** → upsert vào bảng `vocabulary` (onConflict: `deck_id + word`)
- **Result summary**: hiển thị số thành công / skip / lỗi

**CSV format:**
```
Kanji | Hiragana | Hán Việt | Nghĩa | Chưa thuộc | Từ loại
```

**Field mapping:**
| CSV | DB field |
|---|---|
| Kanji | `word` |
| Hiragana | `reading` |
| Hán Việt | `metadata.han_viet` |
| Nghĩa | `meaning_vi` |
| Chưa thuộc | `metadata.needs_review` |
| Từ loại | `part_of_speech` |

---

### Phase 2 — Public API *(Future)*

#### F-06: REST API
```
GET /api/v1/sites                              → List all active sites
GET /api/v1/sites/:slug/articles               → List published articles
GET /api/v1/sites/:slug/articles/:articleSlug  → Get single article
GET /api/v1/sites/:slug/media                  → List media files
```
- Public endpoints (no auth required for reads)
- Rate limiting (to be defined)
- Cache headers for CDN

---

## 4. Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| **Performance** | Dashboard initial load < 2s (LCP) |
| **Responsiveness** | Mobile-friendly (at minimum usable on tablet) |
| **Accessibility** | WCAG 2.1 AA for interactive elements |
| **SEO** | Dashboard pages are private (no SEO needed). Public API should have proper headers. |
| **Security** | RLS on all tables. No secrets in client bundle. |
| **Uptime** | Vercel + Supabase managed — target 99.9% |

---

## 5. Out of Scope (Phase 1)

- ❌ Analytics / page view tracking
- ❌ Comments management
- ❌ Newsletter subscribers
- ❌ Multi-user / team collaboration
- ❌ Custom domain routing
- ❌ Scheduled publishing
- ❌ Version history / revision control
- ❌ Public API endpoints (Phase 2)

---

## 6. User Flows

### 6.1 Login Flow
```
/login → [Enter email + password] → Supabase Auth → redirect to /dashboard
```

### 6.2 Create & Publish Article
```
/sites/[siteId]/articles
  → [New Article] button
  → /sites/[siteId]/articles/new (redirect to editor with new draft)
  → [Write content, set title, cover image, tags]
  → Auto-save every 30s
  → [Publish] button → sets status='published', published_at=NOW()
  → Redirect back to article list
```

### 6.3 Upload Media
```
/sites/[siteId]/media
  → Drag image onto dropzone OR click [Upload]
  → File uploads to Supabase Storage (bucket: 'media', path: 'site_id/filename')
  → Record inserted into `media` table with public URL
  → Grid refreshes showing new image
```

---

## 7. Design Requirements

- **Theme**: Dark mode by default, with light mode toggle option
- **Color System**: Neutral base (zinc/slate) with accent color (indigo or violet)
- **Typography**: Inter (Google Fonts)
- **Component Library**: shadcn/ui (Radix UI primitives + Tailwind)
- **Icons**: Lucide React

### Layout Structure
```
┌─────────────────────────────────────────────────┐
│  Sidebar (240px fixed)  │  Main Content Area     │
│  ─────────────────────  │  ─────────────────────  │
│  Logo                   │  Page Header           │
│  ─────────────────────  │  (Breadcrumb + Title)  │
│  Navigation:            │  ─────────────────────  │
│  • Dashboard            │                        │
│  • [Site Name]          │  Content               │
│    - Articles           │                        │
│    - Media              │                        │
│    - Settings           │                        │
│  ─────────────────────  │                        │
│  User + Logout          │                        │
└─────────────────────────────────────────────────┘
```

---

## 8. Acceptance Criteria

### AC-01: Auth
- [ ] User can log in with email/password
- [ ] Unauthenticated requests to `/` redirect to `/login`
- [ ] User can log out, session is cleared

### AC-02: Site Management
- [ ] User can see list of sites on dashboard
- [ ] User can create a new site with required fields
- [ ] User can edit site name and domain
- [ ] User can delete a site (with all its articles and media)

### AC-03: Articles
- [ ] User can see list of articles filtered by status
- [ ] User can create a new draft article
- [ ] User can write content in rich text editor
- [ ] Article auto-saves every 30 seconds
- [ ] User can publish an article (status changes, published_at is set)
- [ ] User can delete an article

### AC-04: Media
- [ ] User can upload an image (drag & drop)
- [ ] Uploaded image appears in grid with thumbnail
- [ ] User can copy the public URL
- [ ] User can delete an uploaded file

### AC-05: Settings
- [ ] User can update site name and domain
- [ ] Delete site with confirmed input deletes all related data

### AC-11: Dynamic Site Modules
- [ ] `modules` table seeded with all built-in modules
- [ ] `site_modules` seeded with correct defaults per site
- [ ] Sidebar renders only enabled modules in correct order
- [ ] Settings > Modules: toggle enables/disables module, sidebar updates
- [ ] System modules cannot be toggled off
- [ ] Drag-reorder saves new `order_index` to DB
- [ ] Accessing disabled module route returns 404

### AC-10: Vocabulary CSV Import
- [ ] Tab "Import" visible only when `vocabulary-import` module is enabled for site
- [ ] Direct URL access when module not enabled returns 404 via `requireSiteModule()`
- [ ] Deck dropdown populates from Supabase `decks` table
- [ ] Valid CSV shows 5-row preview before import
- [ ] Import inserts vocabulary rows with correct `site_id` and `deck_id`
- [ ] Duplicate word in same deck → UPSERT (no duplicate rows)
- [ ] Result summary shows success / skipped / error counts
- [ ] Non-CSV file or missing required headers shows validation error
