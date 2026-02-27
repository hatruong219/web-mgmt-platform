import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import type { Metadata } from 'next'
import Link from 'next/link'
import type { Article } from '@/types/database'
import { formatDate } from '@/lib/utils'
import ArticleFilters from '@/components/articles/ArticleFilters'
import DeleteArticleButton from '@/components/articles/DeleteArticleButton'
import { canAccessSite, getSiteRole } from '@/lib/permissions'
import s from '../../../shared.module.css'

interface Props {
    params: Promise<{ siteId: string }>
    searchParams: Promise<{ status?: string; q?: string; forbidden?: string }>
}

export const metadata: Metadata = { title: 'Bài viết' }

export default async function ArticlesPage({ params, searchParams }: Props) {
    const { siteId } = await params
    const { status, q, forbidden } = await searchParams
    const siteRole = await getSiteRole(siteId)

    const hasAccess = await canAccessSite(siteId)
    if (!hasAccess || !siteRole) notFound()

    const supabase = await createClient()

    let articlesQuery = supabase
        .from('articles').select('*').eq('site_id', siteId)
        .order('created_at', { ascending: false })

    if (status && status !== 'all') articlesQuery = articlesQuery.eq('status', status)
    if (q) articlesQuery = articlesQuery.ilike('title', `%${q}%`)

    // Chạy song song
    const [siteResult, articlesResult] = await Promise.all([
        supabase.from('sites').select('name').eq('id', siteId).single(),
        articlesQuery,
    ])

    if (!siteResult.data) notFound()
    const site = siteResult.data
    const articles = articlesResult.data
    const siteHomeHref = siteRole === 'admin' ? `/sites/${siteId}` : `/sites/${siteId}/articles`

    return (
        <div className={`${s.page} animate-fade-in`}>
            <div className={s.breadcrumb}>
                <Link href="/" className={s.breadcrumbLink}>Dashboard</Link>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                <Link href={siteHomeHref} className={s.breadcrumbLink}>{site.name}</Link>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                <span>Bài viết</span>
            </div>

            {forbidden && (
                <div
                    style={{
                        display: 'flex',
                        alignItems: 'center',
                        gap: '0.5rem',
                        padding: '0.75rem 1rem',
                        marginBottom: '1rem',
                        background: 'hsl(var(--destructive) / 0.12)',
                        border: '1px solid hsl(var(--destructive) / 0.3)',
                        borderRadius: '0.625rem',
                        color: 'hsl(var(--destructive))',
                        fontSize: '0.875rem',
                    }}
                    role="alert"
                >
                    Bạn không có quyền truy cập trang đó.
                </div>
            )}

            <div className={s.pageHeader}>
                <div>
                    <h1 className={s.pageTitle}>Bài viết</h1>
                    <p className={s.pageSubtitle}>{articles?.length ?? 0} bài viết</p>
                </div>
                <Link href={`/sites/${siteId}/articles/new`} id="new-article-btn" className={s.btnPrimary}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                        <line x1="12" y1="5" x2="12" y2="19" /><line x1="5" y1="12" x2="19" y2="12" />
                    </svg>
                    Bài viết mới
                </Link>
            </div>

            <ArticleFilters currentStatus={status || 'all'} currentQuery={q || ''} siteId={siteId} />

            {!articles || articles.length === 0 ? (
                <div className={`${s.emptyState} glass`}>
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                        <polyline points="14 2 14 8 20 8" />
                    </svg>
                    <h3 className={s.emptyTitle}>Chưa có bài viết nào</h3>
                    <p>Bắt đầu viết bài viết đầu tiên cho website của bạn</p>
                </div>
            ) : (
                <div className={s.articleList}>
                    {(articles as Article[]).map((article) => (
                        <div key={article.id} className={`${s.articleRow} glass`}>
                            <Link href={`/sites/${siteId}/articles/${article.id}`} className={s.articleRowMain}>
                                <div className={s.articleRowContent}>
                                    <h3 className={s.articleRowTitle}>{article.title}</h3>
                                    {article.excerpt && <p className={s.articleRowExcerpt}>{article.excerpt}</p>}
                                    <div className={s.articleRowMeta}>
                                        <span className={`${s.badge} ${article.status === 'published' ? s.badgePublished : article.status === 'draft' ? s.badgeDraft : s.badgeArchived}`}>{article.status}</span>
                                        {article.tags.length > 0 && (
                                            <div className={s.articleTags}>
                                                {article.tags.slice(0, 3).map((tag) => (
                                                    <span key={tag} className={s.tag}>#{tag}</span>
                                                ))}
                                            </div>
                                        )}
                                        <span className={s.articleDate}>{formatDate(article.created_at)}</span>
                                    </div>
                                </div>
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className={s.chevron}>
                                    <polyline points="9 18 15 12 9 6" />
                                </svg>
                            </Link>
                            <DeleteArticleButton articleId={article.id} siteId={siteId} />
                        </div>
                    ))}
                </div>
            )}
        </div>
    )
}
