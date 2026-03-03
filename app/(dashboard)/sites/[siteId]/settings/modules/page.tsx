import { getAllSiteModulesForSettings } from '@/lib/modules/getSiteModules'
import { createClient } from '@/lib/supabase/server'
import { notFound, redirect } from 'next/navigation'
import { getSiteRole } from '@/lib/permissions'
import type { Metadata } from 'next'
import ModuleManager from '@/components/modules/ModuleManager'
import s from '../../../../shared.module.css'
import Link from 'next/link'

interface Props {
  params: Promise<{ siteId: string }>
}

export const metadata: Metadata = { title: 'Modules — Cài đặt' }

export default async function ModulesSettingsPage({ params }: Props) {
  const { siteId } = await params

  const siteRole = await getSiteRole(siteId)
  if (!siteRole) notFound()
  if (siteRole !== 'admin') {
    redirect(`/sites/${siteId}/articles?forbidden=settings`)
  }

  const supabase = await createClient()
  const { data: site } = await supabase.from('sites').select('id, name').eq('id', siteId).single()
  if (!site) notFound()

  const { siteModules, unavailableModules } = await getAllSiteModulesForSettings(siteId)

  return (
    <div className={`${s.page} animate-fade-in`}>
      <div className={s.breadcrumb}>
        <Link href="/" className={s.breadcrumbLink}>Dashboard</Link>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
        <Link href={`/sites/${siteId}`} className={s.breadcrumbLink}>{site.name}</Link>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
        <Link href={`/sites/${siteId}/settings`} className={s.breadcrumbLink}>Cài đặt</Link>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
        <span>Modules</span>
      </div>

      <ModuleManager
        siteId={siteId}
        siteName={site.name}
        siteModules={siteModules}
        unavailableModules={unavailableModules}
      />
    </div>
  )
}
