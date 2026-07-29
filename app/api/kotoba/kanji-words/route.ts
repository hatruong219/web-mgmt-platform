import { NextResponse } from 'next/server'

import { fetchAllRows, publicReadClient } from '@/lib/supabase/public-read'

/**
 * 448 từ vựng chữ Hán của PDF "TỔNG HỢP KANJI N5 N4" (MINATO DORIMU).
 *
 * Trả về ĐÚNG hình dạng của `assets/kanji-words.json` bên app, để app dùng
 * CHUNG một bộ đọc cho cả bản đóng gói lẫn bản tải về. Hai dạng khác nhau thì
 * phải nuôi hai đường đọc, và đường ít chạy hơn sẽ mục mà không ai biết.
 *
 * Đổi tên trường ở đây thì PHẢI đổi cả `tools/build-kanji-words-asset.py` bên
 * app — có test khoá danh sách trường này (`test/kanji_words_test.dart`).
 *
 * Cấp độ (`level`) đi thẳng từ database, hiện seed hết là N4 — không có cách
 * nào chia N5/N4 tự động cho đúng, xem phần đầu migration 20260729000006. App
 * gom các giá trị có thật để dựng bộ lọc, nên sửa cấp trong database rồi bấm
 * đồng bộ là app có ngay, không phải sửa mã hai bên.
 */

type WordRow = {
  order_index: number
  word: string
  han_viet: string
  kana: string
  meaning_vi: string
  level: string
}

/** Kanji, không lấy kana. Cùng dải với regex bên app. */
const KANJI = /[一-鿿]/gu

export async function GET() {
  const siteId = process.env.LANGUAGE_LEARNING_SITE_ID
  if (!siteId) {
    return NextResponse.json({ error: 'Site not configured' }, { status: 500 })
  }

  const supabase = publicReadClient()

  const { rows, error } = await fetchAllRows<WordRow>((from, to) =>
    supabase
      .from('jlpt_kanji_words')
      .select('order_index, word, han_viet, kana, meaning_vi, level')
      .eq('site_id', siteId)
      .order('order_index')
      .range(from, to)
  )
  if (error) {
    return NextResponse.json({ error }, { status: 500 })
  }
  if (rows.length === 0) {
    return NextResponse.json(
      { error: 'Chưa có dữ liệu từ vựng chữ Hán — migration đã chạy chưa?' },
      { status: 404 }
    )
  }

  // Chữ nào app CÓ trang chi tiết. Lấy một lần rồi tra trong bộ nhớ, thay vì
  // hỏi database cho từng từ.
  const { rows: known } = await fetchAllRows<{ character: string }>(
    (from, to) =>
      supabase
        .from('jlpt_kanji')
        .select('character')
        .eq('site_id', siteId)
        .range(from, to)
  )
  const haveDetail = new Set(known.map((k) => k.character))

  return NextResponse.json(
    {
      source: 'PDF TỔNG HỢP KANJI N5 N4 — MINATO DORIMU',
      note: 'nguyên văn, không sửa, không chia cấp độ',
      count: rows.length,
      words: rows.map((r) => {
        // Giữ thứ tự xuất hiện, bỏ trùng — giống hệt bên script dựng asset.
        const chars = [...new Set(r.word.match(KANJI) ?? [])]
        return {
          n: r.order_index,
          word: r.word,
          hv: r.han_viet,
          kana: r.kana,
          meaning: r.meaning_vi,
          // Cấp độ đi thẳng từ database, app KHÔNG hard-code danh sách cấp.
          // Sửa cấp trong database rồi bấm đồng bộ là app có ngay.
          level: r.level,
          chars,
          // Chữ chưa có trang chi tiết — giao diện đừng vẽ liên kết bấm vào
          // rồi rỗng.
          unknown: chars.filter((c) => !haveDetail.has(c)),
        }
      }),
    },
    {
      headers: {
        'Cache-Control':
          'public, max-age=0, s-maxage=3600, stale-while-revalidate=86400',
      },
    }
  )
}
