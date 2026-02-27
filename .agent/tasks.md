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
| ✅ | Generate TypeScript types: `npx supabase gen types typescript` | Done — `types/database.generated.ts` |

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

## Sprint 4 — Media Library & Integration

| Status | Task | Notes |
|--------|------|-------|
| ✅ | Trang Media Library (`/sites/[siteId]/media`) | Done |
| ✅ | Setup Supabase Storage bucket `media-bucket` | Public bucket + env var + RLS policies |
| ✅ | Component: `MediaGrid` | Upload zone + thumbnail grid |
| ✅ | Upload logic: file → Supabase Storage → insert `media` record | Client-side upload |
| ✅ | Copy URL button | Clipboard API |
| ✅ | Delete media (Storage + DB record) | Dùng Server Action `deleteMediaAction` |
| ✅ | Component: `MediaPickerModal` | Grid ảnh + tìm kiếm + upload mới trong modal |
| ✅ | Tích hợp MediaPicker vào TiptapEditor | Nút "Add image" mở Media Picker |
| ✅ | Tích hợp MediaPicker vào Cover Image | "Upload" + "Chọn từ Media" |
| ✅ | Mọi upload đều ghi `media` record | Cover upload trong editor cũng ghi DB |

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
| ✅ | Dark mode toggle | next-themes + ThemeProvider + ThemeToggle |
| ✅ | Responsive layout (mobile sidebar → drawer) | Mobile hamburger menu + drawer sidebar |

---

## Sprint 6 — Deploy

| Status | Task | Notes |
|--------|------|-------|
| ✅ | Push code lên GitHub | Done |
| ✅ | Connect Vercel với GitHub repo | Done |
| ✅ | Add Environment Variables trên Vercel | Done |
| ✅ | Test production build | Done |
| ✅ | Verify Auth flow on production | Done |
| ✅ | Verify Supabase Storage on production | Done |

---

---

## Phase 2 — User Management & Multi-tenant

### Sprint 7 — Database & Auth Foundation

| Status | Task | Notes |
|--------|------|-------|
| ✅ | Migration SQL: profiles, site_members, invitations | `supabase/migrations/20260227_001_user_management.sql` |
| ✅ | Trigger tự động tạo profile khi signup | Included in migration |
| ✅ | Cập nhật RLS policies cho multi-tenant | Policies cho profiles, site_members, invitations, sites, articles, media |
| ✅ | Helper functions: getUserRole(), canAccessSite() | `lib/permissions.ts` |
| ✅ | Update TypeScript types | `types/database.ts` — Profile, SiteMember, Invitation |

> **Action Required**: Chạy migration SQL trên Supabase Dashboard

### Sprint 8 — Dashboard User Management

| Status | Task | Notes |
|--------|------|-------|
| ✅ | Screen: Users list (`/users`) | Super Admin only |
| ✅ | Component: InviteUserModal | Email + Role + Sites |
| ✅ | Server Action: inviteUserAction() | Gửi email invite |
| ✅ | Screen: Accept invitation (`/invite/[token]`) | |
| ✅ | Component: UserRoleBadge, UserAvatar | |
| ✅ | Update Sidebar: hiển thị menu theo role | |

### Sprint 9 — Site Member Management

| Status | Task | Notes |
|--------|------|-------|
| ✅ | Screen: Site Members (`/sites/[siteId]/members`) | |
| ✅ | Component: AddMemberModal, RemoveMemberButton | |
| ✅ | Server Actions: inviteUserAction(), removeSiteMemberAction() | Reuse từ users.ts |
| ✅ | Update article/media/sites actions: check permission | |
| ✅ | Add Members link to site sidebar | |

### Sprint 10 — Site Client Management

| Status | Task | Notes |
|--------|------|-------|
| ⏳ | Supabase: Enable Google OAuth provider | Manual - Dashboard settings |
| ⏳ | Supabase: Configure redirect URLs cho các site con | Manual |
| ⏳ | Supabase: Email templates (Welcome, Verify, Reset) | Manual |
| ✅ | Migration: site_clients table | `20260227120000_site_clients.sql` |
| ✅ | Screen: Site Clients (`/sites/[siteId]/clients`) | Dashboard UI xem clients |
| ✅ | Component: ClientsTable với pagination, filter, search | |
| ✅ | Server Action: exportClientsCSV() | |
| ✅ | Docs: Hướng dẫn site con integrate Supabase Auth | `docs/site-auth-integration.md` |

> **Note**: Site con tự handle UI login/register bằng Supabase Auth SDK.
> Platform chỉ cần config Supabase và cung cấp dashboard quản lý clients.

### Sprint 11 — Profile & Settings

| Status | Task | Notes |
|--------|------|-------|
| ✅ | Screen: User Profile (`/settings/profile`) | |
| ✅ | Component: AvatarUpload | |
| ✅ | Server Action: updateProfileAction(), changePasswordAction() | |
| ✅ | Screen: Change Password (`/settings/security`) | |
| ⏳ | Activity log: track user actions | Backlog - Phase 4 |

---

## Phase 3 — Public API & Site Integration

### Sprint 12 — Content API

| Status | Task | Notes |
|--------|------|-------|
| ⏳ | Route Handler: GET `/api/v1/sites/:slug` | Site info |
| ⏳ | Route Handler: GET `/api/v1/sites/:slug/articles` | Published articles |
| ⏳ | Route Handler: GET `/api/v1/sites/:slug/articles/:slug` | Article detail |
| ⏳ | API Key authentication | Optional |
| ⏳ | Rate limiting | |
| ⏳ | Caching với revalidate | |

### Sprint 13 — SDK & Documentation

| Status | Task | Notes |
|--------|------|-------|
| ⏳ | NPM package: @web-mgmt/client-sdk | |
| ⏳ | API documentation (OpenAPI/Swagger) | |
| ⏳ | Example: Next.js blog consuming API | |
| ⏳ | Example: React app với client auth | |
| ⏳ | Postman collection | |

---

## Phase 4 — Analytics & Advanced Features (Backlog)

| Status | Task | Notes |
|--------|------|-------|
| ⏳ | Analytics: page_views, analytics_daily tables | |
| ⏳ | Analytics dashboard UI | |
| ⏳ | Comments system | Moderated comments |
| ⏳ | Newsletter: send emails to subscribers | |
| ⏳ | Scheduled publishing | |
| ⏳ | Article series / categories | |
| ⏳ | SEO metadata editor (Open Graph preview) | |
| ⏳ | Content versioning | Track revisions |
| ⏳ | Multi-language support | |
| ⏳ | Custom domains | CNAME setup |
| ⏳ | Webhooks | Notify external services |
