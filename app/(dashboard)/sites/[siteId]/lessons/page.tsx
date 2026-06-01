import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import type { Metadata } from 'next'
import Link from 'next/link'
import type { MnnLesson } from '@/types/database'
import { getSiteRole } from '@/lib/permissions'
import { requireSiteModule } from '@/lib/modules/guard'
import LessonList from '@/components/lessons/LessonList'
import s from '../../../shared.module.css'

interface Props {
  params: Promise<{ siteId: string }>
}

export const metadata: Metadata = { title: 'Bài học MNN' }

export default async function LessonsPage({ params }: Props) {
  const { siteId } = await params

  const siteRole = await getSiteRole(siteId)
  if (!siteRole) notFound()

  await requireSiteModule(siteId, 'lessons').catch(() => notFound())

  const supabase = await createClient()

  const [siteResult, lessonsResult] = await Promise.all([
    supabase.from('sites').select('name').eq('id', siteId).single(),
    supabase.from('mnn_lessons').select('*').eq('site_id', siteId).order('lesson_number'),
  ])

  if (!siteResult.data) notFound()

  const site = siteResult.data
  const lessons = (lessonsResult.data ?? []) as MnnLesson[]
  const siteHomeHref = siteRole === 'admin' ? `/sites/${siteId}` : `/sites/${siteId}/lessons`

  return (
    <div className={`${s.page} animate-fade-in`}>
      <div className={s.breadcrumb}>
        <Link href="/" className={s.breadcrumbLink}>Dashboard</Link>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
        <Link href={siteHomeHref} className={s.breadcrumbLink}>{site.name}</Link>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
        <span>Bài học MNN</span>
      </div>

      <LessonList lessons={lessons} siteId={siteId} />
    </div>
  )
}
