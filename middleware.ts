import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          )
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  // Dùng getSession() thay getUser() — đọc JWT từ cookie, KHÔNG gọi network.
  // Single-user app nên không cần verify token với Auth server mỗi request.
  // getSession() cũng tự động refresh token nếu hết hạn.
  const {
    data: { session },
  } = await supabase.auth.getSession()

  const pathname = request.nextUrl.pathname
  const isAuthPage = pathname.startsWith('/login')
  const isInvitePage = pathname.startsWith('/invite')
  const isPublicApiRoute =
    pathname.startsWith('/api/v1') ||
    pathname.startsWith('/api/kana-quiz') ||
    pathname.startsWith('/api/kotoba')

  // Require auth for all pages EXCEPT:
  // - /login (auth page)
  // - /invite/* (invite acceptance flow: tự xử lý login/signup bên trong)
  // - /api/v1/* (public API, sẽ có auth riêng)
  // - /api/kotoba/* (app Kotoba trên iPhone gọi vào, KHÔNG có phiên đăng nhập)
  //
  //   Thiếu dòng kotoba ở đây thì middleware trả 307 về /login, và app nhận
  //   được trang HTML thay vì JSON — lỗi hiện ra trên máy là "máy chủ trả về
  //   dữ liệu không đọc được", không ai đoán ra là do middleware.
  //
  //   Để công khai được vì hai route đó chỉ đọc dữ liệu tra cứu JLPT (chữ Hán,
  //   ngữ pháp giáo trình) qua anon key, không chạm dữ liệu người dùng và
  //   không nhận tham số ghi.
  if (!session && !isAuthPage && !isInvitePage && !isPublicApiRoute) {
    const url = request.nextUrl.clone()
    url.pathname = '/login'
    return NextResponse.redirect(url)
  }

  // Đã đăng nhập mà vào /login thì đẩy về dashboard
  if (session && isAuthPage) {
    const url = request.nextUrl.clone()
    url.pathname = '/'
    return NextResponse.redirect(url)
  }

  return supabaseResponse
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
}
