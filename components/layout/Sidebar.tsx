'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useState, useEffect } from 'react'
import { logoutAction } from '@/app/actions/auth'
import { ThemeToggle } from '@/components/ui/ThemeToggle'
import type { User } from '@supabase/supabase-js'
import type { Site, PlatformRole } from '@/types/database'

// ─── Site accent colors (palette per site index) ────────────────────────────
const SITE_COLORS = [
  { hue: '220 83%', name: 'blue', accent: '#3b82f6' },
  { hue: '262 83%', name: 'violet', accent: '#8b5cf6' },
  { hue: '142 72%', name: 'green', accent: '#22c55e' },
  { hue: '31 90%', name: 'amber', accent: '#f59e0b' },
  { hue: '340 82%', name: 'pink', accent: '#ec4899' },
  { hue: '199 89%', name: 'cyan', accent: '#06b6d4' },
]

// ─── Icons ───────────────────────────────────────────────────────────────────
const Icons = {
  menu: (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <line x1="3" y1="12" x2="21" y2="12" />
      <line x1="3" y1="6" x2="21" y2="6" />
      <line x1="3" y1="18" x2="21" y2="18" />
    </svg>
  ),
  close: (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <line x1="18" y1="6" x2="6" y2="18" />
      <line x1="6" y1="6" x2="18" y2="18" />
    </svg>
  ),
  grid: (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <rect x="3" y="3" width="7" height="7" rx="1" /><rect x="14" y="3" width="7" height="7" rx="1" />
      <rect x="3" y="14" width="7" height="7" rx="1" /><rect x="14" y="14" width="7" height="7" rx="1" />
    </svg>
  ),
  overview: (
    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
      <polyline points="9 22 9 12 15 12 15 22" />
    </svg>
  ),
  article: (
    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
      <polyline points="14 2 14 8 20 8" />
      <line x1="16" y1="13" x2="8" y2="13" /><line x1="16" y1="17" x2="8" y2="17" />
    </svg>
  ),
  image: (
    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <rect x="3" y="3" width="18" height="18" rx="2" />
      <circle cx="8.5" cy="8.5" r="1.5" />
      <polyline points="21 15 16 10 5 21" />
    </svg>
  ),
  settings: (
    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <circle cx="12" cy="12" r="3" />
      <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z" />
    </svg>
  ),
  chevronLeft: (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
      <polyline points="15 18 9 12 15 6" />
    </svg>
  ),
  chevronDown: (
    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
      <polyline points="6 9 12 15 18 9" />
    </svg>
  ),
  logout: (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
      <polyline points="16 17 21 12 16 7" /><line x1="21" y1="12" x2="9" y2="12" />
    </svg>
  ),
  users: (
    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
      <circle cx="9" cy="7" r="4" />
      <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
      <path d="M16 3.13a4 4 0 0 1 0 7.75" />
    </svg>
  ),
  clients: (
    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
      <circle cx="12" cy="7" r="4" />
    </svg>
  ),
}

interface SidebarProps {
  user: User
  sites?: Site[]
  userRole?: PlatformRole
}

export default function Sidebar({ user, sites = [], userRole = 'editor' }: SidebarProps) {
  const pathname = usePathname()
  const [showSiteSwitcher, setShowSiteSwitcher] = useState(false)
  const [isMobileOpen, setIsMobileOpen] = useState(false)

  // ── Detect if we are inside a site context ────────────────────────────────
  const siteMatch = pathname.match(/^\/sites\/([^/]+)/)
  const activeSiteId = siteMatch ? siteMatch[1] : null
  const activeSite = sites.find((s) => s.id === activeSiteId) ?? null

  // ── Assign color per site (stable by index in array) ─────────────────────
  const getSiteColor = (siteId: string) => {
    const idx = sites.findIndex((s) => s.id === siteId)
    return SITE_COLORS[idx % SITE_COLORS.length]
  }

  const activeColor = activeSite ? getSiteColor(activeSite.id) : null
  const userInitials = user.email ? user.email.substring(0, 2).toUpperCase() : 'U'

  const handleSignOut = async () => {
    await logoutAction()
  }

  const isActive = (href: string, exact = false) => {
    if (exact) return pathname === href
    return pathname.startsWith(href)
  }

  // Close switcher when clicking outside
  useEffect(() => {
    if (!showSiteSwitcher) return
    const handler = () => setShowSiteSwitcher(false)
    document.addEventListener('click', handler)
    return () => document.removeEventListener('click', handler)
  }, [showSiteSwitcher])

  // Close mobile sidebar on route change
  useEffect(() => {
    setIsMobileOpen(false)
  }, [pathname])

  // Prevent body scroll when mobile sidebar is open
  useEffect(() => {
    if (isMobileOpen) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = ''
    }
    return () => {
      document.body.style.overflow = ''
    }
  }, [isMobileOpen])

  return (
    <>
      {/* Mobile menu button */}
      <button
        className="mobile-menu-btn"
        onClick={() => setIsMobileOpen(true)}
        aria-label="Open menu"
      >
        {Icons.menu}
      </button>

      {/* Mobile overlay */}
      <div
        className={`sidebar-overlay ${isMobileOpen ? 'open' : ''}`}
        onClick={() => setIsMobileOpen(false)}
        style={{ display: isMobileOpen ? 'block' : undefined }}
      />

      <aside
        className={`sidebar glass ${activeSite ? 'site-context' : ''} ${isMobileOpen ? 'open' : ''}`}
        style={{
          position: 'fixed',
          left: 0,
          top: 0,
          bottom: 0,
          width: 260,
          minWidth: 260,
          maxWidth: 260,
          display: 'flex',
          flexDirection: 'column',
          zIndex: 50,
          ...(activeColor ? {
            '--site-accent': activeColor.accent,
            '--site-hue': activeColor.hue,
          } as React.CSSProperties : {}),
        }}
      >
        {/* Mobile close button */}
        <button
          className="sidebar-close-btn"
          onClick={() => setIsMobileOpen(false)}
          aria-label="Close menu"
        >
          {Icons.close}
        </button>

        {/* ── Logo ──────────────────────────────────────────────── */}
        <div className="sidebar-header">
          <Link href="/" className="sidebar-logo">
            <div className="sidebar-logo-icon">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <rect x="3" y="3" width="7" height="7" rx="1" /><rect x="14" y="3" width="7" height="7" rx="1" />
                <rect x="3" y="14" width="7" height="7" rx="1" /><rect x="14" y="14" width="7" height="7" rx="1" />
              </svg>
            </div>
            <span className="sidebar-logo-text gradient-text">Web Manager</span>
          </Link>
        </div>

      {/* ── GLOBAL MODE: no active site ───────────────────────── */}
      {!activeSite && (
        <nav className="sidebar-nav">
          <p className="sidebar-nav-label">Navigation</p>
          <Link href="/" className={`sidebar-nav-item ${isActive('/', true) ? 'active' : ''}`}>
            <span className="sidebar-nav-icon">{Icons.grid}</span>
            Dashboard
          </Link>
          {userRole === 'super_admin' && (
            <Link href="/users" className={`sidebar-nav-item ${isActive('/users') ? 'active' : ''}`}>
              <span className="sidebar-nav-icon">{Icons.users}</span>
              Users
            </Link>
          )}
        </nav>
      )}

      {/* ── SITE CONTEXT MODE ─────────────────────────────────── */}
      {activeSite && (
        <>
          {/* Site Switcher */}
          <div className="site-switcher-wrap" onClick={(e) => e.stopPropagation()}>
            <button
              className="site-switcher"
              onClick={() => setShowSiteSwitcher((v) => !v)}
              title="Chuyển site"
            >
              <div
                className="site-switcher-avatar"
                style={{ background: `hsl(${activeColor?.hue} 65%)` }}
              >
                {activeSite.name.substring(0, 2).toUpperCase()}
              </div>
              <div className="site-switcher-info">
                <p className="site-switcher-name">{activeSite.name}</p>
                {activeSite.domain && (
                  <p className="site-switcher-domain">{activeSite.domain}</p>
                )}
              </div>
              <span className={`site-switcher-chevron ${showSiteSwitcher ? 'open' : ''}`}>
                {Icons.chevronDown}
              </span>
            </button>

            {/* Dropdown */}
            {showSiteSwitcher && (
              <div className="site-switcher-dropdown glass">
                <p className="site-switcher-dropdown-label">Chuyển sang</p>
                {sites.filter((s) => s.id !== activeSite.id && s.status === 'active').map((site) => {
                  const c = getSiteColor(site.id)
                  return (
                    <Link
                      key={site.id}
                      href={`/sites/${site.id}`}
                      className="site-switcher-option"
                      onClick={() => setShowSiteSwitcher(false)}
                    >
                      <div className="site-opt-avatar" style={{ background: `hsl(${c.hue} 65%)` }}>
                        {site.name.substring(0, 2).toUpperCase()}
                      </div>
                      <div>
                        <p className="site-opt-name">{site.name}</p>
                        {site.domain && <p className="site-opt-domain">{site.domain}</p>}
                      </div>
                    </Link>
                  )
                })}
                {sites.filter((s) => s.id !== activeSite.id && s.status === 'active').length === 0 && (
                  <p className="site-switcher-empty">Không có site nào khác</p>
                )}
              </div>
            )}
          </div>

          {/* Site-specific nav */}
          <nav className="sidebar-nav">
            <p className="sidebar-nav-label">Quản lý</p>
            <Link
              href={`/sites/${activeSite.id}`}
              className={`sidebar-nav-item site-nav ${isActive(`/sites/${activeSite.id}`, true) ? 'active' : ''}`}
            >
              <span className="sidebar-nav-icon">{Icons.overview}</span>
              Tổng quan
            </Link>
            <Link
              href={`/sites/${activeSite.id}/articles`}
              className={`sidebar-nav-item site-nav ${isActive(`/sites/${activeSite.id}/articles`) ? 'active' : ''}`}
            >
              <span className="sidebar-nav-icon">{Icons.article}</span>
              Bài viết
            </Link>
            <Link
              href={`/sites/${activeSite.id}/media`}
              className={`sidebar-nav-item site-nav ${isActive(`/sites/${activeSite.id}/media`) ? 'active' : ''}`}
            >
              <span className="sidebar-nav-icon">{Icons.image}</span>
              Media
            </Link>
            <Link
              href={`/sites/${activeSite.id}/members`}
              className={`sidebar-nav-item site-nav ${isActive(`/sites/${activeSite.id}/members`) ? 'active' : ''}`}
            >
              <span className="sidebar-nav-icon">{Icons.users}</span>
              Members
            </Link>
            <Link
              href={`/sites/${activeSite.id}/clients`}
              className={`sidebar-nav-item site-nav ${isActive(`/sites/${activeSite.id}/clients`) ? 'active' : ''}`}
            >
              <span className="sidebar-nav-icon">{Icons.clients}</span>
              Clients
            </Link>
            <Link
              href={`/sites/${activeSite.id}/settings`}
              className={`sidebar-nav-item site-nav ${isActive(`/sites/${activeSite.id}/settings`) ? 'active' : ''}`}
            >
              <span className="sidebar-nav-icon">{Icons.settings}</span>
              Cài đặt
            </Link>
          </nav>

          {/* Back to all sites */}
          <div className="sidebar-back-wrap">
            <Link href="/" className="sidebar-back-link">
              {Icons.chevronLeft}
              Tất cả websites
            </Link>
          </div>
        </>
      )}

      {/* ── Spacer ────────────────────────────────────────────── */}
      <div className="sidebar-spacer" />

        {/* ── User footer ───────────────────────────────────────── */}
        <div className="sidebar-footer">
          <div className="sidebar-user">
            <div className="sidebar-avatar">{userInitials}</div>
            <div className="sidebar-user-info">
              <p className="sidebar-user-email">{user.email}</p>
            </div>
          </div>
          <div className="sidebar-footer-actions">
            <ThemeToggle />
            <button
              id="sidebar-logout-btn"
              onClick={handleSignOut}
              className="sidebar-logout"
              title="Đăng xuất"
            >
              {Icons.logout}
            </button>
          </div>
        </div>
      </aside>
    </>
  )
}
