'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'

/**
 * Bật / tắt một module cho site
 */
export async function toggleSiteModule(
  siteId: string,
  moduleId: string,
  enabled: boolean
) {
  const supabase = await createClient()
  const { error } = await supabase
    .from('site_modules')
    .update({ is_enabled: enabled, updated_at: new Date().toISOString() })
    .eq('site_id', siteId)
    .eq('module_id', moduleId)
  if (error) throw error
  revalidatePath(`/sites/${siteId}`, 'layout')
}

/**
 * Lưu thứ tự mới (order) cho các site_modules
 * order: danh sách moduleId theo thứ tự mới
 */
export async function reorderSiteModules(siteId: string, order: string[]) {
  const supabase = await createClient()
  // Batch update dùng upsert thay vì loop + await
  const updates = order.map((moduleId, i) => ({
    site_id: siteId,
    module_id: moduleId,
    order_index: i,
    updated_at: new Date().toISOString(),
  }))

  const { error } = await supabase
    .from('site_modules')
    .upsert(updates, { onConflict: 'site_id,module_id', ignoreDuplicates: false })
  if (error) throw error
  revalidatePath(`/sites/${siteId}`, 'layout')
}

/**
 * Bật một module mới cho site (chưa có trong site_modules)
 * Tự động thêm vào cuối danh sách
 */
export async function enableSiteModule(siteId: string, moduleId: string) {
  const supabase = await createClient()

  // Lấy order_index cao nhất hiện tại
  const { data: existing } = await supabase
    .from('site_modules')
    .select('order_index')
    .eq('site_id', siteId)
    .order('order_index', { ascending: false })
    .limit(1)
    .single()

  const nextIndex = existing ? existing.order_index + 1 : 0

  const { error } = await supabase.from('site_modules').upsert({
    site_id: siteId,
    module_id: moduleId,
    is_enabled: true,
    order_index: nextIndex,
    config: {},
    updated_at: new Date().toISOString(),
  }, { onConflict: 'site_id,module_id' })

  if (error) throw error
  revalidatePath(`/sites/${siteId}`, 'layout')
}

/**
 * Cập nhật config của một module trong site
 */
export async function updateModuleConfig(
  siteId: string,
  moduleId: string,
  config: Record<string, unknown>
) {
  const supabase = await createClient()
  const { error } = await supabase
    .from('site_modules')
    .update({ config, updated_at: new Date().toISOString() })
    .eq('site_id', siteId)
    .eq('module_id', moduleId)
  if (error) throw error
  revalidatePath(`/sites/${siteId}`, 'layout')
}
