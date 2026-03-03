'use client'

import React, { useState, useTransition, useCallback } from 'react'
import {
  DndContext,
  DragEndEvent,
  MouseSensor,
  TouchSensor,
  useSensor,
  useSensors,
  closestCenter,
} from '@dnd-kit/core'
import {
  SortableContext,
  arrayMove,
  verticalListSortingStrategy,
} from '@dnd-kit/sortable'
import { restrictToVerticalAxis } from '@dnd-kit/modifiers'
import type { SiteModule, AvailableModule } from '@/lib/modules/module-registry'
import {
  toggleSiteModule,
  reorderSiteModules,
  enableSiteModule,
} from '@/app/actions/site-modules'
import { SortableModuleCard, AvailableModuleCard } from './ModuleCard'
import ModuleConfigModal from './ModuleConfigModal'

interface ModuleManagerProps {
  siteId: string
  siteName: string
  siteModules: SiteModule[]
  unavailableModules: AvailableModule[]
}

export default function ModuleManager({
  siteId,
  siteName,
  siteModules,
  unavailableModules,
}: ModuleManagerProps) {
  const [modules, setModules] = useState<SiteModule[]>(siteModules)
  const [available, setAvailable] = useState<AvailableModule[]>(unavailableModules)
  const [isPending, startTransition] = useTransition()

  // Config modal state
  const [configModal, setConfigModal] = useState<{
    open: boolean
    moduleId: string
    moduleName: string
    config: Record<string, unknown>
  } | null>(null)

  // ─── DnD sensors ───────────────────────────────────────────────────────────
  const sensors = useSensors(
    useSensor(MouseSensor, { activationConstraint: { distance: 5 } }),
    useSensor(TouchSensor, { activationConstraint: { delay: 150, tolerance: 5 } })
  )

  const handleDragEnd = useCallback(
    (event: DragEndEvent) => {
      const { active, over } = event
      if (!over || active.id === over.id) return

      setModules((prev) => {
        const oldIndex = prev.findIndex((m) => m.module_id === active.id)
        const newIndex = prev.findIndex((m) => m.module_id === over.id)
        const reordered = arrayMove(prev, oldIndex, newIndex)

        startTransition(async () => {
          await reorderSiteModules(siteId, reordered.map((m) => m.module_id))
        })
        return reordered
      })
    },
    [siteId]
  )

  // ─── Toggle enabled ─────────────────────────────────────────────────────────
  const handleToggle = useCallback(
    (moduleId: string, enabled: boolean) => {
      setModules((prev) =>
        prev.map((m) => (m.module_id === moduleId ? { ...m, is_enabled: enabled } : m))
      )
      startTransition(async () => {
        await toggleSiteModule(siteId, moduleId, enabled)
      })
    },
    [siteId]
  )

  // ─── Enable new module ──────────────────────────────────────────────────────
  const handleEnable = useCallback(
    (moduleId: string) => {
      const mod = available.find((m) => m.id === moduleId)
      if (!mod) return

      // Optimistic: move from available → modules list
      const newSiteModule: SiteModule = {
        module_id: mod.id,
        order_index: modules.length,
        config: {},
        is_enabled: true,
        modules: {
          id: mod.id,
          name: mod.name,
          name_en: mod.name_en,
          description: mod.description,
          icon: mod.icon,
          route_segment: mod.route_segment,
          category: mod.category,
          is_system: mod.is_system,
        },
      }
      setModules((prev) => [...prev, newSiteModule])
      setAvailable((prev) => prev.filter((m) => m.id !== moduleId))

      startTransition(async () => {
        await enableSiteModule(siteId, moduleId)
      })
    },
    [available, modules.length, siteId]
  )

  // ─── Open config modal ──────────────────────────────────────────────────────
  const handleConfig = useCallback(
    (moduleId: string) => {
      const mod = modules.find((m) => m.module_id === moduleId)
      if (!mod) return
      setConfigModal({
        open: true,
        moduleId,
        moduleName: mod.modules.name,
        config: mod.config || {},
      })
    },
    [modules]
  )

  const enabledModules = modules.filter((m) => m.is_enabled)
  const disabledModules = modules.filter((m) => !m.is_enabled)

  return (
    <div className="module-manager">
      <div className="module-manager-header">
        <h2 className="module-manager-title">Quản lý Modules</h2>
        <p className="module-manager-desc">
          Bật/tắt và sắp xếp các tab quản lý cho site <strong>{siteName}</strong>.
        </p>
      </div>

      {/* ── ĐANG BẬT ─────────────────────────────────────────────── */}
      <section className="module-section">
        <div className="module-section-header">
          <h3 className="module-section-title">
            <span className="module-section-dot enabled" />
            Đang bật
          </h3>
          <span className="module-section-count">{enabledModules.length} modules</span>
        </div>
        <p className="module-section-hint">Kéo để sắp xếp thứ tự hiển thị trong sidebar</p>

        {enabledModules.length === 0 ? (
          <div className="module-empty">Chưa có module nào được bật.</div>
        ) : (
          <DndContext
            sensors={sensors}
            collisionDetection={closestCenter}
            onDragEnd={handleDragEnd}
            modifiers={[restrictToVerticalAxis]}
          >
            <SortableContext
              items={enabledModules.map((m) => m.module_id)}
              strategy={verticalListSortingStrategy}
            >
              <div className="module-list">
                {enabledModules.map((m) => (
                  <SortableModuleCard
                    key={m.module_id}
                    module={m}
                    onToggle={handleToggle}
                    onConfig={handleConfig}
                    isPending={isPending}
                  />
                ))}
              </div>
            </SortableContext>
          </DndContext>
        )}
      </section>

      {/* ── ĐANG TẮT ─────────────────────────────────────────────── */}
      {disabledModules.length > 0 && (
        <section className="module-section">
          <div className="module-section-header">
            <h3 className="module-section-title">
              <span className="module-section-dot disabled" />
              Đang tắt
            </h3>
            <span className="module-section-count">{disabledModules.length} modules</span>
          </div>
          <div className="module-list">
            {disabledModules.map((m) => (
              <SortableModuleCard
                key={m.module_id}
                module={m}
                onToggle={handleToggle}
                onConfig={handleConfig}
                isPending={isPending}
              />
            ))}
          </div>
        </section>
      )}

      {/* ── CÓ THỂ BẬT ───────────────────────────────────────────── */}
      {available.length > 0 && (
        <section className="module-section">
          <div className="module-section-header">
            <h3 className="module-section-title">
              <span className="module-section-dot available" />
              Có thể bật
            </h3>
            <span className="module-section-count">{available.length} modules</span>
          </div>
          <p className="module-section-hint">Các module chưa được cài đặt cho site này</p>
          <div className="module-list">
            {available.map((m) => (
              <AvailableModuleCard
                key={m.id}
                module={m}
                onEnable={handleEnable}
                isPending={isPending}
              />
            ))}
          </div>
        </section>
      )}

      {isPending && (
        <div className="module-saving-indicator">
          <span>Đang lưu...</span>
        </div>
      )}

      {/* Config Modal */}
      {configModal && (
        <ModuleConfigModal
          siteId={siteId}
          moduleId={configModal.moduleId}
          moduleName={configModal.moduleName}
          open={configModal.open}
          config={configModal.config}
          onClose={() => setConfigModal(null)}
          onSaved={() => setConfigModal(null)}
        />
      )}
    </div>
  )
}
