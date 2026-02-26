'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createArticleSchema, updateArticleSchema } from '@/lib/validations'
import { slugify } from '@/lib/utils'

export type ActionResult = {
  error?: string
  success?: boolean
  data?: { id: string }
}

export async function createArticleAction(
  siteId: string,
  title: string,
  content: string,
  excerpt: string,
  coverImage: string,
  tags: string[],
  status: 'draft' | 'published' | 'archived'
): Promise<ActionResult> {
  const slug = slugify(title || 'untitled')

  const parsed = createArticleSchema.safeParse({
    site_id: siteId,
    title: title || 'Untitled',
    slug,
    content,
    excerpt: excerpt || undefined,
    cover_image: coverImage || undefined,
    tags,
    status,
  })

  if (!parsed.success) {
    return { error: parsed.error.issues[0].message }
  }

  const supabase = await createClient()
  const { data, error } = await supabase
    .from('articles')
    .insert({
      ...parsed.data,
      excerpt: parsed.data.excerpt || null,
      cover_image: parsed.data.cover_image || null,
      published_at: status === 'published' ? new Date().toISOString() : null,
    })
    .select('id')
    .single()

  if (error) {
    return { error: error.message }
  }

  revalidatePath(`/sites/${siteId}/articles`)
  revalidatePath(`/sites/${siteId}`)
  return { success: true, data: { id: data.id } }
}

export async function updateArticleAction(
  articleId: string,
  siteId: string,
  title: string,
  content: string,
  excerpt: string,
  coverImage: string,
  tags: string[],
  status: 'draft' | 'published' | 'archived',
  existingPublishedAt: string | null
): Promise<ActionResult> {
  const slug = slugify(title || 'untitled')

  const parsed = updateArticleSchema.safeParse({
    id: articleId,
    site_id: siteId,
    title: title || 'Untitled',
    slug,
    content,
    excerpt: excerpt || undefined,
    cover_image: coverImage || undefined,
    tags,
    status,
  })

  if (!parsed.success) {
    return { error: parsed.error.issues[0].message }
  }

  const supabase = await createClient()
  const { error } = await supabase
    .from('articles')
    .update({
      title: parsed.data.title,
      slug: parsed.data.slug,
      content: parsed.data.content,
      excerpt: parsed.data.excerpt || null,
      cover_image: parsed.data.cover_image || null,
      tags: parsed.data.tags,
      status: parsed.data.status,
      published_at: status === 'published'
        ? existingPublishedAt || new Date().toISOString()
        : existingPublishedAt,
    })
    .eq('id', articleId)

  if (error) {
    return { error: error.message }
  }

  revalidatePath(`/sites/${siteId}/articles`)
  revalidatePath(`/sites/${siteId}/articles/${articleId}`)
  revalidatePath(`/sites/${siteId}`)
  return { success: true }
}

export async function deleteArticleAction(articleId: string, siteId: string): Promise<ActionResult> {
  const supabase = await createClient()
  const { error } = await supabase.from('articles').delete().eq('id', articleId)

  if (error) {
    return { error: error.message }
  }

  revalidatePath(`/sites/${siteId}/articles`)
  revalidatePath(`/sites/${siteId}`)
  revalidatePath('/')
  return { success: true }
}
