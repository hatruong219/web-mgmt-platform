import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import Link from 'next/link'
import type { Metadata } from 'next'
import MediaGrid from '@/components/media/MediaGrid'
import s from '../../../shared.module.css'

interface Props {
    params: Promise<{ siteId: string }>
}

export const metadata: Metadata = { title: 'Media Library' }

export default async function MediaPage({ params }: Props) {
    const { siteId } = await params
    const supabase = await createClient()

    // Chạy song song
    const [siteResult, filesResult] = await Promise.all([
        supabase.from('sites').select('name').eq('id', siteId).single(),
        supabase.from('media').select('*').eq('site_id', siteId).order('created_at', { ascending: false }),
    ])

    if (!siteResult.data) notFound()
    const site = siteResult.data
    const files = filesResult.data

    return (
        <div className={`${s.page} animate-fade-in`}>
            <div className={s.breadcrumb}>
                <Link href="/" className={s.breadcrumbLink}>Dashboard</Link>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                <Link href={`/sites/${siteId}`} className={s.breadcrumbLink}>{site.name}</Link>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                <span>Media</span>
            </div>

            <div className={s.pageHeader}>
                <div>
                    <h1 className={s.pageTitle}>Media Library</h1>
                    <p className={s.pageSubtitle}>{files?.length ?? 0} files</p>
                </div>
            </div>

            <MediaGrid siteId={siteId} initialFiles={files || []} />
        </div>
    )
}
