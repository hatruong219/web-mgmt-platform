import { createClient } from '@supabase/supabase-js'
import { NextResponse } from 'next/server'

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
  { auth: { autoRefreshToken: false, persistSession: false } }
)

export async function GET(req: Request) {
  const { searchParams } = new URL(req.url)
  const lessonsParam = searchParams.get('lessons')

  const lessonNumbers = lessonsParam
    ? lessonsParam.split(',').map(Number).filter((n) => Number.isInteger(n) && n > 0)
    : null

  // Resolve site_id for the language-learning site
  const { data: site } = await supabase
    .from('sites')
    .select('id')
    .eq('slug', 'language-learning')
    .single()

  if (!site) {
    return NextResponse.json({ error: 'Site not found' }, { status: 404 })
  }

  const siteId = site.id

  // Always return all lessons for menu building
  const { data: lessons, error: lessonsError } = await supabase
    .from('mnn_lessons')
    .select('id, lesson_number')
    .eq('site_id', siteId)
    .order('lesson_number')

  if (lessonsError) {
    return NextResponse.json({ error: lessonsError.message }, { status: 500 })
  }

  // Resolve lesson IDs to filter vocabulary when lessons param is provided
  let lessonIds: string[] | null = null
  if (lessonNumbers && lessonNumbers.length > 0) {
    lessonIds = (lessons ?? [])
      .filter((l) => lessonNumbers.includes(l.lesson_number))
      .map((l) => l.id)
  }

  // Build vocabulary query — only rows with reading
  let vocabQuery = supabase
    .from('mnn_vocabulary')
    .select('id, reading, meaning_vi')
    .eq('site_id', siteId)
    .not('reading', 'is', null)

  if (lessonIds) {
    vocabQuery = vocabQuery.in('lesson_id', lessonIds)
  }

  const { data: vocabulary, error: vocabError } = await vocabQuery

  if (vocabError) {
    return NextResponse.json({ error: vocabError.message }, { status: 500 })
  }

  return NextResponse.json({
    lessons: lessons ?? [],
    vocabulary: (vocabulary ?? []).map((v) => ({
      id: v.id,
      kana: v.reading,
      meaning: v.meaning_vi,
    })),
  })
}
