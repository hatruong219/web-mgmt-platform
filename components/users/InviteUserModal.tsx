'use client'

import { useEffect, useState } from 'react'
import { createPortal } from 'react-dom'
import { inviteUserAction } from '@/app/actions/users'
import type { Site, SiteRole } from '@/types/database'

interface InviteUserModalProps {
  sites: Pick<Site, 'id' | 'name' | 'slug'>[]
  defaultSiteId?: string
  allowedRoles?: SiteRole[]
}

export function InviteUserModal({ 
  sites, 
  defaultSiteId,
  allowedRoles = ['admin', 'editor', 'viewer']
}: InviteUserModalProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [mounted, setMounted] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState<{ inviteUrl: string } | null>(null)

  useEffect(() => {
    setMounted(true)
  }, [])

  useEffect(() => {
    if (!mounted) return

    if (isOpen) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = ''
    }

    return () => {
      document.body.style.overflow = ''
    }
  }, [isOpen, mounted])

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    setLoading(true)
    setError(null)
    setSuccess(null)

    const formData = new FormData(e.currentTarget)
    const result = await inviteUserAction(formData)

    if (result.error) {
      setError(result.error)
      setLoading(false)
      return
    }

    if (result.success && result.data) {
      setSuccess(result.data as { inviteUrl: string })
      setLoading(false)
    }
  }

  const handleClose = () => {
    setIsOpen(false)
    setError(null)
    setSuccess(null)
  }

  const copyInviteLink = () => {
    if (success?.inviteUrl) {
      const fullUrl = `${window.location.origin}${success.inviteUrl}`
      navigator.clipboard.writeText(fullUrl)
    }
  }

  const triggerButton = (
    <button
      onClick={() => setIsOpen(true)}
      className="btn-primary"
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '0.5rem',
        padding: '0.625rem 1rem',
        background: 'linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%))',
        color: 'white',
        border: 'none',
        borderRadius: '0.625rem',
        fontSize: '0.875rem',
        fontWeight: 600,
        cursor: 'pointer',
        transition: 'opacity 0.2s',
      }}
    >
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
        <circle cx="8.5" cy="7" r="4" />
        <line x1="20" y1="8" x2="20" y2="14" />
        <line x1="23" y1="11" x2="17" y2="11" />
      </svg>
      Invite User
    </button>
  )

  if (!mounted) {
    return triggerButton
  }

  const modalContent = (
    <div
      style={{
        position: 'fixed',
        inset: 0,
        background: 'rgba(0, 0, 0, 0.6)',
        backdropFilter: 'blur(4px)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        zIndex: 9999,
        padding: '1rem',
      }}
      onClick={(e) => e.target === e.currentTarget && handleClose()}
    >
      <div
        className="glass animate-fade-in"
        style={{
          width: '100%',
          maxWidth: '440px',
          borderRadius: '1rem',
          padding: '1.5rem',
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1.5rem' }}>
          <h2 style={{ fontSize: '1.125rem', fontWeight: 600 }}>Invite User</h2>
          <button
            onClick={handleClose}
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
            }}
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <line x1="18" y1="6" x2="6" y2="18" />
              <line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>
        </div>

        {success ? (
          <div style={{ textAlign: 'center', padding: '1rem 0' }}>
            <div
              style={{
                width: '48px',
                height: '48px',
                background: 'hsl(142 76% 45% / 0.15)',
                borderRadius: '50%',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                margin: '0 auto 1rem',
                color: 'hsl(142 76% 45%)',
              }}
            >
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <polyline points="20 6 9 17 4 12" />
              </svg>
            </div>
            <h3 style={{ fontSize: '1rem', fontWeight: 600, marginBottom: '0.5rem' }}>
              Lời mời đã được tạo!
            </h3>
            <p style={{ fontSize: '0.875rem', color: 'hsl(var(--muted-foreground))', marginBottom: '1rem' }}>
              Gửi link dưới đây cho người được mời
            </p>
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '0.5rem',
                padding: '0.75rem',
                background: 'hsl(var(--secondary))',
                borderRadius: '0.5rem',
                marginBottom: '1rem',
              }}
            >
              <input
                type="text"
                readOnly
                value={`${window.location.origin}${success.inviteUrl}`}
                style={{
                  flex: 1,
                  background: 'transparent',
                  border: 'none',
                  color: 'hsl(var(--foreground))',
                  fontSize: '0.8125rem',
                  outline: 'none',
                }}
              />
              <button
                onClick={copyInviteLink}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  padding: '0.5rem',
                  background: 'hsl(var(--primary))',
                  border: 'none',
                  borderRadius: '0.375rem',
                  color: 'white',
                  cursor: 'pointer',
                }}
              >
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <rect x="9" y="9" width="13" height="13" rx="2" />
                  <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
                </svg>
              </button>
            </div>
            <button
              onClick={handleClose}
              style={{
                width: '100%',
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
              Đóng
            </button>
          </div>
        ) : (
          <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            <div>
              <label
                htmlFor="email"
                style={{ display: 'block', fontSize: '0.875rem', fontWeight: 500, marginBottom: '0.5rem', color: 'hsl(var(--muted-foreground))' }}
              >
                Email
              </label>
              <input
                id="email"
                name="email"
                type="email"
                required
                placeholder="user@example.com"
                style={{
                  width: '100%',
                  padding: '0.75rem 1rem',
                  background: 'hsl(var(--secondary))',
                  border: '1px solid hsl(var(--border))',
                  borderRadius: '0.625rem',
                  color: 'hsl(var(--foreground))',
                  fontSize: '0.9375rem',
                  outline: 'none',
                }}
              />
            </div>

            <div>
              <label
                htmlFor="role"
                style={{ display: 'block', fontSize: '0.875rem', fontWeight: 500, marginBottom: '0.5rem', color: 'hsl(var(--muted-foreground))' }}
              >
                Role
              </label>
              <select
                id="role"
                name="role"
                required
                defaultValue="editor"
                style={{
                  width: '100%',
                  padding: '0.75rem 1rem',
                  background: 'hsl(var(--secondary))',
                  border: '1px solid hsl(var(--border))',
                  borderRadius: '0.625rem',
                  color: 'hsl(var(--foreground))',
                  fontSize: '0.9375rem',
                  outline: 'none',
                  cursor: 'pointer',
                }}
              >
                {allowedRoles.includes('admin') && <option value="admin">Admin</option>}
                {allowedRoles.includes('editor') && <option value="editor">Editor</option>}
                {allowedRoles.includes('viewer') && <option value="viewer">Viewer</option>}
              </select>
            </div>

            <div>
              <label
                htmlFor="siteId"
                style={{ display: 'block', fontSize: '0.875rem', fontWeight: 500, marginBottom: '0.5rem', color: 'hsl(var(--muted-foreground))' }}
              >
                Site
              </label>
              <select
                id="siteId"
                name="siteId"
                required
                defaultValue={defaultSiteId || ''}
                style={{
                  width: '100%',
                  padding: '0.75rem 1rem',
                  background: 'hsl(var(--secondary))',
                  border: '1px solid hsl(var(--border))',
                  borderRadius: '0.625rem',
                  color: 'hsl(var(--foreground))',
                  fontSize: '0.9375rem',
                  outline: 'none',
                  cursor: 'pointer',
                }}
              >
                <option value="" disabled>Chọn site</option>
                {sites.map((site) => (
                  <option key={site.id} value={site.id}>
                    {site.name}
                  </option>
                ))}
              </select>
            </div>

            {error && (
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.5rem',
                  padding: '0.75rem 1rem',
                  background: 'hsl(var(--destructive) / 0.12)',
                  border: '1px solid hsl(var(--destructive) / 0.3)',
                  borderRadius: '0.625rem',
                  color: 'hsl(var(--destructive))',
                  fontSize: '0.875rem',
                }}
              >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <circle cx="12" cy="12" r="10" />
                  <line x1="15" y1="9" x2="9" y2="15" />
                  <line x1="9" y1="9" x2="15" y2="15" />
                </svg>
                {error}
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              style={{
                width: '100%',
                padding: '0.75rem',
                background: 'linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%))',
                border: 'none',
                borderRadius: '0.625rem',
                color: 'white',
                fontSize: '0.9375rem',
                fontWeight: 600,
                cursor: loading ? 'not-allowed' : 'pointer',
                opacity: loading ? 0.6 : 1,
              }}
            >
              {loading ? 'Đang gửi...' : 'Gửi lời mời'}
            </button>
          </form>
        )}
      </div>
    </div>
  )

  return (
    <>
      {triggerButton}
      {isOpen && createPortal(modalContent, document.body)}
    </>
  )
}
