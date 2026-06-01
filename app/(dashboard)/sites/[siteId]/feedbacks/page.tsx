import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import { getSiteRole } from '@/lib/permissions'
import { requireSiteModule } from '@/lib/modules/guard'
import type { Metadata } from 'next'
import type { Feedback } from '@/types/database'
import { FeedbacksTable } from '@/components/feedbacks/FeedbacksTable'
import styles from './page.module.css'

export const metadata: Metadata = {
  title: 'Feedbacks',
}

interface PageProps {
  params: Promise<{ siteId: string }>
  searchParams: Promise<{
    page?: string
    search?: string
    status?: string
  }>
}

const PAGE_SIZE = 20

export default async function FeedbacksPage({ params, searchParams }: PageProps) {
  const { siteId } = await params
  const { page = '1', search, status } = await searchParams

  const [siteRole] = await Promise.all([
    getSiteRole(siteId),
    requireSiteModule(siteId, 'feedbacks').catch(() => notFound()),
  ])
  if (!siteRole) notFound()

  const canDelete = siteRole === 'admin'

  const supabase = await createClient()

  const { data: site } = await supabase
    .from('sites')
    .select('id, name, slug')
    .eq('id', siteId)
    .single()

  if (!site) notFound()

  // Build query
  let query = supabase
    .from('feedbacks')
    .select('*', { count: 'exact' })
    .eq('site_id', siteId)
    .order('created_at', { ascending: false })

  if (search) {
    query = query.or(`name.ilike.%${search}%,email.ilike.%${search}%,message.ilike.%${search}%`)
  }
  if (status && status !== 'all') {
    query = query.eq('status', status)
  }

  const currentPage = parseInt(page, 10) || 1
  const from = (currentPage - 1) * PAGE_SIZE
  const to = from + PAGE_SIZE - 1
  query = query.range(from, to)

  const { data: feedbacks, count } = await query
  const totalPages = Math.ceil((count || 0) / PAGE_SIZE)

  // Stats
  const { data: allFeedbacks } = await supabase
    .from('feedbacks')
    .select('status, rating')
    .eq('site_id', siteId)

  const total = allFeedbacks?.length || 0
  const pending = allFeedbacks?.filter(f => f.status === 'pending').length || 0
  const reviewed = allFeedbacks?.filter(f => f.status === 'reviewed').length || 0
  const withRating = allFeedbacks?.filter(f => f.rating !== null) || []
  const avgRating =
    withRating.length > 0
      ? (withRating.reduce((sum, f) => sum + (f.rating ?? 0), 0) / withRating.length).toFixed(1)
      : null

  return (
    <div className={`${styles.page} animate-fade-in`}>
      <div className={styles.pageHeader}>
        <div>
          <h1 className={styles.pageTitle}>Feedbacks</h1>
          <p className={styles.pageSubtitle}>
            Phản hồi và đánh giá từ người dùng của {site.name}
          </p>
        </div>
      </div>

      {/* Stats */}
      <div className={styles.statsGrid}>
        <div className={`${styles.statCard} glass`}>
          <div className={`${styles.statIcon} ${styles.statIconPurple}`}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
            </svg>
          </div>
          <div>
            <p className={styles.statValue}>{total}</p>
            <p className={styles.statLabel}>Tổng feedback</p>
          </div>
        </div>

        <div className={`${styles.statCard} glass`}>
          <div className={`${styles.statIcon} ${styles.statIconYellow}`}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="10" />
              <polyline points="12 6 12 12 16 14" />
            </svg>
          </div>
          <div>
            <p className={styles.statValue}>{pending}</p>
            <p className={styles.statLabel}>Chờ xử lý</p>
          </div>
        </div>

        <div className={`${styles.statCard} glass`}>
          <div className={`${styles.statIcon} ${styles.statIconGreen}`}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <polyline points="20 6 9 17 4 12" />
            </svg>
          </div>
          <div>
            <p className={styles.statValue}>{reviewed}</p>
            <p className={styles.statLabel}>Đã xem</p>
          </div>
        </div>

        <div className={`${styles.statCard} glass`}>
          <div className={`${styles.statIcon} ${styles.statIconBlue}`}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
            </svg>
          </div>
          <div>
            <p className={styles.statValue}>{avgRating ?? '—'}</p>
            <p className={styles.statLabel}>Điểm TB / 5</p>
          </div>
        </div>
      </div>

      <FeedbacksTable
        feedbacks={(feedbacks || []) as Feedback[]}
        siteId={siteId}
        currentPage={currentPage}
        totalPages={totalPages}
        totalCount={count || 0}
        search={search}
        status={status}
        canDelete={canDelete}
      />
    </div>
  )
}
