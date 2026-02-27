import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import { isSuperAdmin } from '@/lib/permissions'
import type { Metadata } from 'next'
import type { Profile, Invitation, Site } from '@/types/database'
import { UserAvatar } from '@/components/users/UserAvatar'
import { UserRoleBadge } from '@/components/users/UserRoleBadge'
import { InviteUserModal } from '@/components/users/InviteUserModal'
import { CopyInviteLinkButton } from '@/components/users/CopyInviteLinkButton'
import { CancelInvitationButton } from '@/components/users/CancelInvitationButton'
import { DeleteUserButton } from '@/components/users/DeleteUserButton'
import { formatDate } from '@/lib/utils'
import styles from './page.module.css'

export const metadata: Metadata = {
  title: 'Quản lý Users',
}

export default async function UsersPage() {
  // Only Super Admin can access this page
  const superAdmin = await isSuperAdmin()
  if (!superAdmin) {
    redirect('/')
  }

  const supabase = await createClient()

  // Fetch all users and pending invitations
  const [usersResult, invitationsResult, sitesResult] = await Promise.all([
    supabase
      .from('profiles')
      .select('*')
      .order('created_at', { ascending: false }),
    supabase
      .from('invitations')
      .select(`
        *,
        sites (id, name, slug)
      `)
      .is('accepted_at', null)
      .order('created_at', { ascending: false }),
    supabase
      .from('sites')
      .select('id, name, slug')
      .eq('status', 'active')
      .order('name'),
  ])

  const users = (usersResult.data || []) as Profile[]
  const invitations = (invitationsResult.data || []) as (Invitation & { sites: Pick<Site, 'id' | 'name' | 'slug'> | null })[]
  const sites = (sitesResult.data || []) as Pick<Site, 'id' | 'name' | 'slug'>[]

  return (
    <div className={`${styles.page} animate-fade-in`}>
      <div className={styles.pageHeader}>
        <div>
          <h1 className={styles.pageTitle}>Quản lý Users</h1>
          <p className={styles.pageSubtitle}>
            {users.length} users · {invitations.length} lời mời đang chờ
          </p>
        </div>
        <InviteUserModal sites={sites} />
      </div>

      {/* Pending Invitations */}
      {invitations.length > 0 && (
        <section className={styles.section}>
          <h2 className={styles.sectionTitle}>Lời mời đang chờ</h2>
          <div className={styles.invitationsList}>
            {invitations.map((invitation) => (
              <div key={invitation.id} className={`${styles.invitationCard} glass`}>
                <div className={styles.invitationInfo}>
                  <p className={styles.invitationEmail}>{invitation.email}</p>
                  <div className={styles.invitationMeta}>
                    <UserRoleBadge role={invitation.role} />
                    {invitation.sites && (
                      <span className={styles.invitationSite}>
                        → {invitation.sites.name}
                      </span>
                    )}
                    <span className={styles.invitationDate}>
                      Hết hạn: {formatDate(invitation.expires_at)}
                    </span>
                  </div>
                </div>
                <div className={styles.invitationActions}>
                  <CopyInviteLinkButton token={invitation.token} />
                  <CancelInvitationButton
                    invitationId={invitation.id}
                    email={invitation.email}
                    siteName={invitation.sites?.name ?? null}
                  />
                </div>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* Users List */}
      <section className={styles.section}>
        <h2 className={styles.sectionTitle}>Tất cả Users</h2>
        <div className={styles.usersTable}>
          <div className={styles.tableHeader}>
            <div className={styles.colUser}>User</div>
            <div className={styles.colRole}>Role</div>
            <div className={styles.colStatus}>Trạng thái</div>
            <div className={styles.colDate}>Ngày tạo</div>
            <div className={styles.colActions}></div>
          </div>
          {users.map((user) => (
            <div key={user.id} className={styles.tableRow}>
              <div className={styles.colUser}>
                <UserAvatar
                  name={user.full_name}
                  email={user.email}
                  avatarUrl={user.avatar_url}
                  size="md"
                />
                <div className={styles.userInfo}>
                  <p className={styles.userName}>{user.full_name || 'Chưa đặt tên'}</p>
                  <p className={styles.userEmail}>{user.email}</p>
                </div>
              </div>
              <div className={styles.colRole}>
                <UserRoleBadge role={user.role} />
              </div>
              <div className={styles.colStatus}>
                <span className={`${styles.statusBadge} ${user.is_active ? styles.statusActive : styles.statusInactive}`}>
                  {user.is_active ? 'Active' : 'Inactive'}
                </span>
              </div>
              <div className={styles.colDate}>
                {formatDate(user.created_at)}
              </div>
              <div className={styles.colActions}>
                {/* Future: add "assign to site" action beside delete */}
                <DeleteUserButton
                  userId={user.id}
                  userName={user.full_name}
                  userEmail={user.email}
                  role={user.role}
                />
              </div>
            </div>
          ))}
        </div>
      </section>
    </div>
  )
}
