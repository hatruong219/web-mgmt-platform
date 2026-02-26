export default function MediaLoading() {
  return (
    <div style={{ width: '100%' }}>
      {/* Breadcrumb */}
      <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem' }}>
        <div className="skeleton" style={{ width: 80, height: 16, borderRadius: 4 }} />
        <div className="skeleton" style={{ width: 80, height: 16, borderRadius: 4 }} />
        <div className="skeleton" style={{ width: 50, height: 16, borderRadius: 4 }} />
      </div>

      {/* Header */}
      <div style={{ marginBottom: '1.5rem' }}>
        <div className="skeleton" style={{ width: 160, height: 28, borderRadius: 6 }} />
        <div className="skeleton" style={{ width: 60, height: 14, borderRadius: 4, marginTop: 8 }} />
      </div>

      {/* Upload zone */}
      <div className="skeleton" style={{ width: '100%', height: 120, borderRadius: '1rem', marginBottom: '1.5rem' }} />

      {/* Media grid */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(180px, 1fr))', gap: '0.875rem' }}>
        {[1, 2, 3, 4, 5, 6].map(i => (
          <div key={i} className="skeleton glass" style={{ height: 210, borderRadius: '0.875rem' }} />
        ))}
      </div>
    </div>
  )
}
