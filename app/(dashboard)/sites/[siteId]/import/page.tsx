import { notFound } from 'next/navigation'
import Link from 'next/link'
import type { Metadata } from 'next'
import { createClient } from '@/lib/supabase/server'
import { requireSiteModule } from '@/lib/modules/guard'
import { getSiteRole } from '@/lib/permissions'
import s from '../../../shared.module.css'
import VocabImporter from '@/components/vocabulary/VocabImporter'

interface Props {
    params: Promise<{ siteId: string }>
}

export const metadata: Metadata = { title: 'Import từ vựng' }

export default async function ImportPage({ params }: Props) {
    const { siteId } = await params
    const siteRole = await getSiteRole(siteId)
    if (!siteRole) notFound()

    await requireSiteModule(siteId, 'vocabulary-import').catch(() => notFound())

    const supabase = await createClient()
    const { data: site } = await supabase.from('sites').select('name').eq('id', siteId).single()
    if (!site) notFound()

    const { data: decks } = await supabase
        .from('decks')
        .select('id, name, emoji')
        .eq('site_id', siteId)
        .order('order_index')

    return (
        <div className={`${s.page} animate-fade-in`}>
            <div className={s.breadcrumb}>
                <Link href="/" className={s.breadcrumbLink}>Dashboard</Link>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                <Link href={`/sites/${siteId}`} className={s.breadcrumbLink}>{site.name}</Link>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                <Link href={`/sites/${siteId}/vocabulary`} className={s.breadcrumbLink}>Từ vựng</Link>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                <span>Import CSV</span>
            </div>

            <VocabImporter siteId={siteId} decks={(decks || []) as any[]} />
        </div>
    )
}
