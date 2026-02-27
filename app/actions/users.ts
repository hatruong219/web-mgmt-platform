'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'
import { getCurrentUser, isSuperAdmin, isSiteAdmin } from '@/lib/permissions'
import type { SiteRole } from '@/types/database'
import crypto from 'crypto'

export type ActionResult = {
  error?: string
  success?: boolean
  data?: unknown
}

/**
 * Invite a user to the platform or a specific site
 * - Super Admin: can invite admins to any site
 * - Site Admin: can only invite editors to their site
 */
export async function inviteUserAction(formData: FormData): Promise<ActionResult> {
  const email = formData.get('email') as string
  const siteId = formData.get('siteId') as string | null
  const role = formData.get('role') as SiteRole

  if (!email || !role) {
    return { error: 'Email và role là bắt buộc' }
  }

  const currentUser = await getCurrentUser()
  if (!currentUser) {
    return { error: 'Chưa đăng nhập' }
  }

  // Permission check
  const superAdmin = currentUser.role === 'super_admin'
  
  if (!superAdmin) {
    // Site admin can only invite editors
    if (role === 'admin') {
      return { error: 'Chỉ Super Admin mới có thể invite Admin' }
    }
    
    if (!siteId) {
      return { error: 'Site ID là bắt buộc' }
    }
    
    const siteAdmin = await isSiteAdmin(siteId)
    if (!siteAdmin) {
      return { error: 'Bạn không có quyền invite user cho site này' }
    }
  }

  const supabase = await createClient()

  // Check if user already exists
  const { data: existingProfile } = await supabase
    .from('profiles')
    .select('id')
    .eq('email', email)
    .single()

  if (existingProfile && siteId) {
    // User exists, check if already a member of this site
    const { data: existingMember } = await supabase
      .from('site_members')
      .select('id')
      .eq('site_id', siteId)
      .eq('user_id', existingProfile.id)
      .single()

    if (existingMember) {
      return { error: 'User đã là thành viên của site này' }
    }
  }

  // Check for existing pending invitation
  const { data: existingInvite } = await supabase
    .from('invitations')
    .select('id')
    .eq('email', email)
    .eq('site_id', siteId)
    .is('accepted_at', null)
    .single()

  if (existingInvite) {
    return { error: 'Đã có lời mời đang chờ cho email này' }
  }

  // Create invitation
  const token = crypto.randomBytes(32).toString('hex')
  const expiresAt = new Date()
  expiresAt.setDate(expiresAt.getDate() + 7) // 7 days expiry

  const { error: insertError } = await supabase
    .from('invitations')
    .insert({
      email,
      site_id: siteId,
      role,
      token,
      invited_by: currentUser.id,
      expires_at: expiresAt.toISOString(),
    })

  if (insertError) {
    console.error('Insert invitation error:', insertError)
    return { error: 'Không thể tạo lời mời' }
  }

  // TODO: Send email with invitation link
  // For now, just return success with token (for testing)
  
  revalidatePath('/users')
  if (siteId) {
    revalidatePath(`/sites/${siteId}/members`)
  }

  return { 
    success: true, 
    data: { 
      token,
      inviteUrl: `/invite/${token}` 
    } 
  }
}

/**
 * Accept an invitation
 */
export async function acceptInvitationAction(token: string): Promise<ActionResult> {
  const supabase = await createClient()

  // Get current user
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) {
    return { error: 'Bạn cần đăng nhập để chấp nhận lời mời' }
  }

  // Get invitation
  const { data: invitation, error: inviteError } = await supabase
    .from('invitations')
    .select('*')
    .eq('token', token)
    .single()

  if (inviteError || !invitation) {
    return { error: 'Lời mời không tồn tại hoặc đã hết hạn' }
  }

  // Check if already accepted
  if (invitation.accepted_at) {
    return { error: 'Lời mời này đã được chấp nhận' }
  }

  // Check expiry
  if (new Date(invitation.expires_at) < new Date()) {
    return { error: 'Lời mời đã hết hạn' }
  }

  // Check email match
  if (invitation.email !== user.email) {
    return { error: 'Email không khớp với lời mời' }
  }

  // Add user to site_members if site_id exists
  if (invitation.site_id) {
    const { error: memberError } = await supabase
      .from('site_members')
      .insert({
        site_id: invitation.site_id,
        user_id: user.id,
        role: invitation.role,
        invited_by: invitation.invited_by,
        accepted_at: new Date().toISOString(),
      })

    if (memberError) {
      console.error('Add member error:', memberError)
      return { error: 'Không thể thêm bạn vào site' }
    }
  }

  // Mark invitation as accepted
  await supabase
    .from('invitations')
    .update({ accepted_at: new Date().toISOString() })
    .eq('id', invitation.id)

  revalidatePath('/users')
  revalidatePath('/')

  return { success: true }
}

/**
 * Remove a member from a site
 */
export async function removeSiteMemberAction(
  siteId: string, 
  userId: string
): Promise<ActionResult> {
  const currentUser = await getCurrentUser()
  if (!currentUser) {
    return { error: 'Chưa đăng nhập' }
  }

  const supabase = await createClient()

  // Get member's role
  const { data: member } = await supabase
    .from('site_members')
    .select('role')
    .eq('site_id', siteId)
    .eq('user_id', userId)
    .single()

  if (!member) {
    return { error: 'Member không tồn tại' }
  }

  // Permission check
  const superAdmin = currentUser.role === 'super_admin'
  const siteAdmin = await isSiteAdmin(siteId)

  if (!superAdmin && !siteAdmin) {
    return { error: 'Bạn không có quyền xóa member' }
  }

  // Site admin can only remove editors/viewers, not other admins
  if (!superAdmin && member.role === 'admin') {
    return { error: 'Chỉ Super Admin mới có thể xóa Admin' }
  }

  // Delete member
  const { error: deleteError } = await supabase
    .from('site_members')
    .delete()
    .eq('site_id', siteId)
    .eq('user_id', userId)

  if (deleteError) {
    console.error('Delete member error:', deleteError)
    return { error: 'Không thể xóa member' }
  }

  revalidatePath(`/sites/${siteId}/members`)

  return { success: true }
}

/**
 * Update user's platform role (Super Admin only)
 */
export async function updateUserRoleAction(
  userId: string,
  newRole: 'super_admin' | 'admin' | 'editor'
): Promise<ActionResult> {
  const superAdmin = await isSuperAdmin()
  if (!superAdmin) {
    return { error: 'Chỉ Super Admin mới có thể thay đổi role' }
  }

  const supabase = await createClient()

  const { error } = await supabase
    .from('profiles')
    .update({ role: newRole })
    .eq('id', userId)

  if (error) {
    console.error('Update role error:', error)
    return { error: 'Không thể cập nhật role' }
  }

  revalidatePath('/users')

  return { success: true }
}

/**
 * Delete pending invitation
 */
export async function deleteInvitationAction(invitationId: string): Promise<ActionResult> {
  const currentUser = await getCurrentUser()
  if (!currentUser) {
    return { error: 'Chưa đăng nhập' }
  }

  const supabase = await createClient()

  // Get invitation to check permissions
  const { data: invitation } = await supabase
    .from('invitations')
    .select('site_id')
    .eq('id', invitationId)
    .single()

  if (!invitation) {
    return { error: 'Invitation không tồn tại' }
  }

  // Permission check
  const superAdmin = currentUser.role === 'super_admin'
  const siteAdmin = invitation.site_id ? await isSiteAdmin(invitation.site_id) : false

  if (!superAdmin && !siteAdmin) {
    return { error: 'Bạn không có quyền xóa invitation này' }
  }

  const { error } = await supabase
    .from('invitations')
    .delete()
    .eq('id', invitationId)

  if (error) {
    console.error('Delete invitation error:', error)
    return { error: 'Không thể xóa invitation' }
  }

  revalidatePath('/users')

  return { success: true }
}
