'use client'

import { useState, useEffect, useCallback } from 'react'
import { createPortal } from 'react-dom'
import { createClient } from '@/lib/supabase/client'
import { STORAGE_BUCKET } from '@/lib/utils'
import { deleteMediaAction } from '@/app/actions/media'
import type { MediaFile } from '@/types/database'

interface MediaPickerModalProps {
    siteId: string
    open: boolean
    onClose: () => void
    onSelect: (url: string) => void
}

export default function MediaPickerModal({ siteId, open, onClose, onSelect }: MediaPickerModalProps) {
    const [files, setFiles] = useState<MediaFile[]>([])
    const [loading, setLoading] = useState(true)
    const [uploading, setUploading] = useState(false)
    const [search, setSearch] = useState('')

    const loadFiles = useCallback(async () => {
        setLoading(true)
        const supabase = createClient()
        const { data } = await supabase
            .from('media')
            .select('*')
            .eq('site_id', siteId)
            .order('created_at', { ascending: false })
        setFiles(data || [])
        setLoading(false)
    }, [siteId])

    useEffect(() => {
        if (open) {
            loadFiles()
        }
    }, [open, loadFiles])

    const handleUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const fileList = e.target.files
        if (!fileList || fileList.length === 0) return

        setUploading(true)
        const supabase = createClient()

        for (const file of Array.from(fileList)) {
            const ext = file.name.split('.').pop()
            const fileName = `${siteId}/${Date.now()}-${Math.random().toString(36).slice(2, 8)}.${ext}`

            const { data, error } = await supabase.storage.from(STORAGE_BUCKET).upload(fileName, file)
            if (!error && data) {
                const { data: urlData } = supabase.storage.from(STORAGE_BUCKET).getPublicUrl(data.path)
                await supabase.from('media').insert({
                    site_id: siteId,
                    filename: file.name,
                    url: urlData.publicUrl,
                    mime_type: file.type,
                    size: file.size,
                })
            }
        }

        setUploading(false)
        e.target.value = ''
        await loadFiles()
    }

    const handleDelete = async (e: React.MouseEvent, file: MediaFile) => {
        e.stopPropagation()
        if (!confirm(`Xóa "${file.filename}" khỏi Media Library?\n(File vẫn được giữ trong Storage, bài viết đang dùng sẽ không bị ảnh hưởng)`)) return

        const result = await deleteMediaAction(file.id, file.url, siteId)
        if (result.success) {
            setFiles((prev) => prev.filter((f) => f.id !== file.id))
        }
    }

    const filteredFiles = files.filter((f) =>
        f.mime_type?.startsWith('image/') &&
        (search === '' || f.filename.toLowerCase().includes(search.toLowerCase()))
    )

    if (!open) return null

    const modalContent = (
        <div className="mp-overlay" onClick={onClose}>
            <div className="mp-modal" onClick={(e) => e.stopPropagation()}>
                {/* Header */}
                <div className="mp-header">
                    <h2 className="mp-title">Chọn ảnh</h2>
                    <button className="mp-close" onClick={onClose}>
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />
                        </svg>
                    </button>
                </div>

                {/* Toolbar */}
                <div className="mp-toolbar">
                    <div className="mp-search-wrap">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <circle cx="11" cy="11" r="8" /><line x1="21" y1="21" x2="16.65" y2="16.65" />
                        </svg>
                        <input
                            type="text"
                            value={search}
                            onChange={(e) => setSearch(e.target.value)}
                            placeholder="Tìm ảnh..."
                            className="mp-search"
                            autoFocus
                        />
                    </div>
                    <label className="mp-upload-btn">
                        <input type="file" multiple accept="image/jpeg,image/png,image/webp,image/gif" onChange={handleUpload} hidden />
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                            <line x1="12" y1="5" x2="12" y2="19" /><line x1="5" y1="12" x2="19" y2="12" />
                        </svg>
                        {uploading ? 'Đang upload...' : 'Upload mới'}
                    </label>
                </div>

                {/* Grid */}
                <div className="mp-grid-wrap">
                    {loading ? (
                        <div className="mp-loading">Đang tải...</div>
                    ) : filteredFiles.length === 0 ? (
                        <div className="mp-empty">
                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                                <rect x="3" y="3" width="18" height="18" rx="2" /><circle cx="8.5" cy="8.5" r="1.5" /><polyline points="21 15 16 10 5 21" />
                            </svg>
                            <p>Chưa có ảnh nào. Upload ảnh đầu tiên!</p>
                        </div>
                    ) : (
                        <div className="mp-grid">
                            {filteredFiles.map((file) => (
                                <div key={file.id} className="mp-item">
                                    <button
                                        className="mp-item-btn"
                                        onClick={() => {
                                            onSelect(file.url)
                                            onClose()
                                        }}
                                        title={`Chọn: ${file.filename}`}
                                    >
                                        <img src={file.url} alt={file.filename} className="mp-img" loading="lazy" />
                                        <span className="mp-name">{file.filename}</span>
                                    </button>
                                    <button
                                        className="mp-delete"
                                        onClick={(e) => handleDelete(e, file)}
                                        title="Xóa ảnh"
                                    >
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3">
                                            <line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />
                                        </svg>
                                    </button>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </div>

            <style jsx>{`
          .mp-overlay {
            position:fixed; inset:0; z-index:9999; display:flex; align-items:center; justify-content:center;
            background:rgba(0,0,0,.65); backdrop-filter:blur(6px); animation:mpFadeIn .15s ease-out;
          }
          @keyframes mpFadeIn { from { opacity:0; } to { opacity:1; } }
          .mp-modal {
            width:90vw; max-width:720px; max-height:80vh; display:flex; flex-direction:column;
            border-radius:1.25rem; overflow:hidden; animation:mpSlideUp .2s ease-out;
            background:hsl(var(--card)); border:1px solid hsl(var(--border));
            box-shadow:0 24px 80px rgba(0,0,0,.5), 0 0 0 1px hsl(var(--border)/.5);
          }
          @keyframes mpSlideUp {
            from { opacity:0; transform:translateY(20px) scale(0.98); }
            to { opacity:1; transform:translateY(0) scale(1); }
          }
          .mp-header {
            display:flex; align-items:center; justify-content:space-between;
            padding:1.125rem 1.25rem; border-bottom:1px solid hsl(var(--border)/.5);
          }
          .mp-title { font-size:1.125rem; font-weight:700; }
          .mp-close {
            display:flex; align-items:center; justify-content:center; width:32px; height:32px;
            background:hsl(var(--secondary)); border:1px solid hsl(var(--border)); border-radius:0.5rem;
            color:hsl(var(--muted-foreground)); cursor:pointer; transition:all .15s;
          }
          .mp-close:hover { background:hsl(var(--border)); color:hsl(var(--foreground)); }
          .mp-toolbar {
            display:flex; align-items:center; gap:0.75rem; padding:0.75rem 1.25rem;
            border-bottom:1px solid hsl(var(--border)/.3); background:hsl(var(--card)/.5);
          }
          .mp-search-wrap {
            flex:1; display:flex; align-items:center; gap:0.5rem;
            padding:0.5rem 0.75rem; background:hsl(var(--secondary));
            border:1px solid hsl(var(--border)); border-radius:0.5rem;
            color:hsl(var(--muted-foreground));
          }
          .mp-search {
            flex:1; background:transparent; border:none; color:hsl(var(--foreground));
            font-size:0.8125rem; font-family:inherit; outline:none;
          }
          .mp-search::placeholder { color:hsl(var(--muted-foreground)/.5); }
          .mp-upload-btn {
            display:inline-flex; align-items:center; gap:0.375rem;
            padding:0.5rem 1rem; background:linear-gradient(135deg,hsl(262 83% 65%),hsl(220 83% 65%));
            color:white; border:none; border-radius:0.5rem; font-size:0.8125rem; font-weight:600;
            cursor:pointer; transition:all .2s; white-space:nowrap;
            box-shadow:0 2px 8px hsl(262 83% 65%/.25);
          }
          .mp-upload-btn:hover { opacity:0.9; transform:translateY(-1px); }
          .mp-grid-wrap { flex:1; overflow-y:auto; padding:1.25rem; }
          .mp-loading, .mp-empty {
            display:flex; flex-direction:column; align-items:center; justify-content:center;
            gap:0.75rem; padding:3rem; color:hsl(var(--muted-foreground)); font-size:0.875rem;
          }
          .mp-grid {
            display:grid; grid-template-columns:repeat(auto-fill, minmax(140px, 1fr)); gap:0.75rem;
          }
          .mp-item {
            position:relative; background:hsl(var(--secondary)/.5); border:2px solid hsl(var(--border)/.5);
            border-radius:0.75rem; overflow:hidden; transition:all .15s;
            display:flex; flex-direction:column;
          }
          .mp-item:hover { border-color:hsl(var(--primary)); transform:translateY(-2px);
            box-shadow:0 4px 20px hsl(var(--primary)/.2);
          }
          .mp-item-btn {
            background:none; border:none; padding:0; cursor:pointer; display:flex; flex-direction:column;
            color:inherit; font-family:inherit; width:100%;
          }
          .mp-delete {
            position:absolute; top:6px; right:6px; width:24px; height:24px;
            background:hsl(var(--destructive)); border:none; border-radius:50%;
            color:white; display:flex; align-items:center; justify-content:center;
            cursor:pointer; opacity:0; transition:all .15s; transform:scale(0.8);
            box-shadow:0 2px 8px rgba(0,0,0,.4);
          }
          .mp-item:hover .mp-delete { opacity:1; transform:scale(1); }
          .mp-delete:hover { background:hsl(0 84% 50%); transform:scale(1.1) !important; }
          .mp-img { width:100%; height:110px; object-fit:cover; display:block; }
          .mp-name {
            font-size:0.6875rem; padding:0.5rem 0.625rem; white-space:nowrap;
            overflow:hidden; text-overflow:ellipsis; color:hsl(var(--muted-foreground));
          }
        `}</style>
        </div>
    )

    // Portal → render ngoài DOM tree hiện tại → tránh bị ảnh hưởng bởi parent transform/backdrop-filter
    if (typeof document !== 'undefined') {
        return createPortal(modalContent, document.body)
    }
    return modalContent
}
