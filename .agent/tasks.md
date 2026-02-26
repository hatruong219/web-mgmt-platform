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
| ✅ | TypeScript types (`types/database.ts`) | Manual types: Site, Article, MediaFile |
| ✅ | Setup `lib/utils.ts` (cn, formatDate, slugify, truncate) | Done |
| ✅ | Chạy SQL migration trên Supabase (sites, articles, media tables) | Done |
| ⏳ | Init shadcn/ui: `npx shadcn@latest init` | Optional — hiện dùng custom CSS |
| ✅ | Setup Supabase Auth — Email provider | Done |
| ⏳ | Generate TypeScript types: `npx supabase gen types typescript` | Optional — đã có manual types |

---

## Sprint 2 — Auth & Dashboard Layout

| Status | Task | Notes |
|--------|------|-------|
| ✅ | Trang Login (`/login`) | Form: email + password, dùng Server Action |
| ✅ | Server Action: `loginAction()` | `app/actions/auth.ts` — zod validation |
| ✅ | Server Action: `logoutAction()` | `app/actions/auth.ts` — redirect to /login |
| ✅ | Layout dashboard (`(dashboard)/layout.tsx`) | Sidebar cố định 260px |
| ✅ | Component: `Sidebar` | Navigation links, site switcher, user info, logout |
| ✅ | Trang Dashboard (`/`) — danh sách sites | RSC: fetch sites + article counts |
| ✅ | Component: `SiteCard` | Hiển thị name, domain, status, article count |
| ✅ | Dialog: Tạo site mới (`CreateSiteModal`) | Form: name, slug (auto), domain, description |
| ✅ | Server Action: `createSiteAction()` | `app/actions/sites.ts` — zod validation |

---

## Sprint 3 — Article Management

| Status | Task | Notes |
|--------|------|-------|
| ✅ | Trang Article List (`/sites/[siteId]/articles`) | Filter by status, search by title |
| ✅ | Component: `ArticleFilters` | Tabs: All/Draft/Published/Archived + search |
| ✅ | Component: `DeleteArticleButton` | Dùng Server Action |
| ✅ | Server Action: `createArticleAction()` | `app/actions/articles.ts` — zod validation |
| ✅ | Trang Article Editor (`/sites/[siteId]/articles/[articleId]`) | Supports new + edit mode |
| ✅ | Cài Tiptap editor | `@tiptap/react`, `@tiptap/starter-kit`, extensions |
| ✅ | Component: `TiptapEditor` | Toolbar: bold, italic, headings, lists, code, image, link |
| ✅ | Auto-save (debounce 3s) | Trong `ArticleEditor` component |
| ✅ | Sidebar editor: title, slug, excerpt, tags, cover image | Done |
| ✅ | Server Action: `updateArticleAction()` | `app/actions/articles.ts` — zod validation |
| ✅ | Server Action: `deleteArticleAction()` | `app/actions/articles.ts` |

---

## Sprint 4 — Media Library

| Status | Task | Notes |
|--------|------|-------|
| ✅ | Trang Media Library (`/sites/[siteId]/media`) | Done |
| ✅ | Setup Supabase Storage bucket `media-bucket` | Public bucket + env var `NEXT_PUBLIC_SUPABASE_STORAGE_BUCKET` |
| ✅ | Component: `MediaGrid` | Upload zone + thumbnail grid |
| ✅ | Upload logic: file → Supabase Storage → insert `media` record | Client-side upload |
| ✅ | Copy URL button | Clipboard API |
| ✅ | Delete media (Storage + DB record) | Dùng Server Action `deleteMediaAction` |

---

## Sprint 5 — Settings & Polish

| Status | Task | Notes |
|--------|------|-------|
| ✅ | Trang Site Settings (`/sites/[siteId]/settings`) | Done |
| ✅ | Form: Update site name, domain, description | Dùng Server Action |
| ✅ | Server Action: `updateSiteAction()` | `app/actions/sites.ts` — zod validation |
| ✅ | Danger zone: Delete site | Dùng Server Action `deleteSiteAction` |
| ✅ | Zod validation schemas | `lib/validations.ts` — all forms validated |
| ✅ | Loading states (Suspense boundaries, skeleton loaders) | `loading.tsx` cho tất cả routes |
| ✅ | Error boundaries | `error.tsx` cho dashboard + site routes |
| ✅ | Empty states (no articles, no media, no sites) | Done |
| ✅ | Not-found page cho site | `not-found.tsx` |
| ⏳ | Dark mode toggle | next-themes |
| ⏳ | Responsive layout (mobile sidebar → drawer) | Partial responsive CSS |

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
