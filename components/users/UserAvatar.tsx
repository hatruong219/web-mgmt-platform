interface UserAvatarProps {
  name?: string | null
  email?: string
  avatarUrl?: string | null
  size?: 'sm' | 'md' | 'lg'
}

const sizeClasses = {
  sm: { wrapper: 'w-8 h-8 text-xs', font: '0.75rem' },
  md: { wrapper: 'w-10 h-10 text-sm', font: '0.875rem' },
  lg: { wrapper: 'w-12 h-12 text-base', font: '1rem' },
}

export function UserAvatar({ name, email, avatarUrl, size = 'md' }: UserAvatarProps) {
  const initials = getInitials(name, email)
  const sizeClass = sizeClasses[size]

  if (avatarUrl) {
    return (
      <img
        src={avatarUrl}
        alt={name || email || 'User'}
        className={`${sizeClass.wrapper} rounded-full object-cover`}
        style={{ width: size === 'sm' ? 32 : size === 'md' ? 40 : 48 }}
      />
    )
  }

  return (
    <div
      className={sizeClass.wrapper}
      style={{
        width: size === 'sm' ? 32 : size === 'md' ? 40 : 48,
        height: size === 'sm' ? 32 : size === 'md' ? 40 : 48,
        borderRadius: '50%',
        background: 'linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%))',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontSize: sizeClass.font,
        fontWeight: 600,
        color: 'white',
        flexShrink: 0,
      }}
    >
      {initials}
    </div>
  )
}

function getInitials(name?: string | null, email?: string): string {
  if (name) {
    const parts = name.trim().split(' ')
    if (parts.length >= 2) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
    }
    return name.substring(0, 2).toUpperCase()
  }
  if (email) {
    return email.substring(0, 2).toUpperCase()
  }
  return 'U'
}
