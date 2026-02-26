# 🏛️ Architecture — Web Management Platform

> **Purpose**: Technical design decisions, system architecture, and rationale.
> **Last Updated**: 2026-02-26

---

## 1. System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                  Web Management Platform                         │
│                  Next.js 15 on Vercel                           │
│                                                                  │
│   [Dashboard UI]   [Blog CMS]   [Settings]   [API Routes]       │
└───────────────────────────┬─────────────────────────────────────┘
                            │ Supabase SDK
                   ┌────────▼────────┐
                   │   Supabase      │
                   │  ┌───────────┐  │
                   │  │ Auth      │  │
                   │  │ Database  │  │  ← PostgreSQL + RLS
                   │  │ Storage   │  │  ← Media files
                   │  └───────────┘  │
                   └────────┬────────┘
                            │ Public API (Phase 2)
         ┌──────────────────┼──────────────────┐
         ▼                  ▼                  ▼
    [blog.site.com]    [portfolio.com]    [future-site]
       (Next.js)          (Next.js)          (any)
```

---

## 2. Next.js Architecture

### 2.1 App Router Layout

This project uses **Next.js App Router** exclusively.

```
app/
├── (auth)/                    ← Route group: no sidebar layout
│   └── login/page.tsx
├── (dashboard)/               ← Route group: has sidebar layout
│   ├── layout.tsx             ← Sidebar + nav shell
│   ├── page.tsx               ← /  → Dashboard
│   └── sites/
│       └── [siteId]/
│           ├── page.tsx       ← /sites/:siteId
│           ├── articles/
│           │   ├── page.tsx   ← /sites/:siteId/articles
│           │   └── [articleId]/
│           │       └── page.tsx  ← /sites/:siteId/articles/:id
│           ├── media/page.tsx
│           └── settings/page.tsx
├── api/
│   └── v1/                    ← Phase 2: public REST API
├── layout.tsx                 ← Root layout (fonts, providers)
└── globals.css
```

### 2.2 Data Fetching Strategy

| Location | Pattern | When to Use |
|----------|---------|------------|
| `page.tsx` (RSC) | Direct Supabase server client | Initial page data load |
| Server Action | `'use server'` functions | Mutations (create/update/delete) |
| Client Component | Supabase browser client | Real-time, optimistic updates |
| API Route Handler | `app/api/v1/` | Public external API (Phase 2) |

**Decision**: Prefer RSC + Server Actions over API routes for dashboard functionality. API routes (`/api/v1/`) are reserved for external consumers.

### 2.3 Middleware

`middleware.ts` runs on every request:
1. Check for Supabase session cookie
2. If route is under `(dashboard)` and no session → redirect to `/login`
3. If route is `/login` and has session → redirect to `/`
4. Refresh session tokens (Supabase `getSession()` in middleware)

---

## 3. Supabase Architecture

### 3.1 Database Schema

```sql
sites
├── id          UUID PK
├── name        TEXT
├── slug        TEXT UNIQUE
├── domain      TEXT
├── description TEXT
├── status      TEXT CHECK('active','archived')
├── metadata    JSONB
├── created_at  TIMESTAMPTZ
└── updated_at  TIMESTAMPTZ (auto-updated via trigger)

articles
├── id           UUID PK
├── site_id      UUID FK → sites.id (CASCADE DELETE)
├── title        TEXT
├── slug         TEXT
├── content      TEXT (Tiptap JSON or HTML)
├── excerpt      TEXT
├── cover_image  TEXT (public URL)
├── status       TEXT CHECK('draft','published','archived')
├── tags         TEXT[]
├── metadata     JSONB (SEO: meta_title, meta_description, og_image)
├── published_at TIMESTAMPTZ
├── created_at   TIMESTAMPTZ
├── updated_at   TIMESTAMPTZ (auto-updated via trigger)
└── UNIQUE(site_id, slug)

media
├── id         UUID PK
├── site_id    UUID FK → sites.id (CASCADE DELETE)
├── filename   TEXT
├── url        TEXT (Supabase Storage public URL)
├── mime_type  TEXT
├── size       BIGINT
└── created_at TIMESTAMPTZ
```

### 3.2 Row Level Security (RLS)

All tables have RLS enabled. Policies:
- `authenticated` role → full CRUD (you are the only user)
- `anon` role → no access (private dashboard)
- Phase 2: Add separate policies for public API reads on `articles` and `sites`

### 3.3 Storage

- **Bucket**: `media` (public)
- **Path pattern**: `{siteId}/{filename}` or `{siteId}/{uuid}-{filename}` to avoid conflicts
- **Allowed types**: image/jpeg, image/png, image/webp, image/gif
- **Max size**: 10MB per file
- **Policy**: Public read, authenticated write

### 3.4 Supabase Client Configuration

```
lib/supabase/
├── client.ts    → createBrowserClient()  — used in Client Components
├── server.ts    → createServerClient()   — used in RSC, Server Actions, Routes
└── middleware.ts → createServerClient()  — used in middleware.ts
```

**Key rule**: Server client reads cookies from Next.js `cookies()`. Browser client is a singleton.

---

## 4. Key Design Decisions

### 4.1 Multi-Site Pattern: `site_id` FK (not table prefix, not multi-schema)

**Decision**: Single schema with `site_id` foreign key on all content tables.

**Rationale**:
- Table prefix (`blog_articles`, `portfolio_articles`) → schema pollution, hard to query across sites
- Multi-schema (`blog.articles`, `portfolio.articles`) → complex Supabase RLS setup, not well-supported
- `site_id` FK → simple, SaaS-standard pattern (Notion, Ghost multisite), easy RLS, easy cross-site queries

### 4.2 Editor: Tiptap (not Novel, not ProseMirror direct)

**Decision**: Tiptap as the primary rich text editor.

**Rationale**:
- Tiptap is well-maintained, TypeScript-first, extensible
- Novel.sh is simpler but less customizable long-term
- ProseMirror directly is too low-level for this use case

**Content storage**: Tiptap JSON format in `articles.content`. Pro: structured, easy to transform. Con: not human-readable. Alternative: HTML string (simpler, harder to extend).

→ **Store as Tiptap JSON**, render with `@tiptap/react` or convert to HTML for API output.

### 4.3 Server Actions over API Routes for Mutations

**Decision**: Use Next.js Server Actions for dashboard data mutations.

**Rationale**:
- No need to build and maintain a separate API layer for internal dashboard use
- Type-safe end-to-end (no serialization needed)
- Automatic CSRF protection
- Easy progressive enhancement for forms
- Reserve `api/v1/` for external consumers only (Phase 2)

### 4.4 shadcn/ui over building custom components

**Decision**: Use shadcn/ui as the component foundation.

**Rationale**:
- Copy-paste components (no runtime dependency, full control)
- Built on Radix UI (accessibility handled)
- Tailwind-based (consistent with our styling approach)
- Large ecosystem, well-maintained

---

## 5. Phase 2 API Design (Future Reference)

```
Base URL: https://web-mgmt.vercel.app/api/v1

Endpoints:
  GET /sites
    → { data: Site[], count: number }

  GET /sites/:slug/articles
    ? status=published (default)
    ? page=1&per_page=20
    → { data: Article[], pagination: {...} }

  GET /sites/:slug/articles/:articleSlug
    → { data: Article }

  GET /sites/:slug/media
    ? page=1&per_page=50
    → { data: Media[] }
```

**Authentication**: 
- Public endpoints use anon key (handled by RLS — only published content visible)
- No API key required for consumers initially; add rate limiting if needed

---

## 6. Infrastructure

| Service | Purpose | Free Tier |
|---------|---------|-----------|
| **Vercel** | Next.js hosting | 100GB bandwidth/month |
| **Supabase** | Database + Auth + Storage | 500MB DB, 1GB Storage, 50MB file upload |
| **GitHub** | Source control + CI trigger | Free |

**Deployment Flow**:
```
git push main → GitHub → Vercel CI → Build → Deploy → supabase.vercel.app
```

No separate CI needed — Vercel handles build and preview deployments automatically.
