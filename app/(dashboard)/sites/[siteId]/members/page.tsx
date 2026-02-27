import { createClient } from '@/lib/supabase/server'
import { notFound, redirect } from 'next/navigation'
import { isSuperAdmin, canAccessSite, isSiteAdmin, getSiteRole } from '@/lib/permissions'
import type { Metadata } from 'next'
import type { SiteMemberWithProfile, InvitationWithSite } from '@/types/database'
import { UserAvatar } from '@/components/users/UserAvatar'
import { UserRoleBadge } from '@/components/users/UserRoleBadge'
import { AddMemberModal } from '@/components/members/AddMemberModal'
import { RemoveMemberButton } from '@/components/members/RemoveMemberButton'
import { CopyInviteLinkButton } from '@/components/users/CopyInviteLinkButton'
import { CancelInvitationButton } from '@/components/users/CancelInvitationButton'
import { formatDate } from '@/lib/utils'
import styles from './page.module.css'

export const metadata: Metadata = {
  title: 'Quản lý Members',
}

interface PageProps {
  params: Promise<{ siteId: string }>
}

export default async function SiteMembersPage({ params }: PageProps) {
  const { siteId } = await params
  const siteRole = await getSiteRole(siteId)
  if (!siteRole) notFound()

  // Editor/viewer cannot manage members
  if (siteRole !== 'admin') {
    redirect(`/sites/${siteId}/articles?forbidden=members`)
  }

  const supabase = await createClient()

  // Check access
  const hasAccess = await canAccessSite(siteId)
  if (!hasAccess) {
    notFound()
  }

  // Get site info
  const { data: site } = await supabase
    .from('sites')
    .select('id, name, slug')
    .eq('id', siteId)
    .single()

  if (!site) {
    notFound()
  }

  // Check if user can manage members
  const superAdmin = await isSuperAdmin()
  const siteAdmin = await isSiteAdmin(siteId)
  const canManage = superAdmin || siteAdmin
  
  // Fetch members and pending invitations
  const [membersResult, invitationsResult] = await Promise.all([
    supabase
      .from('site_members')
      .select(`
        id,
        role,
        invited_at,
        accepted_at,
        profiles:user_id (
          id,
          email,
          full_name,
          avatar_url,
          role
        )
      `)
      .eq('site_id', siteId)
      .order('invited_at', { ascending: false }),
    supabase
      .from('invitations')
      .select('*')
      .eq('site_id', siteId)
      .is('accepted_at', null)
      .order('created_at', { ascending: false }),
  ])

  const members = (membersResult.data || []) as unknown as SiteMemberWithProfile[]
  const invitations = (invitationsResult.data || []) as InvitationWithSite[]

  return (
    <div className={`${styles.page} animate-fade-in`}>
      <div className={styles.pageHeader}>
        <div>
          <h1 className={styles.pageTitle}>Members</h1>
          <p className={styles.pageSubtitle}>
            {members.length} thành viên · {invitations.length} lời mời đang chờ
          </p>
        </div>
        {canManage && (
          <AddMemberModal 
            siteId={siteId} 
            siteName={site.name}
            isSuperAdmin={superAdmin}
          />
        )}
      </div>

      {/* Pending Invitations */}
      {invitations.length > 0 && canManage && (
        <section className={styles.section}>
          <h2 className={styles.sectionTitle}>Lời mời đang chờ</h2>
          <div className={styles.invitationsList}>
            {invitations.map((invitation) => (
              <div key={invitation.id} className={`${styles.invitationCard} glass`}>
                <div className={styles.invitationInfo}>
                  <p className={styles.invitationEmail}>{invitation.email}</p>
                  <div className={styles.invitationMeta}>
                    <UserRoleBadge role={invitation.role} type="site" />
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
                    siteName={site.name}
                  />
                </div>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* Members List */}
      <section className={styles.section}>
        <h2 className={styles.sectionTitle}>Tất cả Members</h2>
        {members.length === 0 ? (
          <div className={`${styles.emptyState} glass`}>
            <div className={styles.emptyIcon}>
              <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                <circle cx="9" cy="7" r="4" />
                <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                <path d="M16 3.13a4 4 0 0 1 0 7.75" />
              </svg>
            </div>
            <h3 className={styles.emptyTitle}>Chưa có thành viên nào</h3>
            <p className={styles.emptyDesc}>Mời thành viên để cùng quản lý site này</p>
          </div>
        ) : (
          <div className={styles.membersTable}>
            <div className={styles.tableHeader}>
              <div className={styles.colUser}>Thành viên</div>
              <div className={styles.colRole}>Role</div>
              <div className={styles.colDate}>Ngày tham gia</div>
              <div className={styles.colActions}></div>
            </div>
            {members.map((member) => {
              const profile = member.profiles
              const canRemove = canManage && (
                superAdmin || 
                (siteAdmin && member.role !== 'admin')
              )

              return (
                <div key={member.id} className={styles.tableRow}>
                  <div className={styles.colUser}>
                    <UserAvatar
                      name={profile?.full_name}
                      email={profile?.email}
                      avatarUrl={profile?.avatar_url}
                      size="md"
                    />
                    <div className={styles.userInfo}>
                      <p className={styles.userName}>
                        {profile?.full_name || 'Chưa đặt tên'}
                      </p>
                      <p className={styles.userEmail}>{profile?.email}</p>
                    </div>
                  </div>
                  <div className={styles.colRole}>
                    <UserRoleBadge role={member.role} type="site" />
                  </div>
                  <div className={styles.colDate}>
                    {formatDate(member.accepted_at || member.invited_at)}
                  </div>
                  <div className={styles.colActions}>
                    {canRemove && profile && (
                      <RemoveMemberButton
                        siteId={siteId}
                        userId={profile.id}
                        userName={profile.full_name || profile.email}
                      />
                    )}
                  </div>
                </div>
              )
            })}
          </div>
        )}
      </section>
    </div>
  )
}
