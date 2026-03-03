import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import type { ModuleId } from './module-registry'

/**
 * Guard cho module routes.
 * - Trả về `config` của site_module nếu module đang enabled.
 * - Tự động throw 404 nếu module bị disabled.
 * - Pass thẳng (không 404) nếu bảng site_modules chưa tồn tại (migration chưa chạy).
 */
export async function requireSiteModule(
  siteId: string,
  moduleId: ModuleId
): Promise<Record<string, unknown>> {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from('site_modules')
    .select('is_enabled, config')
    .eq('site_id', siteId)
    .eq('module_id', moduleId)
    .eq('is_enabled', true)
    .single()

  // Nếu bảng chưa tồn tại (migration chưa chạy), pass thẳng
  if (error) {
    const errMsg = (error as { message?: string }).message || ''
    if (errMsg.includes('does not exist') || errMsg.includes('relation')) {
      return {}
    }
    // Không tìm thấy record = module disabled → 404
    notFound()
  }

  if (!data) notFound()
  return (data.config as Record<string, unknown>) || {}
}

