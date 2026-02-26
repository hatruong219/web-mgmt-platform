'use client'

import { useEffect } from 'react'
import Link from 'next/link'

export default function SiteError({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    console.error('Site error:', error)
  }, [error])

  return (
    <div className="error-page">
      <div className="error-card glass">
        <div className="error-icon">
          <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
            <circle cx="12" cy="12" r="10" />
            <line x1="12" y1="8" x2="12" y2="12" />
            <line x1="12" y1="16" x2="12.01" y2="16" />
          </svg>
        </div>
        <h2 className="error-title">Không thể tải trang</h2>
        <p className="error-message">{error.message || 'Có lỗi khi tải dữ liệu. Vui lòng thử lại.'}</p>
        <div className="error-actions">
          <button onClick={reset} className="error-btn-primary">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <polyline points="1 4 1 10 7 10" />
              <path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10" />
            </svg>
            Thử lại
          </button>
          <Link href="/" className="error-btn-ghost">
            Về Dashboard
          </Link>
        </div>
      </div>

      <style jsx>{`
        .error-page {
          display: flex;
          align-items: center;
          justify-content: center;
          min-height: 60vh;
        }
        .error-card {
          display: flex;
          flex-direction: column;
          align-items: center;
          text-align: center;
          padding: 3rem;
          border-radius: 1.25rem;
          max-width: 420px;
          gap: 0.75rem;
        }
        .error-icon {
          color: hsl(var(--destructive));
          margin-bottom: 0.5rem;
        }
        .error-title {
          font-size: 1.25rem;
          font-weight: 700;
        }
        .error-message {
          font-size: 0.875rem;
          color: hsl(var(--muted-foreground));
          line-height: 1.5;
        }
        .error-actions {
          display: flex;
          gap: 0.75rem;
          margin-top: 0.5rem;
        }
        .error-btn-primary {
          display: inline-flex;
          align-items: center;
          gap: 0.5rem;
          padding: 0.625rem 1.25rem;
          background: linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%));
          color: white;
          border: none;
          border-radius: 0.625rem;
          font-size: 0.875rem;
          font-weight: 600;
          font-family: inherit;
          cursor: pointer;
          transition: opacity 0.2s;
        }
        .error-btn-primary:hover { opacity: 0.9; }
        .error-btn-ghost {
          padding: 0.625rem 1.25rem;
          background: transparent;
          border: 1px solid hsl(var(--border));
          border-radius: 0.625rem;
          color: hsl(var(--muted-foreground));
          font-size: 0.875rem;
          text-decoration: none;
          transition: all 0.15s;
        }
        .error-btn-ghost:hover {
          background: hsl(var(--secondary));
          color: hsl(var(--foreground));
        }
      `}</style>
    </div>
  )
}
