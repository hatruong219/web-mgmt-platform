'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'
import { STORAGE_BUCKET } from '@/lib/utils'

export type ActionResult = {
  error?: string
  success?: boolean
}

export async function deleteMediaAction(mediaId: string, mediaUrl: string, siteId: string): Promise<ActionResult> {
  const supabase = await createClient()

  // Delete from storage
  const path = mediaUrl.split(`/${STORAGE_BUCKET}/`)[1]
  if (path) {
    await supabase.storage.from(STORAGE_BUCKET).remove([decodeURIComponent(path)])
  }

  // Delete from DB
  const { error } = await supabase.from('media').delete().eq('id', mediaId)

  if (error) {
    return { error: error.message }
  }

  revalidatePath(`/sites/${siteId}/media`)
  return { success: true }
}
