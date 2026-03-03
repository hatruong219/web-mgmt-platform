'use client'

import React, { useState } from 'react'
import { updateModuleConfig } from '@/app/actions/site-modules'

interface ModuleConfigModalProps {
  siteId: string
  moduleId: string
  moduleName: string
  open: boolean
  onClose: () => void
  config: Record<string, unknown>
  onSaved?: () => void
}

export default function ModuleConfigModal({
  siteId,
  moduleId,
  moduleName,
  open,
  onClose,
  config,
  onSaved,
}: ModuleConfigModalProps) {
  const [draft, setDraft] = useState<string>(JSON.stringify(config, null, 2))
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  if (!open) return null

  const handleSave = async () => {
    try {
      setSaving(true)
      setError(null)
      const parsed = JSON.parse(draft)
      await updateModuleConfig(siteId, moduleId, parsed)
      onSaved?.()
      onClose()
    } catch (e) {
      setError(e instanceof Error ? e.message : 'JSON không hợp lệ')
    } finally {
      setSaving(false)
    }
  }

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3 className="modal-title">
            Cấu hình module
            <span className="modal-module-name">{moduleName}</span>
          </h3>
          <button className="modal-close-btn" onClick={onClose} aria-label="Đóng">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>
        </div>

        <p className="modal-desc">
          Chỉnh sửa JSON config cho module <strong>{moduleId}</strong>. Thay đổi sẽ ảnh hưởng đến hành vi của module này trên site.
        </p>

        <div className="modal-editor-wrap">
          <textarea
            className={`modal-editor ${error ? 'error' : ''}`}
            value={draft}
            onChange={(e) => {
              setDraft(e.target.value)
              setError(null)
            }}
            spellCheck={false}
            rows={12}
          />
          {error && <p className="modal-error">{error}</p>}
        </div>

        <div className="modal-footer">
          <button className="modal-btn-cancel" onClick={onClose} disabled={saving}>
            Hủy
          </button>
          <button className="modal-btn-save" onClick={handleSave} disabled={saving}>
            {saving ? 'Đang lưu...' : 'Lưu config'}
          </button>
        </div>
      </div>
    </div>
  )
}
