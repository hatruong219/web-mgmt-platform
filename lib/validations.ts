import { z } from 'zod'

// ─── Auth ───────────────────────────────────────────────────────────────────
export const loginSchema = z.object({
  email: z.string().email('Email không hợp lệ'),
  password: z.string().min(6, 'Mật khẩu tối thiểu 6 ký tự'),
})

export type LoginInput = z.infer<typeof loginSchema>

// ─── Sites ──────────────────────────────────────────────────────────────────
export const createSiteSchema = z.object({
  name: z.string().min(1, 'Tên website không được trống').max(100),
  description: z.string().max(500).optional(),
  domain: z.string().max(253).optional(),
})

export type CreateSiteInput = z.infer<typeof createSiteSchema>

export const updateSiteSchema = z.object({
  id: z.string().uuid(),
  name: z.string().min(1, 'Tên website không được trống').max(100),
  description: z.string().max(500).optional(),
  domain: z.string().max(253).optional(),
})

export type UpdateSiteInput = z.infer<typeof updateSiteSchema>

// ─── Articles ───────────────────────────────────────────────────────────────
export const createArticleSchema = z.object({
  site_id: z.string().uuid(),
  title: z.string().min(1, 'Tiêu đề không được trống').max(200),
  slug: z.string().min(1),
  content: z.string().optional().default(''),
  excerpt: z.string().max(500).optional(),
  cover_image: z.string().url().optional().or(z.literal('')),
  tags: z.array(z.string()).optional().default([]),
  status: z.enum(['draft', 'published', 'archived']).default('draft'),
})

export type CreateArticleInput = z.infer<typeof createArticleSchema>

export const updateArticleSchema = createArticleSchema.extend({
  id: z.string().uuid(),
})

export type UpdateArticleInput = z.infer<typeof updateArticleSchema>
