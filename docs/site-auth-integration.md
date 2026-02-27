# Hướng dẫn tích hợp Authentication cho Site con

Hướng dẫn này giúp các site con (child sites) tích hợp hệ thống authentication với Web Management Platform.

## Tổng quan

Site con có thể sử dụng Supabase Auth để xử lý đăng ký/đăng nhập cho end-users (clients). Platform sẽ quản lý và hiển thị danh sách clients trong dashboard.

## Cách 1: Sử dụng Supabase Auth trực tiếp

### Bước 1: Cài đặt Supabase Client

```bash
npm install @supabase/supabase-js
```

### Bước 2: Khởi tạo Client

```typescript
// lib/supabase.ts
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
```

### Bước 3: Đăng ký bằng Email

```typescript
// Đăng ký user mới
const { data, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password123',
  options: {
    data: {
      full_name: 'Nguyễn Văn A',
    },
  },
})

if (error) {
  console.error('Signup error:', error.message)
} else {
  console.log('User created:', data.user)
}
```

### Bước 4: Đăng nhập

```typescript
// Đăng nhập bằng email/password
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'password123',
})

// Đăng nhập bằng Google OAuth
const { data, error } = await supabase.auth.signInWithOAuth({
  provider: 'google',
  options: {
    redirectTo: 'https://yoursite.com/auth/callback',
  },
})
```

### Bước 5: Đăng xuất

```typescript
const { error } = await supabase.auth.signOut()
```

## Cách 2: Sync clients với Platform

Sau khi user đăng ký/đăng nhập trên site con, gọi API để sync với platform:

### API Endpoint

```
POST /api/v1/sites/{site_slug}/clients
```

### Request Body

```json
{
  "external_id": "supabase-user-uuid",
  "provider": "email",
  "email": "user@example.com",
  "full_name": "Nguyễn Văn A",
  "avatar_url": "https://...",
  "phone": "+84123456789",
  "metadata": {
    "subscription": "premium",
    "preferences": {}
  }
}
```

### Response

```json
{
  "success": true,
  "client_id": "uuid"
}
```

## Cách 3: Webhook (Tự động sync)

Cấu hình Supabase Database Webhook để tự động sync khi có user mới:

1. Vào Supabase Dashboard → Database → Webhooks
2. Tạo webhook mới:
   - Table: `auth.users`
   - Events: `INSERT`, `UPDATE`
   - URL: `https://your-platform.com/api/webhooks/auth`

## Google OAuth Setup

### Bước 1: Tạo Google OAuth credentials

1. Vào [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo project mới hoặc chọn project có sẵn
3. Vào APIs & Services → Credentials
4. Create Credentials → OAuth 2.0 Client IDs
5. Application type: Web application
6. Authorized redirect URIs:
   - `https://<your-supabase-project>.supabase.co/auth/v1/callback`

### Bước 2: Cấu hình trong Supabase

1. Vào Supabase Dashboard → Authentication → Providers
2. Enable Google provider
3. Nhập Client ID và Client Secret từ Google

### Bước 3: Sử dụng trong code

```typescript
const { data, error } = await supabase.auth.signInWithOAuth({
  provider: 'google',
  options: {
    redirectTo: `${window.location.origin}/auth/callback`,
    queryParams: {
      access_type: 'offline',
      prompt: 'consent',
    },
  },
})
```

## Auth Callback Handler

```typescript
// app/auth/callback/route.ts (Next.js App Router)
import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  const next = searchParams.get('next') ?? '/'

  if (code) {
    const supabase = await createClient()
    const { error } = await supabase.auth.exchangeCodeForSession(code)
    
    if (!error) {
      return NextResponse.redirect(`${origin}${next}`)
    }
  }

  return NextResponse.redirect(`${origin}/auth/error`)
}
```

## Best Practices

1. **Luôn validate email** - Bật email confirmation trong Supabase
2. **Sử dụng HTTPS** - Đảm bảo redirect URLs dùng HTTPS
3. **Handle errors** - Luôn xử lý lỗi và hiển thị message phù hợp
4. **Session management** - Sử dụng `onAuthStateChange` để theo dõi session

```typescript
supabase.auth.onAuthStateChange((event, session) => {
  if (event === 'SIGNED_IN') {
    // User signed in
  } else if (event === 'SIGNED_OUT') {
    // User signed out
  }
})
```

## Troubleshooting

### Lỗi "Invalid redirect URL"
- Kiểm tra redirect URL đã được thêm vào Supabase Dashboard → Authentication → URL Configuration

### Lỗi "Email not confirmed"
- User cần click link trong email xác nhận
- Hoặc tắt email confirmation trong Supabase settings (không khuyến khích cho production)

### Lỗi OAuth "Access denied"
- Kiểm tra Google OAuth credentials
- Đảm bảo redirect URI khớp chính xác

## Support

Nếu cần hỗ trợ, liên hệ qua:
- Email: support@yourplatform.com
- Documentation: https://docs.yourplatform.com
