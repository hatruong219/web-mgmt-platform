import type { PlatformRole, SiteRole } from '@/types/database'

interface UserRoleBadgeProps {
  role: PlatformRole | SiteRole
  type?: 'platform' | 'site'
}

const roleConfig: Record<string, { label: string; color: string; bg: string }> = {
  super_admin: {
    label: 'Super Admin',
    color: 'hsl(262 83% 65%)',
    bg: 'hsl(262 83% 65% / 0.15)',
  },
  admin: {
    label: 'Admin',
    color: 'hsl(220 83% 60%)',
    bg: 'hsl(220 83% 60% / 0.15)',
  },
  editor: {
    label: 'Editor',
    color: 'hsl(142 76% 45%)',
    bg: 'hsl(142 76% 45% / 0.15)',
  },
  viewer: {
    label: 'Viewer',
    color: 'hsl(var(--muted-foreground))',
    bg: 'hsl(var(--muted))',
  },
}

export function UserRoleBadge({ role }: UserRoleBadgeProps) {
  const config = roleConfig[role] || roleConfig.viewer

  return (
    <span
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        padding: '0.2rem 0.6rem',
        borderRadius: '9999px',
        fontSize: '0.6875rem',
        fontWeight: 600,
        textTransform: 'uppercase',
        letterSpacing: '0.04em',
        color: config.color,
        background: config.bg,
      }}
    >
      {config.label}
    </span>
  )
}
