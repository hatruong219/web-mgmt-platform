'use server'

import { createClient } from '@/lib/supabase/server'
import { isSiteAdmin, getSiteRole } from '@/lib/permissions'
import { revalidatePath } from 'next/cache'
import type { FeedbackStatus } from '@/types/database'

export type ActionResult<T = undefined> = {
  error?: string
  success?: boolean
  data?: T
}

/**
 * Update feedback status
 */
export async function updateFeedbackStatusAction(
  feedbackId: string,
  siteId: string,
  status: FeedbackStatus,
): Promise<ActionResult> {
  const role = await getSiteRole(siteId)
  if (!role) return { error: 'Không có quyền truy cập' }

  const supabase = await createClient()

  const { error } = await supabase
    .from('feedbacks')
    .update({ status })
    .eq('id', feedbackId)
    .eq('site_id', siteId)

  if (error) return { error: error.message }

  revalidatePath(`/sites/${siteId}/feedbacks`)
  return { success: true }
}

/**
 * Delete a feedback (admin only)
 */
export async function deleteFeedbackAction(
  feedbackId: string,
  siteId: string,
): Promise<ActionResult> {
  const isAdmin = await isSiteAdmin(siteId)
  if (!isAdmin) return { error: 'Chỉ Admin mới có quyền xoá feedback' }

  const supabase = await createClient()

  const { error } = await supabase
    .from('feedbacks')
    .delete()
    .eq('id', feedbackId)
    .eq('site_id', siteId)

  if (error) return { error: error.message }

  revalidatePath(`/sites/${siteId}/feedbacks`)
  return { success: true }
}

/**
 * Export feedbacks to CSV
 */
export async function exportFeedbacksCSV(siteId: string): Promise<ActionResult<string>> {
  const isAdmin = await isSiteAdmin(siteId)
  if (!isAdmin) return { error: 'Chỉ Admin mới có quyền export feedbacks' }

  const supabase = await createClient()

  const { data: feedbacks, error } = await supabase
    .from('feedbacks')
    .select('*')
    .eq('site_id', siteId)
    .order('created_at', { ascending: false })

  if (error) return { error: error.message }
  if (!feedbacks || feedbacks.length === 0) {
    return { error: 'Không có feedback nào để export' }
  }

  const headers = ['ID', 'Name', 'Email', 'Message', 'Rating', 'Status', 'Created At']
  const rows = feedbacks.map(f => [
    f.id,
    f.name,
    f.email || '',
    f.message,
    f.rating !== null ? String(f.rating) : '',
    f.status,
    f.created_at,
  ])

  const csvContent = [
    headers.join(','),
    ...rows.map(row =>
      row.map(cell => `"${String(cell).replace(/"/g, '""')}"`).join(','),
    ),
  ].join('\n')

  return { success: true, data: csvContent }
}
