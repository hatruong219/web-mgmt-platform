# Status: fix-query-performance

## Current
✅ Done

## Completed
- [x] lib/permissions.ts — getCurrentUser + getSiteRole wrapped with React.cache()
- [x] lib/modules/guard.ts — requireSiteModule wrapped with cache (inner _requireSiteModule)
- [x] articles/page.tsx — removed redundant canAccessSite call
- [x] feedbacks/page.tsx — parallelized getSiteRole + requireSiteModule, derived canDelete from siteRole
- [x] clients/page.tsx — removed canAccessSite + isSiteAdmin, derived canExport from siteRole
- [x] members/page.tsx — removed canAccessSite + isSiteAdmin, derived siteAdmin from siteRole
- [x] supabase/migrations/20260601000002_mnn_indexes.sql — 8 indexes for mnn_ tables

## Last updated: 2026-06-01
