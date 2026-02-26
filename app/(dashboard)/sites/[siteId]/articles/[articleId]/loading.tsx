export default function ArticleEditorLoading() {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', minHeight: 'calc(100vh - 4rem)', margin: '-2rem' }}>
      {/* Topbar */}
      <div className="glass" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '0.75rem 1.5rem', borderBottom: '1px solid hsl(var(--border) / 0.5)' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
          <div className="skeleton" style={{ width: 34, height: 34, borderRadius: '0.5rem' }} />
          <div>
            <div className="skeleton" style={{ width: 100, height: 12, borderRadius: 4 }} />
            <div className="skeleton" style={{ width: 60, height: 10, borderRadius: 4, marginTop: 4 }} />
          </div>
        </div>
        <div style={{ display: 'flex', gap: '0.75rem' }}>
          <div className="skeleton" style={{ width: 110, height: 34, borderRadius: '0.5rem' }} />
          <div className="skeleton" style={{ width: 80, height: 34, borderRadius: '0.5rem' }} />
        </div>
      </div>

      {/* Body */}
      <div style={{ display: 'flex', gap: '1.25rem', padding: '1.5rem', flex: 1 }}>
        {/* Main editor */}
        <div style={{ flex: 1 }}>
          <div className="skeleton" style={{ width: '60%', height: 36, borderRadius: 6, marginBottom: '1.25rem' }} />
          <div className="skeleton" style={{ width: '100%', height: 400, borderRadius: '0.875rem' }} />
        </div>

        {/* Sidebar */}
        <div style={{ width: 280, display: 'flex', flexDirection: 'column', gap: '0.875rem' }}>
          <div className="skeleton glass" style={{ height: 140, borderRadius: '0.875rem' }} />
          <div className="skeleton glass" style={{ height: 100, borderRadius: '0.875rem' }} />
          <div className="skeleton glass" style={{ height: 70, borderRadius: '0.875rem' }} />
          <div className="skeleton glass" style={{ height: 50, borderRadius: '0.875rem' }} />
        </div>
      </div>
    </div>
  )
}
