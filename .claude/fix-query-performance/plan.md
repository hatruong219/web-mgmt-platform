# Plan: Fix slow queries across all admin menu pages

## Approach
Two distinct problems: (1) `getSiteRole()` is called 2–4× per page load because every helper (`canAccessSite`, `isSiteAdmin`, `isSuperAdmin`) re-runs the same DB queries independently; (2) permission checks and module guard are awaited sequentially even though they're independent. Fix with `React.cache()` for per-request memoization (the canonical Next.js App Router solution) — zero callers need to change, and run guards in parallel where possible. Also add missing indexes for mnn_ tables.

## Root Cause Analysis

**Current per-page DB call count (worst cases):**

| Page | Auth queries (serial) | Reason |
|---|---|---|
| articles | 9 | getSiteRole×2 (direct + via canAccessSite) + requireSiteModule |
| feedbacks | 10 | canAccessSite + isSiteAdmin = getSiteRole called 2× |
| members | 13 | getSiteRole + canAccessSite + isSiteAdmin = getSiteRole called 3× |
| clients | 13 | getSiteRole + canAccessSite + isSiteAdmin = getSiteRole called 3× |

Each `getSiteRole(siteId)` call = `auth.getUser()` + `profiles` query + `site_members` query = **3 sequential DB round-trips**.

**Problem: No memoization** — `canAccessSite` / `isSiteAdmin` / `isSuperAdmin` all internally call `getSiteRole`, each spawning a new Supabase client and re-running the same 3 queries.

**Problem: Sequential guards** — pages `await getSiteRole` → then `await canAccessSite` → then `await requireSiteModule` even though role + module are independent.

**Problem: Missing mnn_ indexes** — `mnn_vocabulary`, `mnn_grammar`, `mnn_exercises` have no index on `lesson_id` or `site_id` → full table scan on every lesson detail load.

## Specs
- `getSiteRole(siteId)` DB queries run **at most once per request** regardless of how many times it's called
- `getCurrentUser()` DB queries run **at most once per request**  
- No changes to any call sites — all existing pages continue to work without modification
- Permission checks that are independent of each other run in parallel
- mnn_ tables have indexes on `lesson_id` and `site_id` for fast lookups
- After fix: articles/vocabulary pages do ≤ 3 serial DB round-trips (1 auth batch + module + page data)

## Steps

- [ ] **lib/permissions.ts** — Wrap `getCurrentUser` and `getSiteRole` with `import { cache } from 'react'`:
  ```ts
  import { cache } from 'react'
  export const getCurrentUser = cache(async (): Promise<UserProfile | null> => { ... })
  export const getSiteRole = cache(async (siteId: string): Promise<SiteRole | null> => { ... })
  ```
  This is all that's needed — `React.cache()` deduplicates per request, so calling `getSiteRole(siteId)` 4× in the same RSC render tree only hits the DB once. No changes to callers.

- [ ] **lib/modules/guard.ts** — Wrap `requireSiteModule` with `cache` similarly:
  ```ts
  import { cache } from 'react'
  const _requireSiteModule = cache(async (siteId: string, moduleId: ModuleId) => { ... })
  export async function requireSiteModule(...) { return _requireSiteModule(siteId, moduleId) }
  ```
  (cache() requires stable function identity — wrap the inner impl, export the outer)

- [ ] **app/(dashboard)/sites/[siteId]/articles/page.tsx** — Replace sequential double-call with single call:
  ```ts
  // Before: getSiteRole → await → canAccessSite → await (redundant)
  // After:
  const siteRole = await getSiteRole(siteId)
  if (!siteRole) notFound()
  await requireSiteModule(siteId, 'articles').catch(() => notFound())
  ```
  Remove the `canAccessSite` import and call (getSiteRole returning non-null IS the access check).

- [ ] **app/(dashboard)/sites/[siteId]/feedbacks/page.tsx** — Parallelize role + module check, derive `canDelete` from role instead of calling `isSiteAdmin` separately:
  ```ts
  const [siteRole] = await Promise.all([
    getSiteRole(siteId),  // thanks to cache(), isSiteAdmin below is free
    requireSiteModule(siteId, 'feedbacks').catch(() => notFound()),
  ])
  if (!siteRole) notFound()
  const canDelete = siteRole === 'admin'  // no extra DB call
  ```

- [ ] **app/(dashboard)/sites/[siteId]/clients/page.tsx** — Same pattern: remove `canAccessSite` + `isSiteAdmin` calls, derive from already-fetched `siteRole`:
  ```ts
  const [siteRole] = await Promise.all([
    getSiteRole(siteId),
    requireSiteModule(siteId, 'clients').catch(() => notFound()),
  ])
  if (!siteRole) notFound()
  const canExport = siteRole === 'admin'
  ```

- [ ] **app/(dashboard)/sites/[siteId]/members/page.tsx** — Remove `canAccessSite` + `isSiteAdmin` calls (3× getSiteRole → 1×), derive `siteAdmin` from `siteRole`:
  ```ts
  const [siteRole] = await Promise.all([
    getSiteRole(siteId),
    requireSiteModule(siteId, 'members').catch(() => notFound()),
  ])
  if (!siteRole) notFound()
  const siteAdmin = siteRole === 'admin'
  ```

- [ ] **supabase/migrations/20260601000002_mnn_indexes.sql** — Add missing indexes for mnn_ tables:
  ```sql
  CREATE INDEX idx_mnn_lessons_site    ON mnn_lessons(site_id);
  CREATE INDEX idx_mnn_lessons_order   ON mnn_lessons(site_id, lesson_number);
  CREATE INDEX idx_mnn_vocab_lesson    ON mnn_vocabulary(lesson_id);
  CREATE INDEX idx_mnn_vocab_site      ON mnn_vocabulary(site_id);
  CREATE INDEX idx_mnn_grammar_lesson  ON mnn_grammar(lesson_id);
  CREATE INDEX idx_mnn_grammar_site    ON mnn_grammar(site_id);
  CREATE INDEX idx_mnn_exercises_lesson ON mnn_exercises(lesson_id);
  CREATE INDEX idx_mnn_exercises_site   ON mnn_exercises(site_id);
  ```

## Decisions & Risks
- **`React.cache()` scope**: Deduplicates within a single React render tree per request. Works for RSC and server actions in the same request. Does NOT persist across requests — correct behavior for auth.
- **Why not Redis/in-memory cache**: Per-request dedup is sufficient. Cross-request caching of auth data would create security risks.
- **Removing `canAccessSite` calls**: `getSiteRole` returning non-null already proves access. `canAccessSite` is literally `return (await getSiteRole(siteId)) !== null` — removing its call sites is semantically identical, not a behavior change.
- **`isSiteAdmin` / `isSuperAdmin` call sites in pages**: These functions call `getSiteRole` internally, so after adding `cache()` they become effectively free (cache hit). Page-level callers don't need to change for correctness — only the explicit pages with 3× calls (members, clients) benefit from the explicit cleanup.
- **Vocabulary/decks pages**: Already call `getSiteRole` only once, no sequential redundancy — no change needed there.
- **articles `created_at DESC` index**: Already exists (`idx_articles_created_at` not visible but `idx_articles_site_id` covers the eq; the ORDER BY created_at may still need a composite index — out of scope for this fix).

---
_Task: query ở toàn bộ các menu đang rất chậm, fix performance_
_Created: 2026-06-01_
_Critic: self-reviewed — main risk is React.cache() function identity for requireSiteModule (addressed by wrapping inner impl)_
