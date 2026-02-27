'use client'

interface CopyInviteLinkButtonProps {
  token: string
}

export function CopyInviteLinkButton({ token }: CopyInviteLinkButtonProps) {
  const handleCopy = () => {
    const origin = window.location.origin
    const url = `${origin}/invite/${token}`
    navigator.clipboard.writeText(url)
  }

  return (
    <button
      onClick={handleCopy}
      title="Copy link lời mời"
      style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        width: 32,
        height: 32,
        background: 'transparent',
        border: '1px solid hsl(var(--border))',
        borderRadius: '0.5rem',
        color: 'hsl(var(--muted-foreground))',
        cursor: 'pointer',
        transition: 'all 0.15s',
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.background = 'hsl(var(--secondary))'
        e.currentTarget.style.color = 'hsl(var(--foreground))'
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.background = 'transparent'
        e.currentTarget.style.color = 'hsl(var(--muted-foreground))'
      }}
    >
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <rect x="9" y="9" width="13" height="13" rx="2" />
        <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
      </svg>
    </button>
  )
}

