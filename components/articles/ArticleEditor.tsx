'use client'

import { useState, useEffect, useCallback, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'
import { slugify } from '@/lib/utils'
import TiptapEditor from '@/components/editor/TiptapEditor'
import type { Article } from '@/types/database'

interface ArticleEditorProps {
    siteId: string
    siteName: string
    article?: Article | null
}

export default function ArticleEditor({ siteId, siteName, article }: ArticleEditorProps) {
    const isNew = !article
    const router = useRouter()
    const [isPending, startTransition] = useTransition()

    const [title, setTitle] = useState(article?.title ?? '')
    const [content, setContent] = useState(article?.content ?? '')
    const [excerpt, setExcerpt] = useState(article?.excerpt ?? '')
    const [coverImage, setCoverImage] = useState(article?.cover_image ?? '')
    const [tags, setTags] = useState(article?.tags?.join(', ') ?? '')
    const [status, setStatus] = useState<'draft' | 'published' | 'archived'>(article?.status ?? 'draft')

    const [saved, setSaved] = useState(true)
    const [lastSaved, setLastSaved] = useState<string | null>(null)

    // Auto-save debounce
    useEffect(() => {
        if (isNew || saved) return
        const timer = setTimeout(() => {
            handleSave(false)
        }, 3000)
        return () => clearTimeout(timer)
    }, [title, content, excerpt, tags, coverImage])

    const markUnsaved = useCallback(() => setSaved(false), [])

    const handleSave = async (showNotify = true) => {
        const supabase = createClient()
        const slug = slugify(title || 'untitled')
        const tagArr = tags.split(',').map(t => t.trim()).filter(Boolean)

        const payload = {
            site_id: siteId,
            title: title || 'Untitled',
            slug,
            content,
            excerpt: excerpt || null,
            cover_image: coverImage || null,
            tags: tagArr,
            status,
            published_at: status === 'published' ? new Date().toISOString() : article?.published_at || null,
        }

        startTransition(async () => {
            if (isNew) {
                const { data, error } = await supabase.from('articles').insert(payload).select().single()
                if (!error && data) {
                    router.replace(`/sites/${siteId}/articles/${data.id}`)
                    router.refresh()
                }
            } else {
                await supabase.from('articles').update(payload).eq('id', article.id)
                router.refresh()
            }
            setSaved(true)
            setLastSaved(new Date().toLocaleTimeString('vi-VN'))
        })
    }

    const handleCoverUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0]
        if (!file) return

        const supabase = createClient()
        const ext = file.name.split('.').pop()
        const fileName = `${siteId}/${Date.now()}.${ext}`

        const { data, error } = await supabase.storage.from('media').upload(fileName, file)
        if (!error && data) {
            const { data: urlData } = supabase.storage.from('media').getPublicUrl(data.path)
            setCoverImage(urlData.publicUrl)
            markUnsaved()
        }
    }

    return (
        <div className="editor-page animate-fade-in">
            {/* Header */}
            <div className="editor-topbar glass">
                <div className="editor-topbar-left">
                    <Link href={`/sites/${siteId}/articles`} className="back-btn" title="Quay lại">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <polyline points="15 18 9 12 15 6" />
                        </svg>
                    </Link>
                    <div className="topbar-info">
                        <span className="topbar-site">{siteName}</span>
                        <div className="topbar-status-row">
                            {saved ? (
                                <span className="save-status saved">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><polyline points="20 6 9 17 4 12" /></svg>
                                    {lastSaved ? `Đã lưu lúc ${lastSaved}` : 'Đã lưu'}
                                </span>
                            ) : (
                                <span className="save-status unsaved">Chưa lưu</span>
                            )}
                        </div>
                    </div>
                </div>
                <div className="editor-topbar-right">
                    <select
                        value={status}
                        onChange={(e) => { setStatus(e.target.value as typeof status); markUnsaved() }}
                        className="status-select"
                    >
                        <option value="draft">📝 Bản nháp</option>
                        <option value="published">✅ Xuất bản</option>
                        <option value="archived">📦 Lưu trữ</option>
                    </select>
                    <button
                        id="save-article-btn"
                        onClick={() => handleSave(true)}
                        disabled={isPending}
                        className="btn-primary"
                    >
                        {isPending ? 'Đang lưu...' : isNew ? 'Tạo bài viết' : 'Lưu'}
                    </button>
                </div>
            </div>

            {/* Main Editor Area */}
            <div className="editor-body">
                <div className="editor-main">
                    {/* Title */}
                    <input
                        id="article-title"
                        type="text"
                        value={title}
                        onChange={(e) => { setTitle(e.target.value); markUnsaved() }}
                        placeholder="Tiêu đề bài viết..."
                        className="title-input"
                        autoFocus={isNew}
                    />

                    {/* Content Editor */}
                    <TiptapEditor
                        content={content}
                        onChange={(html) => { setContent(html); markUnsaved() }}
                    />
                </div>

                {/* Sidebar */}
                <aside className="editor-sidebar">
                    {/* Cover Image */}
                    <div className="sidebar-section glass">
                        <h3 className="sidebar-label">Ảnh bìa</h3>
                        {coverImage ? (
                            <div className="cover-preview">
                                <img src={coverImage} alt="Cover" className="cover-img" />
                                <button onClick={() => { setCoverImage(''); markUnsaved() }} className="cover-remove" title="Xóa ảnh">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                        <line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />
                                    </svg>
                                </button>
                            </div>
                        ) : (
                            <label className="cover-upload">
                                <input type="file" accept="image/*" onChange={handleCoverUpload} hidden />
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                                    <rect x="3" y="3" width="18" height="18" rx="2" /><circle cx="8.5" cy="8.5" r="1.5" /><polyline points="21 15 16 10 5 21" />
                                </svg>
                                <span>Upload ảnh bìa</span>
                            </label>
                        )}
                    </div>

                    {/* Excerpt */}
                    <div className="sidebar-section glass">
                        <h3 className="sidebar-label">Tóm tắt</h3>
                        <textarea
                            id="article-excerpt"
                            value={excerpt}
                            onChange={(e) => { setExcerpt(e.target.value); markUnsaved() }}
                            placeholder="Mô tả ngắn gọn bài viết..."
                            className="sidebar-textarea"
                            rows={3}
                        />
                    </div>

                    {/* Tags */}
                    <div className="sidebar-section glass">
                        <h3 className="sidebar-label">Tags</h3>
                        <input
                            id="article-tags"
                            type="text"
                            value={tags}
                            onChange={(e) => { setTags(e.target.value); markUnsaved() }}
                            placeholder="react, nextjs, tutorial"
                            className="sidebar-input"
                        />
                        <p className="sidebar-hint">Phân cách bằng dấu phẩy</p>
                    </div>

                    {/* Slug */}
                    <div className="sidebar-section glass">
                        <h3 className="sidebar-label">Slug</h3>
                        <p className="slug-preview">{slugify(title || 'untitled')}</p>
                    </div>
                </aside>
            </div>

            <style jsx>{`
        .editor-page { display:flex; flex-direction:column; min-height:calc(100vh - 4rem); margin:-2rem; }
        .editor-topbar {
          position:sticky; top:0; z-index:20; display:flex; align-items:center; justify-content:space-between;
          padding:0.75rem 1.5rem; border-bottom:1px solid hsl(var(--border)/.5);
        }
        .editor-topbar-left { display:flex; align-items:center; gap:0.75rem; }
        .back-btn {
          display:flex; align-items:center; justify-content:center; width:34px; height:34px;
          background:hsl(var(--secondary)); border-radius:0.5rem; color:hsl(var(--muted-foreground));
          text-decoration:none; transition:all .15s;
        }
        .back-btn:hover { background:hsl(var(--border)); color:hsl(var(--foreground)); }
        .topbar-info { display:flex; flex-direction:column; }
        .topbar-site { font-size:0.8125rem; color:hsl(var(--muted-foreground)); }
        .topbar-status-row { display:flex; align-items:center; gap:0.5rem; }
        .save-status { display:flex; align-items:center; gap:0.25rem; font-size:0.75rem; }
        .save-status.saved { color:hsl(142 76% 45%); }
        .save-status.unsaved { color:hsl(38 92% 60%); }
        .editor-topbar-right { display:flex; align-items:center; gap:0.75rem; }
        .status-select {
          padding:0.5rem 0.75rem; background:hsl(var(--secondary)); border:1px solid hsl(var(--border));
          border-radius:0.5rem; color:hsl(var(--foreground)); font-size:0.8125rem; font-family:inherit; outline:none; cursor:pointer;
        }
        .btn-primary {
          padding:0.5rem 1.125rem; background:linear-gradient(135deg,hsl(262 83% 65%),hsl(220 83% 65%));
          color:white; border:none; border-radius:0.5rem; font-size:0.8125rem; font-weight:600;
          font-family:inherit; cursor:pointer; transition:opacity .2s;
        }
        .btn-primary:hover { opacity:0.9; }
        .btn-primary:disabled { opacity:0.6; cursor:not-allowed; }
        .editor-body { display:flex; gap:1.25rem; padding:1.5rem; flex:1; }
        .editor-main { flex:1; min-width:0; }
        .title-input {
          width:100%; font-size:2rem; font-weight:700; letter-spacing:-0.02em; background:transparent;
          border:none; color:hsl(var(--foreground)); outline:none; margin-bottom:1.25rem;
          padding:0.5rem 0; border-bottom:2px solid transparent; transition:border-color .2s;
        }
        .title-input:focus { border-bottom-color:hsl(var(--primary)/.4); }
        .title-input::placeholder { color:hsl(var(--muted-foreground)/.4); }
        .editor-sidebar { width:280px; flex-shrink:0; display:flex; flex-direction:column; gap:0.875rem; }
        .sidebar-section { padding:1rem; border-radius:0.875rem; }
        .sidebar-label { font-size:0.8125rem; font-weight:600; margin-bottom:0.625rem; color:hsl(var(--muted-foreground)); }
        .sidebar-textarea, .sidebar-input {
          width:100%; padding:0.5rem 0.75rem; background:hsl(var(--secondary)); border:1px solid hsl(var(--border));
          border-radius:0.5rem; color:hsl(var(--foreground)); font-size:0.8125rem; font-family:inherit;
          outline:none; transition:border-color .2s;
        }
        .sidebar-textarea { resize:vertical; }
        .sidebar-textarea:focus, .sidebar-input:focus { border-color:hsl(var(--primary)); }
        .sidebar-hint { font-size:0.75rem; color:hsl(var(--muted-foreground)/.6); margin-top:0.375rem; }
        .slug-preview { font-size:0.8125rem; color:hsl(var(--primary)); word-break:break-all; }
        .cover-preview { position:relative; border-radius:0.5rem; overflow:hidden; }
        .cover-img { width:100%; height:120px; object-fit:cover; display:block; }
        .cover-remove {
          position:absolute; top:0.375rem; right:0.375rem; width:24px; height:24px;
          background:hsl(0 0% 0%/.6); border:none; border-radius:50%; color:white;
          display:flex; align-items:center; justify-content:center; cursor:pointer; transition:background .15s;
        }
        .cover-remove:hover { background:hsl(var(--destructive)); }
        .cover-upload {
          display:flex; flex-direction:column; align-items:center; justify-content:center; gap:0.5rem;
          padding:1.5rem; border:2px dashed hsl(var(--border)); border-radius:0.5rem;
          color:hsl(var(--muted-foreground)); font-size:0.8125rem; cursor:pointer; transition:all .15s;
        }
        .cover-upload:hover { border-color:hsl(var(--primary)/.5); color:hsl(var(--primary)); }
        @media (max-width: 900px) {
          .editor-body { flex-direction:column; }
          .editor-sidebar { width:100%; }
        }
      `}</style>
        </div>
    )
}
