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
    const [showDeleteConfirm, setShowDeleteConfirm] = useState(false)

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
        startTransition(async () => {
            await deleteSiteAction(site.id)
        })
    }

    const initials = site.name.slice(0, 2).toUpperCase()

    return (
        <div className="settings-page">
            {/* Site Identity Card */}
            <div className="identity-card glass">
                <div className="identity-header">
                    <div className="identity-avatar">{initials}</div>
                    <div className="identity-info">
                        <h2 className="identity-name">{site.name}</h2>
                        <div className="identity-meta">
                            <span className="identity-slug">/{site.slug}</span>
                            {site.domain && (
                                <>
                                    <span className="identity-dot">·</span>
                                    <a href={site.domain} target="_blank" rel="noopener noreferrer" className="identity-domain">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="12" r="10"/><path d="M2 12h20"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
                                        {site.domain.replace(/^https?:\/\//, '')}
                                    </a>
                                </>
                            )}
                        </div>
                    </div>
                </div>
                <div className="identity-id">
                    <span className="identity-id-label">ID</span>
                    <code className="identity-id-value">{site.id}</code>
                </div>
            </div>

            {/* General Settings */}
            <form onSubmit={handleSave}>
                <div className="settings-card glass">
                    <div className="card-header">
                        <div className="card-icon">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                                <circle cx="12" cy="12" r="3"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/>
                            </svg>
                        </div>
                        <div>
                            <h2 className="card-title">Thông tin chung</h2>
                            <p className="card-desc">Cập nhật tên, mô tả và domain của website</p>
                        </div>
                    </div>

                    <div className="form-grid">
                        <div className="form-group">
                            <label className="form-label">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M4 7V4a2 2 0 0 1 2-2h8.5L20 7.5V20a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-3"/></svg>
                                Tên website
                            </label>
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

                        <div className="form-group full-width">
                            <label className="form-label">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                                Mô tả
                            </label>
                            <textarea
                                id="settings-description"
                                name="description"
                                value={description}
                                onChange={(e) => setDescription(e.target.value)}
                                className="form-input form-textarea"
                                rows={3}
                                placeholder="Mô tả ngắn gọn về website..."
                            />
                        </div>

                        <div className="form-group">
                            <label className="form-label">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="12" r="10"/><path d="M2 12h20"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
                                Domain
                            </label>
                            <input
                                id="settings-domain"
                                name="domain"
                                type="text"
                                value={domain}
                                onChange={(e) => setDomain(e.target.value)}
                                placeholder="https://blog.example.com"
                                className="form-input"
                            />
                        </div>

                        <div className="form-group">
                            <label className="form-label">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/></svg>
                                Slug
                            </label>
                            <div className="slug-display">
                                <span className="slug-prefix">/</span>
                                <span className="slug-value">{site.slug}</span>
                                <span className="slug-lock">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                </span>
                            </div>
                            <p className="form-hint">Không thể thay đổi slug sau khi tạo</p>
                        </div>
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
                        {saved && (
                            <span className="saved-msg">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                                Đã lưu thay đổi
                            </span>
                        )}
                        <button id="settings-save-btn" type="submit" disabled={isPending} className="btn-primary">
                            {isPending ? (
                                <>
                                    <span className="spinner" />
                                    Đang lưu...
                                </>
                            ) : (
                                <>
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                                    Lưu thay đổi
                                </>
                            )}
                        </button>
                    </div>
                </div>
            </form>

            {/* Danger Zone */}
            <div className="danger-zone glass">
                <div className="card-header">
                    <div className="card-icon danger-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                            <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
                        </svg>
                    </div>
                    <div>
                        <h2 className="card-title danger-title">Vùng nguy hiểm</h2>
                        <p className="card-desc">Hành động không thể hoàn tác</p>
                    </div>
                </div>

                <div className="danger-content">
                    <div className="danger-item">
                        <div className="danger-item-info">
                            <h3 className="danger-item-title">Xóa website</h3>
                            <p className="danger-item-desc">Xóa vĩnh viễn website cùng tất cả bài viết, media và cài đặt liên quan.</p>
                        </div>
                        {!showDeleteConfirm ? (
                            <button
                                type="button"
                                onClick={() => setShowDeleteConfirm(true)}
                                className="btn-danger-outline"
                            >
                                Xóa website
                            </button>
                        ) : (
                            <div className="delete-confirm">
                                <p className="delete-confirm-text">Bạn chắc chắn?</p>
                                <div className="delete-confirm-actions">
                                    <button type="button" onClick={() => setShowDeleteConfirm(false)} className="btn-cancel">
                                        Hủy
                                    </button>
                                    <button
                                        id="delete-site-btn"
                                        type="button"
                                        onClick={handleDelete}
                                        disabled={isPending}
                                        className="btn-danger"
                                    >
                                        {isPending ? 'Đang xóa...' : 'Xác nhận xóa'}
                                    </button>
                                </div>
                            </div>
                        )}
                    </div>
                </div>
            </div>

            <style jsx>{`
        .settings-page { display:flex; flex-direction:column; gap:1.25rem; max-width:720px; margin:0 auto; }

        /* Identity Card */
        .identity-card { padding:1.5rem; border-radius:1rem; }
        .identity-header { display:flex; align-items:center; gap:1rem; }
        .identity-avatar {
          width:52px; height:52px; border-radius:0.875rem; display:flex; align-items:center; justify-content:center;
          font-size:1rem; font-weight:700; color:white; flex-shrink:0;
          background:linear-gradient(135deg,hsl(262 83% 65%),hsl(220 83% 65%));
          box-shadow:0 6px 20px hsl(262 83% 65%/.3);
        }
        .identity-info { flex:1; min-width:0; }
        .identity-name { font-size:1.25rem; font-weight:700; letter-spacing:-0.02em; }
        .identity-meta { display:flex; align-items:center; gap:0.5rem; margin-top:0.25rem; }
        .identity-slug { font-size:0.8125rem; color:hsl(var(--primary)); font-weight:500; font-family:'JetBrains Mono',monospace; }
        .identity-dot { color:hsl(var(--muted-foreground)/.4); }
        .identity-domain {
          display:inline-flex; align-items:center; gap:0.375rem; font-size:0.8125rem;
          color:hsl(var(--muted-foreground)); text-decoration:none; transition:color .15s;
        }
        .identity-domain:hover { color:hsl(var(--foreground)); }
        .identity-id {
          display:flex; align-items:center; gap:0.5rem; margin-top:1rem;
          padding-top:1rem; border-top:1px solid hsl(var(--border)/.5);
        }
        .identity-id-label {
          font-size:0.6875rem; font-weight:600; text-transform:uppercase; letter-spacing:0.05em;
          color:hsl(var(--muted-foreground)/.5); padding:0.125rem 0.375rem;
          background:hsl(var(--secondary)); border-radius:0.25rem;
        }
        .identity-id-value {
          font-size:0.75rem; color:hsl(var(--muted-foreground)/.6); font-family:'JetBrains Mono',monospace;
        }

        /* Card Header */
        .card-header { display:flex; align-items:flex-start; gap:0.875rem; margin-bottom:1.5rem; }
        .card-icon {
          width:36px; height:36px; border-radius:0.625rem; display:flex; align-items:center; justify-content:center;
          background:hsl(var(--primary)/.1); color:hsl(var(--primary)); flex-shrink:0;
        }
        .card-icon.danger-icon { background:hsl(var(--destructive)/.1); color:hsl(var(--destructive)); }
        .card-title { font-size:1rem; font-weight:600; }
        .card-desc { font-size:0.8125rem; color:hsl(var(--muted-foreground)); margin-top:0.125rem; }

        /* Settings Card */
        .settings-card { padding:1.5rem; border-radius:1rem; }

        /* Form Grid */
        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:1rem 1.25rem; }
        .form-group.full-width { grid-column:1 / -1; }
        .form-group { display:flex; flex-direction:column; gap:0.375rem; }
        .form-label {
          display:flex; align-items:center; gap:0.375rem;
          font-size:0.8125rem; font-weight:500; color:hsl(var(--muted-foreground));
        }
        .form-input {
          width:100%; padding:0.625rem 0.875rem; background:hsl(var(--background)/.6); border:1px solid hsl(var(--border));
          border-radius:0.625rem; color:hsl(var(--foreground)); font-size:0.9375rem; font-family:inherit;
          outline:none; transition:border-color .2s, box-shadow .2s, background .2s;
        }
        .form-input:hover { border-color:hsl(var(--border) / 0.8); background:hsl(var(--background)/.8); }
        .form-input:focus { border-color:hsl(var(--primary)); box-shadow:0 0 0 3px hsl(var(--primary)/.12); background:hsl(var(--background)); }
        .form-input::placeholder { color:hsl(var(--muted-foreground)/.4); }
        .form-textarea { resize:vertical; min-height:80px; }

        /* Slug display */
        .slug-display {
          display:flex; align-items:center; gap:0.25rem; padding:0.625rem 0.875rem;
          background:hsl(var(--secondary)/.6); border:1px solid hsl(var(--border)/.5);
          border-radius:0.625rem; font-family:'JetBrains Mono',monospace;
        }
        .slug-prefix { color:hsl(var(--muted-foreground)/.4); font-size:0.875rem; }
        .slug-value { font-size:0.875rem; color:hsl(var(--primary)); font-weight:500; }
        .slug-lock { margin-left:auto; color:hsl(var(--muted-foreground)/.4); display:flex; }

        .form-hint { font-size:0.6875rem; color:hsl(var(--muted-foreground)/.5); }

        .form-error {
          display:flex; align-items:center; gap:0.5rem; padding:0.75rem 1rem; margin-top:1rem;
          background:hsl(var(--destructive)/.08); border:1px solid hsl(var(--destructive)/.2);
          border-radius:0.625rem; color:hsl(var(--destructive)); font-size:0.8125rem;
        }

        .form-actions { display:flex; align-items:center; gap:1rem; justify-content:flex-end; margin-top:1.25rem; padding-top:1.25rem; border-top:1px solid hsl(var(--border)/.4); }
        .saved-msg { display:flex; align-items:center; gap:0.375rem; font-size:0.8125rem; color:hsl(142 76% 45%); font-weight:500; animation:fadeIn .3s ease; }

        .btn-primary {
          display:inline-flex; align-items:center; gap:0.5rem;
          padding:0.625rem 1.5rem; background:linear-gradient(135deg,hsl(262 83% 65%),hsl(220 83% 65%));
          color:white; border:none; border-radius:0.625rem; font-size:0.875rem; font-weight:600;
          font-family:inherit; cursor:pointer; transition:all .2s;
          box-shadow:0 4px 12px hsl(262 83% 65%/.25);
        }
        .btn-primary:hover { transform:translateY(-1px); box-shadow:0 6px 16px hsl(262 83% 65%/.35); }
        .btn-primary:active { transform:translateY(0); }
        .btn-primary:disabled { opacity:0.6; cursor:not-allowed; transform:none; }

        .spinner {
          width:14px; height:14px; border:2px solid rgba(255,255,255,.3); border-top-color:white;
          border-radius:50%; animation:spin .6s linear infinite;
        }
        @keyframes spin { to { transform:rotate(360deg); } }

        /* Danger Zone */
        .danger-zone { padding:1.5rem; border-radius:1rem; border:1px solid hsl(var(--destructive)/.15); }
        .danger-title { color:hsl(var(--destructive)); }
        .danger-content { padding:1rem 1.25rem; background:hsl(var(--destructive)/.04); border-radius:0.75rem; }
        .danger-item { display:flex; align-items:center; justify-content:space-between; gap:1.5rem; }
        .danger-item-info { flex:1; }
        .danger-item-title { font-size:0.9375rem; font-weight:600; }
        .danger-item-desc { font-size:0.8125rem; color:hsl(var(--muted-foreground)); margin-top:0.25rem; line-height:1.5; }

        .btn-danger-outline {
          padding:0.5rem 1rem; background:transparent; border:1px solid hsl(var(--destructive)/.4);
          border-radius:0.625rem; color:hsl(var(--destructive)); font-size:0.8125rem; font-weight:600;
          font-family:inherit; cursor:pointer; transition:all .15s; white-space:nowrap; flex-shrink:0;
        }
        .btn-danger-outline:hover { background:hsl(var(--destructive)/.1); border-color:hsl(var(--destructive)/.6); }

        .delete-confirm { display:flex; flex-direction:column; align-items:flex-end; gap:0.5rem; flex-shrink:0; }
        .delete-confirm-text { font-size:0.8125rem; font-weight:500; color:hsl(var(--destructive)); }
        .delete-confirm-actions { display:flex; gap:0.5rem; }

        .btn-cancel {
          padding:0.5rem 1rem; background:hsl(var(--secondary)); border:1px solid hsl(var(--border));
          border-radius:0.625rem; color:hsl(var(--foreground)); font-size:0.8125rem; font-weight:500;
          font-family:inherit; cursor:pointer; transition:all .15s;
        }
        .btn-cancel:hover { background:hsl(var(--border)); }

        .btn-danger {
          padding:0.5rem 1rem; background:hsl(var(--destructive)); border:none;
          border-radius:0.625rem; color:white; font-size:0.8125rem; font-weight:600;
          font-family:inherit; cursor:pointer; transition:all .15s;
        }
        .btn-danger:hover { opacity:0.9; }
        .btn-danger:disabled { opacity:0.5; cursor:not-allowed; }

        @media (max-width: 640px) {
          .form-grid { grid-template-columns:1fr; }
          .danger-item { flex-direction:column; align-items:flex-start; }
        }
      `}</style>
        </div>
    )
}
