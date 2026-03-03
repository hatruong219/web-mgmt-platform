import { createClient } from '@/lib/supabase/server'
import type { SiteModule } from './module-registry'

/**
 * Fetch tất cả enabled modules cho sidebar (server-side only)
 */
export async function getSiteModules(siteId: string): Promise<SiteModule[]> {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from('site_modules')
    .select('module_id, order_index, config, is_enabled, modules(id, name, icon, route_segment, category, is_system)')
    .eq('site_id', siteId)
    .eq('is_enabled', true)
    .order('order_index')
  // Nếu bảng chưa tồn tại (migration chưa chạy) → trả về array rỗng thay vì crash
  if (error) return []
  return (data || []) as unknown as SiteModule[]
}

/**
 * Fetch TẤT CẢ site_modules (enabled + disabled) + tất cả available modules
 * Dùng cho Settings > Modules page
 */
export async function getAllSiteModulesForSettings(siteId: string) {
  const supabase = await createClient()

  const [siteModulesRes, allModulesRes] = await Promise.all([
    supabase
      .from('site_modules')
      .select('module_id, order_index, config, is_enabled, modules(id, name, name_en, icon, route_segment, category, is_system, description)')
      .eq('site_id', siteId)
      .order('order_index'),
    supabase
      .from('modules')
      .select('id, name, name_en, icon, route_segment, category, is_system, description, order_index')
      .eq('is_active', true)
      .order('order_index'),
  ])

  if (siteModulesRes.error) throw siteModulesRes.error
  if (allModulesRes.error) throw allModulesRes.error

  const siteModules = (siteModulesRes.data || []) as unknown as SiteModule[]
  const allModules = allModulesRes.data || []

  // Modules chưa được add vào site_modules
  const siteModuleIds = new Set(siteModules.map((m) => m.module_id))
  const unavailableModules = allModules.filter((m) => !siteModuleIds.has(m.id as never))

  return { siteModules, unavailableModules }
}
