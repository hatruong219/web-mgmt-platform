'use client'

import { useState, useTransition } from 'react'
import type { MnnExercise } from '@/types/database'
import { createMnnExercise, updateMnnExercise, deleteMnnExercise } from '@/app/actions/lessons'

interface Props {
  exercises: MnnExercise[]
  lessonId: string
  siteId: string
}

function ExerciseForm({
  initial,
  onSave,
  onCancel,
  lessonId,
  siteId,
}: {
  initial?: MnnExercise
  onSave: () => void
  onCancel: () => void
  lessonId: string
  siteId: string
}) {
  const [error, setError] = useState('')
  const [isPending, startTransition] = useTransition()
  const [type, setType] = useState<'fill_blank' | 'multiple_choice'>(initial?.type ?? 'fill_blank')

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    setError('')
    const fd = new FormData(e.currentTarget)
    const optionsRaw = (fd.get('options') as string).trim()
    const data = {
      type,
      question: fd.get('question') as string,
      options: type === 'multiple_choice' && optionsRaw
        ? optionsRaw.split('\n').map((s) => s.trim()).filter(Boolean)
        : null,
      answer: fd.get('answer') as string,
      explanation_vi: (fd.get('explanation_vi') as string) || null,
      order_index: parseInt(fd.get('order_index') as string, 10) || 0,
    }
    startTransition(async () => {
      const res = initial
        ? await updateMnnExercise(initial.id, lessonId, siteId, data)
        : await createMnnExercise(lessonId, siteId, data)
      if (res.error) { setError(res.error); return }
      onSave()
    })
  }

  const initialOptions = initial?.type === 'multiple_choice' && Array.isArray(initial.options)
    ? initial.options.filter((o): o is string => typeof o === 'string').join('\n')
    : ''

  return (
    <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem', padding: '1rem', background: 'hsl(var(--accent) / 0.4)', borderRadius: '0.75rem' }}>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Loại *</span>
          <select
            name="type"
            value={type}
            onChange={(e) => setType(e.target.value as 'fill_blank' | 'multiple_choice')}
            style={inputStyle}
          >
            <option value="fill_blank">Điền vào chỗ trống</option>
            <option value="multiple_choice">Trắc nghiệm</option>
          </select>
        </label>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Thứ tự</span>
          <input name="order_index" type="number" min={0} defaultValue={initial?.order_index ?? 0} style={inputStyle} />
        </label>
      </div>

      <label style={labelStyle}>
        <span style={labelTextStyle}>Câu hỏi *</span>
        <textarea name="question" required rows={2} defaultValue={initial?.question} style={{ ...inputStyle, resize: 'vertical' }} />
      </label>

      {type === 'multiple_choice' && (
        <label style={labelStyle}>
          <span style={labelTextStyle}>Các lựa chọn (mỗi dòng một lựa chọn)</span>
          <textarea name="options" rows={4} defaultValue={initialOptions} placeholder={'A. ...\nB. ...\nC. ...\nD. ...'} style={{ ...inputStyle, resize: 'vertical' }} />
        </label>
      )}
      {type === 'fill_blank' && <input type="hidden" name="options" value="" />}

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Đáp án đúng *</span>
          <input name="answer" required defaultValue={initial?.answer} style={inputStyle} />
        </label>
        <label style={labelStyle}>
          <span style={labelTextStyle}>Giải thích</span>
          <input name="explanation_vi" defaultValue={initial?.explanation_vi ?? ''} style={inputStyle} />
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

const TYPE_LABELS: Record<MnnExercise['type'], string> = {
  fill_blank: 'Điền chỗ trống',
  multiple_choice: 'Trắc nghiệm',
}

export default function ExercisesTab({ exercises, lessonId, siteId }: Props) {
  const [showAdd, setShowAdd] = useState(false)
  const [editId, setEditId] = useState<string | null>(null)
  const [deletingId, setDeletingId] = useState<string | null>(null)
  const [, startTransition] = useTransition()

  function handleDelete(item: MnnExercise) {
    if (!confirm('Xóa bài tập này?')) return
    setDeletingId(item.id)
    startTransition(async () => {
      await deleteMnnExercise(item.id, lessonId, siteId)
      setDeletingId(null)
    })
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <p style={{ margin: 0, color: 'hsl(var(--muted-foreground))', fontSize: '0.875rem' }}>
          {exercises.length} bài tập
        </p>
        {!showAdd && (
          <button onClick={() => setShowAdd(true)} style={btnPrimaryStyle}>+ Thêm bài tập</button>
        )}
      </div>

      {showAdd && (
        <ExerciseForm lessonId={lessonId} siteId={siteId} onSave={() => setShowAdd(false)} onCancel={() => setShowAdd(false)} />
      )}

      {exercises.length === 0 && !showAdd ? (
        <p style={{ textAlign: 'center', color: 'hsl(var(--muted-foreground))', padding: '2rem' }}>Chưa có bài tập</p>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
          {exercises.map((item, idx) => (
            <div key={item.id}>
              {editId === item.id ? (
                <ExerciseForm
                  initial={item}
                  lessonId={lessonId}
                  siteId={siteId}
                  onSave={() => setEditId(null)}
                  onCancel={() => setEditId(null)}
                />
              ) : (
                <div className="glass" style={{ padding: '1rem 1.25rem', borderRadius: '0.75rem' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: '1rem' }}>
                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ display: 'flex', gap: '0.5rem', alignItems: 'center', marginBottom: '0.375rem' }}>
                        <span style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))' }}>#{idx + 1}</span>
                        <span style={{ fontSize: '0.75rem', padding: '0.125rem 0.5rem', background: 'hsl(var(--accent))', borderRadius: '999px' }}>
                          {TYPE_LABELS[item.type]}
                        </span>
                      </div>
                      <p style={{ margin: '0 0 0.375rem', fontWeight: 500 }}>{item.question}</p>
                      {item.type === 'multiple_choice' && Array.isArray(item.options) && (
                        <ul style={{ margin: '0 0 0.375rem', paddingLeft: '1.25rem', fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))' }}>
                          {(item.options as string[]).map((opt, i) => (
                            <li key={i}>{opt}</li>
                          ))}
                        </ul>
                      )}
                      <p style={{ margin: 0, fontSize: '0.8125rem' }}>
                        <span style={{ color: 'hsl(var(--muted-foreground))' }}>Đáp án: </span>
                        <strong>{item.answer}</strong>
                        {item.explanation_vi && <span style={{ color: 'hsl(var(--muted-foreground))' }}> — {item.explanation_vi}</span>}
                      </p>
                    </div>
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
