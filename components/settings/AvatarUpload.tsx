'use client'

import { useState, useRef } from 'react'
import { createClient } from '@/lib/supabase/client'
import { UserAvatar } from '@/components/users/UserAvatar'
import { STORAGE_BUCKET } from '@/lib/utils'
import styles from './AvatarUpload.module.css'

interface AvatarUploadProps {
  currentUrl: string | null
  name: string | null
  email: string
  onUpload: (url: string) => void
}

export function AvatarUpload({ currentUrl, name, email, onUpload }: AvatarUploadProps) {
  const [uploading, setUploading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const fileInputRef = useRef<HTMLInputElement>(null)

  const handleClick = () => {
    fileInputRef.current?.click()
  }

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file) return

    // Validate file
    if (!file.type.startsWith('image/')) {
      setError('Chỉ chấp nhận file ảnh')
      return
    }

    if (file.size > 2 * 1024 * 1024) {
      setError('File không được vượt quá 2MB')
      return
    }

    setUploading(true)
    setError(null)

    try {
      const supabase = createClient()
      
      // Get current user
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) {
        setError('Chưa đăng nhập')
        return
      }

      // Generate unique filename
      const ext = file.name.split('.').pop()
      const filename = `avatars/${user.id}-${Date.now()}.${ext}`

      // Upload to storage
      const { error: uploadError } = await supabase.storage
        .from(STORAGE_BUCKET)
        .upload(filename, file, { upsert: true })

      if (uploadError) {
        setError(uploadError.message)
        return
      }

      // Get public URL
      const { data: { publicUrl } } = supabase.storage
        .from(STORAGE_BUCKET)
        .getPublicUrl(filename)

      onUpload(publicUrl)
    } catch {
      setError('Có lỗi xảy ra khi upload')
    } finally {
      setUploading(false)
    }
  }

  return (
    <div className={styles.container}>
      <div className={styles.avatarWrapper} onClick={handleClick}>
        <UserAvatar
          name={name}
          email={email}
          avatarUrl={currentUrl}
          size="lg"
        />
        <div className={styles.overlay}>
          {uploading ? (
            <div className={styles.spinner} />
          ) : (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" />
              <circle cx="12" cy="13" r="4" />
            </svg>
          )}
        </div>
      </div>
      <input
        ref={fileInputRef}
        type="file"
        accept="image/*"
        onChange={handleFileChange}
        className={styles.hiddenInput}
      />
      <p className={styles.hint}>Click để thay đổi avatar</p>
      {error && <p className={styles.error}>{error}</p>}
    </div>
  )
}
