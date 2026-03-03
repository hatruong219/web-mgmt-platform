'use server'

import { createAdminClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'

// VARCHAR(5) safe — map 'jlpt-n5' → 'N5', 'jlpt-n4' → 'N4', etc.
function sanitizeJlpt(raw: string | null | undefined): string | null {
  if (!raw) return null
  const s = raw.trim().toUpperCase()
  // Handle patterns like 'JLPT-N5', 'JLPT N5', 'N5'
  const match = s.match(/N[1-5]/)
  return match ? match[0] : s.slice(0, 5)
}

// ─── VOCABULARY WORDS ─────────────────────────────────────────────────────────


export async function createVocabWord(formData: FormData) {
  const supabase = createAdminClient()
  const siteId = formData.get('site_id') as string
  const word = formData.get('word') as string
  const slugBase = word.toLowerCase().replace(/[^a-z0-9ぁ-ん一-龠ァ-ヴー]/g, '-').slice(0, 50)

  const { error } = await supabase.from('vocabulary').insert({
    site_id:       siteId,
    deck_id:       formData.get('deck_id') as string,
    language_code: (formData.get('language_code') as string) || 'ja',
    word,
    reading:       (formData.get('reading') as string) || null,
    romanization:  (formData.get('romanization') as string) || null,
    meaning_vi:    formData.get('meaning_vi') as string,
    meaning_en:    (formData.get('meaning_en') as string) || null,
    part_of_speech:(formData.get('part_of_speech') as string) || null,
    jlpt_level:    (formData.get('jlpt_level') as string) || null,
    tags:          (formData.get('tags') as string)?.split(',').map(t => t.trim()).filter(Boolean) || [],
    is_active:     true,
  })
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/vocabulary`)
  return { success: true }
}

export async function updateVocabWord(id: string, siteId: string, formData: FormData) {
  const supabase = createAdminClient()
  const { error } = await supabase.from('vocabulary').update({
    deck_id:       formData.get('deck_id') as string,
    language_code: (formData.get('language_code') as string) || 'ja',
    word:          formData.get('word') as string,
    reading:       (formData.get('reading') as string) || null,
    romanization:  (formData.get('romanization') as string) || null,
    meaning_vi:    formData.get('meaning_vi') as string,
    meaning_en:    (formData.get('meaning_en') as string) || null,
    part_of_speech:(formData.get('part_of_speech') as string) || null,
    jlpt_level:    (formData.get('jlpt_level') as string) || null,
    tags:          (formData.get('tags') as string)?.split(',').map(t => t.trim()).filter(Boolean) || [],
    updated_at:    new Date().toISOString(),
  }).eq('id', id).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/vocabulary`)
  return { success: true }
}

export async function deleteVocabWord(id: string, siteId: string) {
  const supabase = createAdminClient()
  const { error } = await supabase.from('vocabulary').delete().eq('id', id).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/vocabulary`)
  return { success: true }
}

export async function toggleVocabActive(id: string, siteId: string, isActive: boolean) {
  const supabase = createAdminClient()
  const { error } = await supabase.from('vocabulary').update({ is_active: isActive }).eq('id', id).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/vocabulary`)
  return { success: true }
}

export async function bulkImportVocab(siteId: string, deckId: string, rows: Array<{
  word: string; reading?: string; romanization?: string
  meaning_vi: string; meaning_en?: string
  part_of_speech?: string; jlpt_level?: string; tags?: string
}>) {
  const supabase = createAdminClient()
  const data = rows.map((r, i) => ({
    site_id:       siteId,
    deck_id:       deckId,
    language_code: 'ja',
    word:          r.word,
    reading:       r.reading || null,
    romanization:  r.romanization || null,
    meaning_vi:    r.meaning_vi,
    meaning_en:    r.meaning_en || null,
    part_of_speech:r.part_of_speech || null,
    jlpt_level:    sanitizeJlpt(r.jlpt_level),
    tags:          r.tags?.split(',').map(t => t.trim()).filter(Boolean) || [],
    order_index:   i,
    is_active:     true,
  }))
  const { error, data: inserted } = await supabase.from('vocabulary').insert(data).select('id')
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/vocabulary`)
  return { success: true, count: inserted?.length ?? 0 }
}

// ─── DECKS ────────────────────────────────────────────────────────────────────

export async function createDeck(formData: FormData) {
  const supabase = createAdminClient()
  const siteId = formData.get('site_id') as string
  const name = formData.get('name') as string
  const slug = name.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]/g, '-').replace(/-+/g, '-').slice(0, 80)

  const { error } = await supabase.from('decks').insert({
    site_id:       siteId,
    name,
    slug:          `${slug}-${Date.now().toString(36)}`,
    description:   (formData.get('description') as string) || null,
    language_code: (formData.get('language_code') as string) || 'ja',
    emoji:         (formData.get('emoji') as string) || '📚',
    is_public:     formData.get('is_public') === 'true',
    order_index:   parseInt(formData.get('order_index') as string) || 0,
  })
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/decks`)
  return { success: true }
}

export async function updateDeck(id: string, siteId: string, formData: FormData) {
  const supabase = createAdminClient()
  const { error } = await supabase.from('decks').update({
    name:          formData.get('name') as string,
    description:   (formData.get('description') as string) || null,
    language_code: (formData.get('language_code') as string) || 'ja',
    emoji:         (formData.get('emoji') as string) || '📚',
    is_public:     formData.get('is_public') === 'true',
    updated_at:    new Date().toISOString(),
  }).eq('id', id).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/decks`)
  return { success: true }
}

export async function deleteDeck(id: string, siteId: string) {
  const supabase = createAdminClient()
  const { error } = await supabase.from('decks').delete().eq('id', id).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/decks`)
  return { success: true }
}
