import { StatSkeleton, ArticleRowSkeleton } from '@/components/ui/Skeleton'

export default function SiteOverviewLoading() {
  return (
    <div style={{ width: '100%' }}>
      {/* Breadcrumb */}
      <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem' }}>
        <div className="skeleton" style={{ width: 80, height: 16, borderRadius: 4 }} />
        <div className="skeleton" style={{ width: 100, height: 16, borderRadius: 4 }} />
      </div>

      {/* Site header */}
      <div style={{ display: 'flex', gap: '1.25rem', alignItems: 'center', marginBottom: '2rem' }}>
        <div className="skeleton" style={{ width: 60, height: 60, borderRadius: '1rem' }} />
        <div>
          <div className="skeleton" style={{ width: 200, height: 28, borderRadius: 6 }} />
          <div className="skeleton" style={{ width: 300, height: 14, borderRadius: 4, marginTop: 8 }} />
        </div>
      </div>

      {/* Stats */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1rem', marginBottom: '2rem' }}>
        <StatSkeleton />
        <StatSkeleton />
        <StatSkeleton />
      </div>

      {/* Quick nav */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1rem', marginBottom: '2.5rem' }}>
        {[1, 2, 3].map(i => (
          <div key={i} className="skeleton glass" style={{ padding: '1rem 1.25rem', borderRadius: '0.875rem', height: 52 }} />
        ))}
      </div>

      {/* Recent articles */}
      <div className="skeleton" style={{ width: 180, height: 20, borderRadius: 4, marginBottom: '1rem' }} />
      <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
        <ArticleRowSkeleton />
        <ArticleRowSkeleton />
        <ArticleRowSkeleton />
      </div>
    </div>
  )
}
