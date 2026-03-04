'use client'

import { useRouter, useSearchParams } from 'next/navigation'
import { useState, useTransition } from 'react'
import type { Feedback, FeedbackStatus } from '@/types/database'
import { formatDate } from '@/lib/utils'
import { updateFeedbackStatusAction, deleteFeedbackAction } from '@/app/actions/feedbacks'
import styles from './FeedbacksTable.module.css'

interface FeedbacksTableProps {
  feedbacks: Feedback[]
  siteId: string
  currentPage: number
  totalPages: number
  totalCount: number
  search?: string
  status?: string
  canDelete?: boolean
}

const statusLabels: Record<FeedbackStatus, string> = {
  pending: 'Chờ xử lý',
  reviewed: 'Đã xem',
  archived: 'Lưu trữ',
}

const statusOptions: Array<{ value: string; label: string }> = [
  { value: 'all', label: 'Tất cả trạng thái' },
  { value: 'pending', label: 'Chờ xử lý' },
  { value: 'reviewed', label: 'Đã xem' },
  { value: 'archived', label: 'Lưu trữ' },
]

function RatingStars({ rating }: { rating: number | null }) {
  if (rating === null) return <span className={styles.noRating}>—</span>
  return (
    <span className={styles.stars} aria-label={`${rating}/5 sao`}>
      {Array.from({ length: 5 }, (_, i) => (
        <span key={i} className={i < rating ? styles.starFilled : styles.starEmpty}>
          ★
        </span>
      ))}
    </span>
  )
}

export function FeedbacksTable({
  feedbacks,
  siteId,
  currentPage,
  totalPages,
  totalCount,
  search = '',
  status = 'all',
  canDelete = false,
}: FeedbacksTableProps) {
  const router = useRouter()
  const searchParams = useSearchParams()
  const [searchValue, setSearchValue] = useState(search)
  const [isPending, startTransition] = useTransition()
  const [actionError, setActionError] = useState<string | null>(null)

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
    router.push(`/sites/${siteId}/feedbacks?${params.toString()}`)
  }

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    updateFilters({ search: searchValue })
  }

  const goToPage = (page: number) => {
    const params = new URLSearchParams(searchParams.toString())
    params.set('page', page.toString())
    router.push(`/sites/${siteId}/feedbacks?${params.toString()}`)
  }

  const handleStatusChange = (feedbackId: string, newStatus: FeedbackStatus) => {
    setActionError(null)
    startTransition(async () => {
      const result = await updateFeedbackStatusAction(feedbackId, siteId, newStatus)
      if (result.error) setActionError(result.error)
    })
  }

  const handleDelete = (feedbackId: string) => {
    if (!confirm('Bạn có chắc muốn xoá feedback này?')) return
    setActionError(null)
    startTransition(async () => {
      const result = await deleteFeedbackAction(feedbackId, siteId)
      if (result.error) setActionError(result.error)
    })
  }

  const pageNumbers = Array.from({ length: totalPages }, (_, i) => i + 1).filter(
    p => p === 1 || p === totalPages || Math.abs(p - currentPage) <= 1,
  )

  return (
    <div className={styles.container}>
      {/* Filters */}
      <div className={styles.filters}>
        <form onSubmit={handleSearch} className={styles.searchForm}>
          <input
            type="text"
            placeholder="Tìm theo tên hoặc email..."
            value={searchValue}
            onChange={e => setSearchValue(e.target.value)}
            className={styles.searchInput}
          />
          <button type="submit" className={styles.searchBtn}>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="11" cy="11" r="8" /><path d="m21 21-4.35-4.35" />
            </svg>
          </button>
        </form>

        <select
          value={status}
          onChange={e => updateFilters({ status: e.target.value })}
          className={styles.filterSelect}
        >
          {statusOptions.map(opt => (
            <option key={opt.value} value={opt.value}>{opt.label}</option>
          ))}
        </select>
      </div>

      {actionError && (
        <div className={styles.errorBanner}>{actionError}</div>
      )}

      {feedbacks.length === 0 ? (
        <div className={styles.emptyState}>
          <div className={styles.emptyIcon}>
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
              <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
            </svg>
          </div>
          <p className={styles.emptyTitle}>Chưa có feedback nào</p>
          <p className={styles.emptyDesc}>
            {search || status !== 'all'
              ? 'Không tìm thấy feedback phù hợp với bộ lọc hiện tại.'
              : 'Feedback từ người dùng sẽ hiển thị ở đây.'}
          </p>
        </div>
      ) : (
        <>
          <div className={styles.table}>
            {/* Header */}
            <div className={styles.tableHeader}>
              <span>Người gửi</span>
              <span>Nội dung</span>
              <span>Đánh giá</span>
              <span>Trạng thái</span>
              <span>Ngày gửi</span>
              <span>Hành động</span>
            </div>

            {/* Rows */}
            {feedbacks.map(fb => (
              <div key={fb.id} className={styles.tableRow}>
                {/* Sender */}
                <div className={styles.colSender}>
                  <span className={styles.senderName}>{fb.name}</span>
                  {fb.email && (
                    <span className={styles.senderEmail}>{fb.email}</span>
                  )}
                </div>

                {/* Message */}
                <div className={styles.colMessage} title={fb.message}>
                  {fb.message}
                </div>

                {/* Rating */}
                <div className={styles.colRating} data-label="Đánh giá:">
                  <RatingStars rating={fb.rating} />
                </div>

                {/* Status */}
                <div className={styles.colStatus} data-label="Trạng thái:">
                  <select
                    value={fb.status}
                    onChange={e =>
                      handleStatusChange(fb.id, e.target.value as FeedbackStatus)
                    }
                    disabled={isPending}
                    className={`${styles.statusSelect} ${styles[`status_${fb.status}`]}`}
                  >
                    {(Object.keys(statusLabels) as FeedbackStatus[]).map(s => (
                      <option key={s} value={s}>{statusLabels[s]}</option>
                    ))}
                  </select>
                </div>

                {/* Date */}
                <div className={styles.colDate} data-label="Ngày gửi:">
                  {formatDate(fb.created_at)}
                </div>

                {/* Actions */}
                <div className={styles.colActions}>
                  {canDelete && (
                    <button
                      onClick={() => handleDelete(fb.id)}
                      disabled={isPending}
                      className={styles.deleteBtn}
                      title="Xoá feedback"
                    >
                      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <polyline points="3 6 5 6 21 6" />
                        <path d="M19 6l-1 14H6L5 6" />
                        <path d="M10 11v6M14 11v6" />
                        <path d="M9 6V4h6v2" />
                      </svg>
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>

          {/* Pagination */}
          {totalPages > 1 && (
            <div className={styles.pagination}>
              <span className={styles.paginationInfo}>
                Trang {currentPage} / {totalPages} · {totalCount} feedback
              </span>
              <div className={styles.paginationButtons}>
                <button
                  onClick={() => goToPage(currentPage - 1)}
                  disabled={currentPage <= 1}
                  className={styles.paginationBtn}
                >
                  ‹
                </button>
                {pageNumbers.map((p, i) => (
                  <button
                    key={p}
                    onClick={() => goToPage(p)}
                    className={`${styles.paginationBtn} ${p === currentPage ? styles.paginationBtnActive : ''}`}
                  >
                    {p}
                  </button>
                ))}
                <button
                  onClick={() => goToPage(currentPage + 1)}
                  disabled={currentPage >= totalPages}
                  className={styles.paginationBtn}
                >
                  ›
                </button>
              </div>
            </div>
          )}
        </>
      )}
    </div>
  )
}
