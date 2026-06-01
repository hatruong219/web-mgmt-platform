'use client'

import { useState, useTransition } from 'react'
import Link from 'next/link'
import type { MnnLesson } from '@/types/database'
import { deleteLesson } from '@/app/actions/lessons'
import LessonFormDialog from './LessonFormDialog'
import s from '@/app/(dashboard)/shared.module.css'

interface Props {
  lessons: MnnLesson[]
  siteId: string
}

export default function LessonList({ lessons, siteId }: Props) {
  const [showCreate, setShowCreate] = useState(false)
  const [editLesson, setEditLesson] = useState<MnnLesson | null>(null)
  const [deletingId, setDeletingId] = useState<string | null>(null)
  const [, startTransition] = useTransition()

  function handleDelete(lesson: MnnLesson) {
    if (!confirm(`Xóa bài ${lesson.lesson_number}: ${lesson.title_vi}?`)) return
    setDeletingId(lesson.id)
    startTransition(async () => {
      await deleteLesson(lesson.id, siteId)
      setDeletingId(null)
    })
  }

  return (
    <>
      <div className={s.pageHeader}>
        <div>
          <h1 className={s.pageTitle}>Bài học MNN</h1>
          <p className={s.pageSubtitle}>{lessons.length} bài học</p>
        </div>
        <button className={s.btnPrimary} onClick={() => setShowCreate(true)}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
            <line x1="12" y1="5" x2="12" y2="19" /><line x1="5" y1="12" x2="19" y2="12" />
          </svg>
          Bài học mới
        </button>
      </div>

      {lessons.length === 0 ? (
        <div className={`${s.emptyState} glass`}>
          <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
            <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z" />
            <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z" />
          </svg>
          <h3 className={s.emptyTitle}>Chưa có bài học nào</h3>
          <p>Thêm bài học đầu tiên từ Minna no Nihongo</p>
        </div>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
          {lessons.map((lesson) => (
            <div
              key={lesson.id}
              className="glass"
              style={{
                display: 'flex',
                alignItems: 'center',
                padding: '1rem 1.25rem',
                borderRadius: '0.875rem',
                gap: '1rem',
              }}
            >
              <div
                style={{
                  minWidth: 40, height: 40,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  background: 'hsl(262 83% 65% / 0.15)',
                  borderRadius: '0.5rem',
                  fontWeight: 700,
                  fontSize: '0.875rem',
                  color: 'hsl(262 83% 65%)',
                }}
              >
                {lesson.lesson_number}
              </div>

              <Link
                href={`/sites/${siteId}/lessons/${lesson.id}`}
                style={{ flex: 1, minWidth: 0, textDecoration: 'none', color: 'inherit' }}
              >
                <p style={{ fontWeight: 600, margin: 0 }}>{lesson.title_vi}</p>
                {lesson.situation_vi && (
                  <p style={{ fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))', margin: 0, marginTop: 2 }}>
                    {lesson.situation_vi}
                  </p>
                )}
              </Link>

              <div style={{ display: 'flex', gap: '0.5rem', flexShrink: 0 }}>
                <button
                  onClick={() => setEditLesson(lesson)}
                  style={{
                    display: 'inline-flex', alignItems: 'center', gap: '0.375rem',
                    padding: '0.375rem 0.75rem', borderRadius: '0.5rem',
                    background: 'hsl(var(--accent))', color: 'hsl(var(--accent-foreground))',
                    fontSize: '0.8125rem', fontWeight: 500, border: 'none', cursor: 'pointer',
                  }}
                >
                  Sửa
                </button>
                <button
                  onClick={() => handleDelete(lesson)}
                  disabled={deletingId === lesson.id}
                  style={{
                    display: 'inline-flex', alignItems: 'center',
                    padding: '0.375rem 0.75rem', borderRadius: '0.5rem',
                    background: 'hsl(var(--destructive) / 0.12)',
                    color: 'hsl(var(--destructive))',
                    fontSize: '0.8125rem', fontWeight: 500, border: 'none', cursor: 'pointer',
                    opacity: deletingId === lesson.id ? 0.5 : 1,
                  }}
                >
                  {deletingId === lesson.id ? '...' : 'Xóa'}
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {showCreate && (
        <LessonFormDialog
          siteId={siteId}
          onClose={() => setShowCreate(false)}
        />
      )}

      {editLesson && (
        <LessonFormDialog
          siteId={siteId}
          lesson={editLesson}
          onClose={() => setEditLesson(null)}
        />
      )}
    </>
  )
}
