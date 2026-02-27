import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import { canAccessSite, isSiteAdmin } from '@/lib/permissions'
import type { Metadata } from 'next'
import type { SiteClient } from '@/types/database'
import { ClientsTable } from '@/components/clients/ClientsTable'
import { ExportClientsButton } from '@/components/clients/ExportClientsButton'
import styles from './page.module.css'

export const metadata: Metadata = {
  title: 'Site Clients',
}

interface PageProps {
  params: Promise<{ siteId: string }>
  searchParams: Promise<{ 
    page?: string
    search?: string
    provider?: string
    status?: string
  }>
}

const PAGE_SIZE = 20

export default async function SiteClientsPage({ params, searchParams }: PageProps) {
  const { siteId } = await params
  const { page = '1', search, provider, status } = await searchParams

  // Check access
  const hasAccess = await canAccessSite(siteId)
  if (!hasAccess) {
    notFound()
  }

  const supabase = await createClient()

  // Get site info
  const { data: site } = await supabase
    .from('sites')
    .select('id, name, slug')
    .eq('id', siteId)
    .single()

  if (!site) {
    notFound()
  }

  // Check if user can export
  const canExport = await isSiteAdmin(siteId)

  // Build query
  let query = supabase
    .from('site_clients')
    .select('*', { count: 'exact' })
    .eq('site_id', siteId)
    .order('created_at', { ascending: false })

  // Apply filters
  if (search) {
    query = query.or(`email.ilike.%${search}%,full_name.ilike.%${search}%`)
  }
  if (provider && provider !== 'all') {
    query = query.eq('provider', provider)
  }
  if (status === 'active') {
    query = query.eq('is_active', true)
  } else if (status === 'inactive') {
    query = query.eq('is_active', false)
  }

  // Pagination
  const currentPage = parseInt(page, 10) || 1
  const from = (currentPage - 1) * PAGE_SIZE
  const to = from + PAGE_SIZE - 1
  query = query.range(from, to)

  const { data: clients, count, error } = await query

  const totalPages = Math.ceil((count || 0) / PAGE_SIZE)

  // Stats
  const { data: stats } = await supabase
    .from('site_clients')
    .select('provider, is_active')
    .eq('site_id', siteId)

  const totalClients = stats?.length || 0
  const activeClients = stats?.filter(c => c.is_active).length || 0
  const providerCounts = (stats || []).reduce<Record<string, number>>((acc, c) => {
    acc[c.provider] = (acc[c.provider] || 0) + 1
    return acc
  }, {})

  return (
    <div className={`${styles.page} animate-fade-in`}>
      <div className={styles.pageHeader}>
        <div>
          <h1 className={styles.pageTitle}>Clients</h1>
          <p className={styles.pageSubtitle}>
            Quản lý end-users của {site.name}
          </p>
        </div>
        {canExport && totalClients > 0 && (
          <ExportClientsButton siteId={siteId} siteName={site.name} />
        )}
      </div>

      {/* Stats */}
      <div className={styles.statsGrid}>
        <div className={`${styles.statCard} glass`}>
          <div className={`${styles.statIcon} ${styles.statIconPurple}`}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
              <circle cx="9" cy="7" r="4" />
              <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
              <path d="M16 3.13a4 4 0 0 1 0 7.75" />
            </svg>
          </div>
          <div>
            <p className={styles.statValue}>{totalClients}</p>
            <p className={styles.statLabel}>Tổng clients</p>
          </div>
        </div>

        <div className={`${styles.statCard} glass`}>
          <div className={`${styles.statIcon} ${styles.statIconGreen}`}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <polyline points="20 6 9 17 4 12" />
            </svg>
          </div>
          <div>
            <p className={styles.statValue}>{activeClients}</p>
            <p className={styles.statLabel}>Active</p>
          </div>
        </div>

        <div className={`${styles.statCard} glass`}>
          <div className={`${styles.statIcon} ${styles.statIconBlue}`}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
              <polyline points="22,6 12,13 2,6" />
            </svg>
          </div>
          <div>
            <p className={styles.statValue}>{providerCounts['email'] || 0}</p>
            <p className={styles.statLabel}>Email</p>
          </div>
        </div>

        <div className={`${styles.statCard} glass`}>
          <div className={`${styles.statIcon} ${styles.statIconRed}`}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" />
              <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
              <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" />
              <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" />
            </svg>
          </div>
          <div>
            <p className={styles.statValue}>{providerCounts['google'] || 0}</p>
            <p className={styles.statLabel}>Google</p>
          </div>
        </div>
      </div>

      {/* Clients Table */}
      <ClientsTable
        clients={(clients || []) as SiteClient[]}
        siteId={siteId}
        currentPage={currentPage}
        totalPages={totalPages}
        totalCount={count || 0}
        search={search}
        provider={provider}
        status={status}
      />
    </div>
  )
}
