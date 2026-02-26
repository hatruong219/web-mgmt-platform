import { ArticleRowSkeleton } from '@/components/ui/Skeleton'

export default function ArticlesLoading() {
  return (
    <div style={{ width: '100%' }}>
      {/* Breadcrumb */}
      <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem' }}>
        <div className="skeleton" style={{ width: 80, height: 16, borderRadius: 4 }} />
        <div className="skeleton" style={{ width: 80, height: 16, borderRadius: 4 }} />
        <div className="skeleton" style={{ width: 60, height: 16, borderRadius: 4 }} />
      </div>

      {/* Header */}
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '1.5rem' }}>
        <div>
          <div className="skeleton" style={{ width: 120, height: 28, borderRadius: 6 }} />
          <div className="skeleton" style={{ width: 80, height: 14, borderRadius: 4, marginTop: 8 }} />
        </div>
        <div className="skeleton" style={{ width: 140, height: 40, borderRadius: '0.625rem' }} />
      </div>

      {/* Filters */}
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '1.25rem' }}>
        <div className="skeleton" style={{ width: 320, height: 40, borderRadius: '0.625rem' }} />
        <div className="skeleton" style={{ width: 220, height: 40, borderRadius: '0.625rem' }} />
      </div>

      {/* Article list */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
        <ArticleRowSkeleton />
        <ArticleRowSkeleton />
        <ArticleRowSkeleton />
        <ArticleRowSkeleton />
        <ArticleRowSkeleton />
      </div>
    </div>
  )
}
