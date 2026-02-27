import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Sidebar from '@/components/layout/Sidebar'
import type { Site, Profile, PlatformRole } from '@/types/database'

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const supabase = await createClient()

  // Middleware đã verify auth bằng getUser(), ở đây chỉ cần đọc session từ cookie (không network call)
  // Chạy song song với query sites và profile
  const [sessionResult, sitesResult] = await Promise.all([
    supabase.auth.getSession(),
    supabase.from('sites').select('id, name, slug, domain, status').order('created_at', { ascending: true }),
  ])

  const user = sessionResult.data.session?.user
  if (!user) redirect('/login')

  // Fetch user profile for role
  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()

  const sites = sitesResult.data
  const userRole = (profile?.role as PlatformRole) || 'editor'

  return (
    <div className="dashboard-layout">
      <Sidebar user={user} sites={(sites as Site[]) ?? []} userRole={userRole} />
      <main className="dashboard-main">
        <div className="dashboard-content">
          {children}
        </div>
      </main>
    </div>
  )
}
