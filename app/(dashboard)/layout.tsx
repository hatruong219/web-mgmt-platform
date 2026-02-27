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

  // Middleware đã verify auth bằng getUser(), ở đây chỉ cần đọc session từ cookie (không network call)
  // Chạy song song với query sites
  const [sessionResult, sitesResult] = await Promise.all([
    supabase.auth.getSession(),
    supabase.from('sites').select('id, name, slug, domain, status').order('created_at', { ascending: true }),
  ])

  const user = sessionResult.data.session?.user
  if (!user) redirect('/login')

  const sites = sitesResult.data

  return (
    <div className="dashboard-layout">
      <Sidebar user={user} sites={(sites as Site[]) ?? []} />
      <main className="dashboard-main">
        <div className="dashboard-content">
          {children}
        </div>
      </main>
    </div>
  )
}
