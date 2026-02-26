# ✅ Tasks — Web Management Platform

> Tracking chi tiết tiến độ Phase 1.
> Cập nhật file này sau mỗi task hoàn thành.
> **Legend**: ✅ Done · 🚧 In Progress · ⏳ Pending · ❌ Blocked

---

## Sprint 1 — Setup & Foundation

| Status | Task | Notes |
|--------|------|-------|
| ✅ | Khởi tạo Next.js 15 với App Router + TypeScript + Tailwind | Done |
| ✅ | Cài `@supabase/supabase-js`, `@supabase/ssr` | Done |
| ✅ | Config `.env.local` với Supabase credentials | Done |
| ✅ | Tạo `lib/supabase/client.ts` (browser client) | Done |
| ✅ | Tạo `lib/supabase/server.ts` (server client) | Done |
| ✅ | Setup `middleware.ts` — bảo vệ dashboard routes | Done |
| ⏳ | Chạy SQL migration trên Supabase (sites, articles, media tables) | Xem `supabase/migrations/` |
| ⏳ | Init shadcn/ui: `npx shadcn@latest init` | |
| ⏳ | Setup Supabase Auth — Email provider | |
| ⏳ | Generate TypeScript types: `npx supabase gen types typescript` | Output → `types/database.ts` |

---

## Sprint 2 — Auth & Dashboard Layout

| Status | Task | Notes |
|--------|------|-------|
| ⏳ | Trang Login (`/login`) | Form: email + password |
| ⏳ | Server Action: `loginAction()` | Gọi `supabase.auth.signInWithPassword()` |
| ⏳ | Server Action: `logoutAction()` | Gọi `supabase.auth.signOut()` |
| ⏳ | Layout dashboard (`(dashboard)/layout.tsx`) | Sidebar cố định 240px |
| ⏳ | Component: `Sidebar` | Navigation links, user info, logout button |
| ⏳ | Trang Dashboard (`/`) — danh sách sites | RSC: fetch sites từ Supabase |
| ⏳ | Component: `SiteCard` | Hiển thị name, domain, status, article count |
| ⏳ | Dialog: Tạo site mới | Form: name, slug (auto), domain, description |
| ⏳ | Server Action: `createSiteAction()` | INSERT vào `sites` table |

---

## Sprint 3 — Article Management

| Status | Task | Notes |
|--------|------|-------|
| ⏳ | Trang Article List (`/sites/[siteId]/articles`) | |
| ⏳ | Component: `ArticleTable` | Columns: title, status, published_at, tags |
| ⏳ | Filter articles theo status (tabs) | All / Draft / Published / Archived |
| ⏳ | Server Action: `createArticleAction()` | INSERT draft → redirect to editor |
| ⏳ | Trang Article Editor (`/sites/[siteId]/articles/[articleId]`) | |
| ⏳ | Cài Tiptap: `@tiptap/react`, `@tiptap/starter-kit` | |
| ⏳ | Component: `RichTextEditor` | Tiptap editor với toolbar |
| ⏳ | Auto-save (debounce 30s) | `useDebouncedCallback` |
| ⏳ | Sidebar editor: title, slug, excerpt, tags, cover image | |
| ⏳ | Server Action: `updateArticleAction()` | UPDATE article fields |
| ⏳ | Server Action: `publishArticleAction()` | Set status='published', published_at=NOW() |
| ⏳ | Server Action: `deleteArticleAction()` | DELETE với confirmation |

---

## Sprint 4 — Media Library

| Status | Task | Notes |
|--------|------|-------|
| ⏳ | Trang Media Library (`/sites/[siteId]/media`) | |
| ⏳ | Setup Supabase Storage bucket `media` | Public read |
| ⏳ | Component: `MediaUploader` | Drag & drop zone |
| ⏳ | Upload logic: file → Supabase Storage → insert `media` record | |
| ⏳ | Component: `MediaGrid` | Thumbnail grid with file info |
| ⏳ | Copy URL button | Clipboard API |
| ⏳ | Delete media (Storage + DB record) | |

---

## Sprint 5 — Settings & Polish

| Status | Task | Notes |
|--------|------|-------|
| ⏳ | Trang Site Settings (`/sites/[siteId]/settings`) | |
| ⏳ | Form: Update site name, domain, description | react-hook-form + zod |
| ⏳ | Server Action: `updateSiteAction()` | |
| ⏳ | Danger zone: Delete site (typed confirmation) | |
| ⏳ | Server Action: `deleteSiteAction()` | CASCADE deletes articles + media |
| ⏳ | Dark mode toggle | next-themes |
| ⏳ | Responsive layout (mobile sidebar → drawer) | |
| ⏳ | Loading states (Suspense boundaries, skeleton loaders) | |
| ⏳ | Error boundaries | |
| ⏳ | Empty states (no articles, no media, no sites) | |

---

## Sprint 6 — Deploy

| Status | Task | Notes |
|--------|------|-------|
| ⏳ | Push code lên GitHub | |
| ⏳ | Connect Vercel với GitHub repo | |
| ⏳ | Add Environment Variables trên Vercel | |
| ⏳ | Test production build | `npm run build` locally first |
| ⏳ | Verify Auth flow on production | |
| ⏳ | Verify Supabase Storage on production | |

---

## Backlog (Phase 2+)

- [ ] Public REST API (`/api/v1/...`)
- [ ] Analytics: track page views per site
- [ ] SEO metadata editor (Open Graph preview)
- [ ] Article series / categories
- [ ] Scheduled publishing
- [ ] Newsletter subscriber management
