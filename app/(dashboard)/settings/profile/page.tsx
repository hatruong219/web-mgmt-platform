import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import type { Metadata } from 'next'
import { ProfileForm } from '@/components/settings/ProfileForm'
import { UserRoleBadge } from '@/components/users/UserRoleBadge'
import type { Profile } from '@/types/database'
import styles from './page.module.css'

export const metadata: Metadata = {
  title: 'Hồ sơ cá nhân',
}

export default async function ProfilePage() {
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) {
    redirect('/login')
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .single()

  if (!profile) {
    redirect('/login')
  }

  return (
    <div className={`${styles.page} animate-fade-in`}>
      <div className={styles.header}>
        <h1 className={styles.title}>Hồ sơ cá nhân</h1>
        <p className={styles.subtitle}>Quản lý thông tin tài khoản của bạn</p>
      </div>

      <div className={`${styles.card} glass`}>
        <div className={styles.roleSection}>
          <span className={styles.roleLabel}>Vai trò của bạn:</span>
          <UserRoleBadge role={profile.role} />
        </div>

        <ProfileForm profile={profile as Profile} />
      </div>
    </div>
  )
}
