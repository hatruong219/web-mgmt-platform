import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import type { Metadata } from 'next'
import { AcceptInviteForm } from './AcceptInviteForm'

export const metadata: Metadata = {
  title: 'Chấp nhận lời mời',
}

interface PageProps {
  params: Promise<{ token: string }>
}

export default async function AcceptInvitePage({ params }: PageProps) {
  const { token } = await params
  const supabase = await createClient()

  // Get invitation details
  const { data: invitation, error } = await supabase
    .from('invitations')
    .select(`
      *,
      sites (id, name, slug)
    `)
    .eq('token', token)
    .single()

  if (error || !invitation) {
    return (
      <div style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '1rem',
      }}>
        <div className="glass" style={{
          maxWidth: '400px',
          padding: '2rem',
          borderRadius: '1rem',
          textAlign: 'center',
        }}>
          <div style={{
            width: '48px',
            height: '48px',
            background: 'hsl(var(--destructive) / 0.15)',
            borderRadius: '50%',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            margin: '0 auto 1rem',
            color: 'hsl(var(--destructive))',
          }}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="10" />
              <line x1="15" y1="9" x2="9" y2="15" />
              <line x1="9" y1="9" x2="15" y2="15" />
            </svg>
          </div>
          <h1 style={{ fontSize: '1.25rem', fontWeight: 600, marginBottom: '0.5rem' }}>
            Lời mời không hợp lệ
          </h1>
          <p style={{ color: 'hsl(var(--muted-foreground))', marginBottom: '1.5rem' }}>
            Link này không tồn tại hoặc đã hết hạn.
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
            Về trang đăng nhập
          </a>
        </div>
      </div>
    )
  }

  // Check if already accepted
  if (invitation.accepted_at) {
    redirect('/')
  }

  // Check if expired
  if (new Date(invitation.expires_at) < new Date()) {
    return (
      <div style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '1rem',
      }}>
        <div className="glass" style={{
          maxWidth: '400px',
          padding: '2rem',
          borderRadius: '1rem',
          textAlign: 'center',
        }}>
          <div style={{
            width: '48px',
            height: '48px',
            background: 'hsl(31 90% 50% / 0.15)',
            borderRadius: '50%',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            margin: '0 auto 1rem',
            color: 'hsl(31 90% 50%)',
          }}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="10" />
              <polyline points="12 6 12 12 16 14" />
            </svg>
          </div>
          <h1 style={{ fontSize: '1.25rem', fontWeight: 600, marginBottom: '0.5rem' }}>
            Lời mời đã hết hạn
          </h1>
          <p style={{ color: 'hsl(var(--muted-foreground))', marginBottom: '1.5rem' }}>
            Vui lòng liên hệ admin để được gửi lại lời mời mới.
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
            Về trang đăng nhập
          </a>
        </div>
      </div>
    )
  }

  // Check if user is logged in
  const { data: { user } } = await supabase.auth.getUser()

  const site = invitation.sites as { id: string; name: string; slug: string } | null

  return (
    <div style={{
      minHeight: '100vh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '1rem',
    }}>
      <div className="glass animate-fade-in" style={{
        maxWidth: '440px',
        width: '100%',
        padding: '2rem',
        borderRadius: '1rem',
      }}>
        <div style={{ textAlign: 'center', marginBottom: '1.5rem' }}>
          <div style={{
            width: '56px',
            height: '56px',
            background: 'linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%))',
            borderRadius: '0.875rem',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            margin: '0 auto 1rem',
            color: 'white',
          }}>
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <rect x="3" y="3" width="7" height="7" rx="1" />
              <rect x="14" y="3" width="7" height="7" rx="1" />
              <rect x="3" y="14" width="7" height="7" rx="1" />
              <rect x="14" y="14" width="7" height="7" rx="1" />
            </svg>
          </div>
          <h1 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '0.5rem' }}>
            Bạn được mời tham gia
          </h1>
          {site && (
            <p style={{ color: 'hsl(var(--muted-foreground))' }}>
              Tham gia quản lý <strong style={{ color: 'hsl(var(--foreground))' }}>{site.name}</strong> với vai trò{' '}
              <strong style={{ color: 'hsl(262 83% 65%)' }}>
                {invitation.role === 'admin' ? 'Admin' : invitation.role === 'editor' ? 'Editor' : 'Viewer'}
              </strong>
            </p>
          )}
        </div>

        <AcceptInviteForm 
          token={token} 
          email={invitation.email}
          isLoggedIn={!!user}
          userEmail={user?.email}
        />
      </div>
    </div>
  )
}
