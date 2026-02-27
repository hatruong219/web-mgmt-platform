'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'
import { STORAGE_BUCKET } from '@/lib/utils'
import { isSiteAdmin } from '@/lib/permissions'

export type ActionResult = {
  error?: string
  success?: boolean
}

export async function deleteMediaAction(mediaId: string, mediaUrl: string, siteId: string): Promise<ActionResult> {
  // Permission check: only admin can delete
  const isAdmin = await isSiteAdmin(siteId)
  if (!isAdmin) {
    return { error: 'Chỉ Admin mới có quyền xóa media' }
  }

  const supabase = await createClient()

  // Hướng B: Chỉ xóa record trong DB, GIỮ file trong Storage bucket
  // → Bài viết đang dùng ảnh này sẽ không bị vỡ ảnh
  // → File vẫn accessible qua public URL
  const { error } = await supabase.from('media').delete().eq('id', mediaId)

  if (error) {
    return { error: error.message }
  }

  revalidatePath(`/sites/${siteId}/media`)
  return { success: true }
}

/**
 * Xóa vĩnh viễn: xóa cả file trong Storage bucket + DB record
 * Dùng khi chắc chắn muốn xóa hẳn (ví dụ: cleanup orphaned files)
 */
export async function hardDeleteMediaAction(mediaId: string, mediaUrl: string, siteId: string): Promise<ActionResult> {
  // Permission check: only admin can delete
  const isAdmin = await isSiteAdmin(siteId)
  if (!isAdmin) {
    return { error: 'Chỉ Admin mới có quyền xóa media' }
  }

  const supabase = await createClient()

  // Xóa file khỏi Storage bucket
  const path = mediaUrl.split(`/${STORAGE_BUCKET}/`)[1]
  if (path) {
    await supabase.storage.from(STORAGE_BUCKET).remove([decodeURIComponent(path)])
  }

  // Xóa record khỏi DB
  const { error } = await supabase.from('media').delete().eq('id', mediaId)

  if (error) {
    return { error: error.message }
  }

  revalidatePath(`/sites/${siteId}/media`)
  return { success: true }
}
