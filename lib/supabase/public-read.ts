import { createClient, type SupabaseClient } from '@supabase/supabase-js'

/**
 * Client chỉ để ĐỌC dữ liệu công khai từ route API.
 *
 * Dùng anon key, không session, không cookie — dữ liệu giáo trình mở cho mọi
 * người đọc qua RLS nên không cần ngữ cảnh người dùng. Khác `lib/supabase/server`
 * (cần cookie để biết ai đang đăng nhập) và `admin` (service role, quyền ghi).
 */
export function publicReadClient(): SupabaseClient {
  return createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    { auth: { autoRefreshToken: false, persistSession: false } }
  )
}

/** PostgREST mặc định trả tối đa 1000 dòng mỗi lần. */
const PAGE_SIZE = 1000

/**
 * Đọc HẾT các dòng khớp điều kiện, tự phân trang.
 *
 * Vì sao cần: PostgREST cắt ở 1000 dòng và KHÔNG báo lỗi — nó trả 1000 dòng
 * như thể đó là toàn bộ. Bảng `mnn_sentences` có 1247 câu, nên gọi thẳng
 * `.select()` sẽ mất 247 câu một cách im lặng, và không ai phát hiện cho tới
 * khi người học thấy thiếu bài.
 *
 * `build` nhận (from, to) và trả về truy vấn đã gắn `.range()`. Truyền hàm chứ
 * không truyền query dựng sẵn vì query của Supabase chỉ thi hành được một lần.
 */
export async function fetchAllRows<T>(
  build: (
    from: number,
    to: number
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>
): Promise<{ rows: T[]; error: string | null }> {
  const rows: T[] = []
  for (let from = 0; ; from += PAGE_SIZE) {
    const { data, error } = await build(from, from + PAGE_SIZE - 1)
    if (error) return { rows, error: error.message }
    // `data` để `unknown` chứ không phải `T[]`: supabase-js suy kiểu phần tử từ
    // CHUỖI select, và kiểu suy ra đó không nhất thiết khớp interface mình khai.
    // Buộc kiểu ở đây thì hàm dùng được với mọi truy vấn; đổi lại người gọi
    // chịu trách nhiệm khai đúng T — nên tên cột đã được đối chiếu với migration
    // bằng script, vì sai tên cột thì chỉ lỗi lúc chạy, tsc không bắt.
    const page = (data ?? []) as T[]
    rows.push(...page)
    // Trang non hơn kích thước tối đa nghĩa là đã hết dữ liệu. Trang đầy đúng
    // bằng PAGE_SIZE thì phải hỏi tiếp — có thể còn, có thể vừa hết chẵn.
    if (page.length < PAGE_SIZE) return { rows, error: null }
  }
}
