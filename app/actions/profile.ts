'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'

export type ActionResult = {
  error?: string
  success?: boolean
}

/**
 * Update current user's profile
 */
export async function updateProfileAction(formData: FormData): Promise<ActionResult> {
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) {
    return { error: 'Chưa đăng nhập' }
  }

  const fullName = (formData.get('full_name') as string)?.trim() || null
  const avatarUrl = (formData.get('avatar_url') as string)?.trim() || null

  const { error } = await supabase
    .from('profiles')
    .update({
      full_name: fullName,
      avatar_url: avatarUrl,
    })
    .eq('id', user.id)

  if (error) {
    return { error: error.message }
  }

  revalidatePath('/settings/profile')
  revalidatePath('/')

  return { success: true }
}

/**
 * Change password
 */
export async function changePasswordAction(formData: FormData): Promise<ActionResult> {
  const currentPassword = formData.get('current_password') as string
  const newPassword = formData.get('new_password') as string
  const confirmPassword = formData.get('confirm_password') as string

  if (!currentPassword || !newPassword || !confirmPassword) {
    return { error: 'Vui lòng điền đầy đủ thông tin' }
  }

  if (newPassword !== confirmPassword) {
    return { error: 'Mật khẩu mới không khớp' }
  }

  if (newPassword.length < 6) {
    return { error: 'Mật khẩu mới phải có ít nhất 6 ký tự' }
  }

  const supabase = await createClient()

  // Verify current password by re-authenticating
  const { data: { user } } = await supabase.auth.getUser()
  if (!user?.email) {
    return { error: 'Chưa đăng nhập' }
  }

  // Try to sign in with current password to verify
  const { error: signInError } = await supabase.auth.signInWithPassword({
    email: user.email,
    password: currentPassword,
  })

  if (signInError) {
    return { error: 'Mật khẩu hiện tại không đúng' }
  }

  // Update password
  const { error: updateError } = await supabase.auth.updateUser({
    password: newPassword,
  })

  if (updateError) {
    return { error: updateError.message }
  }

  return { success: true }
}
