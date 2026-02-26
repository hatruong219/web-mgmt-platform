'use client'

import { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { createSiteAction } from '@/app/actions/sites'
import { slugify } from '@/lib/utils'

interface CreateSiteModalProps {
    variant?: 'default' | 'inline'
}

export default function CreateSiteModal({ variant = 'default' }: CreateSiteModalProps) {
    const [open, setOpen] = useState(false)
    const [name, setName] = useState('')
    const [description, setDescription] = useState('')
    const [domain, setDomain] = useState('')
    const [isPending, startTransition] = useTransition()
    const [error, setError] = useState<string | null>(null)
    const router = useRouter()

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault()
        setError(null)

        const formData = new FormData(e.currentTarget)

        startTransition(async () => {
            const result = await createSiteAction(formData)

            if (result.error) {
                setError(result.error)
            } else {
                setOpen(false)
                setName('')
                setDescription('')
                setDomain('')
                router.refresh()
            }
        })
    }

    return (
        <>
            <button
                id="create-site-btn"
                onClick={() => setOpen(true)}
                className={variant === 'inline' ? 'btn-primary mt-2' : 'btn-primary'}
            >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                    <line x1="12" y1="5" x2="12" y2="19" />
                    <line x1="5" y1="12" x2="19" y2="12" />
                </svg>
                Thêm website
            </button>

            {open && (
                <div className="modal-overlay" onClick={(e) => e.target === e.currentTarget && setOpen(false)}>
                    <div className="modal glass animate-fade-in">
                        <div className="modal-header">
                            <h2 className="modal-title">Thêm website mới</h2>
                            <button className="modal-close" onClick={() => setOpen(false)}>
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                    <line x1="18" y1="6" x2="6" y2="18" />
                                    <line x1="6" y1="6" x2="18" y2="18" />
                                </svg>
                            </button>
                        </div>

                        <form onSubmit={handleSubmit} className="modal-form">
                            <div className="form-group">
                                <label className="form-label">Tên website *</label>
                                <input
                                    id="site-name-input"
                                    name="name"
                                    type="text"
                                    required
                                    value={name}
                                    onChange={(e) => setName(e.target.value)}
                                    placeholder="Ví dụ: My Blog"
                                    className="form-input"
                                    autoFocus
                                />
                                {name && (
                                    <p className="form-hint">
                                        Slug: <code>{slugify(name)}</code>
                                    </p>
                                )}
                            </div>

                            <div className="form-group">
                                <label className="form-label">Mô tả</label>
                                <textarea
                                    id="site-description-input"
                                    name="description"
                                    value={description}
                                    onChange={(e) => setDescription(e.target.value)}
                                    placeholder="Mô tả ngắn về website..."
                                    className="form-input form-textarea"
                                    rows={3}
                                />
                            </div>

                            <div className="form-group">
                                <label className="form-label">Domain</label>
                                <input
                                    id="site-domain-input"
                                    name="domain"
                                    type="text"
                                    value={domain}
                                    onChange={(e) => setDomain(e.target.value)}
                                    placeholder="blog.example.com"
                                    className="form-input"
                                />
                            </div>

                            {error && (
                                <div className="form-error">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                        <circle cx="12" cy="12" r="10" />
                                        <line x1="15" y1="9" x2="9" y2="15" />
                                        <line x1="9" y1="9" x2="15" y2="15" />
                                    </svg>
                                    {error}
                                </div>
                            )}

                            <div className="modal-footer">
                                <button type="button" onClick={() => setOpen(false)} className="btn-ghost">
                                    Hủy
                                </button>
                                <button
                                    id="site-submit-btn"
                                    type="submit"
                                    disabled={isPending}
                                    className="btn-primary"
                                >
                                    {isPending ? 'Đang tạo...' : 'Tạo website'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            <style jsx>{`
        .btn-primary {
          display: inline-flex;
          align-items: center;
          gap: 0.5rem;
          padding: 0.625rem 1.25rem;
          background: linear-gradient(135deg, hsl(262 83% 65%), hsl(220 83% 65%));
          color: white;
          border: none;
          border-radius: 0.625rem;
          font-size: 0.875rem;
          font-weight: 600;
          font-family: inherit;
          cursor: pointer;
          transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s;
          box-shadow: 0 4px 12px hsl(262 83% 65% / 0.25);
          white-space: nowrap;
        }
        .btn-primary:hover { opacity: 0.9; transform: translateY(-1px); }
        .btn-primary:disabled { opacity: 0.6; cursor: not-allowed; }
        .btn-ghost {
          padding: 0.625rem 1.25rem;
          background: transparent;
          border: 1px solid hsl(var(--border));
          border-radius: 0.625rem;
          color: hsl(var(--muted-foreground));
          font-size: 0.875rem;
          font-family: inherit;
          cursor: pointer;
          transition: all 0.15s;
        }
        .btn-ghost:hover {
          background: hsl(var(--secondary));
          color: hsl(var(--foreground));
        }
        .mt-2 { margin-top: 0.75rem; }
        .modal-overlay {
          position: fixed;
          inset: 0;
          background: hsl(var(--background) / 0.7);
          backdrop-filter: blur(4px);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 100;
          padding: 1rem;
        }
        .modal {
          width: 100%;
          max-width: 480px;
          border-radius: 1.25rem;
          padding: 1.75rem;
        }
        .modal-header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          margin-bottom: 1.5rem;
        }
        .modal-title {
          font-size: 1.125rem;
          font-weight: 700;
        }
        .modal-close {
          display: flex;
          align-items: center;
          justify-content: center;
          width: 32px;
          height: 32px;
          background: hsl(var(--secondary));
          border: none;
          border-radius: 0.5rem;
          color: hsl(var(--muted-foreground));
          cursor: pointer;
          transition: all 0.15s;
        }
        .modal-close:hover {
          background: hsl(var(--border));
          color: hsl(var(--foreground));
        }
        .modal-form {
          display: flex;
          flex-direction: column;
          gap: 1.125rem;
        }
        .modal-footer {
          display: flex;
          justify-content: flex-end;
          gap: 0.75rem;
          padding-top: 0.5rem;
        }
        .form-group {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }
        .form-label {
          font-size: 0.875rem;
          font-weight: 500;
          color: hsl(var(--muted-foreground));
        }
        .form-input {
          width: 100%;
          padding: 0.625rem 0.875rem;
          background: hsl(var(--secondary));
          border: 1px solid hsl(var(--border));
          border-radius: 0.625rem;
          color: hsl(var(--foreground));
          font-size: 0.9375rem;
          font-family: inherit;
          transition: border-color 0.2s, box-shadow 0.2s;
          outline: none;
        }
        .form-input:focus {
          border-color: hsl(var(--primary));
          box-shadow: 0 0 0 3px hsl(var(--primary) / 0.12);
        }
        .form-textarea { resize: vertical; }
        .form-hint {
          font-size: 0.8125rem;
          color: hsl(var(--muted-foreground) / 0.7);
        }
        .form-hint code {
          color: hsl(var(--primary));
          background: hsl(var(--primary) / 0.1);
          padding: 0.1rem 0.35rem;
          border-radius: 0.25rem;
        }
        .form-error {
          display: flex;
          align-items: center;
          gap: 0.5rem;
          padding: 0.625rem 0.875rem;
          background: hsl(var(--destructive) / 0.12);
          border: 1px solid hsl(var(--destructive) / 0.3);
          border-radius: 0.5rem;
          color: hsl(var(--destructive));
          font-size: 0.8125rem;
        }
      `}</style>
        </>
    )
}
