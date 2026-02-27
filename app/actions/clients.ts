'use server'

import { createClient } from '@/lib/supabase/server'
import { isSiteAdmin } from '@/lib/permissions'

export type ActionResult = {
  error?: string
  success?: boolean
  data?: string
}

/**
 * Export clients to CSV
 */
export async function exportClientsCSV(siteId: string): Promise<ActionResult> {
  // Permission check: only admin can export
  const isAdmin = await isSiteAdmin(siteId)
  if (!isAdmin) {
    return { error: 'Chỉ Admin mới có quyền export clients' }
  }

  const supabase = await createClient()

  const { data: clients, error } = await supabase
    .from('site_clients')
    .select('*')
    .eq('site_id', siteId)
    .order('created_at', { ascending: false })

  if (error) {
    return { error: error.message }
  }

  if (!clients || clients.length === 0) {
    return { error: 'Không có client nào để export' }
  }

  // Generate CSV
  const headers = [
    'ID',
    'Email',
    'Full Name',
    'Phone',
    'Provider',
    'Status',
    'Verified',
    'Login Count',
    'Last Login',
    'Created At',
  ]

  const rows = clients.map(client => [
    client.id,
    client.email,
    client.full_name || '',
    client.phone || '',
    client.provider,
    client.is_active ? 'Active' : 'Inactive',
    client.is_verified ? 'Yes' : 'No',
    client.login_count.toString(),
    client.last_login || '',
    client.created_at,
  ])

  const csvContent = [
    headers.join(','),
    ...rows.map(row => row.map(cell => `"${String(cell).replace(/"/g, '""')}"`).join(',')),
  ].join('\n')

  return { success: true, data: csvContent }
}

/**
 * Toggle client active status
 */
export async function toggleClientStatusAction(
  clientId: string, 
  siteId: string,
  isActive: boolean
): Promise<ActionResult> {
  // Permission check
  const isAdmin = await isSiteAdmin(siteId)
  if (!isAdmin) {
    return { error: 'Chỉ Admin mới có quyền thay đổi trạng thái client' }
  }

  const supabase = await createClient()

  const { error } = await supabase
    .from('site_clients')
    .update({ is_active: isActive })
    .eq('id', clientId)
    .eq('site_id', siteId)

  if (error) {
    return { error: error.message }
  }

  return { success: true }
}
