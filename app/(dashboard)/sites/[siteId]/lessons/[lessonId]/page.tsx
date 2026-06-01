import { createClient } from '@/lib/supabase/server'
import { cache } from 'react'
import { notFound } from 'next/navigation'
import type { Metadata } from 'next'
import Link from 'next/link'
import type { MnnLesson, MnnVocabulary, MnnGrammar, MnnExercise } from '@/types/database'
import { getSiteRole } from '@/lib/permissions'
import { requireSiteModule } from '@/lib/modules/guard'
import LessonDetailTabs from '@/components/lessons/LessonDetailTabs'
import s from '../../../../shared.module.css'

interface Props {
  params: Promise<{ siteId: string; lessonId: string }>
}

const getLesson = cache(async (lessonId: string, siteId: string) => {
  const supabase = await createClient()
  const { data } = await supabase.from('mnn_lessons').select('*').eq('id', lessonId).eq('site_id', siteId).single()
  return data as MnnLesson | null
})

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { siteId, lessonId } = await params
  const lesson = await getLesson(lessonId, siteId)
  return { title: lesson ? `Bài ${lesson.lesson_number}: ${lesson.title_vi}` : 'Bài học' }
}

export default async function LessonDetailPage({ params }: Props) {
  const { siteId, lessonId } = await params

  const siteRole = await getSiteRole(siteId)
  if (!siteRole) notFound()

  await requireSiteModule(siteId, 'lessons').catch(() => notFound())

  const supabase = await createClient()

  const [siteResult, lesson, vocabResult, grammarResult, exercisesResult] = await Promise.all([
    supabase.from('sites').select('name').eq('id', siteId).single(),
    getLesson(lessonId, siteId),
    supabase.from('mnn_vocabulary').select('*').eq('lesson_id', lessonId).eq('site_id', siteId).order('order_index'),
    supabase.from('mnn_grammar').select('*').eq('lesson_id', lessonId).eq('site_id', siteId).order('order_index'),
    supabase.from('mnn_exercises').select('*').eq('lesson_id', lessonId).eq('site_id', siteId).order('order_index'),
  ])

  if (!siteResult.data || !lesson) notFound()

  const site = siteResult.data
  const vocabulary = (vocabResult.data ?? []) as MnnVocabulary[]
  const grammar = (grammarResult.data ?? []) as MnnGrammar[]
  const exercises = (exercisesResult.data ?? []) as MnnExercise[]

  return (
    <div className={`${s.page} animate-fade-in`}>
      <div className={s.breadcrumb}>
        <Link href="/" className={s.breadcrumbLink}>Dashboard</Link>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
        <Link href={`/sites/${siteId}`} className={s.breadcrumbLink}>{site.name}</Link>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
        <Link href={`/sites/${siteId}/lessons`} className={s.breadcrumbLink}>Bài học MNN</Link>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
        <span>Bài {lesson.lesson_number}</span>
      </div>

      <div className={s.pageHeader}>
        <div>
          <h1 className={s.pageTitle}>Bài {lesson.lesson_number}: {lesson.title_vi}</h1>
          {lesson.situation_vi && <p className={s.pageSubtitle}>{lesson.situation_vi}</p>}
        </div>
      </div>

      <LessonDetailTabs
        lessonId={lesson.id}
        vocabulary={vocabulary}
        grammar={grammar}
        exercises={exercises}
        siteId={siteId}
      />
    </div>
  )
}
