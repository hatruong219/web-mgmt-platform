'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createSiteSchema, updateSiteSchema } from '@/lib/validations'
import { slugify } from '@/lib/utils'

export type ActionResult = {
  error?: string
  success?: boolean
}

export async function createSiteAction(formData: FormData): Promise<ActionResult> {
  const raw = {
    name: (formData.get('name') as string)?.trim(),
    description: (formData.get('description') as string)?.trim() || undefined,
    domain: (formData.get('domain') as string)?.trim() || undefined,
  }

  const parsed = createSiteSchema.safeParse(raw)
  if (!parsed.success) {
    return { error: parsed.error.issues[0].message }
  }

  const supabase = await createClient()
  const slug = slugify(parsed.data.name)

  const { error } = await supabase.from('sites').insert({
    name: parsed.data.name,
    slug,
    description: parsed.data.description || null,
    domain: parsed.data.domain || null,
  })

  if (error) {
    return { error: error.message }
  }

  revalidatePath('/')
  return { success: true }
}

export async function updateSiteAction(formData: FormData): Promise<ActionResult> {
  const raw = {
    id: formData.get('id') as string,
    name: (formData.get('name') as string)?.trim(),
    description: (formData.get('description') as string)?.trim() || undefined,
    domain: (formData.get('domain') as string)?.trim() || undefined,
  }

  const parsed = updateSiteSchema.safeParse(raw)
  if (!parsed.success) {
    return { error: parsed.error.issues[0].message }
  }

  const supabase = await createClient()
  const { error } = await supabase
    .from('sites')
    .update({
      name: parsed.data.name,
      description: parsed.data.description || null,
      domain: parsed.data.domain || null,
    })
    .eq('id', parsed.data.id)

  if (error) {
    return { error: error.message }
  }

  revalidatePath(`/sites/${parsed.data.id}`)
  revalidatePath(`/sites/${parsed.data.id}/settings`)
  revalidatePath('/')
  return { success: true }
}

export async function deleteSiteAction(siteId: string): Promise<ActionResult> {
  const supabase = await createClient()
  const { error } = await supabase.from('sites').delete().eq('id', siteId)

  if (error) {
    return { error: error.message }
  }

  revalidatePath('/')
  redirect('/')
}
