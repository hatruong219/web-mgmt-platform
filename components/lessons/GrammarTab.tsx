'use client'

import { useState, useTransition } from 'react'
import type { MnnGrammar } from '@/types/database'
import { createMnnGrammar, updateMnnGrammar, deleteMnnGrammar } from '@/app/actions/lessons'

interface Props {
  grammar: MnnGrammar[]
  lessonId: string
  siteId: string
}

function GrammarForm({
  initial,
  onSave,
  onCancel,
  lessonId,
  siteId,
}: {
  initial?: MnnGrammar
  onSave: () => void
  onCancel: () => void
  lessonId: string
  siteId: string
}) {
  const [error, setError] = useState('')
  const [isPending, startTransition] = useTransition()

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    setError('')
    const fd = new FormData(e.currentTarget)
    const data = {
      pattern: fd.get('pattern') as string,
      explanation_vi: fd.get('explanation_vi') as string,
      example_ja: (fd.get('example_ja') as string) || null,
      example_vi: (fd.get('example_vi') as string) || null,
      order_index: parseInt(fd.get('order_index') as string, 10) || 0,
    }
    startTransition(async () => {
      const res = initial
        ? await updateMnnGrammar(initial.id, lessonId, siteId, data)
        : await createMnnGrammar(lessonId, siteId, data)
      if (res.error) { setError(res.error); return }
      onSave()
    })
  }

  return (
    <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem', padding: '1rem', background: 'hsl(var(--accent) / 0.4)', borderRadius: '0.75rem' }}>
      <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '0.75rem' }}>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Mẫu ngữ pháp *</span>
          <input name="pattern" required defaultValue={initial?.pattern} placeholder="VD: 〜は〜です" style={inputStyle} />
        </label>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Thứ tự</span>
          <input name="order_index" type="number" min={0} defaultValue={initial?.order_index ?? 0} style={inputStyle} />
        </label>
      </div>
      <label style={labelStyle}>
        <span style={labelTextStyle}>Giải thích (tiếng Việt) *</span>
        <textarea name="explanation_vi" required rows={2} defaultValue={initial?.explanation_vi} style={{ ...inputStyle, resize: 'vertical' }} />
      </label>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Ví dụ (tiếng Nhật)</span>
          <input name="example_ja" defaultValue={initial?.example_ja ?? ''} style={inputStyle} />
        </label>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Dịch ví dụ</span>
          <input name="example_vi" defaultValue={initial?.example_vi ?? ''} style={inputStyle} />
        </label>
      </div>
      {error && <p style={{ color: 'hsl(var(--destructive))', fontSize: '0.8125rem', margin: 0 }}>{error}</p>}
      <div style={{ display: 'flex', gap: '0.5rem', justifyContent: 'flex-end' }}>
        <button type="button" onClick={onCancel} style={btnSecondaryStyle}>Hủy</button>
        <button type="submit" disabled={isPending} style={btnPrimaryStyle}>{isPending ? 'Lưu...' : 'Lưu'}</button>
      </div>
    </form>
  )
}

export default function GrammarTab({ grammar, lessonId, siteId }: Props) {
  const [showAdd, setShowAdd] = useState(false)
  const [editId, setEditId] = useState<string | null>(null)
  const [deletingId, setDeletingId] = useState<string | null>(null)
  const [, startTransition] = useTransition()

  function handleDelete(item: MnnGrammar) {
    if (!confirm(`Xóa mẫu "${item.pattern}"?`)) return
    setDeletingId(item.id)
    startTransition(async () => {
      await deleteMnnGrammar(item.id, lessonId, siteId)
      setDeletingId(null)
    })
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <p style={{ margin: 0, color: 'hsl(var(--muted-foreground))', fontSize: '0.875rem' }}>
          {grammar.length} mẫu ngữ pháp
        </p>
        {!showAdd && (
          <button onClick={() => setShowAdd(true)} style={btnPrimaryStyle}>+ Thêm ngữ pháp</button>
        )}
      </div>

      {showAdd && (
        <GrammarForm lessonId={lessonId} siteId={siteId} onSave={() => setShowAdd(false)} onCancel={() => setShowAdd(false)} />
      )}

      {grammar.length === 0 && !showAdd ? (
        <p style={{ textAlign: 'center', color: 'hsl(var(--muted-foreground))', padding: '2rem' }}>Chưa có ngữ pháp</p>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
          {grammar.map((item) => (
            <div key={item.id}>
              {editId === item.id ? (
                <GrammarForm
                  initial={item}
                  lessonId={lessonId}
                  siteId={siteId}
                  onSave={() => setEditId(null)}
                  onCancel={() => setEditId(null)}
                />
              ) : (
                <div className="glass" style={{ padding: '1rem 1.25rem', borderRadius: '0.75rem' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                    <div style={{ flex: 1, minWidth: 0 }}>
                      <p style={{ fontWeight: 700, fontSize: '1rem', margin: '0 0 0.25rem' }}>{item.pattern}</p>
                      <p style={{ margin: '0 0 0.5rem', color: 'hsl(var(--muted-foreground))', fontSize: '0.875rem' }}>{item.explanation_vi}</p>
                      {item.example_ja && (
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '0.125rem' }}>
                          <span style={{ fontSize: '0.8125rem' }}>{item.example_ja}</span>
                          {item.example_vi && <span style={{ fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))' }}>{item.example_vi}</span>}
                        </div>
                      )}
                    </div>
                    <div style={{ display: 'flex', gap: '0.375rem', flexShrink: 0, marginLeft: '1rem' }}>
                      <button onClick={() => setEditId(item.id)} style={btnSmallStyle}>Sửa</button>
                      <button
                        onClick={() => handleDelete(item)}
                        disabled={deletingId === item.id}
                        style={{ ...btnSmallDestructiveStyle, opacity: deletingId === item.id ? 0.5 : 1 }}
                      >
                        {deletingId === item.id ? '...' : 'Xóa'}
                      </button>
                    </div>
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

const labelStyle: React.CSSProperties = { display: 'flex', flexDirection: 'column', gap: '0.25rem' }
const labelTextStyle: React.CSSProperties = { fontSize: '0.75rem', fontWeight: 500, color: 'hsl(var(--muted-foreground))' }
const inputStyle: React.CSSProperties = {
  padding: '0.4375rem 0.625rem', background: 'hsl(var(--background))',
  border: '1px solid hsl(var(--border))', borderRadius: '0.5rem',
  fontSize: '0.875rem', color: 'hsl(var(--foreground))', width: '100%', boxSizing: 'border-box',
}
const btnPrimaryStyle: React.CSSProperties = {
  padding: '0.4375rem 1rem', background: 'linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%))',
  color: 'white', border: 'none', borderRadius: '0.5rem', fontSize: '0.8125rem', fontWeight: 600, cursor: 'pointer',
}
const btnSecondaryStyle: React.CSSProperties = {
  padding: '0.4375rem 1rem', background: 'hsl(var(--accent))', color: 'hsl(var(--accent-foreground))',
  border: 'none', borderRadius: '0.5rem', fontSize: '0.8125rem', fontWeight: 500, cursor: 'pointer',
}
const btnSmallStyle: React.CSSProperties = {
  padding: '0.25rem 0.625rem', background: 'hsl(var(--accent))', color: 'hsl(var(--accent-foreground))',
  border: 'none', borderRadius: '0.375rem', fontSize: '0.75rem', cursor: 'pointer',
}
const btnSmallDestructiveStyle: React.CSSProperties = {
  padding: '0.25rem 0.625rem', background: 'hsl(var(--destructive) / 0.12)', color: 'hsl(var(--destructive))',
  border: 'none', borderRadius: '0.375rem', fontSize: '0.75rem', cursor: 'pointer',
}
