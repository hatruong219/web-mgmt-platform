import { StatSkeleton, CardSkeleton } from '@/components/ui/Skeleton'

export default function DashboardLoading() {
  return (
    <div style={{ maxWidth: 1000 }}>
      {/* Header */}
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '2rem' }}>
        <div>
          <div className="skeleton" style={{ width: 160, height: 30, borderRadius: 6 }} />
          <div className="skeleton" style={{ width: 240, height: 16, borderRadius: 4, marginTop: 8 }} />
        </div>
        <div className="skeleton" style={{ width: 140, height: 40, borderRadius: '0.625rem' }} />
      </div>

      {/* Stats */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1rem', marginBottom: '2.5rem' }}>
        <StatSkeleton />
        <StatSkeleton />
        <StatSkeleton />
      </div>

      {/* Section title */}
      <div className="skeleton" style={{ width: 180, height: 20, borderRadius: 4, marginBottom: '1rem' }} />

      {/* Site cards */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))', gap: '1rem' }}>
        <CardSkeleton />
        <CardSkeleton />
        <CardSkeleton />
      </div>
    </div>
  )
}
