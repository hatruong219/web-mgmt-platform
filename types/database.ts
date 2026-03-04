export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Site {
  id: string
  name: string
  slug: string
  domain: string | null
  description: string | null
  status: 'active' | 'archived'
  metadata: Json
  created_at: string
  updated_at: string
}

export interface Article {
  id: string
  site_id: string
  title: string
  slug: string
  content: string | null
  excerpt: string | null
  cover_image: string | null
  status: 'draft' | 'published' | 'archived'
  tags: string[]
  metadata: Json
  published_at: string | null
  created_at: string
  updated_at: string
}

export interface MediaFile {
  id: string
  site_id: string | null
  filename: string
  url: string
  mime_type: string | null
  size: number | null
  created_at: string
}

// ─── User Management Types ─────────────────────────────────────────────────

export type PlatformRole = 'super_admin' | 'admin' | 'editor'
export type SiteRole = 'admin' | 'editor' | 'viewer'

export interface Profile {
  id: string
  email: string
  full_name: string | null
  avatar_url: string | null
  role: PlatformRole
  is_active: boolean
  metadata: Json
  created_at: string
  updated_at: string
}

export interface SiteMember {
  id: string
  site_id: string
  user_id: string
  role: SiteRole
  invited_by: string | null
  invited_at: string
  accepted_at: string | null
}

export interface Invitation {
  id: string
  email: string
  site_id: string | null
  role: SiteRole
  token: string
  invited_by: string | null
  expires_at: string
  accepted_at: string | null
  created_at: string
}

// ─── Joined Types ──────────────────────────────────────────────────────────

export interface ArticleWithSite extends Article {
  sites: Pick<Site, 'id' | 'name' | 'slug'>
}

export interface SiteMemberWithProfile extends SiteMember {
  profiles: Pick<Profile, 'id' | 'email' | 'full_name' | 'avatar_url' | 'role'> | null
}

export interface SiteMemberWithSite extends SiteMember {
  sites: Pick<Site, 'id' | 'name' | 'slug'>
}

export interface InvitationWithSite extends Invitation {
  sites: Pick<Site, 'id' | 'name' | 'slug'> | null
  inviter?: Pick<Profile, 'id' | 'email' | 'full_name'>
}

// ─── Site Clients Types ───────────────────────────────────────────────────

export type AuthProvider = 'email' | 'google' | 'facebook' | 'github' | 'apple'

export interface SiteClient {
  id: string
  site_id: string
  external_id: string | null
  provider: AuthProvider
  email: string
  full_name: string | null
  avatar_url: string | null
  phone: string | null
  is_active: boolean
  is_verified: boolean
  metadata: Json
  last_login: string | null
  login_count: number
  created_at: string
  updated_at: string
}

// ─── Feedback Types ───────────────────────────────────────────────────────

export type FeedbackStatus = 'pending' | 'reviewed' | 'archived'

export interface Feedback {
  id: string
  site_id: string
  name: string
  email: string | null
  message: string
  rating: number | null
  image: string | null
  status: FeedbackStatus
  metadata: Json
  created_at: string
  updated_at: string
}
