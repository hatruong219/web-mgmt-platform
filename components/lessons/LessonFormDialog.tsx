'use client'

import { useState, useTransition } from 'react'
import type { MnnLesson } from '@/types/database'
import { createLesson, updateLesson } from '@/app/actions/lessons'

interface Props {
  siteId: string
  lesson?: MnnLesson
  onClose: () => void
}

export default function LessonFormDialog({ siteId, lesson, onClose }: Props) {
  const [error, setError] = useState('')
  const [isPending, startTransition] = useTransition()

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    setError('')
    const fd = new FormData(e.currentTarget)
    const data = {
      lesson_number: parseInt(fd.get('lesson_number') as string, 10),
      title_vi: fd.get('title_vi') as string,
      situation_vi: (fd.get('situation_vi') as string) || null,
      order_index: parseInt(fd.get('order_index') as string, 10) || 0,
    }
    startTransition(async () => {
      const res = lesson
        ? await updateLesson(lesson.id, siteId, data)
        : await createLesson(siteId, data)
      if (res.error) { setError(res.error); return }
      onClose()
    })
  }

  return (
    <div
      style={{
        position: 'fixed', inset: 0, zIndex: 50,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        background: 'hsl(var(--background) / 0.7)', backdropFilter: 'blur(4px)',
      }}
      onClick={(e) => { if (e.target === e.currentTarget) onClose() }}
    >
      <div
        className="glass"
        style={{
          width: '100%', maxWidth: 480,
          padding: '1.5rem', borderRadius: '1rem',
          display: 'flex', flexDirection: 'column', gap: '1.25rem',
        }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <h2 style={{ fontWeight: 700, fontSize: '1.125rem', margin: 0 }}>
            {lesson ? 'Sửa bài học' : 'Bài học mới'}
          </h2>
          <button
            onClick={onClose}
            style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4 }}
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>
        </div>

        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '0.875rem' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
            <label style={{ display: 'flex', flexDirection: 'column', gap: '0.375rem' }}>
              <span style={{ fontSize: '0.8125rem', fontWeight: 500 }}>Số bài *</span>
              <input
                name="lesson_number"
                type="number"
                min={1}
                required
                defaultValue={lesson?.lesson_number}
                style={inputStyle}
              />
            </label>
            <label style={{ display: 'flex', flexDirection: 'column', gap: '0.375rem' }}>
              <span style={{ fontSize: '0.8125rem', fontWeight: 500 }}>Thứ tự hiển thị</span>
              <input
                name="order_index"
                type="number"
                min={0}
                defaultValue={lesson?.order_index ?? 0}
                style={inputStyle}
              />
            </label>
          </div>

          <label style={{ display: 'flex', flexDirection: 'column', gap: '0.375rem' }}>
            <span style={{ fontSize: '0.8125rem', fontWeight: 500 }}>Tiêu đề (tiếng Việt) *</span>
            <input
              name="title_vi"
              type="text"
              required
              defaultValue={lesson?.title_vi}
              placeholder="VD: Xin chào"
              minLength={1}
              style={inputStyle}
            />
          </label>

          <label style={{ display: 'flex', flexDirection: 'column', gap: '0.375rem' }}>
            <span style={{ fontSize: '0.8125rem', fontWeight: 500 }}>Tình huống</span>
            <textarea
              name="situation_vi"
              rows={3}
              defaultValue={lesson?.situation_vi ?? ''}
              placeholder="Mô tả tình huống bài học..."
              style={{ ...inputStyle, resize: 'vertical' }}
            />
          </label>

          {error && (
            <p style={{ color: 'hsl(var(--destructive))', fontSize: '0.8125rem', margin: 0 }}>{error}</p>
          )}

          <div style={{ display: 'flex', gap: '0.75rem', justifyContent: 'flex-end' }}>
            <button type="button" onClick={onClose} style={btnSecondaryStyle}>Hủy</button>
            <button type="submit" disabled={isPending} style={btnPrimaryStyle}>
              {isPending ? 'Đang lưu...' : lesson ? 'Cập nhật' : 'Tạo mới'}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}

const inputStyle: React.CSSProperties = {
  padding: '0.5rem 0.75rem',
  background: 'hsl(var(--background))',
  border: '1px solid hsl(var(--border))',
  borderRadius: '0.5rem',
  fontSize: '0.875rem',
  color: 'hsl(var(--foreground))',
  width: '100%',
  boxSizing: 'border-box',
}

const btnPrimaryStyle: React.CSSProperties = {
  padding: '0.5rem 1.25rem',
  background: 'linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%))',
  color: 'white',
  border: 'none',
  borderRadius: '0.625rem',
  fontSize: '0.875rem',
  fontWeight: 600,
  cursor: 'pointer',
}

const btnSecondaryStyle: React.CSSProperties = {
  padding: '0.5rem 1.25rem',
  background: 'hsl(var(--accent))',
  color: 'hsl(var(--accent-foreground))',
  border: 'none',
  borderRadius: '0.625rem',
  fontSize: '0.875rem',
  fontWeight: 500,
  cursor: 'pointer',
}
