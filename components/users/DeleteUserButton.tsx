'use client'

import { useEffect, useState } from 'react'
import { createPortal } from 'react-dom'
import { useRouter } from 'next/navigation'
import { deleteUserAction } from '@/app/actions/users'
import type { PlatformRole } from '@/lib/permissions'

interface DeleteUserButtonProps {
  userId: string
  userName: string | null
  userEmail: string
  role: PlatformRole
}

export function DeleteUserButton({ userId, userName, userEmail, role }: DeleteUserButtonProps) {
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  const [showConfirm, setShowConfirm] = useState(false)
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  if (role === 'super_admin') {
    return null
  }

  const handleDelete = async () => {
    setLoading(true)

    const result = await deleteUserAction(userId)

    if (result.error) {
      // eslint-disable-next-line no-alert
      alert(result.error)
      setLoading(false)
      setShowConfirm(false)
      return
    }

    router.refresh()
    setShowConfirm(false)
  }

  const displayName = userName && userName.trim().length > 0 ? userName : userEmail

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
                maxWidth: '420px',
                borderRadius: '1rem',
                padding: '1.75rem',
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
                  <polyline points="3 6 5 6 21 6" />
                  <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6" />
                  <path d="M10 11v6" />
                  <path d="M14 11v6" />
                  <path d="M9 6V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2" />
                </svg>
              </div>
              <h3 style={{ fontSize: '1.125rem', fontWeight: 600, marginBottom: '0.5rem', textAlign: 'center' }}>
                Xóa user này?
              </h3>
              <p style={{ color: 'hsl(var(--muted-foreground))', marginBottom: '1.5rem', textAlign: 'center' }}>
                User{' '}
                <strong style={{ color: 'hsl(var(--foreground))' }}>
                  {displayName}
                </strong>{' '}
                sẽ bị xóa khỏi hệ thống và không thể đăng nhập lại.
              </p>
              <div style={{ display: 'flex', gap: '0.75rem' }}>
                <button
                  type="button"
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
                  Hủy
                </button>
                <button
                  type="button"
                  onClick={handleDelete}
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
                  {loading ? 'Đang xóa...' : 'Xóa user'}
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
        title="Xóa user này"
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
          <polyline points="3 6 5 6 21 6" />
          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6" />
          <path d="M10 11v6" />
          <path d="M14 11v6" />
          <path d="M9 6V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2" />
        </svg>
      </button>

      {modal}
    </>
  )
}

