# Feature Spec — Vocabulary CSV Import Tab

> **Feature ID**: F-10  
> **Status**: 📋 Planned  
> **Phase**: Phase 2.5 (Language Learning extension)  
> **Last Updated**: 2026-03-03  
> **Depends on**: F-11 (Dynamic Site Modules) — **phải implement F-11 trước**  
> **Module ID**: `vocabulary-import` (enabled cho language-learning site qua `site_modules` table)

---

## 1. Tổng quan

Thêm một **tab "Import Vocabulary"** vào trang quản lý site của web-mgmt-platform, chuyên dùng để bulk import từ vựng tiếng Nhật từ file CSV vào bảng `vocabulary` của Supabase (database của project `language-learning`).

Tab này **chỉ hiển thị** khi module `vocabulary-import` được bật trong `site_modules` cho site đó (quản lý qua F-11 — Dynamic Site Modules).

Khi implement F-11 xong, language-learning site sẽ được seed sẵn module `vocabulary-import` trong `site_modules`.

---

## 2. Env Variables

Thêm vào `.env` và `.env.example` (dùng cho seed migration — không còn dùng để guard FE):

```env
# Language Learning Site ID — dùng trong migration seed để enable vocabulary-import module
NEXT_PUBLIC_LANGUAGE_LEARNING_SITE_ID=1219bda2-aa1e-4288-ab7e-caff011cdf5c
```

---

## 3. CSV Format

File CSV mà user upload phải có đúng cấu trúc header sau (UTF-8):

| Header CSV | Bắt buộc | Map sang DB field | Ghi chú |
|---|---|---|---|
| `Kanji` | ✅ | `word` | Từ gốc — ví dụ: `食べる`, `こんにちは` |
| `Hiragana` | ✅ | `reading` | Phiên âm kana — ví dụ: `たべる` |
| `Hán Việt` | ❌ | `metadata.han_viet` | Âm Hán Việt — ví dụ: `thực` |
| `Nghĩa` | ✅ | `meaning_vi` | Nghĩa tiếng Việt |
| `Chưa thuộc` | ❌ | `metadata.needs_review` | `true`/`false` hoặc `1`/`0` |
| `Từ loại` | ❌ | `part_of_speech` | `動詞`, `名詞`, `形容詞`, ... |

**Ví dụ file CSV hợp lệ:**
```csv
Kanji,Hiragana,Hán Việt,Nghĩa,Chưa thuộc,Từ loại
食べる,たべる,thực,ăn,true,動詞
飲む,のむ,ẩm,uống,false,動詞
学校,がっこう,học hiệu,trường học,true,名詞
```

---

## 4. UI / UX

### 4.1 Vị trí

Trong layout site `app/(dashboard)/sites/[siteId]/`, thêm tab **"Import"** vào thanh tab navigation (cạnh Articles, Media, Settings).

```
[Articles] [Media] [Import] [Settings]
                      ↑ Tab mới — chỉ hiện nếu siteId === LANGUAGE_LEARNING_SITE_ID
```

### 4.2 Layout Tab `app/(dashboard)/sites/[siteId]/import/page.tsx`

```
┌─────────────────────────────────────────────────────────┐
│  Import Vocabulary                                       │
│  ─────────────────────────────────────────────────────  │
│                                                         │
│  Deck đích:  [Dropdown — Chọn deck]  ▼                  │
│                                                         │
│  File CSV:   [ Drop file here or click to upload  ]     │
│              Chỉ nhận .csv · UTF-8 · Tối đa 5MB         │
│                                                         │
│  [ Preview bảng — 5 dòng đầu của CSV ]                  │
│                                                         │
│  [ Import (X dòng) ]   [ Clear ]                        │
│                                                         │
│  ─────── Kết quả import ───────                         │
│  ✅ 42 từ imported thành công                            │
│  ⚠️  3 dòng bỏ qua (thiếu trường bắt buộc)              │
│  ❌ 1 lỗi (duplicate word trong deck)                   │
│                                                         │
│  [Xem chi tiết lỗi ▼]                                   │
└─────────────────────────────────────────────────────────┘
```

### 4.3 Dropdown Deck

- Lấy tất cả `decks` theo `site_id = LANGUAGE_LEARNING_SITE_ID` từ Supabase
- Hiển thị: `{emoji} {name}` — ví dụ: `📚 JLPT N5 — Từ cơ bản`
- Bắt buộc chọn trước khi upload

### 4.4 File Upload

- Chấp nhận: `.csv` only
- Encoding: UTF-8 (validate)
- Max size: 5MB
- Parse client-side bằng `papaparse`

### 4.5 Preview

- Hiển thị **5 dòng đầu** dạng bảng trước khi import
- Highlight cột nào bị thiếu hoặc sai

### 4.6 Import Result

- Sau khi import xong, hiển thị summary:
  - Số dòng thành công
  - Số dòng skip (thiếu field bắt buộc)
  - Số dòng lỗi (DB error, duplicate, etc.)
- Có thể expand để xem chi tiết từng lỗi (row number + reason)

---

## 5. Logic xử lý

### 5.1 Parse CSV

```
1. Đọc file bằng FileReader (UTF-8)
2. Parse bằng papaparse (header: true, skipEmptyLines: true)
3. Validate header — phải có ít nhất: Kanji, Hiragana, Nghĩa
4. Map từng row → VocabularyInsert object
5. Validate từng row:
   - word (Kanji) không được rỗng
   - meaning_vi (Nghĩa) không được rỗng
   - reading (Hiragana) không được rỗng
6. Tách rows hợp lệ vs rows lỗi
```

### 5.2 Import vào Supabase

```
1. Gọi Server Action hoặc API Route (POST /api/vocabulary/import)
2. Nhận: { deckId, rows: VocabularyInsert[] }
3. Dùng Supabase Service Role Key để bypass RLS (admin write)
4. Batch insert: supabase.from('vocabulary').upsert(rows, { onConflict: 'deck_id,word' })
   → onConflict strategy: UPSERT (update nếu đã tồn tại cùng word trong deck)
5. Return: { success: number, errors: { row, message }[] }
```

### 5.3 Field Mapping chi tiết

```typescript
type VocabularyInsert = {
  site_id: string            // = LANGUAGE_LEARNING_SITE_ID (env)
  deck_id: string            // từ dropdown
  language_code: 'ja'        // hardcoded
  word: string               // CSV: Kanji
  reading: string            // CSV: Hiragana
  meaning_vi: string         // CSV: Nghĩa
  part_of_speech?: string    // CSV: Từ loại (optional)
  metadata: {
    han_viet?: string        // CSV: Hán Việt
    needs_review?: boolean   // CSV: Chưa thuộc → parse boolean
  }
  is_active: true
  order_index: number        // = row index trong CSV (stt)
}
```

---

## 6. File Structure

```
app/(dashboard)/sites/[siteId]/
├── import/
│   └── page.tsx                         ← Import tab page (Server Component, guard check)
components/
└── vocabulary-import/
    ├── VocabularyImportTab.tsx          ← Main container (Client Component)
    ├── DeckSelector.tsx                 ← Dropdown chọn deck
    ├── CsvDropzone.tsx                  ← File upload + drag & drop
    ├── CsvPreviewTable.tsx              ← Preview 5 dòng đầu
    └── ImportResultSummary.tsx          ← Kết quả sau import
app/
└── actions/
    └── vocabulary-import.ts            ← Server Action: importVocabularyFromCsv()
lib/
└── vocabulary-import/
    ├── parse-csv.ts                     ← Parse & validate CSV rows
    └── map-csv-to-vocabulary.ts         ← Map CSV row → VocabularyInsert
```

---

## 7. Access Control

Dùng `requireSiteModule()` từ F-11 thay vì check env cứng:

```typescript
// app/(dashboard)/sites/[siteId]/import/page.tsx
import { requireSiteModule } from '@/lib/modules/guard'

export default async function ImportPage({ params }) {
  const { siteId } = await params
  // Tự động 404 nếu module chưa được enable cho site này
  const moduleConfig = await requireSiteModule(siteId, 'vocabulary-import')
  // ...
}
```

Tab "Import" hiện trong sidebar vì `vocabulary-import` module có `is_enabled = true` trong `site_modules` (dynamic, không hardcode).

---

## 8. Dependencies cần thêm

| Package | Mục đích |
|---|---|
| `papaparse` | Parse CSV client-side |
| `@types/papaparse` | TypeScript types |

---

## 9. Acceptance Criteria

- [ ] **AC-10.1**: Tab "Import" chỉ hiển thị trong site navigation khi `siteId === LANGUAGE_LEARNING_SITE_ID`
- [ ] **AC-10.2**: Truy cập thẳng URL `/sites/[other-id]/import` → `404 Not Found`
- [ ] **AC-10.3**: Dropdown hiển thị đúng danh sách decks của site language-learning
- [ ] **AC-10.4**: Upload file CSV đúng format → preview 5 dòng đầu hiển thị đúng
- [ ] **AC-10.5**: Upload file không phải CSV → hiển thị lỗi, không cho import
- [ ] **AC-10.6**: File CSV thiếu header bắt buộc (Kanji/Hiragana/Nghĩa) → hiển thị lỗi rõ ràng
- [ ] **AC-10.7**: Import thành công → từ vựng xuất hiện trong Supabase với đúng `deck_id` và `site_id`
- [ ] **AC-10.8**: Từ đã tồn tại (cùng `word` trong `deck_id`) → UPSERT (cập nhật, không tạo duplicate)
- [ ] **AC-10.9**: Hiển thị summary: số thành công / skip / lỗi sau khi import
- [ ] **AC-10.10**: File CSV có ký tự tiếng Nhật và tiếng Việt (UTF-8) → parse đúng

---

## 10. Out of Scope

- ❌ Export vocabulary ra CSV
- ❌ Import cho các ngôn ngữ khác (chỉ `language_code = 'ja'` cho phase này)
- ❌ Import `vocabulary_examples` (câu ví dụ) — Phase 2
- ❌ Import audio_url / image_url
- ❌ Undo import
- ❌ Scheduled / background import (file quá lớn)

---

## 11. Timeline estimate

| Task | Estimate |
|---|---|
| Setup env + route guard | 0.5h |
| DeckSelector component | 0.5h |
| CsvDropzone + papaparse integration | 1h |
| CsvPreviewTable | 0.5h |
| parse-csv + map-csv-to-vocabulary logic | 1h |
| Server Action importVocabularyFromCsv | 1h |
| ImportResultSummary UI | 0.5h |
| Tab navigation conditional render | 0.5h |
| Testing + edge cases | 1h |
| **Total** | **~6.5h** |
