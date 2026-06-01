# Status: nihongo-admin-lessons

## Current
✅ Done

## Completed
- [x] supabase/migrations/20260601000001_mnn_seed_lessons_module.sql
- [x] types/database.ts — MnnLesson, MnnVocabulary, MnnGrammar, MnnExercise types added
- [x] app/actions/lessons.ts — all CRUD server actions
- [x] app/(dashboard)/sites/[siteId]/lessons/page.tsx
- [x] app/(dashboard)/sites/[siteId]/lessons/loading.tsx
- [x] app/(dashboard)/sites/[siteId]/lessons/[lessonId]/page.tsx
- [x] app/(dashboard)/sites/[siteId]/lessons/[lessonId]/loading.tsx
- [x] components/lessons/LessonList.tsx
- [x] components/lessons/LessonFormDialog.tsx
- [x] components/lessons/LessonDetailTabs.tsx
- [x] components/lessons/VocabularyTab.tsx
- [x] components/lessons/GrammarTab.tsx
- [x] components/lessons/ExercisesTab.tsx

## Notes
- Node.js v12 on dev machine — tsc/eslint require Node 14+, could not run automated checks
- No `any` types, all imports verified manually

## Last updated: 2026-06-01
