import type { Metadata } from 'next'
import { ChangePasswordForm } from '@/components/settings/ChangePasswordForm'
import styles from './page.module.css'

export const metadata: Metadata = {
  title: 'Bảo mật',
}

export default function SecurityPage() {
  return (
    <div className={`${styles.page} animate-fade-in`}>
      <div className={styles.header}>
        <h1 className={styles.title}>Bảo mật</h1>
        <p className={styles.subtitle}>Quản lý mật khẩu và bảo mật tài khoản</p>
      </div>

      <div className={`${styles.card} glass`}>
        <h2 className={styles.cardTitle}>Đổi mật khẩu</h2>
        <ChangePasswordForm />
      </div>
    </div>
  )
}
