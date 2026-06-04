# Web Management Platform

A centralized CMS and control panel for managing multiple personal websites — one Supabase database as the single source of truth, consumed by all sites through a shared API.

```
┌─────────────────────────────────────────┐
│         Web Management Platform         │
│          (Next.js 15 + Vercel)          │
│                                         │
│  [Dashboard]  [Blog CMS]  [Media]       │
└──────────────────┬──────────────────────┘
                   │
          ┌────────▼────────┐
          │   Supabase DB   │
          │  (PostgreSQL)   │
          └────────┬────────┘
                   │
    ┌──────────────┼──────────────┐
    ▼              ▼              ▼
[Blog Site]   [Portfolio]   [Future Site]
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 15 (App Router) |
| Language | TypeScript (strict) |
| Database | PostgreSQL via Supabase |
| Auth | Supabase Auth (Email/Password) |
| Styling | Tailwind CSS + shadcn/ui |
| Forms | react-hook-form + zod |
| Deploy | Vercel |

## Features

**Phase 1 — Dashboard & Blog CMS** *(current)*

- **Authentication** — Email/password login, persistent sessions, all routes protected by middleware
- **Site Management** — Create, edit, archive, and delete sites; each site scoped by `site_id`
- **Article Management** — Rich text editor (Tiptap), auto-save every 30s, draft/publish/archive workflow, SEO metadata sidebar
- **Media Library** — Drag-and-drop upload to Supabase Storage, grid view, one-click URL copy
- **Site Settings** — Update site info, danger-zone delete with typed confirmation

**Phase 2 — Dynamic Module System** *(planned)*

- Per-site module toggle (articles, media, vocabulary, lessons, etc.)
- Dynamic sidebar rendered from `site_modules` config
- Language learning extension: vocabulary, decks, CSV import, lesson management

**Phase 3 — Public REST API** *(future)*

```
GET /api/v1/sites
GET /api/v1/sites/:slug/articles
GET /api/v1/sites/:slug/articles/:articleSlug
GET /api/v1/sites/:slug/media
```

## Project Structure

```
app/
├── (auth)/login/             ← Login page (public)
├── (dashboard)/              ← Protected layout
│   ├── page.tsx              ← Dashboard: all sites
│   └── sites/[siteId]/
│       ├── articles/         ← Article list & editor
│       ├── media/            ← Media library
│       └── settings/         ← Site settings
└── api/v1/                   ← Public API (Phase 3)
components/
├── ui/                       ← shadcn/ui primitives
├── editor/                   ← Rich text editor
├── sites/                    ← Site management
└── articles/                 ← Article management
lib/
├── supabase/
│   ├── client.ts             ← Browser client
│   ├── server.ts             ← Server client (RSC)
│   └── middleware.ts
└── utils.ts
types/
└── database.ts               ← Generated from Supabase
```

## Database Schema

Every content table is scoped with `site_id`:

| Table | Purpose |
|-------|---------|
| `sites` | Registry of all managed websites |
| `articles` | Blog posts scoped by `site_id` |
| `media` | Uploaded files scoped by `site_id` |

Key conventions: `UNIQUE(site_id, slug)`, `metadata JSONB` for flexible fields, `updated_at` auto-trigger on all tables.

## Getting Started

### Prerequisites

- Node.js 18+
- A [Supabase](https://supabase.com) project

### Setup

1. Clone the repo and install dependencies:

```bash
npm install
```

2. Copy the environment template and fill in your Supabase credentials:

```bash
cp .env.example .env.local
```

```bash
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key   # server-side only
```

3. Push the database migrations:

```bash
npx supabase db push
```

4. Start the dev server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

## Development Commands

```bash
npm run dev          # Start dev server at localhost:3000
npm run build        # Production build
npm run lint         # ESLint check
npm run type-check   # TypeScript check (tsc --noEmit)
```

## Deployment

The project is configured for Vercel. Push to `main` triggers an automatic deploy.

Set the three environment variables above in the Vercel project settings before the first deploy.

## Documentation

- [`.agent/plan.md`](.agent/plan.md) — Full development roadmap
- [`docs/spec.md`](docs/spec.md) — Product specification and acceptance criteria
- [`docs/architecture.md`](docs/architecture.md) — System design decisions
- [`docs/conventions.md`](docs/conventions.md) — Code style guide
