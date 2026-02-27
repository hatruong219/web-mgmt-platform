'use client'

import { useRouter, useSearchParams } from 'next/navigation'
import { useState } from 'react'
import type { SiteClient } from '@/types/database'
import { UserAvatar } from '@/components/users/UserAvatar'
import { formatDate } from '@/lib/utils'
import styles from './ClientsTable.module.css'

interface ClientsTableProps {
  clients: SiteClient[]
  siteId: string
  currentPage: number
  totalPages: number
  totalCount: number
  search?: string
  provider?: string
  status?: string
}

const providerLabels: Record<string, string> = {
  email: 'Email',
  google: 'Google',
  facebook: 'Facebook',
  github: 'GitHub',
  apple: 'Apple',
}

export function ClientsTable({
  clients,
  siteId,
  currentPage,
  totalPages,
  totalCount,
  search = '',
  provider = 'all',
  status = 'all',
}: ClientsTableProps) {
  const router = useRouter()
  const searchParams = useSearchParams()
  const [searchValue, setSearchValue] = useState(search)

  const updateFilters = (updates: Record<string, string>) => {
    const params = new URLSearchParams(searchParams.toString())
    Object.entries(updates).forEach(([key, value]) => {
      if (value && value !== 'all') {
        params.set(key, value)
      } else {
        params.delete(key)
      }
    })
    params.delete('page')
    router.push(`/sites/${siteId}/clients?${params.toString()}`)
  }

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    updateFilters({ search: searchValue })
  }

  const goToPage = (page: number) => {
    const params = new URLSearchParams(searchParams.toString())
    params.set('page', page.toString())
    router.push(`/sites/${siteId}/clients?${params.toString()}`)
  }

  return (
    <div className={styles.container}>
      {/* Filters */}
      <div className={styles.filters}>
        <form onSubmit={handleSearch} className={styles.searchForm}>
          <input
            type="text"
            placeholder="Tìm theo email hoặc tên..."
            value={searchValue}
            onChange={(e) => setSearchValue(e.target.value)}
            className={styles.searchInput}
          />
          <button type="submit" className={styles.searchBtn}>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="11" cy="11" r="8" />
              <line x1="21" y1="21" x2="16.65" y2="16.65" />
            </svg>
          </button>
        </form>

        <select
          value={provider}
          onChange={(e) => updateFilters({ provider: e.target.value })}
          className={styles.filterSelect}
        >
          <option value="all">Tất cả providers</option>
          <option value="email">Email</option>
          <option value="google">Google</option>
          <option value="facebook">Facebook</option>
          <option value="github">GitHub</option>
        </select>

        <select
          value={status}
          onChange={(e) => updateFilters({ status: e.target.value })}
          className={styles.filterSelect}
        >
          <option value="all">Tất cả trạng thái</option>
          <option value="active">Active</option>
          <option value="inactive">Inactive</option>
        </select>
      </div>

      {/* Table */}
      {clients.length === 0 ? (
        <div className={`${styles.emptyState} glass`}>
          <div className={styles.emptyIcon}>
            <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
              <circle cx="9" cy="7" r="4" />
              <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
              <path d="M16 3.13a4 4 0 0 1 0 7.75" />
            </svg>
          </div>
          <h3 className={styles.emptyTitle}>
            {search || provider !== 'all' || status !== 'all' 
              ? 'Không tìm thấy client nào' 
              : 'Chưa có client nào'}
          </h3>
          <p className={styles.emptyDesc}>
            {search || provider !== 'all' || status !== 'all'
              ? 'Thử thay đổi bộ lọc để xem kết quả khác'
              : 'Clients sẽ xuất hiện khi có người đăng ký trên site của bạn'}
          </p>
        </div>
      ) : (
        <>
          <div className={styles.table}>
            <div className={styles.tableHeader}>
              <div className={styles.colUser}>Client</div>
              <div className={styles.colProvider}>Provider</div>
              <div className={styles.colStatus}>Trạng thái</div>
              <div className={styles.colLogin}>Đăng nhập gần nhất</div>
              <div className={styles.colDate}>Ngày đăng ký</div>
            </div>
            {clients.map((client) => (
              <div key={client.id} className={styles.tableRow}>
                <div className={styles.colUser}>
                  <UserAvatar
                    name={client.full_name}
                    email={client.email}
                    avatarUrl={client.avatar_url}
                    size="md"
                  />
                  <div className={styles.userInfo}>
                    <p className={styles.userName}>
                      {client.full_name || 'Chưa đặt tên'}
                    </p>
                    <p className={styles.userEmail}>{client.email}</p>
                  </div>
                </div>
                <div className={styles.colProvider}>
                  <span className={`${styles.providerBadge} ${styles[`provider${client.provider}`]}`}>
                    {providerLabels[client.provider] || client.provider}
                  </span>
                </div>
                <div className={styles.colStatus}>
                  <span className={`${styles.statusBadge} ${client.is_active ? styles.statusActive : styles.statusInactive}`}>
                    {client.is_active ? 'Active' : 'Inactive'}
                  </span>
                  {client.is_verified && (
                    <span className={styles.verifiedBadge} title="Email verified">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z" />
                      </svg>
                    </span>
                  )}
                </div>
                <div className={styles.colLogin}>
                  {client.last_login ? (
                    <span title={`${client.login_count} lần đăng nhập`}>
                      {formatDate(client.last_login)}
                    </span>
                  ) : (
                    <span className={styles.neverLogin}>Chưa đăng nhập</span>
                  )}
                </div>
                <div className={styles.colDate}>
                  {formatDate(client.created_at)}
                </div>
              </div>
            ))}
          </div>

          {/* Pagination */}
          {totalPages > 1 && (
            <div className={styles.pagination}>
              <span className={styles.paginationInfo}>
                Hiển thị {(currentPage - 1) * 20 + 1}-{Math.min(currentPage * 20, totalCount)} / {totalCount}
              </span>
              <div className={styles.paginationButtons}>
                <button
                  onClick={() => goToPage(currentPage - 1)}
                  disabled={currentPage <= 1}
                  className={styles.paginationBtn}
                >
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <polyline points="15 18 9 12 15 6" />
                  </svg>
                </button>
                {Array.from({ length: Math.min(5, totalPages) }, (_, i) => {
                  let pageNum: number
                  if (totalPages <= 5) {
                    pageNum = i + 1
                  } else if (currentPage <= 3) {
                    pageNum = i + 1
                  } else if (currentPage >= totalPages - 2) {
                    pageNum = totalPages - 4 + i
                  } else {
                    pageNum = currentPage - 2 + i
                  }
                  return (
                    <button
                      key={pageNum}
                      onClick={() => goToPage(pageNum)}
                      className={`${styles.paginationBtn} ${currentPage === pageNum ? styles.paginationBtnActive : ''}`}
                    >
                      {pageNum}
                    </button>
                  )
                })}
                <button
                  onClick={() => goToPage(currentPage + 1)}
                  disabled={currentPage >= totalPages}
                  className={styles.paginationBtn}
                >
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <polyline points="9 18 15 12 9 6" />
                  </svg>
                </button>
              </div>
            </div>
          )}
        </>
      )}
    </div>
  )
}
