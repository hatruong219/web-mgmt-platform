import { cache } from 'react'
import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import type { ModuleId } from './module-registry'

const _requireSiteModule = cache(async (siteId: string, moduleId: ModuleId): Promise<Record<string, unknown>> => {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from('site_modules')
    .select('is_enabled, config')
    .eq('site_id', siteId)
    .eq('module_id', moduleId)
    .eq('is_enabled', true)
    .single()

  if (error) {
    const errMsg = (error as { message?: string }).message || ''
    if (errMsg.includes('does not exist') || errMsg.includes('relation')) {
      return {}
    }
    notFound()
  }

  if (!data) notFound()
  return (data.config as Record<string, unknown>) || {}
})

export async function requireSiteModule(
  siteId: string,
  moduleId: ModuleId
): Promise<Record<string, unknown>> {
  return _requireSiteModule(siteId, moduleId)
}
