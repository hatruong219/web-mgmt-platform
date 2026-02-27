'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { updateProfileAction } from '@/app/actions/profile'
import { AvatarUpload } from './AvatarUpload'
import type { Profile } from '@/types/database'
import styles from './ProfileForm.module.css'

interface ProfileFormProps {
  profile: Profile
}

export function ProfileForm({ profile }: ProfileFormProps) {
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)
  const [avatarUrl, setAvatarUrl] = useState(profile.avatar_url)

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    setLoading(true)
    setError(null)
    setSuccess(false)

    const formData = new FormData(e.currentTarget)
    formData.set('avatar_url', avatarUrl || '')

    const result = await updateProfileAction(formData)

    if (result.error) {
      setError(result.error)
    } else {
      setSuccess(true)
      router.refresh()
    }

    setLoading(false)
  }

  return (
    <form onSubmit={handleSubmit} className={styles.form}>
      <div className={styles.avatarSection}>
        <AvatarUpload
          currentUrl={avatarUrl}
          name={profile.full_name}
          email={profile.email}
          onUpload={setAvatarUrl}
        />
      </div>

      <div className={styles.field}>
        <label htmlFor="full_name" className={styles.label}>
          Họ tên
        </label>
        <input
          id="full_name"
          name="full_name"
          type="text"
          defaultValue={profile.full_name || ''}
          placeholder="Nguyễn Văn A"
          className={styles.input}
        />
      </div>

      <div className={styles.field}>
        <label htmlFor="email" className={styles.label}>
          Email
        </label>
        <input
          id="email"
          name="email"
          type="email"
          value={profile.email}
          disabled
          className={`${styles.input} ${styles.inputDisabled}`}
        />
        <p className={styles.hint}>Email không thể thay đổi</p>
      </div>

      {error && (
        <div className={styles.error}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <circle cx="12" cy="12" r="10" />
            <line x1="15" y1="9" x2="9" y2="15" />
            <line x1="9" y1="9" x2="15" y2="15" />
          </svg>
          {error}
        </div>
      )}

      {success && (
        <div className={styles.success}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <polyline points="20 6 9 17 4 12" />
          </svg>
          Đã cập nhật thành công
        </div>
      )}

      <button
        type="submit"
        disabled={loading}
        className={styles.submitBtn}
      >
        {loading ? 'Đang lưu...' : 'Lưu thay đổi'}
      </button>
    </form>
  )
}
