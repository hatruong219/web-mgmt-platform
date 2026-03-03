# Feature Spec — Dynamic Site Modules

> **Feature ID**: F-11  
> **Status**: 🚧 In Progress (Settings Modules UI phase)  
> **Phase**: Phase 2 (Dynamic Module System)  
> **Last Updated**: 2026-03-03  
> **Priority**: 🔴 P0 — Prerequisite cho F-10 (vocabulary import tab)  
> **Depends on**: F-02 (Site Management), F-05 (Site Settings)

---

## [Update 2026-03-03]
- Đã hoàn thành: DB migration, seed modules, dynamic sidebar, route + component cho Settings > Modules UI
- Đang triển khai: ModuleManager, ModuleCard, ModuleConfigModal, server actions (toggle, reorder, config)
- Đã chuẩn bị: Drag & drop, toggle, config modal, server actions kết nối Supabase
- Tiếp theo: Tích hợp drag & drop UI, hoàn thiện lưu thứ tự, kết nối toggle/config với DB, test edge cases

---

## 1. Problem Statement

Hiện tại các tab quản lý trong sidebar (Articles, Media, Members, Clients, Settings) được **hardcode** cho mọi site. Điều này gây ra vấn đề:

- Portfolio site (`gnourt-portfolio`) cần: **Articles, Media** → không cần Vocabulary, Decks
- Language Learning site cần: **Vocabulary, Decks, Lessons, User Progress** → không cần Articles
- Một landing page site chỉ cần: **Media, Settings** 
- Không có cách nào thêm module mới mà không sửa code

**Solution**: Xây dựng **Module Registry System** — mỗi site tự configure danh sách tab/module cần dùng, lưu trong DB, render sidebar động theo config đó.

---

## 2. Concepts

| Concept | Mô tả |
|---|---|
| **Module** | Một đơn vị chức năng quản lý (Articles, Vocabulary, Media, ...). Có route, icon, component riêng. |
| **Module Registry** | Bảng `modules` — danh sách tất cả module có sẵn trong platform |
| **Site Module** | Bảng `site_modules` — module nào được bật cho site nào, với config riêng |
| **System Module** | Module bắt buộc, không thể tắt (VD: Settings) |
| **Optional Module** | Module có thể bật/tắt tùy site |

---

## 3. Database Schema

### 3.1 Bảng `modules` — Module Registry

```sql
CREATE TABLE modules (
  id           TEXT PRIMARY KEY,            -- 'articles', 'media', 'vocabulary', 'decks', ...
  name         VARCHAR(100) NOT NULL,       -- "Bài viết", "Từ vựng"
  name_en      VARCHAR(100),               -- "Articles", "Vocabulary"
  description  TEXT,
  icon         VARCHAR(50) NOT NULL,        -- tên icon Lucide: 'FileText', 'BookOpen', ...
  route_segment VARCHAR(100) NOT NULL,      -- segment URL: 'articles', 'vocabulary', ...
  config_schema JSONB NOT NULL DEFAULT '{}',-- JSON Schema cho module config (dùng validate)
  is_system    BOOLEAN NOT NULL DEFAULT false, -- true = không thể tắt (e.g. 'settings')
  is_active    BOOLEAN NOT NULL DEFAULT true,  -- false = ẩn khỏi marketplace tạm thời
  category     VARCHAR(50),                -- 'content', 'commerce', 'learning', 'analytics'
  order_index  INT NOT NULL DEFAULT 0,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

**Seed data — Built-in modules:**

| id | name | icon | route_segment | is_system | category |
|---|---|---|---|---|---|
| `settings` | Cài đặt | `Settings` | `settings` | ✅ true | system |
| `articles` | Bài viết | `FileText` | `articles` | ❌ | content |
| `media` | Media | `Image` | `media` | ❌ | content |
| `members` | Members | `Users` | `members` | ❌ | system |
| `clients` | Clients | `Briefcase` | `clients` | ❌ | system |
| `vocabulary` | Từ vựng | `BookOpen` | `vocabulary` | ❌ | learning |
| `decks` | Bộ thẻ | `Layers` | `decks` | ❌ | learning |
| `lessons` | Bài học | `GraduationCap` | `lessons` | ❌ | learning |
| `user-progress` | Tiến độ học | `TrendingUp` | `progress` | ❌ | learning |
| `vocabulary-import` | Import CSV | `Upload` | `import` | ❌ | learning |

---

### 3.2 Bảng `site_modules` — Per-site Module Config

```sql
CREATE TABLE site_modules (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  site_id      UUID NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  module_id    TEXT NOT NULL REFERENCES modules(id) ON DELETE RESTRICT,
  is_enabled   BOOLEAN NOT NULL DEFAULT true,
  order_index  INT NOT NULL DEFAULT 0,            -- thứ tự tab trong sidebar
  config       JSONB NOT NULL DEFAULT '{}',       -- config riêng cho module+site này
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT site_modules_unique UNIQUE (site_id, module_id)
);

CREATE INDEX idx_site_modules_site_id ON site_modules(site_id);
CREATE INDEX idx_site_modules_enabled ON site_modules(site_id, is_enabled, order_index);

-- Trigger updated_at
CREATE TRIGGER update_site_modules_updated_at
  BEFORE UPDATE ON site_modules
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- RLS: Admin only
ALTER TABLE site_modules ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admin manage site_modules"
  ON site_modules USING (
    EXISTS (SELECT 1 FROM site_members WHERE site_id = site_modules.site_id AND user_id = auth.uid() AND role = 'admin')
  );
```

**`config` field ví dụ theo module:**

```jsonc
// module: 'vocabulary-import' → restrict by site_id
{
  "allowed_site_id": "1219bda2-aa1e-4288-ab7e-caff011cdf5c"
}

// module: 'articles' → custom options
{
  "enable_tags": true,
  "enable_cover_image": true,
  "default_status": "draft"
}

// module: 'vocabulary' → language config
{
  "default_language_code": "ja",
  "enable_audio_tts": true
}
```

---

## 4. ERD

```
sites
  └── site_modules (site_id, module_id, is_enabled, order_index, config)
        └── modules (id, name, icon, route_segment, is_system, category)
```

---

## 5. Feature: Module Manager trong Settings

### 5.1 UI — Tab "Modules" trong Settings

```
Settings
├── General         ← tên, domain, description
├── Modules         ← ← TẠI ĐÂY (tab mới)
└── Danger Zone     ← xóa site
```

**Layout trang Modules Settings:**

```
┌──────────────────────────────────────────────────────────┐
│  Quản lý Modules                                         │
│  Bật/tắt và sắp xếp các tab quản lý cho site này        │
│  ──────────────────────────────────────────────────────  │
│                                                          │
│  ĐANG BẬT (kéo để sắp xếp)                              │
│  ┌──────────────────────────────────────────────────┐    │
│  │ ⠿  📄 Bài viết          content   [●]  [ ⚙ ]    │    │
│  │ ⠿  🖼 Media             content   [●]  [ ⚙ ]    │    │
│  │ ⠿  ⚙  Cài đặt          system    [●]  —          │    │
│  └──────────────────────────────────────────────────┘    │
│                                                          │
│  CÓ THỂ BẬT                                             │
│  ┌──────────────────────────────────────────────────┐    │
│  │      📖 Từ vựng          learning  [○]  [ + ]    │    │
│  │      🃏 Bộ thẻ           learning  [○]  [ + ]    │    │
│  │      📤 Import CSV       learning  [○]  [ + ]    │    │
│  │      🎓 Bài học          learning  [○]  [ + ]    │    │
│  └──────────────────────────────────────────────────┘    │
│                                                          │
│  [ Lưu thứ tự ]                                          │
└──────────────────────────────────────────────────────────┘
```

**Tính năng:**
- **Toggle bật/tắt**: Toggle switch mỗi module (system module thì disabled)
- **Drag & drop reorder**: Kéo để sắp xếp thứ tự tab trong sidebar
- **Module Config**: Nút ⚙ mở modal config riêng theo từng module (nếu có `config_schema`)
- **Category badge**: `content`, `learning`, `system` để phân nhóm

### 5.2 Sidebar — Dynamic Render

Sidebar không còn hardcode nav items mà **fetch từ `site_modules`**:

```typescript
// Fetch modules cho site hiện tại (server-side, cached)
const siteModules = await supabase
  .from('site_modules')
  .select('module_id, order_index, config, modules(id, name, icon, route_segment)')
  .eq('site_id', siteId)
  .eq('is_enabled', true)
  .order('order_index')

// Render nav items dynamically
siteModules.map(sm => (
  <NavItem
    href={`/sites/${siteId}/${sm.modules.route_segment}`}
    icon={sm.modules.icon}
    label={sm.modules.name}
  />
))
```

---

## 6. Module Route Architecture

Mỗi module có một folder route riêng, tự load theo convention:

```
app/(dashboard)/sites/[siteId]/
├── articles/          ← module: 'articles'
├── media/             ← module: 'media'  
├── members/           ← module: 'members'
├── clients/           ← module: 'clients'
├── vocabulary/        ← module: 'vocabulary'       [NEW — Phase 2]
├── decks/             ← module: 'decks'            [NEW — Phase 2]
├── import/            ← module: 'vocabulary-import'[NEW — F-10]
├── lessons/           ← module: 'lessons'          [Future]
├── progress/          ← module: 'user-progress'    [Future]
└── settings/          ← module: 'settings'  
    ├── page.tsx       ← General tab
    └── modules/       ← Modules tab (NEW — F-11)
        └── page.tsx
```

---

## 7. Module Guard — Access Control

Mỗi module route tự guard bằng helper `requireSiteModule()`:

```typescript
// lib/modules/guard.ts
export async function requireSiteModule(siteId: string, moduleId: string) {
  const supabase = await createClient()
  const { data } = await supabase
    .from('site_modules')
    .select('is_enabled, config')
    .eq('site_id', siteId)
    .eq('module_id', moduleId)
    .eq('is_enabled', true)
    .single()

  if (!data) notFound()
  return data.config
}

// Dùng trong page.tsx của từng module:
// app/(dashboard)/sites/[siteId]/import/page.tsx
const config = await requireSiteModule(siteId, 'vocabulary-import')
// → tự động 404 nếu module chưa được bật cho site này
```

---

## 8. Implementation Phases

### Phase A — Foundation (F-11a) ⏱ ~4h
- [ ] Migration: tạo bảng `modules` + `site_modules`
- [ ] Seed: insert built-in modules vào `modules`
- [ ] Seed: insert default `site_modules` cho site hiện có (gnourt-portfolio → articles, media; language-learning → vocabulary, decks, import)
- [ ] `lib/modules/guard.ts` — `requireSiteModule()` helper
- [ ] `lib/modules/getSiteModules.ts` — fetch modules cho sidebar (cached)

### Phase B — Settings UI (F-11b) ⏱ ~4h
- [ ] Route: `app/(dashboard)/sites/[siteId]/settings/modules/page.tsx`
- [ ] Component: `ModuleManager.tsx` — danh sách bật/tắt
- [ ] Component: `ModuleCard.tsx` — từng module item với toggle + config button
- [ ] Server Action: `toggleSiteModule()`, `reorderSiteModules()`
- [ ] Drag & drop reorder (`@dnd-kit/core`)

### Phase C — Dynamic Sidebar (F-11c) ⏱ ~2h
- [ ] Refactor sidebar nav: từ hardcode → dynamic từ `site_modules`
- [ ] Cache sidebar modules (React cache / unstable_cache)
- [ ] Fallback nếu `site_modules` chưa có data cho site

### Phase D — Apply guard cho modules hiện có (F-11d) ⏱ ~1h
- [ ] Apply `requireSiteModule('articles')` → `app/sites/[siteId]/articles/`
- [ ] Apply `requireSiteModule('media')` → `app/sites/[siteId]/media/`
- [ ] Apply `requireSiteModule('members')` → `app/sites/[siteId]/members/`

---

## 9. File Structure

```
app/(dashboard)/sites/[siteId]/settings/
└── modules/
    └── page.tsx                        ← Settings > Modules tab

components/
└── modules/
    ├── ModuleManager.tsx               ← Container (Client Component)
    ├── ModuleCard.tsx                  ← Module item (toggle, drag handle, config btn)
    ├── ModuleConfigModal.tsx           ← Modal config riêng từng module
    └── ModuleCategoryGroup.tsx         ← Group by category

lib/
└── modules/
    ├── guard.ts                        ← requireSiteModule()
    ├── getSiteModules.ts               ← fetch + cache modules for sidebar
    └── module-registry.ts             ← type defs, moduleId constants

app/
└── actions/
    └── site-modules.ts                ← toggleSiteModule(), reorderSiteModules(), updateModuleConfig()

supabase/
└── migrations/
    └── 20260303000001_create_modules.sql
```

---

## 10. Dependencies cần thêm

| Package | Mục đích |
|---|---|
| `@dnd-kit/core` | Drag & drop reorder modules |
| `@dnd-kit/sortable` | Sortable list utilities |
| `@dnd-kit/utilities` | CSS transform utilities |

---

## 11. Acceptance Criteria

- [ ] **AC-11.1**: Bảng `modules` có đầy đủ seed data cho tất cả built-in modules
- [ ] **AC-11.2**: Bảng `site_modules` tự seed đúng defaults khi site tạo mới
- [ ] **AC-11.3**: Sidebar render đúng chỉ các module đang `is_enabled = true`
- [ ] **AC-11.4**: Thứ tự sidebar đúng theo `order_index` của `site_modules`
- [ ] **AC-11.5**: Settings > Modules: toggle bật/tắt module → sidebar cập nhật ngay
- [ ] **AC-11.6**: System modules (`settings`) không thể tắt (toggle disabled)
- [ ] **AC-11.7**: Drag & drop reorder → lưu `order_index` mới xuống DB
- [ ] **AC-11.8**: Truy cập route của module chưa bật → 404
- [ ] **AC-11.9**: `requireSiteModule()` trả về `config` đúng từ `site_modules.config`
- [ ] **AC-11.10**: Module `vocabulary-import` bật cho language-learning site → tab "Import" hiện trong sidebar

---

## 12. Migration Plan (từ hardcode → dynamic)

```
Bước 1: Tạo bảng + seed modules (không ảnh hưởng code hiện tại)
Bước 2: Implement getSiteModules() + guard helper
Bước 3: Tạo Settings > Modules UI
Bước 4: Refactor sidebar (breaking change — cần làm cùng lúc với bước 2)
Bước 5: Apply guard cho từng module route
Bước 6: F-10 (vocabulary import) dùng guard thay vì env check cứng
```

---

## 13. Timeline Estimate

| Task | Estimate |
|---|---|
| Phase A — DB + helpers | 4h |
| Phase B — Settings UI | 4h |
| Phase C — Dynamic sidebar | 2h |
| Phase D — Apply guards | 1h |
| Testing & edge cases | 2h |
| **Total** | **~13h** |

---

## 14. Relation với F-10

Sau khi F-11 hoàn thành, F-10 (Vocabulary CSV Import) sẽ được **refactor**:
- Thay vì check `siteId === LANGUAGE_LEARNING_SITE_ID` cứng trong code
- Dùng `requireSiteModule(siteId, 'vocabulary-import')` → module chỉ được bật cho language-learning site thông qua DB config
- Tab "Import" hiện trong sidebar dynamic thay vì conditional render riêng
