'use client'

import { useEffect, useState } from 'react'
import { createPortal } from 'react-dom'
import { useRouter } from 'next/navigation'
import { deleteInvitationAction } from '@/app/actions/users'

interface CancelInvitationButtonProps {
  invitationId: string
  email: string
  siteName?: string | null
}

export function CancelInvitationButton({ invitationId, email, siteName }: CancelInvitationButtonProps) {
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  const [showConfirm, setShowConfirm] = useState(false)
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const handleCancel = async () => {
    setLoading(true)
    const result = await deleteInvitationAction(invitationId)

    if (result.error) {
      alert(result.error)
      setLoading(false)
      setShowConfirm(false)
      return
    }

    router.refresh()
    setShowConfirm(false)
  }

  const targetLabel = siteName ? `${email} (${siteName})` : email

  const modal =
    showConfirm && mounted
      ? createPortal(
          <div
            style={{
              position: 'fixed',
              inset: 0,
              background: 'rgba(0, 0, 0, 0.6)',
              backdropFilter: 'blur(4px)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              zIndex: 1000,
              padding: '1rem',
            }}
            onClick={(e) => e.target === e.currentTarget && setShowConfirm(false)}
          >
            <div
              className="glass animate-fade-in"
              style={{
                width: '100%',
                maxWidth: '400px',
                borderRadius: '1rem',
                padding: '1.5rem',
                textAlign: 'center',
              }}
            >
              <div
                style={{
                  width: '48px',
                  height: '48px',
                  background: 'hsl(var(--destructive) / 0.15)',
                  borderRadius: '50%',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  margin: '0 auto 1rem',
                  color: 'hsl(var(--destructive))',
                }}
              >
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <circle cx="12" cy="12" r="10" />
                  <line x1="15" y1="9" x2="9" y2="15" />
                  <line x1="9" y1="9" x2="15" y2="15" />
                </svg>
              </div>
              <h3 style={{ fontSize: '1.125rem', fontWeight: 600, marginBottom: '0.5rem' }}>
                Hủy lời mời này?
              </h3>
              <p style={{ color: 'hsl(var(--muted-foreground))', marginBottom: '1.5rem' }}>
                Lời mời gửi tới{' '}
                <strong style={{ color: 'hsl(var(--foreground))' }}>
                  {targetLabel}
                </strong>{' '}
                sẽ bị xóa. Bạn có thể mời lại sau nếu cần.
              </p>
              <div style={{ display: 'flex', gap: '0.75rem' }}>
                <button
                  onClick={() => setShowConfirm(false)}
                  style={{
                    flex: 1,
                    padding: '0.75rem',
                    background: 'hsl(var(--secondary))',
                    border: '1px solid hsl(var(--border))',
                    borderRadius: '0.625rem',
                    color: 'hsl(var(--foreground))',
                    fontSize: '0.875rem',
                    fontWeight: 500,
                    cursor: 'pointer',
                  }}
                >
                  Giữ lại
                </button>
                <button
                  onClick={handleCancel}
                  disabled={loading}
                  style={{
                    flex: 1,
                    padding: '0.75rem',
                    background: 'hsl(var(--destructive))',
                    border: 'none',
                    borderRadius: '0.625rem',
                    color: 'white',
                    fontSize: '0.875rem',
                    fontWeight: 600,
                    cursor: loading ? 'not-allowed' : 'pointer',
                    opacity: loading ? 0.6 : 1,
                  }}
                >
                  {loading ? 'Đang hủy...' : 'Hủy lời mời'}
                </button>
              </div>
            </div>
          </div>,
          document.body
        )
      : null

  return (
    <>
      <button
        onClick={() => setShowConfirm(true)}
        title="Hủy lời mời"
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          width: 32,
          height: 32,
          background: 'transparent',
          border: '1px solid hsl(var(--border))',
          borderRadius: '0.5rem',
          color: 'hsl(var(--muted-foreground))',
          cursor: 'pointer',
          transition: 'all 0.15s',
        }}
        onMouseEnter={(e) => {
          e.currentTarget.style.background = 'hsl(var(--destructive) / 0.1)'
          e.currentTarget.style.borderColor = 'hsl(var(--destructive) / 0.3)'
          e.currentTarget.style.color = 'hsl(var(--destructive))'
        }}
        onMouseLeave={(e) => {
          e.currentTarget.style.background = 'transparent'
          e.currentTarget.style.borderColor = 'hsl(var(--border))'
          e.currentTarget.style.color = 'hsl(var(--muted-foreground))'
        }}
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <circle cx="12" cy="12" r="10" />
          <line x1="15" y1="9" x2="9" y2="15" />
          <line x1="9" y1="9" x2="15" y2="15" />
        </svg>
      </button>

      {modal}
    </>
  )
}

