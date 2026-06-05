'use client'

import { useState, useEffect, useCallback, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'
import { createArticleAction, updateArticleAction } from '@/app/actions/articles'
import { slugify, STORAGE_BUCKET } from '@/lib/utils'
import TiptapEditor from '@/components/editor/TiptapEditor'
import MediaPickerModal from '@/components/media/MediaPickerModal'
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
    const [showCoverPicker, setShowCoverPicker] = useState(false)
    const [coverUploading, setCoverUploading] = useState(false)
    const [isPreview, setIsPreview] = useState(false)

    // Auto-save debounce
    useEffect(() => {
        if (isNew || saved) return
        const timer = setTimeout(() => {
            handleSave(false)
        }, 3000)
        return () => clearTimeout(timer)
    }, [title, content, excerpt, tags, coverImage])

    const markUnsaved = useCallback(() => setSaved(false), [])

    const handleSave = async (_showNotify = true) => {
        const tagArr = tags.split(',').map(t => t.trim()).filter(Boolean)

        startTransition(async () => {
            if (isNew) {
                const result = await createArticleAction(siteId, title, content, excerpt, coverImage, tagArr, status)
                if (result.success && result.data) {
                    router.replace(`/sites/${siteId}/articles/${result.data.id}`)
                    router.refresh()
                }
            } else {
                await updateArticleAction(
                    article.id, siteId, title, content, excerpt, coverImage, tagArr, status,
                    article.published_at
                )
                router.refresh()
            }
            setSaved(true)
            setLastSaved(new Date().toLocaleTimeString('vi-VN'))
        })
    }

    const handleCoverUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0]
        if (!file) return

        setCoverUploading(true)
        try {
            const supabase = createClient()
            const ext = file.name.split('.').pop()
            const fileName = `${siteId}/${Date.now()}-${Math.random().toString(36).slice(2, 6)}.${ext}`

            const { data, error } = await supabase.storage.from(STORAGE_BUCKET).upload(fileName, file)
            if (!error && data) {
                const { data: urlData } = supabase.storage.from(STORAGE_BUCKET).getPublicUrl(data.path)
                // Ghi vào media table để track trong Media Library
                await supabase.from('media').insert({
                    site_id: siteId,
                    filename: file.name,
                    url: urlData.publicUrl,
                    mime_type: file.type,
                    size: file.size,
                })
                setCoverImage(urlData.publicUrl)
                markUnsaved()
            }
        } finally {
            setCoverUploading(false)
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
                    <button
                        onClick={() => setIsPreview(v => !v)}
                        className={`btn-preview${isPreview ? ' active' : ''}`}
                        title={isPreview ? 'Quay lại chỉnh sửa' : 'Xem trước'}
                    >
                        {isPreview ? (
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                            </svg>
                        ) : (
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" /><circle cx="12" cy="12" r="3" />
                            </svg>
                        )}
                        {isPreview ? 'Chỉnh sửa' : 'Preview'}
                    </button>
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
                {isPreview ? (
                    <div className="preview-main">
                        {coverImage && (
                            <img src={coverImage} alt="Cover" className="preview-cover" />
                        )}
                        <h1 className="preview-title">{title || 'Untitled'}</h1>
                        {excerpt && <p className="preview-excerpt">{excerpt}</p>}
                        {tags && (
                            <div className="preview-tags">
                                {tags.split(',').map(t => t.trim()).filter(Boolean).map(tag => (
                                    <span key={tag} className="preview-tag">{tag}</span>
                                ))}
                            </div>
                        )}
                        <div
                            className="preview-content prose"
                            dangerouslySetInnerHTML={{ __html: content }}
                        />
                    </div>
                ) : (
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
                        siteId={siteId}
                    />
                </div>
                )}

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
                        ) : coverUploading ? (
                            <div className="cover-uploading">
                                <span className="cover-spinner" />
                                <span>Đang upload...</span>
                            </div>
                        ) : (
                            <div className="cover-options">
                                <label className="cover-upload">
                                    <input type="file" accept="image/*" onChange={handleCoverUpload} hidden />
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                        <polyline points="17 8 12 3 7 8" /><line x1="12" y1="3" x2="12" y2="15" />
                                    </svg>
                                    <span>Upload ảnh bìa</span>
                                </label>
                                <button type="button" className="cover-pick-media" onClick={() => setShowCoverPicker(true)}>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                                        <rect x="3" y="3" width="18" height="18" rx="2" /><circle cx="8.5" cy="8.5" r="1.5" /><polyline points="21 15 16 10 5 21" />
                                    </svg>
                                    <span>Chọn từ Media</span>
                                </button>
                            </div>
                        )}
                        <MediaPickerModal
                            siteId={siteId}
                            open={showCoverPicker}
                            onClose={() => setShowCoverPicker(false)}
                            onSelect={(url) => { setCoverImage(url); markUnsaved() }}
                        />
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
        .cover-uploading {
          display:flex; align-items:center; justify-content:center; gap:0.625rem;
          padding:1.25rem; border:2px dashed hsl(var(--primary)/.3); border-radius:0.5rem;
          color:hsl(var(--primary)); font-size:0.8125rem; font-weight:500;
        }
        .cover-spinner {
          width:16px; height:16px; border:2px solid hsl(var(--primary)/.3); border-top-color:hsl(var(--primary));
          border-radius:50%; animation:coverSpin .6s linear infinite;
        }
        @keyframes coverSpin { to { transform:rotate(360deg); } }
        .cover-options { display:flex; flex-direction:column; gap:0.5rem; }
        .cover-upload {
          display:flex; align-items:center; justify-content:center; gap:0.5rem;
          padding:0.875rem; border:2px dashed hsl(var(--border)); border-radius:0.5rem;
          color:hsl(var(--muted-foreground)); font-size:0.8125rem; cursor:pointer; transition:all .15s;
        }
        .cover-upload:hover { border-color:hsl(var(--primary)/.5); color:hsl(var(--primary)); }
        .cover-pick-media {
          display:flex; align-items:center; justify-content:center; gap:0.5rem;
          padding:0.625rem; background:hsl(var(--secondary)); border:1px solid hsl(var(--border));
          border-radius:0.5rem; color:hsl(var(--muted-foreground)); font-size:0.8125rem;
          cursor:pointer; transition:all .15s; font-family:inherit;
        }
        .cover-pick-media:hover { border-color:hsl(var(--primary)/.5); color:hsl(var(--primary)); background:hsl(var(--primary)/.05); }
        .btn-preview {
          display:flex; align-items:center; gap:0.375rem;
          padding:0.5rem 0.875rem; background:hsl(var(--secondary)); border:1px solid hsl(var(--border));
          border-radius:0.5rem; color:hsl(var(--muted-foreground)); font-size:0.8125rem; font-weight:500;
          font-family:inherit; cursor:pointer; transition:all .15s;
        }
        .btn-preview:hover { border-color:hsl(var(--primary)/.5); color:hsl(var(--primary)); }
        .btn-preview.active { background:hsl(var(--primary)/.1); border-color:hsl(var(--primary)/.4); color:hsl(var(--primary)); }
        .preview-main {
          flex:1; min-width:0; max-width:720px; margin:0 auto;
          padding:0 1rem 4rem;
        }
        .preview-cover {
          width:100%; max-height:360px; object-fit:cover; border-radius:0.875rem;
          margin-bottom:2rem; display:block;
        }
        .preview-title {
          font-size:2.25rem; font-weight:700; letter-spacing:-0.02em;
          color:hsl(var(--foreground)); margin-bottom:0.75rem; line-height:1.2;
        }
        .preview-excerpt {
          font-size:1.0625rem; color:hsl(var(--muted-foreground)); margin-bottom:1rem;
          line-height:1.6; border-left:3px solid hsl(var(--primary)/.4); padding-left:1rem;
        }
        .preview-tags { display:flex; flex-wrap:wrap; gap:0.375rem; margin-bottom:2rem; }
        .preview-tag {
          padding:0.25rem 0.625rem; background:hsl(var(--primary)/.1); border:1px solid hsl(var(--primary)/.2);
          border-radius:9999px; font-size:0.75rem; color:hsl(var(--primary)); font-weight:500;
        }
        .preview-content {
          color:hsl(var(--foreground)); font-size:1rem; line-height:1.8;
        }
        .preview-content :global(h1),
        .preview-content :global(h2),
        .preview-content :global(h3) { font-weight:700; margin:1.5em 0 0.5em; letter-spacing:-0.01em; }
        .preview-content :global(h1) { font-size:1.875rem; }
        .preview-content :global(h2) { font-size:1.5rem; }
        .preview-content :global(h3) { font-size:1.25rem; }
        .preview-content :global(p) { margin:0.875em 0; }
        .preview-content :global(a) { color:hsl(var(--primary)); text-decoration:underline; }
        .preview-content :global(code) {
          font-family:monospace; font-size:0.875em;
          background:hsl(var(--secondary)); padding:0.15em 0.4em; border-radius:0.3em;
        }
        .preview-content :global(pre) {
          background:hsl(var(--secondary)); border:1px solid hsl(var(--border));
          border-radius:0.625rem; padding:1rem 1.25rem; overflow-x:auto; margin:1.25em 0;
        }
        .preview-content :global(pre code) { background:none; padding:0; }
        .preview-content :global(ul), .preview-content :global(ol) { padding-left:1.5rem; margin:0.875em 0; }
        .preview-content :global(li) { margin:0.25em 0; }
        .preview-content :global(blockquote) {
          border-left:3px solid hsl(var(--primary)/.4); margin:1.25em 0;
          padding:0.5em 1em; color:hsl(var(--muted-foreground));
        }
        .preview-content :global(img) { max-width:100%; border-radius:0.5rem; margin:1em 0; }
        .preview-content :global(hr) { border:none; border-top:1px solid hsl(var(--border)); margin:2em 0; }
        @media (max-width: 900px) {
          .editor-body { flex-direction:column; }
          .editor-sidebar { width:100%; }
        }
      `}</style>
        </div>
    )
}
