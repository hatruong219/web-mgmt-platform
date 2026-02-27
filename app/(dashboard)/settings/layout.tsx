import Link from 'next/link'
import styles from './layout.module.css'

export default function SettingsLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className={styles.layout}>
      <aside className={styles.sidebar}>
        <h2 className={styles.sidebarTitle}>Cài đặt</h2>
        <nav className={styles.nav}>
          <Link href="/settings/profile" className={styles.navItem}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
              <circle cx="12" cy="7" r="4" />
            </svg>
            Hồ sơ
          </Link>
          <Link href="/settings/security" className={styles.navItem}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
              <path d="M7 11V7a5 5 0 0 1 10 0v4" />
            </svg>
            Bảo mật
          </Link>
        </nav>
      </aside>
      <main className={styles.main}>
        {children}
      </main>
    </div>
  )
}
