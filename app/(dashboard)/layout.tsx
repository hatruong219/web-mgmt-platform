import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Sidebar from '@/components/layout/Sidebar'
import type { Site } from '@/types/database'

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) redirect('/login')

  const { data: sites } = await supabase
    .from('sites')
    .select('id, name, slug, domain, status')
    .order('created_at', { ascending: true })

  return (
    <div style={{ display: 'flex', minHeight: '100vh' }}>
      <Sidebar user={user} sites={(sites as Site[]) ?? []} />
      <main style={{
        flex: 1,
        marginLeft: 260,
        minHeight: '100vh',
        overflowY: 'auto' as const,
      }}>
        <div style={{ padding: '2rem', maxWidth: 1280 }}>
          {children}
        </div>
      </main>
    </div>
  )
}
