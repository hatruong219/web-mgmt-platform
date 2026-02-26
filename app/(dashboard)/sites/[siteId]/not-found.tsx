'use client'

import Link from 'next/link'

export default function SiteNotFound() {
  return (
    <div className="not-found">
      <div className="not-found-card glass">
        <div className="not-found-icon">
          <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
            <circle cx="12" cy="12" r="10" />
            <path d="M16 16s-1.5-2-4-2-4 2-4 2" />
            <line x1="9" y1="9" x2="9.01" y2="9" />
            <line x1="15" y1="9" x2="15.01" y2="9" />
          </svg>
        </div>
        <h2 style={{ fontSize: '1.25rem', fontWeight: 700 }}>Website không tồn tại</h2>
        <p style={{ fontSize: '0.875rem', color: 'hsl(var(--muted-foreground))' }}>
          Website bạn đang tìm không tồn tại hoặc đã bị xóa.
        </p>
        <Link
          href="/"
          style={{
            marginTop: '0.5rem',
            display: 'inline-flex',
            alignItems: 'center',
            gap: '0.5rem',
            padding: '0.625rem 1.25rem',
            background: 'linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%))',
            color: 'white',
            border: 'none',
            borderRadius: '0.625rem',
            fontSize: '0.875rem',
            fontWeight: 600,
            textDecoration: 'none',
          }}
        >
          Về Dashboard
        </Link>
      </div>

      <style jsx>{`
        .not-found {
          display: flex;
          align-items: center;
          justify-content: center;
          min-height: 60vh;
        }
        .not-found-card {
          display: flex;
          flex-direction: column;
          align-items: center;
          text-align: center;
          padding: 3rem;
          border-radius: 1.25rem;
          max-width: 420px;
          gap: 0.75rem;
        }
        .not-found-icon {
          color: hsl(var(--muted-foreground) / 0.4);
          margin-bottom: 0.5rem;
        }
      `}</style>
    </div>
  )
}
