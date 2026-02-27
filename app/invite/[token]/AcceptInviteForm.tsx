'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import {
  acceptInvitationAction,
  loginAndAcceptInvitationAction,
  signupAndAcceptInvitationAction,
} from '@/app/actions/users'

interface AcceptInviteFormProps {
  token: string
  email: string
  isLoggedIn: boolean
  userEmail?: string
}

export function AcceptInviteForm({ token, email, isLoggedIn, userEmail }: AcceptInviteFormProps) {
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [mode, setMode] = useState<'accept' | 'login' | 'signup'>(isLoggedIn ? 'accept' : 'login')

  const handleAccept = async () => {
    setLoading(true)
    setError(null)

    const result = await acceptInvitationAction(token)

    if (result.error) {
      setError(result.error)
      setLoading(false)
      return
    }

    router.push('/')
  }

  const handleLogin = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    const formData = new FormData(e.currentTarget)
    const result = await loginAndAcceptInvitationAction(token, email, formData)

    if (result.error) {
      setError(result.error)
      setLoading(false)
      return
    }

    router.push('/')
  }

  const handleSignup = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    const formData = new FormData(e.currentTarget)
    const result = await signupAndAcceptInvitationAction(token, email, formData)

    if (result.error) {
      setError(result.error)
      setLoading(false)
      return
    }

    router.push('/')
  }

  // User is logged in with matching email
  if (isLoggedIn && userEmail === email) {
    return (
      <div>
        <p style={{ textAlign: 'center', color: 'hsl(var(--muted-foreground))', marginBottom: '1.5rem' }}>
          Bạn đang đăng nhập với <strong style={{ color: 'hsl(var(--foreground))' }}>{userEmail}</strong>
        </p>

        {error && (
          <div style={{
            display: 'flex',
            alignItems: 'center',
            gap: '0.5rem',
            padding: '0.75rem 1rem',
            background: 'hsl(var(--destructive) / 0.12)',
            border: '1px solid hsl(var(--destructive) / 0.3)',
            borderRadius: '0.625rem',
            color: 'hsl(var(--destructive))',
            fontSize: '0.875rem',
            marginBottom: '1rem',
          }}>
            {error}
          </div>
        )}

        <button
          onClick={handleAccept}
          disabled={loading}
          style={{
            width: '100%',
            padding: '0.875rem',
            background: 'linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%))',
            border: 'none',
            borderRadius: '0.625rem',
            color: 'white',
            fontSize: '1rem',
            fontWeight: 600,
            cursor: loading ? 'not-allowed' : 'pointer',
            opacity: loading ? 0.6 : 1,
          }}
        >
          {loading ? 'Đang xử lý...' : 'Chấp nhận lời mời'}
        </button>
      </div>
    )
  }

  // User is logged in with different email
  if (isLoggedIn && userEmail !== email) {
    return (
      <div style={{ textAlign: 'center' }}>
        <p style={{ color: 'hsl(var(--destructive))', marginBottom: '1rem' }}>
          Bạn đang đăng nhập với email khác ({userEmail}).
        </p>
        <p style={{ color: 'hsl(var(--muted-foreground))', marginBottom: '1.5rem' }}>
          Vui lòng đăng xuất và đăng nhập lại với email <strong>{email}</strong>
        </p>
        <a
          href="/login"
          style={{
            display: 'inline-block',
            padding: '0.75rem 1.5rem',
            background: 'hsl(var(--secondary))',
            border: '1px solid hsl(var(--border))',
            borderRadius: '0.625rem',
            color: 'hsl(var(--foreground))',
            textDecoration: 'none',
            fontSize: '0.875rem',
            fontWeight: 500,
          }}
        >
          Đăng xuất
        </a>
      </div>
    )
  }

  // Not logged in - show login or signup form
  return (
    <div>
      <div style={{
        display: 'flex',
        gap: '0.5rem',
        marginBottom: '1.5rem',
        padding: '0.25rem',
        background: 'hsl(var(--secondary))',
        borderRadius: '0.5rem',
      }}>
        <button
          onClick={() => {
            setMode('login')
            setError(null)
          }}
          style={{
            flex: 1,
            padding: '0.5rem',
            background: mode === 'login' ? 'hsl(var(--card))' : 'transparent',
            border: 'none',
            borderRadius: '0.375rem',
            color: mode === 'login' ? 'hsl(var(--foreground))' : 'hsl(var(--muted-foreground))',
            fontSize: '0.875rem',
            fontWeight: 500,
            cursor: 'pointer',
          }}
        >
          Đăng nhập
        </button>
        <button
          onClick={() => {
            setMode('signup')
            setError(null)
          }}
          style={{
            flex: 1,
            padding: '0.5rem',
            background: mode === 'signup' ? 'hsl(var(--card))' : 'transparent',
            border: 'none',
            borderRadius: '0.375rem',
            color: mode === 'signup' ? 'hsl(var(--foreground))' : 'hsl(var(--muted-foreground))',
            fontSize: '0.875rem',
            fontWeight: 500,
            cursor: 'pointer',
          }}
        >
          Tạo tài khoản
        </button>
      </div>

      <p style={{ textAlign: 'center', color: 'hsl(var(--muted-foreground))', marginBottom: '1rem', fontSize: '0.875rem' }}>
        Email: <strong style={{ color: 'hsl(var(--foreground))' }}>{email}</strong>
      </p>

      {error && (
        <div style={{
          display: 'flex',
          alignItems: 'center',
          gap: '0.5rem',
          padding: '0.75rem 1rem',
          background: 'hsl(var(--destructive) / 0.12)',
          border: '1px solid hsl(var(--destructive) / 0.3)',
          borderRadius: '0.625rem',
          color: 'hsl(var(--destructive))',
          fontSize: '0.875rem',
          marginBottom: '1rem',
        }}>
          {error}
        </div>
      )}

      {mode === 'login' ? (
        <form onSubmit={handleLogin} style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
          <div>
            <label style={{ display: 'block', fontSize: '0.875rem', fontWeight: 500, marginBottom: '0.5rem', color: 'hsl(var(--muted-foreground))' }}>
              Mật khẩu
            </label>
            <input
              name="password"
              type="password"
              required
              placeholder="••••••••"
              style={{
                width: '100%',
                padding: '0.75rem 1rem',
                background: 'hsl(var(--secondary))',
                border: '1px solid hsl(var(--border))',
                borderRadius: '0.625rem',
                color: 'hsl(var(--foreground))',
                fontSize: '0.9375rem',
                outline: 'none',
              }}
            />
          </div>
          <button
            type="submit"
            disabled={loading}
            style={{
              width: '100%',
              padding: '0.875rem',
              background: 'linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%))',
              border: 'none',
              borderRadius: '0.625rem',
              color: 'white',
              fontSize: '1rem',
              fontWeight: 600,
              cursor: loading ? 'not-allowed' : 'pointer',
              opacity: loading ? 0.6 : 1,
            }}
          >
            {loading ? 'Đang xử lý...' : 'Đăng nhập & Chấp nhận'}
          </button>
        </form>
      ) : (
        <form onSubmit={handleSignup} style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
          <div>
            <label style={{ display: 'block', fontSize: '0.875rem', fontWeight: 500, marginBottom: '0.5rem', color: 'hsl(var(--muted-foreground))' }}>
              Họ tên
            </label>
            <input
              name="fullName"
              type="text"
              required
              placeholder="Nguyễn Văn A"
              style={{
                width: '100%',
                padding: '0.75rem 1rem',
                background: 'hsl(var(--secondary))',
                border: '1px solid hsl(var(--border))',
                borderRadius: '0.625rem',
                color: 'hsl(var(--foreground))',
                fontSize: '0.9375rem',
                outline: 'none',
              }}
            />
          </div>
          <div>
            <label style={{ display: 'block', fontSize: '0.875rem', fontWeight: 500, marginBottom: '0.5rem', color: 'hsl(var(--muted-foreground))' }}>
              Mật khẩu
            </label>
            <input
              name="password"
              type="password"
              required
              minLength={6}
              placeholder="Tối thiểu 6 ký tự"
              style={{
                width: '100%',
                padding: '0.75rem 1rem',
                background: 'hsl(var(--secondary))',
                border: '1px solid hsl(var(--border))',
                borderRadius: '0.625rem',
                color: 'hsl(var(--foreground))',
                fontSize: '0.9375rem',
                outline: 'none',
              }}
            />
          </div>
          <button
            type="submit"
            disabled={loading}
            style={{
              width: '100%',
              padding: '0.875rem',
              background: 'linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%))',
              border: 'none',
              borderRadius: '0.625rem',
              color: 'white',
              fontSize: '1rem',
              fontWeight: 600,
              cursor: loading ? 'not-allowed' : 'pointer',
              opacity: loading ? 0.6 : 1,
            }}
          >
            {loading ? 'Đang xử lý...' : 'Tạo tài khoản & Chấp nhận'}
          </button>
        </form>
      )}
    </div>
  )
}
