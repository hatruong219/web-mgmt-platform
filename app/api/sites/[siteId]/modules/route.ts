import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

export async function GET(
  _req: Request,
  { params }: { params: Promise<{ siteId: string }> }
) {
  const { siteId } = await params
  if (!siteId) {
    return NextResponse.json({ error: 'Missing siteId' }, { status: 400 })
  }

  const supabase = await createClient()

  // Auth check
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const { data, error } = await supabase
    .from('site_modules')
    .select('module_id, order_index, config, is_enabled, modules(id, name, icon, route_segment, category, is_system)')
    .eq('site_id', siteId)
    .eq('is_enabled', true)
    .order('order_index')

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }

  return NextResponse.json(data || [])
}
