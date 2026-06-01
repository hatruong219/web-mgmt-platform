'use client'

import { useState, useTransition } from 'react'
import type { MnnVocabulary } from '@/types/database'
import { createMnnVocab, updateMnnVocab, deleteMnnVocab } from '@/app/actions/lessons'

interface Props {
  vocabulary: MnnVocabulary[]
  lessonId: string
  siteId: string
}

const POS_LIST = ['名詞', '動詞', 'い形容詞', 'な形容詞', '副詞', '助詞', '助動詞', '感動詞', '接続詞', 'その他']

function VocabForm({
  initial,
  onSave,
  onCancel,
  lessonId,
  siteId,
}: {
  initial?: MnnVocabulary
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
      word: fd.get('word') as string,
      reading: (fd.get('reading') as string) || null,
      romanization: (fd.get('romanization') as string) || null,
      meaning_vi: fd.get('meaning_vi') as string,
      part_of_speech: (fd.get('part_of_speech') as string) || null,
      order_index: parseInt(fd.get('order_index') as string, 10) || 0,
    }
    startTransition(async () => {
      const res = initial
        ? await updateMnnVocab(initial.id, lessonId, siteId, data)
        : await createMnnVocab(lessonId, siteId, data)
      if (res.error) { setError(res.error); return }
      onSave()
    })
  }

  return (
    <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem', padding: '1rem', background: 'hsl(var(--accent) / 0.4)', borderRadius: '0.75rem' }}>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '0.75rem' }}>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Từ *</span>
          <input name="word" required defaultValue={initial?.word} style={inputStyle} />
        </label>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Cách đọc</span>
          <input name="reading" defaultValue={initial?.reading ?? ''} style={inputStyle} />
        </label>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Romaji</span>
          <input name="romanization" defaultValue={initial?.romanization ?? ''} style={inputStyle} />
        </label>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr 1fr', gap: '0.75rem' }}>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Nghĩa (tiếng Việt) *</span>
          <input name="meaning_vi" required defaultValue={initial?.meaning_vi} style={inputStyle} />
        </label>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Từ loại</span>
          <select name="part_of_speech" defaultValue={initial?.part_of_speech ?? ''} style={inputStyle}>
            <option value="">—</option>
            {POS_LIST.map((p) => <option key={p} value={p}>{p}</option>)}
          </select>
        </label>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Thứ tự</span>
          <input name="order_index" type="number" min={0} defaultValue={initial?.order_index ?? 0} style={inputStyle} />
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

export default function VocabularyTab({ vocabulary, lessonId, siteId }: Props) {
  const [showAdd, setShowAdd] = useState(false)
  const [editId, setEditId] = useState<string | null>(null)
  const [deletingId, setDeletingId] = useState<string | null>(null)
  const [, startTransition] = useTransition()

  function handleDelete(item: MnnVocabulary) {
    if (!confirm(`Xóa từ "${item.word}"?`)) return
    setDeletingId(item.id)
    startTransition(async () => {
      await deleteMnnVocab(item.id, lessonId, siteId)
      setDeletingId(null)
    })
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <p style={{ margin: 0, color: 'hsl(var(--muted-foreground))', fontSize: '0.875rem' }}>
          {vocabulary.length} từ vựng
        </p>
        {!showAdd && (
          <button onClick={() => setShowAdd(true)} style={btnPrimaryStyle}>
            + Thêm từ
          </button>
        )}
      </div>

      {showAdd && (
        <VocabForm lessonId={lessonId} siteId={siteId} onSave={() => setShowAdd(false)} onCancel={() => setShowAdd(false)} />
      )}

      {vocabulary.length === 0 && !showAdd ? (
        <p style={{ textAlign: 'center', color: 'hsl(var(--muted-foreground))', padding: '2rem' }}>Chưa có từ vựng</p>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '0.375rem' }}>
          {vocabulary.map((item) => (
            <div key={item.id}>
              {editId === item.id ? (
                <VocabForm
                  initial={item}
                  lessonId={lessonId}
                  siteId={siteId}
                  onSave={() => setEditId(null)}
                  onCancel={() => setEditId(null)}
                />
              ) : (
                <div
                  className="glass"
                  style={{ display: 'flex', alignItems: 'center', padding: '0.75rem 1rem', borderRadius: '0.75rem', gap: '1rem' }}
                >
                  <div style={{ minWidth: 80 }}>
                    <span style={{ fontSize: '1.125rem', fontWeight: 700 }}>{item.word}</span>
                    {item.reading && <span style={{ fontSize: '0.75rem', color: 'hsl(var(--muted-foreground))', marginLeft: '0.5rem' }}>{item.reading}</span>}
                  </div>
                  {item.romanization && <span style={{ fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))' }}>{item.romanization}</span>}
                  {item.part_of_speech && (
                    <span style={{ fontSize: '0.75rem', padding: '0.125rem 0.5rem', background: 'hsl(262 83% 65% / 0.12)', color: 'hsl(262 83% 58%)', borderRadius: '999px', fontWeight: 500 }}>
                      {item.part_of_speech}
                    </span>
                  )}
                  <span style={{ flex: 1 }}>{item.meaning_vi}</span>
                  <div style={{ display: 'flex', gap: '0.375rem', flexShrink: 0 }}>
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
