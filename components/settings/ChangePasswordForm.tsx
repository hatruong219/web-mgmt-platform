'use client'

import { useState } from 'react'
import { changePasswordAction } from '@/app/actions/profile'
import styles from './ChangePasswordForm.module.css'

export function ChangePasswordForm() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    setLoading(true)
    setError(null)
    setSuccess(false)

    const formData = new FormData(e.currentTarget)
    const result = await changePasswordAction(formData)

    if (result.error) {
      setError(result.error)
    } else {
      setSuccess(true)
      e.currentTarget.reset()
    }

    setLoading(false)
  }

  return (
    <form onSubmit={handleSubmit} className={styles.form}>
      <div className={styles.field}>
        <label htmlFor="current_password" className={styles.label}>
          Mật khẩu hiện tại
        </label>
        <input
          id="current_password"
          name="current_password"
          type="password"
          required
          placeholder="••••••••"
          className={styles.input}
        />
      </div>

      <div className={styles.field}>
        <label htmlFor="new_password" className={styles.label}>
          Mật khẩu mới
        </label>
        <input
          id="new_password"
          name="new_password"
          type="password"
          required
          minLength={6}
          placeholder="Tối thiểu 6 ký tự"
          className={styles.input}
        />
      </div>

      <div className={styles.field}>
        <label htmlFor="confirm_password" className={styles.label}>
          Xác nhận mật khẩu mới
        </label>
        <input
          id="confirm_password"
          name="confirm_password"
          type="password"
          required
          minLength={6}
          placeholder="Nhập lại mật khẩu mới"
          className={styles.input}
        />
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
          Đã đổi mật khẩu thành công
        </div>
      )}

      <button
        type="submit"
        disabled={loading}
        className={styles.submitBtn}
      >
        {loading ? 'Đang xử lý...' : 'Đổi mật khẩu'}
      </button>
    </form>
  )
}
