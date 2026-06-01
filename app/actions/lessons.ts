'use server'

import { createAdminClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'

type ActionResult = { error?: string; success?: boolean }

// ─── LESSONS ─────────────────────────────────────────────────────────────────

export async function createLesson(siteId: string, data: {
  lesson_number: number
  title_vi: string
  situation_vi: string | null
  order_index: number
}): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_lessons').insert({ site_id: siteId, ...data })
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  return { success: true }
}

export async function updateLesson(id: string, siteId: string, data: {
  lesson_number: number
  title_vi: string
  situation_vi: string | null
  order_index: number
}): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_lessons').update(data).eq('id', id).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  return { success: true }
}

export async function deleteLesson(id: string, siteId: string): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_lessons').delete().eq('id', id).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  return { success: true }
}

// ─── MNN VOCABULARY ───────────────────────────────────────────────────────────

export async function createMnnVocab(lessonId: string, siteId: string, data: {
  word: string
  reading: string | null
  romanization: string | null
  meaning_vi: string
  part_of_speech: string | null
  order_index: number
}): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_vocabulary').insert({ lesson_id: lessonId, site_id: siteId, ...data })
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  revalidatePath(`/sites/${siteId}/lessons/${lessonId}`)
  return { success: true }
}

export async function updateMnnVocab(id: string, lessonId: string, siteId: string, data: {
  word: string
  reading: string | null
  romanization: string | null
  meaning_vi: string
  part_of_speech: string | null
  order_index: number
}): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_vocabulary').update(data).eq('id', id).eq('lesson_id', lessonId).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  revalidatePath(`/sites/${siteId}/lessons/${lessonId}`)
  return { success: true }
}

export async function deleteMnnVocab(id: string, lessonId: string, siteId: string): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_vocabulary').delete().eq('id', id).eq('lesson_id', lessonId).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  revalidatePath(`/sites/${siteId}/lessons/${lessonId}`)
  return { success: true }
}

// ─── MNN GRAMMAR ──────────────────────────────────────────────────────────────

export async function createMnnGrammar(lessonId: string, siteId: string, data: {
  pattern: string
  explanation_vi: string
  example_ja: string | null
  example_vi: string | null
  order_index: number
}): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_grammar').insert({ lesson_id: lessonId, site_id: siteId, ...data })
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  revalidatePath(`/sites/${siteId}/lessons/${lessonId}`)
  return { success: true }
}

export async function updateMnnGrammar(id: string, lessonId: string, siteId: string, data: {
  pattern: string
  explanation_vi: string
  example_ja: string | null
  example_vi: string | null
  order_index: number
}): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_grammar').update(data).eq('id', id).eq('lesson_id', lessonId).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  revalidatePath(`/sites/${siteId}/lessons/${lessonId}`)
  return { success: true }
}

export async function deleteMnnGrammar(id: string, lessonId: string, siteId: string): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_grammar').delete().eq('id', id).eq('lesson_id', lessonId).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  revalidatePath(`/sites/${siteId}/lessons/${lessonId}`)
  return { success: true }
}

// ─── MNN EXERCISES ────────────────────────────────────────────────────────────

export async function createMnnExercise(lessonId: string, siteId: string, data: {
  type: 'fill_blank' | 'multiple_choice'
  question: string
  options: string[] | null
  answer: string
  explanation_vi: string | null
  order_index: number
}): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_exercises').insert({
    lesson_id: lessonId,
    site_id: siteId,
    ...data,
    options: data.type === 'multiple_choice' ? data.options : null,
  })
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  revalidatePath(`/sites/${siteId}/lessons/${lessonId}`)
  return { success: true }
}

export async function updateMnnExercise(id: string, lessonId: string, siteId: string, data: {
  type: 'fill_blank' | 'multiple_choice'
  question: string
  options: string[] | null
  answer: string
  explanation_vi: string | null
  order_index: number
}): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_exercises').update({
    ...data,
    options: data.type === 'multiple_choice' ? data.options : null,
  }).eq('id', id).eq('lesson_id', lessonId).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  revalidatePath(`/sites/${siteId}/lessons/${lessonId}`)
  return { success: true }
}

export async function deleteMnnExercise(id: string, lessonId: string, siteId: string): Promise<ActionResult> {
  const supabase = createAdminClient()
  const { error } = await supabase.from('mnn_exercises').delete().eq('id', id).eq('lesson_id', lessonId).eq('site_id', siteId)
  if (error) return { error: error.message }
  revalidatePath(`/sites/${siteId}/lessons`)
  revalidatePath(`/sites/${siteId}/lessons/${lessonId}`)
  return { success: true }
}
