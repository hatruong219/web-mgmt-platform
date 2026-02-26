'use client'

import { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { updateSiteAction, deleteSiteAction } from '@/app/actions/sites'
import type { Site } from '@/types/database'

interface Props {
    site: Site
}

export default function SiteSettingsForm({ site }: Props) {
    const router = useRouter()
    const [isPending, startTransition] = useTransition()
    const [name, setName] = useState(site.name)
    const [description, setDescription] = useState(site.description || '')
    const [domain, setDomain] = useState(site.domain || '')
    const [saved, setSaved] = useState(false)
    const [error, setError] = useState<string | null>(null)

    const handleSave = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault()
        setError(null)

        const formData = new FormData(e.currentTarget)
        formData.set('id', site.id)

        startTransition(async () => {
            const result = await updateSiteAction(formData)

            if (result.error) {
                setError(result.error)
            } else {
                setSaved(true)
                setTimeout(() => setSaved(false), 3000)
                router.refresh()
            }
        })
    }

    const handleDelete = async () => {
        if (!confirm(`Xác nhận xóa website "${site.name}"? Tất cả bài viết và media sẽ bị xóa vĩnh viễn.`)) return

        startTransition(async () => {
            await deleteSiteAction(site.id)
        })
    }

    return (
        <div className="settings-page">
            <form onSubmit={handleSave} className="settings-form">
                <div className="settings-card glass">
                    <h2 className="section-title">Thông tin chung</h2>

                    <div className="form-group">
                        <label className="form-label">Tên website</label>
                        <input
                            id="settings-name"
                            name="name"
                            type="text"
                            required
                            value={name}
                            onChange={(e) => setName(e.target.value)}
                            className="form-input"
                        />
                    </div>

                    <div className="form-group">
                        <label className="form-label">Mô tả</label>
                        <textarea
                            id="settings-description"
                            name="description"
                            value={description}
                            onChange={(e) => setDescription(e.target.value)}
                            className="form-input form-textarea"
                            rows={3}
                        />
                    </div>

                    <div className="form-group">
                        <label className="form-label">Domain</label>
                        <input
                            id="settings-domain"
                            name="domain"
                            type="text"
                            value={domain}
                            onChange={(e) => setDomain(e.target.value)}
                            placeholder="blog.example.com"
                            className="form-input"
                        />
                    </div>

                    <div className="form-group">
                        <label className="form-label">Slug</label>
                        <p className="slug-value">{site.slug}</p>
                        <p className="form-hint">Không thể thay đổi slug sau khi tạo</p>
                    </div>

                    {error && (
                        <div className="form-error">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                <circle cx="12" cy="12" r="10" /><line x1="15" y1="9" x2="9" y2="15" /><line x1="9" y1="9" x2="15" y2="15" />
                            </svg>
                            {error}
                        </div>
                    )}

                    <div className="form-actions">
                        {saved && <span className="saved-msg">✓ Đã lưu thay đổi</span>}
                        <button id="settings-save-btn" type="submit" disabled={isPending} className="btn-primary">
                            {isPending ? 'Đang lưu...' : 'Lưu thay đổi'}
                        </button>
                    </div>
                </div>
            </form>

            {/* Danger Zone */}
            <div className="danger-zone glass">
                <h2 className="section-title danger-title">Vùng nguy hiểm</h2>
                <p className="danger-desc">Xóa website sẽ xóa tất cả bài viết và media liên quan. Hành động này không thể hoàn tác.</p>
                <button
                    id="delete-site-btn"
                    onClick={handleDelete}
                    disabled={isPending}
                    className="btn-danger"
                >
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <polyline points="3 6 5 6 21 6" /><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                    </svg>
                    Xóa website này
                </button>
            </div>

            <style jsx>{`
        .settings-page { display:flex; flex-direction:column; gap:1.5rem; max-width:640px; }
        .settings-card { padding:1.75rem; border-radius:1rem; }
        .section-title { font-size:1.125rem; font-weight:600; margin-bottom:1.25rem; }
        .form-group { display:flex; flex-direction:column; gap:0.5rem; margin-bottom:1.125rem; }
        .form-label { font-size:0.875rem; font-weight:500; color:hsl(var(--muted-foreground)); }
        .form-input {
          width:100%; padding:0.625rem 0.875rem; background:hsl(var(--secondary)); border:1px solid hsl(var(--border));
          border-radius:0.625rem; color:hsl(var(--foreground)); font-size:0.9375rem; font-family:inherit;
          outline:none; transition:border-color .2s, box-shadow .2s;
        }
        .form-input:focus { border-color:hsl(var(--primary)); box-shadow:0 0 0 3px hsl(var(--primary)/.12); }
        .form-textarea { resize:vertical; }
        .slug-value { font-size:0.9375rem; color:hsl(var(--primary)); }
        .form-hint { font-size:0.75rem; color:hsl(var(--muted-foreground)/.6); }
        .form-error {
          display:flex; align-items:center; gap:0.5rem; padding:0.625rem 0.875rem;
          background:hsl(var(--destructive)/.12); border:1px solid hsl(var(--destructive)/.3);
          border-radius:0.5rem; color:hsl(var(--destructive)); font-size:0.8125rem; margin-bottom:0.75rem;
        }
        .form-actions { display:flex; align-items:center; gap:1rem; justify-content:flex-end; }
        .saved-msg { font-size:0.8125rem; color:hsl(142 76% 45%); }
        .btn-primary {
          padding:0.625rem 1.25rem; background:linear-gradient(135deg,hsl(262 83% 65%),hsl(220 83% 65%));
          color:white; border:none; border-radius:0.625rem; font-size:0.875rem; font-weight:600;
          font-family:inherit; cursor:pointer; transition:opacity .2s;
        }
        .btn-primary:hover { opacity:0.9; }
        .btn-primary:disabled { opacity:0.6; cursor:not-allowed; }
        .danger-zone { padding:1.75rem; border-radius:1rem; border-left:3px solid hsl(var(--destructive)); }
        .danger-title { color:hsl(var(--destructive)); }
        .danger-desc { font-size:0.875rem; color:hsl(var(--muted-foreground)); margin-bottom:1rem; }
        .btn-danger {
          display:inline-flex; align-items:center; gap:0.5rem; padding:0.625rem 1.25rem;
          background:hsl(var(--destructive)/.12); border:1px solid hsl(var(--destructive)/.3);
          border-radius:0.625rem; color:hsl(var(--destructive)); font-size:0.875rem; font-weight:600;
          font-family:inherit; cursor:pointer; transition:all .15s;
        }
        .btn-danger:hover { background:hsl(var(--destructive)/.2); }
        .btn-danger:disabled { opacity:0.5; cursor:not-allowed; }
      `}</style>
        </div>
    )
}
