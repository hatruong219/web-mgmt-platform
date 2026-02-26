export default function SettingsLoading() {
  return (
    <div style={{ width: '100%' }}>
      {/* Breadcrumb */}
      <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem' }}>
        <div className="skeleton" style={{ width: 80, height: 16, borderRadius: 4 }} />
        <div className="skeleton" style={{ width: 80, height: 16, borderRadius: 4 }} />
        <div className="skeleton" style={{ width: 60, height: 16, borderRadius: 4 }} />
      </div>

      {/* Title */}
      <div className="skeleton" style={{ width: 100, height: 28, borderRadius: 6 }} />
      <div className="skeleton" style={{ width: 200, height: 14, borderRadius: 4, marginTop: 8 }} />

      {/* Settings form */}
      <div className="glass" style={{ padding: '1.75rem', borderRadius: '1rem', marginTop: '1.5rem' }}>
        <div className="skeleton" style={{ width: 140, height: 20, borderRadius: 4, marginBottom: '1.25rem' }} />

        {[1, 2, 3, 4].map(i => (
          <div key={i} style={{ marginBottom: '1.125rem' }}>
            <div className="skeleton" style={{ width: 100, height: 14, borderRadius: 4 }} />
            <div className="skeleton" style={{ width: '100%', height: 40, borderRadius: '0.625rem', marginTop: 8 }} />
          </div>
        ))}

        <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
          <div className="skeleton" style={{ width: 120, height: 40, borderRadius: '0.625rem' }} />
        </div>
      </div>

      {/* Danger zone */}
      <div className="glass" style={{ padding: '1.75rem', borderRadius: '1rem', marginTop: '1.5rem', borderLeft: '3px solid hsl(var(--destructive))' }}>
        <div className="skeleton" style={{ width: 140, height: 20, borderRadius: 4, marginBottom: '1rem' }} />
        <div className="skeleton" style={{ width: '100%', height: 14, borderRadius: 4, marginBottom: '1rem' }} />
        <div className="skeleton" style={{ width: 150, height: 40, borderRadius: '0.625rem' }} />
      </div>
    </div>
  )
}
