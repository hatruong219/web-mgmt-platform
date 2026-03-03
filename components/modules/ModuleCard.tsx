'use client'

import React from 'react'
import type { SiteModule, AvailableModule } from '@/lib/modules/module-registry'
import { useSortable } from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'

// Icon map dùng SVG inline để khớp với Sidebar
const CategoryColors: Record<string, string> = {
  system: 'var(--badge-system)',
  content: 'var(--badge-content)',
  learning: 'var(--badge-learning)',
  commerce: 'var(--badge-commerce)',
}

interface SiteModuleCardProps {
  module: SiteModule
  onToggle: (moduleId: string, enabled: boolean) => void
  onConfig: (moduleId: string) => void
  isPending?: boolean
}

interface AvailableModuleCardProps {
  module: AvailableModule
  onEnable: (moduleId: string) => void
  isPending?: boolean
}

// ── Sortable (drag & drop) card cho enabled modules ──────────────────────────
export function SortableModuleCard({ module, onToggle, onConfig, isPending }: SiteModuleCardProps) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: module.module_id, disabled: module.modules.is_system })

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
    zIndex: isDragging ? 999 : undefined,
  }

  const isSystem = module.modules.is_system
  const catColor = CategoryColors[module.modules.category] || '#888'

  return (
    <div ref={setNodeRef} style={style} className={`module-card ${isDragging ? 'dragging' : ''}`}>
      {/* Drag handle */}
      <button
        className={`module-drag-handle ${isSystem ? 'disabled' : ''}`}
        {...(isSystem ? {} : { ...attributes, ...listeners })}
        aria-label="Kéo để sắp xếp"
        disabled={isSystem}
        title={isSystem ? 'Module hệ thống không thể sắp xếp' : 'Kéo để sắp xếp'}
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <circle cx="9" cy="5" r="1" fill="currentColor" /><circle cx="15" cy="5" r="1" fill="currentColor" />
          <circle cx="9" cy="12" r="1" fill="currentColor" /><circle cx="15" cy="12" r="1" fill="currentColor" />
          <circle cx="9" cy="19" r="1" fill="currentColor" /><circle cx="15" cy="19" r="1" fill="currentColor" />
        </svg>
      </button>

      {/* Module info */}
      <div className="module-card-info">
        <span className="module-card-name">{module.modules.name}</span>
        <span className="module-card-badge" style={{ '--badge-color': catColor } as React.CSSProperties}>
          {module.modules.category}
        </span>
      </div>

      {/* Actions */}
      <div className="module-card-actions">
        {!isSystem && (
          <button
            className={`module-config-btn`}
            onClick={() => onConfig(module.module_id)}
            title="Cấu hình module"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="3" />
              <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z" />
            </svg>
          </button>
        )}

        <label className={`module-toggle-wrap ${isSystem ? 'disabled' : ''}`} title={isSystem ? 'Module hệ thống không thể tắt' : undefined}>
          <input
            type="checkbox"
            className="module-toggle-input"
            checked={module.is_enabled}
            disabled={isSystem || isPending}
            onChange={(e) => onToggle(module.module_id, e.target.checked)}
          />
          <span className="module-toggle-slider" />
        </label>

        {isSystem && (
          <span className="module-system-badge">system</span>
        )}
      </div>
    </div>
  )
}

// ── Card cho module chưa được bật (available) ────────────────────────────────
export function AvailableModuleCard({ module, onEnable, isPending }: AvailableModuleCardProps) {
  const catColor = CategoryColors[module.category] || '#888'
  return (
    <div className="module-card available">
      <div className="module-card-info">
        <span className="module-card-name">{module.name}</span>
        {module.description && (
          <span className="module-card-desc">{module.description}</span>
        )}
        <span className="module-card-badge" style={{ '--badge-color': catColor } as React.CSSProperties}>
          {module.category}
        </span>
      </div>
      <button
        className="module-enable-btn"
        disabled={isPending}
        onClick={() => onEnable(module.id)}
      >
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
          <line x1="12" y1="5" x2="12" y2="19" /><line x1="5" y1="12" x2="19" y2="12" />
        </svg>
        Bật
      </button>
    </div>
  )
}
