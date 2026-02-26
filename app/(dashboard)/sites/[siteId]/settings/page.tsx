import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import Link from 'next/link'
import type { Metadata } from 'next'
import SiteSettingsForm from '@/components/sites/SiteSettingsForm'
import s from '../../../shared.module.css'

interface Props {
    params: Promise<{ siteId: string }>
}

export const metadata: Metadata = { title: 'Cài đặt' }

export default async function SettingsPage({ params }: Props) {
    const { siteId } = await params
    const supabase = await createClient()

    const { data: site } = await supabase.from('sites').select('*').eq('id', siteId).single()
    if (!site) notFound()

    return (
        <div className={`${s.page} animate-fade-in`}>
            <div className={s.breadcrumb}>
                <Link href="/" className={s.breadcrumbLink}>Dashboard</Link>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                <Link href={`/sites/${siteId}`} className={s.breadcrumbLink}>{site.name}</Link>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                <span>Cài đặt</span>
            </div>

            <SiteSettingsForm site={site} />
        </div>
    )
}
