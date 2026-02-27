'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { removeSiteMemberAction } from '@/app/actions/users'

interface RemoveMemberButtonProps {
  siteId: string
  userId: string
  userName: string
}

export function RemoveMemberButton({ siteId, userId, userName }: RemoveMemberButtonProps) {
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  const [showConfirm, setShowConfirm] = useState(false)

  const handleRemove = async () => {
    setLoading(true)
    const result = await removeSiteMemberAction(siteId, userId)
    
    if (result.error) {
      alert(result.error)
      setLoading(false)
      setShowConfirm(false)
      return
    }

    router.refresh()
    setShowConfirm(false)
  }

  return (
    <>
      <button
        onClick={() => setShowConfirm(true)}
        title="Xóa member"
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          width: '32px',
          height: '32px',
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
          <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
          <circle cx="8.5" cy="7" r="4" />
          <line x1="18" y1="8" x2="23" y2="13" />
          <line x1="23" y1="8" x2="18" y2="13" />
        </svg>
      </button>

      {showConfirm && (
        <div
          style={{
            position: 'fixed',
            inset: 0,
            background: 'rgba(0, 0, 0, 0.6)',
            backdropFilter: 'blur(4px)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            zIndex: 100,
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
                <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                <circle cx="8.5" cy="7" r="4" />
                <line x1="18" y1="8" x2="23" y2="13" />
                <line x1="23" y1="8" x2="18" y2="13" />
              </svg>
            </div>
            <h3 style={{ fontSize: '1.125rem', fontWeight: 600, marginBottom: '0.5rem' }}>
              Xóa thành viên?
            </h3>
            <p style={{ color: 'hsl(var(--muted-foreground))', marginBottom: '1.5rem' }}>
              Bạn có chắc muốn xóa <strong style={{ color: 'hsl(var(--foreground))' }}>{userName}</strong> khỏi site này?
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
                Hủy
              </button>
              <button
                onClick={handleRemove}
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
                {loading ? 'Đang xóa...' : 'Xóa'}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  )
}
