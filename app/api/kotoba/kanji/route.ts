import { NextResponse } from 'next/server'

import { fetchAllRows, publicReadClient } from '@/lib/supabase/public-read'

/**
 * Chữ Hán và mảnh cấu tạo cho app Kotoba.
 *
 * QUAN TRỌNG — hình dạng trả về phải GIỐNG HỆT `assets/kanji.json` mà app đóng
 * gói sẵn. App dùng chung một bộ phân tích (`KanjiSet.fromJson`) cho cả hai
 * đường: đọc từ asset lúc mở app, và đọc từ đây khi bấm đồng bộ. Hai hình dạng
 * khác nhau thì phải viết hai bộ phân tích, mà hai bộ thì sớm muộn lệch nhau và
 * lỗi chỉ lộ ra sau khi đồng bộ — đúng lúc khó truy nhất.
 *
 * Nên khi đổi tên khoá ở đây, phải đổi cả trong tools/emit-kanji-migration.py
 * và tools/build-kanji-dataset.py bên repo app.
 */

type KanjiRow = {
  character: string
  jlpt_level: string
  jlpt_level_ref: string | null
  in_course: boolean
  kyujitai: string | null
  on_readings: string[] | null
  kun_readings: string[] | null
  han_viet: string[] | null
  han_viet_source: string | null
  meaning_en: string[] | null
  meaning_vi: string | null
  meaning_vi_source: string | null
  meaning_classic: string | null
  stroke_count: number | null
  school_grade: number | null
  radical_number: number | null
  frequency: number | null
  parts: string[] | null
}

type PartRow = {
  part: string
  unlocks_count: number
  in_set: boolean
  is_shape: boolean
  radical_of: string | null
  radical_strokes: number | null
  han_viet: string | null
  meaning_vi: string | null
  meaning_en: string | null
  meaning_classic: string | null
  source: string | null
}

/** Cột đơn trong DB nhưng là mảng trong asset — bọc lại, null thành mảng rỗng. */
const wrap = (v: string | null): string[] => (v ? [v] : [])

export async function GET() {
  const siteId = process.env.LANGUAGE_LEARNING_SITE_ID
  if (!siteId) {
    return NextResponse.json({ error: 'Site not configured' }, { status: 500 })
  }

  const supabase = publicReadClient()

  const { rows: kanji, error: kanjiError } = await fetchAllRows<KanjiRow>(
    (from, to) =>
      supabase
        .from('jlpt_kanji')
        .select(
          'character, jlpt_level, jlpt_level_ref, in_course, kyujitai,' +
            ' on_readings, kun_readings, han_viet, han_viet_source,' +
            ' meaning_en, meaning_vi, meaning_vi_source, meaning_classic,' +
            ' stroke_count, school_grade, radical_number, frequency, parts'
        )
        .eq('site_id', siteId)
        .order('order_index')
        .range(from, to)
  )
  if (kanjiError) {
    return NextResponse.json({ error: kanjiError }, { status: 500 })
  }

  const { rows: parts, error: partsError } = await fetchAllRows<PartRow>(
    (from, to) =>
      supabase
        .from('jlpt_kanji_parts')
        .select(
          'part, unlocks_count, in_set, is_shape, radical_of,' +
            ' radical_strokes, han_viet, meaning_vi, meaning_en,' +
            ' meaning_classic, source'
        )
        .eq('site_id', siteId)
        .order('order_index')
        .range(from, to)
  )
  if (partsError) {
    return NextResponse.json({ error: partsError }, { status: 500 })
  }

  if (kanji.length === 0) {
    return NextResponse.json(
      { error: 'Chưa có dữ liệu kanji — migration đã chạy chưa?' },
      { status: 404 }
    )
  }

  return NextResponse.json(
    {
      source: 'web-mgmt-platform/api/kotoba/kanji',
      counts: {
        kanji: kanji.length,
        components: parts.length,
      },
      kanji: kanji.map((k) => ({
        c: k.character,
        on: k.on_readings ?? [],
        kun: k.kun_readings ?? [],
        hv: k.han_viet ?? [],
        en: k.meaning_en ?? [],
        strokes: k.stroke_count ?? 0,
        grade: k.school_grade ?? 0,
        radical: k.radical_number ?? 0,
        freq: k.frequency ?? 0,
        level: k.jlpt_level,
        level_ref: k.jlpt_level_ref ?? k.jlpt_level,
        in_course: k.in_course,
        parts: k.parts ?? [],
        kyujitai: k.kyujitai,
        hv_src: k.han_viet_source,
        meaning_classic: k.meaning_classic,
        meaning_vi: k.meaning_vi,
        meaning_vi_src: k.meaning_vi_source,
      })),
      components: parts.map((p) => ({
        c: p.part,
        unlocks: p.unlocks_count,
        in_set: p.in_set,
        hv: wrap(p.han_viet),
        meaning_vi: p.meaning_vi,
        radical_of: p.radical_of,
        radical_strokes: p.radical_strokes,
        src: p.source,
        en: wrap(p.meaning_en),
        meaning_classic: p.meaning_classic,
        is_shape: p.is_shape,
      })),
    },
    // Dữ liệu giáo trình đổi rất ít. Cho phép cache ở biên một giờ, và dùng bản
    // cũ trong lúc làm mới nền — app bấm đồng bộ không phải chờ round-trip DB.
    { headers: { 'Cache-Control': 'public, max-age=0, s-maxage=3600, stale-while-revalidate=86400' } }
  )
}
