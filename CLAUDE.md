# CLAUDE.md — AI Agent Instructions

> This file tells AI assistants (Claude, Gemini, Copilot, etc.) how to work with this codebase.
> Read this file **first** before making any changes.

---

## 🏗️ Project Overview

**Web Management Platform** — A centralized CMS/control panel for managing multiple personal websites.

- **Stack**: Next.js 15 (App Router) · Supabase · TypeScript · Tailwind CSS · shadcn/ui
- **Database**: PostgreSQL via Supabase (multi-site with `site_id` FK pattern)
- **Auth**: Supabase Auth (Email/Password)
- **Deploy**: Vercel

---

## 📁 Project Structure

```
app/
├── (auth)/login/             ← Login page (public)
├── (dashboard)/              ← Protected layout with sidebar
│   ├── layout.tsx            ← Main dashboard layout
│   ├── page.tsx              ← Dashboard: list of all sites
│   └── sites/[siteId]/
│       ├── page.tsx          ← Site overview
│       ├── articles/         ← Article list & editor
│       ├── media/            ← Media library
│       └── settings/         ← Site settings
├── api/v1/                   ← Public API (Phase 2)
components/
├── ui/                       ← shadcn/ui primitives
├── editor/                   ← Tiptap/Novel rich text editor
├── sites/                    ← Site management components
└── articles/                 ← Article management components
lib/
├── supabase/
│   ├── client.ts             ← Browser Supabase client
│   ├── server.ts             ← Server Supabase client (RSC)
│   └── middleware.ts         ← Auth middleware helper
└── utils.ts                  ← Shared utilities (cn, slugify, etc.)
types/
└── database.ts               ← TypeScript types (from Supabase gen)
```

---

## ⚙️ Development Commands

```bash
npm run dev          # Start dev server at localhost:3000
npm run build        # Production build
npm run lint         # ESLint check
npm run type-check   # TypeScript check (tsc --noEmit)
```

---

## 🔑 Core Rules

### 1. TypeScript — Always Strict
- Use **strict TypeScript** — no `any`, no casting with `as` unless absolutely necessary
- Generate and use types from `types/database.ts` (via `supabase gen types typescript`)
- Use `zod` for runtime validation of API inputs and form data

### 2. Data Fetching
- **Server Components** (RSC) fetch data directly using `lib/supabase/server.ts`
- **Client Components** use `@supabase/supabase-js` browser client from `lib/supabase/client.ts`
- Prefer RSC for initial data load; use client fetching only for mutations and real-time
- **Always handle errors** — never assume queries succeed

### 3. File Naming
- Pages: `page.tsx` (Next.js App Router convention)
- Components: `PascalCase.tsx` (e.g., `ArticleCard.tsx`)
- Utilities/hooks: `camelCase.ts` (e.g., `useArticles.ts`, `formatDate.ts`)
- All folders: `kebab-case`

### 4. Component Structure
```tsx
// 1. Imports (external → internal → types → styles)
// 2. Types/interfaces
// 3. Component definition
// 4. Export

// Prefer named exports for components
export function ArticleCard({ article }: ArticleCardProps) { ... }
```

### 5. Supabase Usage
- **NEVER** use `supabase.auth.admin` client-side
- **NEVER** expose `SERVICE_ROLE_KEY` to client
- Always check `error` from Supabase responses before using `data`
- Use RLS (Row Level Security) — policies are defined in `supabase/migrations/`

### 6. Styling
- Use **Tailwind CSS** utility classes
- Use **shadcn/ui** components for UI primitives (Button, Input, Dialog, etc.)
- Use `cn()` helper from `lib/utils.ts` for conditional classes
- Dark mode: use Tailwind's `dark:` variant; theme defined in `globals.css`

### 7. Forms
- Use `react-hook-form` + `zod` resolver for all forms
- Handle loading, error, and success states explicitly

### 8. Mutations & Server Actions
- Use **Next.js Server Actions** for mutations (preferred over API routes for dashboard)
- Use `api/v1/` Route Handlers for external-facing public API (Phase 2)
- Revalidate affected paths after mutations using `revalidatePath()`

---

## 🗄️ Database Conventions

### Tables
| Table | Purpose |
|-------|---------|
| `sites` | Registry of all managed websites |
| `articles` | Blog posts / content (scoped by `site_id`) |
| `media` | Uploaded files (scoped by `site_id`) |

### Key Patterns
- Every content table has `site_id UUID REFERENCES sites(id)`
- Use `metadata JSONB` for site-specific fields
- Slugs are unique **per site**: `UNIQUE(site_id, slug)`
- `created_at` / `updated_at` on all tables (trigger auto-updates `updated_at`)

### Migrations
- Store migrations in `supabase/migrations/`
- Name format: `YYYYMMDDHHMMSS_description.sql`
- Run with: `npx supabase db push`

---

## 🔐 Environment Variables

```bash
# Required — never commit these
NEXT_PUBLIC_SUPABASE_URL=       # Supabase project URL
NEXT_PUBLIC_SUPABASE_ANON_KEY=  # Public anon key (safe for client)
SUPABASE_SERVICE_ROLE_KEY=      # Secret — server-side only, NEVER expose
```

---

## 🚧 Current Phase

**Phase 1 — UI & Blog CMS** (In Progress)

See `.agent/tasks.md` for detailed task tracking.
See `.agent/plan.md` for development roadmap.
See `docs/spec.md` for full product requirements.
See `docs/architecture.md` for system design decisions.
See `docs/conventions.md` for code style guide.

---

## ❌ Anti-Patterns to Avoid

- ❌ Don't use `pages/` router — this project uses **App Router** only
- ❌ Don't use `getServerSideProps` or `getStaticProps`
- ❌ Don't query Supabase directly in client components without proper error handling
- ❌ Don't bypass RLS with service role key in public-facing code
- ❌ Don't create new UI components if a shadcn/ui equivalent exists
- ❌ Don't put business logic in `page.tsx` — extract to `actions/` or `lib/`
