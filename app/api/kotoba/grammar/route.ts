import { NextResponse } from 'next/server'

import { fetchAllRows, publicReadClient } from '@/lib/supabase/public-read'

/**
 * Ngữ pháp Minna no Nihongo 50 bài, và câu ví dụ Việt–Nhật.
 *
 * Đây là route có nhiều dòng nhất: 1247 câu, VƯỢT mốc 1000 dòng mà PostgREST
 * cắt mặc định. Cắt thì nó không báo lỗi — trả về 1000 dòng như thể đó là toàn
 * bộ, mất 247 câu im lặng. Nên bắt buộc đi qua `fetchAllRows`.
 *
 * Mỗi câu có HAI bản tiếng Nhật:
 *     ja_kanji   きのう山が見えました。
 *     ja_kana    きのうやまがみえました。
 * Nhờ đó phần chấm bài dịch không cần tách từ lúc chạy — người học gõ kiểu nào
 * cũng khớp được. Câu nào nguồn không ghi furigana thì hai bản bằng nhau và
 * has_furigana = false; đó là sự thật, không phải thiếu dữ liệu.
 */

type LessonRow = {
  id: string
  lesson_number: number
  title_vi: string
  situation_vi: string | null
}

type GrammarRow = {
  id: string
  lesson_id: string
  pattern: string
  explanation_vi: string
  example_ja: string | null
  example_vi: string | null
  order_index: number
}

type SentenceRow = {
  lesson_id: string
  grammar_id: string | null
  ja_kanji: string
  ja_kana: string
  vi: string
  has_furigana: boolean
  order_index: number
}

export async function GET() {
  const siteId = process.env.LANGUAGE_LEARNING_SITE_ID
  if (!siteId) {
    return NextResponse.json({ error: 'Site not configured' }, { status: 500 })
  }

  const supabase = publicReadClient()

  const { rows: lessons, error: lessonError } = await fetchAllRows<LessonRow>(
    (from, to) =>
      supabase
        .from('mnn_lessons')
        .select('id, lesson_number, title_vi, situation_vi')
        .eq('site_id', siteId)
        .order('lesson_number')
        .range(from, to)
  )
  if (lessonError) {
    return NextResponse.json({ error: lessonError }, { status: 500 })
  }

  const { rows: grammar, error: grammarError } = await fetchAllRows<GrammarRow>(
    (from, to) =>
      supabase
        .from('mnn_grammar')
        .select(
          'id, lesson_id, pattern, explanation_vi, example_ja, example_vi,' +
            ' order_index'
        )
        .eq('site_id', siteId)
        .order('order_index')
        .range(from, to)
  )
  if (grammarError) {
    return NextResponse.json({ error: grammarError }, { status: 500 })
  }

  const { rows: sentences, error: sentenceError } =
    await fetchAllRows<SentenceRow>((from, to) =>
      supabase
        .from('mnn_sentences')
        .select(
          'lesson_id, grammar_id, ja_kanji, ja_kana, vi, has_furigana,' +
            ' order_index'
        )
        .eq('site_id', siteId)
        .order('order_index')
        .range(from, to)
    )
  if (sentenceError) {
    return NextResponse.json({ error: sentenceError }, { status: 500 })
  }

  if (grammar.length === 0) {
    return NextResponse.json(
      { error: 'Chưa có dữ liệu ngữ pháp — migration đã chạy chưa?' },
      { status: 404 }
    )
  }

  // Trả về theo SỐ BÀI, không trả uuid: app không lưu uuid và cũng không cần.
  // Ghép ở đây một lần rẻ hơn để app tự ghép mỗi lần mở màn.
  const lessonNumber = new Map(lessons.map((l) => [l.id, l.lesson_number]))
  const grammarKey = new Map(
    grammar.map((g) => [g.id, `${lessonNumber.get(g.lesson_id)}:${g.order_index}`])
  )

  return NextResponse.json(
    {
      source: 'web-mgmt-platform/api/kotoba/grammar',
      counts: {
        lessons: lessons.length,
        grammar: grammar.length,
        sentences: sentences.length,
      },
      lessons: lessons.map((l) => ({
        n: l.lesson_number,
        title: l.title_vi,
        situation: l.situation_vi,
      })),
      grammar: grammar
        .filter((g) => lessonNumber.has(g.lesson_id))
        .map((g) => ({
          lesson: lessonNumber.get(g.lesson_id),
          // `ord` là khoá để câu ví dụ trỏ về mẫu, không phải để hiển thị.
          ord: g.order_index,
          pattern: g.pattern,
          explain: g.explanation_vi,
          example_ja: g.example_ja,
          example_vi: g.example_vi,
        })),
      sentences: sentences
        .filter((s) => lessonNumber.has(s.lesson_id))
        .map((s) => ({
          lesson: lessonNumber.get(s.lesson_id),
          // Trỏ về mẫu ngữ pháp qua cặp (bài, ord). null nghĩa là câu không gắn
          // với mẫu nào — hiện chưa có, nhưng schema cho phép.
          grammar: s.grammar_id ? grammarKey.get(s.grammar_id) ?? null : null,
          ja_kanji: s.ja_kanji,
          ja_kana: s.ja_kana,
          vi: s.vi,
          has_furigana: s.has_furigana,
          ord: s.order_index,
        })),
    },
    { headers: { 'Cache-Control': 'public, max-age=0, s-maxage=3600, stale-while-revalidate=86400' } }
  )
}
