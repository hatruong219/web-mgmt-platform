import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import type { Metadata } from 'next'
import Link from 'next/link'
import type { Site, Article } from '@/types/database'
import { formatDate } from '@/lib/utils'
import s from '../../shared.module.css'

interface Props {
  params: Promise<{ siteId: string }>
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { siteId } = await params
  const supabase = await createClient()
  const { data } = await supabase.from('sites').select('name').eq('id', siteId).single()
  return { title: data?.name ?? 'Site' }
}

export default async function SiteOverviewPage({ params }: Props) {
  const { siteId } = await params
  const supabase = await createClient()

  // Chạy tất cả queries song song thay vì tuần tự
  const [siteResult, articlesResult, totalResult, publishedResult, draftResult] = await Promise.all([
    supabase.from('sites').select('*').eq('id', siteId).single(),
    supabase.from('articles').select('*').eq('site_id', siteId).order('created_at', { ascending: false }).limit(5),
    supabase.from('articles').select('*', { count: 'exact', head: true }).eq('site_id', siteId),
    supabase.from('articles').select('*', { count: 'exact', head: true }).eq('site_id', siteId).eq('status', 'published'),
    supabase.from('articles').select('*', { count: 'exact', head: true }).eq('site_id', siteId).eq('status', 'draft'),
  ])

  if (!siteResult.data) notFound()

  const typedSite = siteResult.data as Site
  const articles = articlesResult.data
  const totalCount = totalResult.count
  const publishedCount = publishedResult.count
  const draftCount = draftResult.count

  return (
    <div className={`${s.page} animate-fade-in`}>
      <div className={s.breadcrumb}>
        <Link href="/" className={s.breadcrumbLink}>Dashboard</Link>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
        <span>{typedSite.name}</span>
      </div>

      <div className={s.siteHeader}>
        <div className={s.siteHeaderInfo}>
          <div className={s.siteBigAvatar}>{typedSite.name.substring(0, 2).toUpperCase()}</div>
          <div>
            <h1 className={s.pageTitle}>{typedSite.name}</h1>
            {typedSite.description && <p className={s.siteDescription}>{typedSite.description}</p>}
            {typedSite.domain && (
              <a href={`https://${typedSite.domain}`} target="_blank" rel="noopener noreferrer" className={s.siteDomainLink}>
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
                  <polyline points="15 3 21 3 21 9" /><line x1="10" y1="14" x2="21" y2="3" />
                </svg>
                {typedSite.domain}
              </a>
            )}
          </div>
        </div>
        <div className={s.siteActions}>
          <Link href={`/sites/${siteId}/articles/new`} id="new-article-btn" className={s.btnPrimary}>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
              <line x1="12" y1="5" x2="12" y2="19" /><line x1="5" y1="12" x2="19" y2="12" />
            </svg>
            Bài viết mới
          </Link>
        </div>
      </div>

      <div className={s.statsRow}>
        <div className={`${s.miniStat} ${s.miniStatPurple} glass`}>
          <p className={s.miniStatValue}>{totalCount ?? 0}</p>
          <p className={s.miniStatLabel}>Tổng bài viết</p>
        </div>
        <div className={`${s.miniStat} ${s.miniStatGreen} glass`}>
          <p className={s.miniStatValue}>{publishedCount ?? 0}</p>
          <p className={s.miniStatLabel}>Đã xuất bản</p>
        </div>
        <div className={`${s.miniStat} ${s.miniStatAmber} glass`}>
          <p className={s.miniStatValue}>{draftCount ?? 0}</p>
          <p className={s.miniStatLabel}>Bản nháp</p>
        </div>
      </div>

      <div className={s.quickNav}>
        <Link href={`/sites/${siteId}/articles`} className={`${s.quickNavCard} glass`}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
            <polyline points="14 2 14 8 20 8" /><line x1="16" y1="13" x2="8" y2="13" /><line x1="16" y1="17" x2="8" y2="17" />
          </svg>
          <span>Bài viết</span>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className={s.arrow}><polyline points="9 18 15 12 9 6" /></svg>
        </Link>
        <Link href={`/sites/${siteId}/media`} className={`${s.quickNavCard} glass`}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
            <rect x="3" y="3" width="18" height="18" rx="2" /><circle cx="8.5" cy="8.5" r="1.5" /><polyline points="21 15 16 10 5 21" />
          </svg>
          <span>Media</span>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className={s.arrow}><polyline points="9 18 15 12 9 6" /></svg>
        </Link>
        <Link href={`/sites/${siteId}/settings`} className={`${s.quickNavCard} glass`}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
            <circle cx="12" cy="12" r="3" />
            <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z" />
          </svg>
          <span>Cài đặt</span>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className={s.arrow}><polyline points="9 18 15 12 9 6" /></svg>
        </Link>
      </div>

      <div>
        <div className={s.recentHeader}>
          <h2 className={s.sectionTitle}>Bài viết gần đây</h2>
          <Link href={`/sites/${siteId}/articles`} className={s.viewAllLink}>Xem tất cả →</Link>
        </div>

        {!articles || articles.length === 0 ? (
          <div className={`${s.emptyMini} glass`}>
            <p>Chưa có bài viết nào. <Link href={`/sites/${siteId}/articles/new`} className={s.link}>Tạo bài viết đầu tiên →</Link></p>
          </div>
        ) : (
          <div className={s.recentList}>
            {(articles as Article[]).map((article) => (
              <Link key={article.id} href={`/sites/${siteId}/articles/${article.id}`} className={`${s.recentItem} glass`}>
                <div className={s.recentItemInfo}>
                  <p className={s.recentItemTitle}>{article.title}</p>
                  <div className={s.recentItemMeta}>
                    <span className={`${s.badge} ${article.status === 'published' ? s.badgePublished : article.status === 'draft' ? s.badgeDraft : s.badgeArchived}`}>{article.status}</span>
                    <span className={s.recentItemDate}>{formatDate(article.created_at)}</span>
                  </div>
                </div>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
