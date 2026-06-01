# Plan: Admin pages for MNN Lessons (Nihongo)

## Approach
Add a `lessons` admin section under `/sites/[siteId]/lessons/` with a list page and a lesson detail page that has tabbed sub-sections (từ vựng, ngữ pháp, bài tập). Follows the existing articles/vocabulary RSC pattern — server component fetches data, client components handle forms and mutations via server actions.

## Specs
- List page shows all `mnn_lessons` for a site, sorted by `lesson_number`, with "Edit" link and "Delete" button per row
- "New Lesson" button opens a dialog with form fields: lesson_number, title_vi, situation_vi, order_index
- `lesson_number` uniqueness errors returned from server action and displayed in dialog
- Lesson detail page (`/lessons/[lessonId]`) has 3 tabs (local `useState`, not URL param): Từ vựng / Ngữ pháp / Bài tập
- Each tab has an inline table with Add/Edit/Delete actions via server actions
- Exercises tab shows/hides `options` textarea only when `type === 'multiple_choice'`; passes `null` for `fill_blank`
- Module guard uses `requireSiteModule(siteId, 'lessons')` — must be seeded into `site_modules` via migration
- All server actions use `createAdminClient()` (bypasses RLS); no `updated_at` field used (not in mnn_ schema)
- `revalidatePath` in sub-table actions covers both list path and detail path

## Steps

- [x] **supabase/migrations/20260601000001_mnn_seed_lessons_module.sql** — Seed `modules` table with `('lessons', 'Bài học MNN', ...)` row and seed `site_modules` for the language-learning site with `lessons` enabled (same pattern as `20260304000001_create_feedbacks.sql` lines 51-64)

- [x] **types/database.ts** — Add interfaces:
  ```ts
  MnnLesson { id, site_id, lesson_number: number, title_vi, situation_vi: string|null, order_index: number, created_at }
  MnnVocabulary { id, site_id, lesson_id, word, reading: string|null, romanization: string|null, meaning_vi, part_of_speech: string|null, order_index: number }
  MnnGrammar { id, site_id, lesson_id, pattern, explanation_vi, example_ja: string|null, example_vi: string|null, order_index: number }
  MnnExercise { id, site_id, lesson_id, type: 'fill_blank'|'multiple_choice', question, options: Json|null, answer, explanation_vi: string|null, order_index: number }
  ```

- [x] **app/actions/lessons.ts** — Server actions using `createAdminClient()`:
  - `createLesson(siteId, data)` / `updateLesson(id, siteId, data)` / `deleteLesson(id, siteId)` — revalidate `/sites/${siteId}/lessons`
  - `createMnnVocab(lessonId, siteId, data)` / `updateMnnVocab(id, lessonId, siteId, data)` / `deleteMnnVocab(id, lessonId, siteId)` — revalidate both paths
  - `createMnnGrammar(...)` / `updateMnnGrammar(...)` / `deleteMnnGrammar(...)` — revalidate both paths
  - `createMnnExercise(...)` / `updateMnnExercise(...)` / `deleteMnnExercise(...)` — revalidate both paths; `options` = `null` for `fill_blank`, `string[]` for `multiple_choice`
  - All actions return `{ error?: string; success?: boolean }` — no `updated_at` field in any update payload

- [x] Create **app/(dashboard)/sites/[siteId]/lessons/page.tsx** — RSC: call `getSiteRole(siteId)` → `canAccessSite(siteId)` → `requireSiteModule(siteId, 'lessons')`, fetch site name + all lessons ordered by `lesson_number`, render `LessonList` client component

- [ ] Create **app/(dashboard)/sites/[siteId]/lessons/loading.tsx** — loading skeleton (same pattern as articles/loading.tsx)

- [ ] Create **app/(dashboard)/sites/[siteId]/lessons/[lessonId]/page.tsx** — RSC: permission guards, fetch lesson + all 3 sub-tables in parallel via `Promise.all`, 404 if lesson not found, render `LessonDetailTabs` client component with typed props

- [ ] Create **app/(dashboard)/sites/[siteId]/lessons/[lessonId]/loading.tsx** — loading skeleton

- [ ] Create **components/lessons/LessonList.tsx** — Client: table of `MnnLesson[]`, "Edit" link → `/sites/${siteId}/lessons/${lesson.id}`, Delete calls `deleteLesson`, "New" button opens `LessonFormDialog`

- [ ] Create **components/lessons/LessonFormDialog.tsx** — shadcn Dialog: form fields lesson_number (number), title_vi (text), situation_vi (textarea), order_index (number); calls `createLesson`/`updateLesson`; displays returned `error` string inline

- [ ] Create **components/lessons/LessonDetailTabs.tsx** — Client: `useState<'vocabulary'|'grammar'|'exercises'>` for active tab; renders `VocabularyTab`, `GrammarTab`, or `ExercisesTab` based on active tab; receives all data as typed props

- [ ] Create **components/lessons/VocabularyTab.tsx** — Client: table of `MnnVocabulary[]`, Add/Edit/Delete via server actions, inline dialog for word/reading/romanization/meaning_vi/part_of_speech/order_index

- [ ] Create **components/lessons/GrammarTab.tsx** — Client: table of `MnnGrammar[]`, Add/Edit/Delete via server actions, inline dialog for pattern/explanation_vi/example_ja/example_vi/order_index

- [ ] Create **components/lessons/ExercisesTab.tsx** — Client: table of `MnnExercise[]`, Add/Edit/Delete via server actions, inline dialog with type selector; `options` textarea only shown when `type === 'multiple_choice'`; converts comma-separated string to `string[]` on save; passes `null` for `fill_blank`

## Decisions & Risks
- **No RLS migration**: All mutations go through `createAdminClient()` (SERVICE_ROLE_KEY) which bypasses RLS entirely. Adding write policies to mnn_ tables would have no effect on this app.
- **No `updated_at` in update payloads**: `mnn_lessons`, `mnn_vocabulary`, `mnn_grammar`, `mnn_exercises` have no `updated_at` column — do not include it in `.update()` calls.
- **Tab state is local `useState`**: URL searchParam would cause unnecessary RSC re-renders and re-fetches of all three sub-tables on every tab click. Local state is simpler and correct here.
- **Migration must seed both `modules` and `site_modules`**: TypeScript `ModuleId` type already includes `'lessons'` but the DB rows are missing — `requireSiteModule` will 404 without them.
- **lesson_number uniqueness**: On constraint violation Supabase returns error code `23505`; action returns `{ error: error.message }` which the dialog displays below the form.
- **`options` typing**: `MnnExercise.options` is `Json | null` to match the existing `Json` type alias; components cast to `string[]` when rendering `multiple_choice` rows.

---
_Task: đã bổ sung db cho phần lessor nihongo nhưng chưa có phần web quản lý ở admin page, hãy thêm phần đó đi nhỉ_
_Created: 2026-06-01_
_Critic findings: 11 issues found and fixed — critical: lessons module not seeded in DB, no updated_at on mnn tables, missing getSiteRole guard; major: wrong tab state approach (URL→useState), missing revalidatePath for detail path, missing loading.tsx files; minor: options type precision, exercises conditional field_
