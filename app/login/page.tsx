'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import type { Metadata } from 'next'

// Metadata defined server-side; login page is client component so we export separately
export default function LoginPage() {
    const router = useRouter()
    const [email, setEmail] = useState('')
    const [password, setPassword] = useState('')
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState<string | null>(null)

    const handleLogin = async (e: React.FormEvent) => {
        e.preventDefault()
        setLoading(true)
        setError(null)

        const supabase = createClient()
        const { error } = await supabase.auth.signInWithPassword({ email, password })

        if (error) {
            setError(error.message)
            setLoading(false)
        } else {
            router.push('/')
            router.refresh()
        }
    }

    return (
        <div className="login-page">
            <div className="login-bg">
                <div className="login-orb login-orb-1" />
                <div className="login-orb login-orb-2" />
            </div>

            <div className="login-card glass animate-fade-in">
                {/* Logo */}
                <div className="login-logo">
                    <div className="login-logo-icon">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <rect x="3" y="3" width="7" height="7" rx="1" />
                            <rect x="14" y="3" width="7" height="7" rx="1" />
                            <rect x="3" y="14" width="7" height="7" rx="1" />
                            <rect x="14" y="14" width="7" height="7" rx="1" />
                        </svg>
                    </div>
                    <h1 className="login-title gradient-text">Web Manager</h1>
                    <p className="login-subtitle">Đăng nhập để quản lý websites của bạn</p>
                </div>

                {/* Form */}
                <form onSubmit={handleLogin} className="login-form">
                    <div className="form-group">
                        <label htmlFor="email" className="form-label">Email</label>
                        <input
                            id="email"
                            type="email"
                            required
                            placeholder="you@example.com"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            className="form-input"
                            autoComplete="email"
                        />
                    </div>

                    <div className="form-group">
                        <label htmlFor="password" className="form-label">Mật khẩu</label>
                        <input
                            id="password"
                            type="password"
                            required
                            placeholder="••••••••"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            className="form-input"
                            autoComplete="current-password"
                        />
                    </div>

                    {error && (
                        <div className="form-error" role="alert">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                <circle cx="12" cy="12" r="10" />
                                <line x1="15" y1="9" x2="9" y2="15" />
                                <line x1="9" y1="9" x2="15" y2="15" />
                            </svg>
                            {error}
                        </div>
                    )}

                    <button
                        id="login-submit-btn"
                        type="submit"
                        disabled={loading}
                        className="btn-primary btn-full"
                    >
                        {loading ? (
                            <span className="btn-loading">
                                <svg className="spin" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                    <path d="M21 12a9 9 0 1 1-6.219-8.56" />
                                </svg>
                                Đang đăng nhập...
                            </span>
                        ) : (
                            'Đăng nhập'
                        )}
                    </button>
                </form>
            </div>

            <style jsx>{`
        .login-page {
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          position: relative;
          overflow: hidden;
          padding: 1rem;
        }
        .login-bg {
          position: absolute;
          inset: 0;
          pointer-events: none;
        }
        .login-orb {
          position: absolute;
          border-radius: 50%;
          filter: blur(80px);
          opacity: 0.25;
        }
        .login-orb-1 {
          width: 500px;
          height: 500px;
          background: hsl(262 83% 65%);
          top: -100px;
          right: -100px;
        }
        .login-orb-2 {
          width: 400px;
          height: 400px;
          background: hsl(220 83% 60%);
          bottom: -100px;
          left: -100px;
        }
        .login-card {
          width: 100%;
          max-width: 420px;
          border-radius: 1.25rem;
          padding: 2.5rem;
          position: relative;
          z-index: 1;
        }
        .login-logo {
          text-align: center;
          margin-bottom: 2rem;
        }
        .login-logo-icon {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          width: 56px;
          height: 56px;
          background: linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%));
          border-radius: 0.875rem;
          color: white;
          margin-bottom: 1rem;
          box-shadow: 0 8px 24px hsl(262 83% 65% / 0.35);
        }
        .login-title {
          font-size: 1.75rem;
          font-weight: 700;
          margin-bottom: 0.375rem;
        }
        .login-subtitle {
          font-size: 0.875rem;
          color: hsl(var(--muted-foreground));
        }
        .login-form {
          display: flex;
          flex-direction: column;
          gap: 1.25rem;
        }
        .form-group {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }
        .form-label {
          font-size: 0.875rem;
          font-weight: 500;
          color: hsl(var(--muted-foreground));
        }
        .form-input {
          width: 100%;
          padding: 0.75rem 1rem;
          background: hsl(var(--secondary));
          border: 1px solid hsl(var(--border));
          border-radius: 0.625rem;
          color: hsl(var(--foreground));
          font-size: 0.9375rem;
          font-family: inherit;
          transition: border-color 0.2s, box-shadow 0.2s;
          outline: none;
        }
        .form-input:focus {
          border-color: hsl(var(--primary));
          box-shadow: 0 0 0 3px hsl(var(--primary) / 0.15);
        }
        .form-input::placeholder {
          color: hsl(var(--muted-foreground) / 0.6);
        }
        .form-error {
          display: flex;
          align-items: center;
          gap: 0.5rem;
          padding: 0.75rem 1rem;
          background: hsl(var(--destructive) / 0.12);
          border: 1px solid hsl(var(--destructive) / 0.3);
          border-radius: 0.625rem;
          color: hsl(var(--destructive));
          font-size: 0.875rem;
        }
        .btn-primary {
          padding: 0.75rem 1.5rem;
          background: linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%));
          color: white;
          border: none;
          border-radius: 0.625rem;
          font-size: 0.9375rem;
          font-weight: 600;
          font-family: inherit;
          cursor: pointer;
          transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s;
          box-shadow: 0 4px 16px hsl(262 83% 65% / 0.3);
        }
        .btn-primary:hover:not(:disabled) {
          opacity: 0.92;
          transform: translateY(-1px);
          box-shadow: 0 8px 24px hsl(262 83% 65% / 0.4);
        }
        .btn-primary:active:not(:disabled) {
          transform: translateY(0);
        }
        .btn-primary:disabled {
          opacity: 0.6;
          cursor: not-allowed;
        }
        .btn-full {
          width: 100%;
        }
        .btn-loading {
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 0.5rem;
        }
        .spin {
          animation: spin 1s linear infinite;
        }
        @keyframes spin {
          to { transform: rotate(360deg); }
        }
      `}</style>
        </div>
    )
}
