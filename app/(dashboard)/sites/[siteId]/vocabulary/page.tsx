import { notFound } from 'next/navigation'
import Link from 'next/link'
import type { Metadata } from 'next'
import { createClient } from '@/lib/supabase/server'
import { requireSiteModule } from '@/lib/modules/guard'
import { getSiteRole } from '@/lib/permissions'
import s from '../../../shared.module.css'
import VocabularyList from '@/components/vocabulary/VocabularyList'

interface Props {
    params: Promise<{ siteId: string }>
    searchParams: Promise<{ q?: string; deckId?: string; jlpt?: string; page?: string }>
}

export const metadata: Metadata = { title: 'Từ vựng' }

const PAGE_SIZE = 30

export default async function VocabularyPage({ params, searchParams }: Props) {
    const { siteId } = await params
    const { q, deckId, jlpt, page = '1' } = await searchParams

    const siteRole = await getSiteRole(siteId)
    if (!siteRole) notFound()

    await requireSiteModule(siteId, 'vocabulary').catch(() => notFound())

    const supabase = await createClient()
    const { data: site } = await supabase.from('sites').select('name').eq('id', siteId).single()
    if (!site) notFound()

    const currentPage = parseInt(page, 10) || 1
    const from = (currentPage - 1) * PAGE_SIZE
    const to = from + PAGE_SIZE - 1

    // Fetch decks for this site
    const { data: decks } = await supabase
        .from('decks')
        .select('id, name, emoji, language_code')
        .eq('site_id', siteId)
        .order('order_index')

    // Build vocabulary query
    let query = supabase
        .from('vocabulary')
        .select('*', { count: 'exact' })
        .eq('site_id', siteId)
        .order('order_index')
        .range(from, to)

    if (q) query = query.or(`word.ilike.%${q}%,meaning_vi.ilike.%${q}%,reading.ilike.%${q}%`)
    if (deckId) query = query.eq('deck_id', deckId)
    if (jlpt) query = query.eq('jlpt_level', jlpt)

    const { data: words, count } = await query
    const totalPages = Math.ceil((count || 0) / PAGE_SIZE)

    // Total count (no filter)
    const { count: totalWords } = await supabase
        .from('vocabulary').select('*', { count: 'exact', head: true }).eq('site_id', siteId)

    return (
        <div className={`${s.page} animate-fade-in`}>
            <div className={s.breadcrumb}>
                <Link href="/" className={s.breadcrumbLink}>Dashboard</Link>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                <Link href={`/sites/${siteId}`} className={s.breadcrumbLink}>{site.name}</Link>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                <span>Từ vựng</span>
            </div>

            <VocabularyList
                siteId={siteId}
                words={(words || []) as any[]}
                decks={(decks || []) as any[]}
                totalCount={count || 0}
                totalWords={totalWords || 0}
                currentPage={currentPage}
                totalPages={totalPages}
                filters={{ q, deckId, jlpt }}
            />
        </div>
    )
}
