'use client'

export function Skeleton({ className = '', style }: { className?: string; style?: React.CSSProperties }) {
  return (
    <div
      className={`skeleton ${className}`}
      style={style}
    />
  )
}

export function CardSkeleton() {
  return (
    <div className="skeleton-card glass">
      <div className="skeleton-card-header">
        <Skeleton style={{ width: 40, height: 40, borderRadius: '0.625rem' }} />
        <Skeleton style={{ width: 60, height: 20, borderRadius: 9999 }} />
      </div>
      <Skeleton style={{ width: '70%', height: 18, borderRadius: 4 }} />
      <Skeleton style={{ width: '100%', height: 14, borderRadius: 4 }} />
      <div className="skeleton-card-footer">
        <Skeleton style={{ width: 80, height: 14, borderRadius: 4 }} />
        <Skeleton style={{ width: 60, height: 14, borderRadius: 4 }} />
      </div>

      <style jsx>{`
        .skeleton-card { padding:1.5rem; border-radius:1rem; display:flex; flex-direction:column; gap:0.75rem; }
        .skeleton-card-header { display:flex; justify-content:space-between; align-items:center; }
        .skeleton-card-footer { display:flex; justify-content:space-between; padding-top:0.75rem; border-top:1px solid hsl(var(--border)/.4); margin-top:auto; }
      `}</style>
    </div>
  )
}

export function ArticleRowSkeleton() {
  return (
    <div className="skeleton-row glass">
      <div className="skeleton-row-content">
        <Skeleton style={{ width: '60%', height: 16, borderRadius: 4 }} />
        <Skeleton style={{ width: '40%', height: 12, borderRadius: 4, marginTop: 6 }} />
        <div className="skeleton-row-meta">
          <Skeleton style={{ width: 60, height: 18, borderRadius: 9999 }} />
          <Skeleton style={{ width: 80, height: 12, borderRadius: 4 }} />
        </div>
      </div>

      <style jsx>{`
        .skeleton-row { padding:1rem 1.25rem; border-radius:0.875rem; }
        .skeleton-row-content { display:flex; flex-direction:column; gap:0.25rem; }
        .skeleton-row-meta { display:flex; align-items:center; gap:0.75rem; margin-top:0.5rem; }
      `}</style>
    </div>
  )
}

export function StatSkeleton() {
  return (
    <div className="skeleton-stat glass">
      <Skeleton style={{ width: 44, height: 44, borderRadius: '0.75rem' }} />
      <div>
        <Skeleton style={{ width: 40, height: 24, borderRadius: 4 }} />
        <Skeleton style={{ width: 80, height: 12, borderRadius: 4, marginTop: 6 }} />
      </div>

      <style jsx>{`
        .skeleton-stat { padding:1.25rem; border-radius:1rem; display:flex; align-items:center; gap:1rem; }
      `}</style>
    </div>
  )
}
