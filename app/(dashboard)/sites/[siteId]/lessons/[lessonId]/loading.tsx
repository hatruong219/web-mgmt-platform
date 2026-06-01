export default function LessonDetailLoading() {
  return (
    <div style={{ width: '100%' }}>
      <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem' }}>
        <div className="skeleton" style={{ width: 80, height: 16, borderRadius: 4 }} />
        <div className="skeleton" style={{ width: 80, height: 16, borderRadius: 4 }} />
        <div className="skeleton" style={{ width: 100, height: 16, borderRadius: 4 }} />
        <div className="skeleton" style={{ width: 80, height: 16, borderRadius: 4 }} />
      </div>
      <div style={{ marginBottom: '1.5rem' }}>
        <div className="skeleton" style={{ width: 200, height: 28, borderRadius: 6 }} />
        <div className="skeleton" style={{ width: 300, height: 14, borderRadius: 4, marginTop: 8 }} />
      </div>
      <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem' }}>
        {Array.from({ length: 3 }).map((_, i) => (
          <div key={i} className="skeleton" style={{ width: 100, height: 36, borderRadius: '0.5rem' }} />
        ))}
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
        {Array.from({ length: 6 }).map((_, i) => (
          <div key={i} className="skeleton" style={{ height: 52, borderRadius: '0.625rem' }} />
        ))}
      </div>
    </div>
  )
}
