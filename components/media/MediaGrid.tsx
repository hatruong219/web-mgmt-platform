'use client'

import { useState, useCallback, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import type { MediaFile } from '@/types/database'

interface Props {
    siteId: string
    initialFiles: MediaFile[]
}

export default function MediaGrid({ siteId, initialFiles }: Props) {
    const router = useRouter()
    const [files, setFiles] = useState<MediaFile[]>(initialFiles)
    const [isDragging, setIsDragging] = useState(false)
    const [uploading, setUploading] = useState(false)
    const [copied, setCopied] = useState<string | null>(null)
    const [isPending, startTransition] = useTransition()

    const uploadFiles = async (fileList: FileList) => {
        setUploading(true)
        const supabase = createClient()

        for (const file of Array.from(fileList)) {
            const ext = file.name.split('.').pop()
            const fileName = `${siteId}/${Date.now()}-${Math.random().toString(36).slice(2, 8)}.${ext}`

            const { data, error } = await supabase.storage.from('media').upload(fileName, file)
            if (!error && data) {
                const { data: urlData } = supabase.storage.from('media').getPublicUrl(data.path)

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
        router.refresh()
        // Reload
        const { data: refreshed } = await supabase
            .from('media')
            .select('*')
            .eq('site_id', siteId)
            .order('created_at', { ascending: false })
        if (refreshed) setFiles(refreshed)
    }

    const handleDrop = useCallback((e: React.DragEvent) => {
        e.preventDefault()
        setIsDragging(false)
        if (e.dataTransfer.files.length > 0) {
            uploadFiles(e.dataTransfer.files)
        }
    }, [siteId])

    const handleDragOver = useCallback((e: React.DragEvent) => {
        e.preventDefault()
        setIsDragging(true)
    }, [])

    const handleDragLeave = useCallback(() => setIsDragging(false), [])

    const handleFileInput = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.files && e.target.files.length > 0) {
            uploadFiles(e.target.files)
        }
    }

    const copyUrl = (url: string) => {
        navigator.clipboard.writeText(url)
        setCopied(url)
        setTimeout(() => setCopied(null), 2000)
    }

    const deleteFile = async (file: MediaFile) => {
        if (!confirm('Xóa file này?')) return
        const supabase = createClient()
        startTransition(async () => {
            // Delete from storage
            const path = file.url.split('/media/')[1]
            if (path) await supabase.storage.from('media').remove([decodeURIComponent(path)])
            // Delete from DB
            await supabase.from('media').delete().eq('id', file.id)
            setFiles((prev) => prev.filter((f) => f.id !== file.id))
        })
    }

    const formatSize = (bytes: number | null) => {
        if (!bytes) return '—'
        if (bytes < 1024) return `${bytes} B`
        if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
        return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
    }

    const isImage = (mime: string | null) => mime?.startsWith('image/')

    return (
        <div>
            {/* Upload Zone */}
            <div
                className={`upload-zone ${isDragging ? 'dragging' : ''} ${uploading ? 'uploading' : ''}`}
                onDrop={handleDrop}
                onDragOver={handleDragOver}
                onDragLeave={handleDragLeave}
            >
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                    <polyline points="17 8 12 3 7 8" />
                    <line x1="12" y1="3" x2="12" y2="15" />
                </svg>
                <p className="upload-text">
                    {uploading ? 'Đang upload...' : isDragging ? 'Thả file tại đây' : 'Kéo thả file hoặc click để upload'}
                </p>
                <label className="upload-btn">
                    <input type="file" multiple accept="image/*,video/*,.pdf,.doc,.docx" onChange={handleFileInput} hidden />
                    Chọn file
                </label>
            </div>

            {/* Media Grid */}
            {files.length === 0 ? (
                <div className="empty glass">
                    <p>Chưa có file nào. Upload file đầu tiên!</p>
                </div>
            ) : (
                <div className="media-grid">
                    {files.map((file) => (
                        <div key={file.id} className="media-card glass">
                            <div className="media-preview">
                                {isImage(file.mime_type) ? (
                                    <img src={file.url} alt={file.filename} className="media-img" loading="lazy" />
                                ) : (
                                    <div className="media-file-icon">
                                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                            <polyline points="14 2 14 8 20 8" />
                                        </svg>
                                        <span>{file.mime_type?.split('/')[1] || 'file'}</span>
                                    </div>
                                )}
                            </div>
                            <div className="media-info">
                                <p className="media-name" title={file.filename}>{file.filename}</p>
                                <p className="media-size">{formatSize(file.size)}</p>
                            </div>
                            <div className="media-actions">
                                <button
                                    onClick={() => copyUrl(file.url)}
                                    className={`action-btn ${copied === file.url ? 'copied' : ''}`}
                                    title="Copy URL"
                                >
                                    {copied === file.url ? (
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><polyline points="20 6 9 17 4 12" /></svg>
                                    ) : (
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                            <rect x="9" y="9" width="13" height="13" rx="2" /><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
                                        </svg>
                                    )}
                                </button>
                                <button onClick={() => deleteFile(file)} className="action-btn del" title="Xóa" disabled={isPending}>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                        <polyline points="3 6 5 6 21 6" /><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                                    </svg>
                                </button>
                            </div>
                        </div>
                    ))}
                </div>
            )}

            <style jsx>{`
        .upload-zone {
          display:flex; flex-direction:column; align-items:center; gap:0.75rem;
          padding:2rem; border:2px dashed hsl(var(--border)); border-radius:1rem;
          color:hsl(var(--muted-foreground)); transition:all .2s; margin-bottom:1.5rem; cursor:default;
        }
        .upload-zone.dragging { border-color:hsl(var(--primary)); background:hsl(var(--primary)/.05); color:hsl(var(--primary)); }
        .upload-zone.uploading { opacity:0.7; pointer-events:none; }
        .upload-text { font-size:0.875rem; }
        .upload-btn {
          padding:0.5rem 1rem; background:hsl(var(--secondary)); border:1px solid hsl(var(--border));
          border-radius:0.5rem; font-size:0.8125rem; font-weight:500; cursor:pointer; transition:all .15s; color:hsl(var(--foreground));
        }
        .upload-btn:hover { background:hsl(var(--border)); }
        .media-grid {
          display:grid; grid-template-columns:repeat(auto-fill, minmax(180px, 1fr)); gap:0.875rem;
        }
        .media-card { border-radius:0.875rem; overflow:hidden; transition:all .2s; }
        .media-card:hover { border-color:hsl(var(--primary)/.3); transform:translateY(-2px); }
        .media-preview {
          width:100%; height:130px; background:hsl(var(--secondary));
          display:flex; align-items:center; justify-content:center; overflow:hidden;
        }
        .media-img { width:100%; height:100%; object-fit:cover; }
        .media-file-icon {
          display:flex; flex-direction:column; align-items:center; gap:0.375rem;
          color:hsl(var(--muted-foreground));
        }
        .media-file-icon span { font-size:0.6875rem; text-transform:uppercase; font-weight:600; }
        .media-info { padding:0.625rem 0.75rem 0.375rem; }
        .media-name {
          font-size:0.8125rem; font-weight:500; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
        }
        .media-size { font-size:0.75rem; color:hsl(var(--muted-foreground)/.6); }
        .media-actions { display:flex; gap:0.375rem; padding:0.375rem 0.75rem 0.75rem; }
        .action-btn {
          display:flex; align-items:center; justify-content:center; width:30px; height:30px;
          background:hsl(var(--secondary)); border:1px solid hsl(var(--border)); border-radius:0.375rem;
          color:hsl(var(--muted-foreground)); cursor:pointer; transition:all .15s;
        }
        .action-btn:hover { background:hsl(var(--border)); color:hsl(var(--foreground)); }
        .action-btn.copied { color:hsl(142 76% 45%); border-color:hsl(142 76% 45%/.3); }
        .action-btn.del:hover { background:hsl(var(--destructive)/.1); border-color:hsl(var(--destructive)/.3); color:hsl(var(--destructive)); }
        .empty { padding:2rem; border-radius:1rem; text-align:center; color:hsl(var(--muted-foreground)); font-size:0.875rem; }
      `}</style>
        </div>
    )
}
