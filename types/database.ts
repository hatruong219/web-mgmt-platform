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

// Joined types
export interface ArticleWithSite extends Article {
  sites: Pick<Site, 'id' | 'name' | 'slug'>
}
