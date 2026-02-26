import { createClient } from '@/lib/supabase/server'
import type { Metadata } from 'next'
import Link from 'next/link'
import type { Site } from '@/types/database'
import CreateSiteModal from '@/components/sites/CreateSiteModal'
import { formatDate } from '@/lib/utils'
import styles from './page.module.css'

export const metadata: Metadata = {
  title: 'Dashboard',
}

export default async function DashboardPage() {
  const supabase = await createClient()

  const { data: sites } = await supabase
    .from('sites')
    .select('*')
    .order('created_at', { ascending: false })

  const { data: articleCounts } = await supabase
    .from('articles')
    .select('site_id')

  const countBySite = (articleCounts || []).reduce<Record<string, number>>(
    (acc, row) => {
      acc[row.site_id] = (acc[row.site_id] || 0) + 1
      return acc
    },
    {}
  )

  const totalArticles = (articleCounts || []).length
  const totalSites = (sites || []).length

  return (
    <div className={`${styles.page} animate-fade-in`}>
      <div className={styles.pageHeader}>
        <div>
          <h1 className={styles.pageTitle}>Dashboard</h1>
          <p className={styles.pageSubtitle}>Tổng quan tất cả websites của bạn</p>
        </div>
        <CreateSiteModal />
      </div>

      <div className={styles.statsGrid}>
        <div className={`${styles.statCard} glass`}>
          <div className={`${styles.statIcon} ${styles.statIconPurple}`}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="10" /><path d="M2 12h20M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
            </svg>
          </div>
          <div>
            <p className={styles.statValue}>{totalSites}</p>
            <p className={styles.statLabel}>Websites</p>
          </div>
        </div>

        <div className={`${styles.statCard} glass`}>
          <div className={`${styles.statIcon} ${styles.statIconBlue}`}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
              <polyline points="14 2 14 8 20 8" /><line x1="16" y1="13" x2="8" y2="13" /><line x1="16" y1="17" x2="8" y2="17" />
            </svg>
          </div>
          <div>
            <p className={styles.statValue}>{totalArticles}</p>
            <p className={styles.statLabel}>Tổng bài viết</p>
          </div>
        </div>

        <div className={`${styles.statCard} glass`}>
          <div className={`${styles.statIcon} ${styles.statIconGreen}`}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <polyline points="20 6 9 17 4 12" />
            </svg>
          </div>
          <div>
            <p className={styles.statValue}>{totalArticles}</p>
            <p className={styles.statLabel}>Đã xuất bản</p>
          </div>
        </div>
      </div>

      <div>
        <h2 className={styles.sectionTitle}>Websites của tôi</h2>

        {!sites || sites.length === 0 ? (
          <div className={`${styles.emptyState} glass`}>
            <div className={styles.emptyIcon}>
              <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <circle cx="12" cy="12" r="10" /><path d="M2 12h20M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
              </svg>
            </div>
            <h3 className={styles.emptyTitle}>Chưa có website nào</h3>
            <p className={styles.emptyDesc}>Tạo website đầu tiên của bạn để bắt đầu quản lý nội dung</p>
            <CreateSiteModal variant="inline" />
          </div>
        ) : (
          <div className={styles.sitesGrid}>
            {(sites as Site[]).map((site) => (
              <Link key={site.id} href={`/sites/${site.id}`} className={`${styles.siteCard} glass`}>
                <div className={styles.siteCardHeader}>
                  <div className={styles.siteAvatar}>{site.name.substring(0, 2).toUpperCase()}</div>
                  <span className={`${styles.siteBadge} ${site.status === 'active' ? styles.siteBadgeActive : styles.siteBadgeArchived}`}>
                    {site.status === 'active' ? 'Active' : 'Archived'}
                  </span>
                </div>
                <h3 className={styles.siteName}>{site.name}</h3>
                {site.description && <p className={styles.siteDesc}>{site.description}</p>}
                {site.domain && (
                  <div className={styles.siteDomain}>
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71" />
                      <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71" />
                    </svg>
                    {site.domain}
                  </div>
                )}
                <div className={styles.siteFooter}>
                  <span className={styles.siteCount}>
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                      <polyline points="14 2 14 8 20 8" />
                    </svg>
                    {countBySite[site.id] || 0} bài viết
                  </span>
                  <span className={styles.siteDate}>{formatDate(site.created_at)}</span>
                </div>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
