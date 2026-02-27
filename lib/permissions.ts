import { createClient } from '@/lib/supabase/server'

export type PlatformRole = 'super_admin' | 'admin' | 'editor'
export type SiteRole = 'admin' | 'editor' | 'viewer'

export interface UserProfile {
  id: string
  email: string
  full_name: string | null
  avatar_url: string | null
  role: PlatformRole
  is_active: boolean
}

export interface SiteMembership {
  site_id: string
  role: SiteRole
  site_name?: string
  site_slug?: string
}

/**
 * Get current user's profile with platform role
 */
export async function getCurrentUser(): Promise<UserProfile | null> {
  const supabase = await createClient()
  
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return null

  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .single()

  if (!profile) return null

  return {
    id: profile.id,
    email: profile.email,
    full_name: profile.full_name,
    avatar_url: profile.avatar_url,
    role: profile.role as PlatformRole,
    is_active: profile.is_active,
  }
}

/**
 * Check if current user is Super Admin
 */
export async function isSuperAdmin(): Promise<boolean> {
  const user = await getCurrentUser()
  return user?.role === 'super_admin'
}

/**
 * Get user's role for a specific site
 */
export async function getSiteRole(siteId: string): Promise<SiteRole | null> {
  const supabase = await createClient()
  
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return null

  // Super admin has full access to all sites
  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()

  if (profile?.role === 'super_admin') {
    return 'admin' // Super admin acts as admin on all sites
  }

  // Check site membership
  const { data: membership } = await supabase
    .from('site_members')
    .select('role')
    .eq('site_id', siteId)
    .eq('user_id', user.id)
    .single()

  return membership?.role as SiteRole | null
}

/**
 * Check if user can access a specific site
 */
export async function canAccessSite(siteId: string): Promise<boolean> {
  const role = await getSiteRole(siteId)
  return role !== null
}

/**
 * Check if user can edit content (articles, media) on a site
 */
export async function canEditSite(siteId: string): Promise<boolean> {
  const role = await getSiteRole(siteId)
  return role === 'admin' || role === 'editor'
}

/**
 * Check if user is admin of a specific site
 */
export async function isSiteAdmin(siteId: string): Promise<boolean> {
  const role = await getSiteRole(siteId)
  return role === 'admin'
}

/**
 * Check if user can invite members to a site
 * - Super Admin: can invite admins to any site
 * - Site Admin: can invite editors to their site
 */
export async function canInviteToSite(siteId: string, targetRole: SiteRole): Promise<boolean> {
  const user = await getCurrentUser()
  if (!user) return false

  // Super admin can invite anyone (including admins)
  if (user.role === 'super_admin') {
    return true
  }

  // Site admin can only invite editors/viewers (not other admins)
  if (targetRole === 'admin') {
    return false
  }

  const siteRole = await getSiteRole(siteId)
  return siteRole === 'admin'
}

/**
 * Check if user can remove a member from a site
 * - Super Admin: can remove anyone
 * - Site Admin: can remove editors/viewers (not other admins)
 */
export async function canRemoveMember(siteId: string, memberRole: SiteRole): Promise<boolean> {
  const user = await getCurrentUser()
  if (!user) return false

  // Super admin can remove anyone
  if (user.role === 'super_admin') {
    return true
  }

  // Site admin can only remove editors/viewers
  if (memberRole === 'admin') {
    return false
  }

  const siteRole = await getSiteRole(siteId)
  return siteRole === 'admin'
}

/**
 * Get all sites the current user has access to
 */
export async function getUserSites(): Promise<SiteMembership[]> {
  const supabase = await createClient()
  
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return []

  // Check if super admin
  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()

  if (profile?.role === 'super_admin') {
    // Super admin can access all sites
    const { data: sites } = await supabase
      .from('sites')
      .select('id, name, slug')
      .order('created_at', { ascending: true })

    return (sites || []).map(site => ({
      site_id: site.id,
      role: 'admin' as SiteRole,
      site_name: site.name,
      site_slug: site.slug,
    }))
  }

  // Regular users: get their site memberships
  const { data: memberships } = await supabase
    .from('site_members')
    .select(`
      site_id,
      role,
      sites (name, slug)
    `)
    .eq('user_id', user.id)

  return (memberships || []).map(m => ({
    site_id: m.site_id,
    role: m.role as SiteRole,
    site_name: (m.sites as { name: string } | null)?.name,
    site_slug: (m.sites as { slug: string } | null)?.slug,
  }))
}

/**
 * Permission check result with reason
 */
export interface PermissionResult {
  allowed: boolean
  reason?: string
}

/**
 * Check permission with detailed reason
 */
export async function checkPermission(
  action: 'view' | 'edit' | 'delete' | 'invite' | 'manage',
  resource: 'site' | 'article' | 'media' | 'member',
  siteId?: string
): Promise<PermissionResult> {
  const user = await getCurrentUser()
  
  if (!user) {
    return { allowed: false, reason: 'Not authenticated' }
  }

  if (!user.is_active) {
    return { allowed: false, reason: 'Account is deactivated' }
  }

  // Super admin can do everything
  if (user.role === 'super_admin') {
    return { allowed: true }
  }

  // For site-specific resources, check site membership
  if (siteId) {
    const siteRole = await getSiteRole(siteId)
    
    if (!siteRole) {
      return { allowed: false, reason: 'No access to this site' }
    }

    switch (action) {
      case 'view':
        return { allowed: true }
      
      case 'edit':
        if (siteRole === 'viewer') {
          return { allowed: false, reason: 'Viewers cannot edit content' }
        }
        return { allowed: true }
      
      case 'delete':
        if (siteRole !== 'admin') {
          return { allowed: false, reason: 'Only site admins can delete' }
        }
        return { allowed: true }
      
      case 'invite':
      case 'manage':
        if (siteRole !== 'admin') {
          return { allowed: false, reason: 'Only site admins can manage members' }
        }
        return { allowed: true }
    }
  }

  return { allowed: false, reason: 'Permission denied' }
}
