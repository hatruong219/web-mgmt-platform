'use client'

import { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { createDeck, updateDeck, deleteDeck } from '@/app/actions/vocabulary'
import s from '@/app/(dashboard)/shared.module.css'

type Deck = {
    id: string; name: string; description: string | null; slug: string
    emoji: string | null; language_code: string; is_public: boolean
    order_index: number; created_at: string
    vocabulary?: { count: number }[]
}

const LANG_OPTIONS = [
    { value: 'ja', label: '🇯🇵 Tiếng Nhật' },
    { value: 'en', label: '🇺🇸 Tiếng Anh' },
    { value: 'ko', label: '🇰🇷 Tiếng Hàn' },
    { value: 'zh', label: '🇨🇳 Tiếng Trung' },
    { value: 'fr', label: '🇫🇷 Tiếng Pháp' },
]
const EMOJIS = ['📚', '🎯', '⚡', '🌸', '🔥', '💡', '🎓', '🗺️', '🍱', '👋', '🔢', '🎨', '👨‍👩‍👧‍👦']
const COLORS: Record<string, string> = {
    'ja': 'hsl(0 72% 58%)', 'en': 'hsl(220 83% 60%)',
    'ko': 'hsl(262 83% 62%)', 'zh': 'hsl(31 90% 55%)', 'fr': 'hsl(142 72% 42%)',
}

function DeckForm({ siteId, initial, onSave, onCancel }: {
    siteId: string; initial?: Deck; onSave: () => void; onCancel: () => void
}) {
    const [isPending, startTransition] = useTransition()
    const [error, setError] = useState('')
    const [selectedEmoji, setSelectedEmoji] = useState(initial?.emoji ?? '📚')

    const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault()
        setError('')
        const fd = new FormData(e.currentTarget)
        fd.set('site_id', siteId)
        fd.set('emoji', selectedEmoji)

        startTransition(async () => {
            const res = initial
                ? await updateDeck(initial.id, siteId, fd)
                : await createDeck(fd)
            if (res.error) { setError(res.error); return }
            onSave()
        })
    }

    const inputStyle: React.CSSProperties = {
        padding: '0.5625rem 0.875rem', background: 'hsl(var(--secondary))',
        border: '1px solid hsl(var(--border))', borderRadius: '0.5rem',
        color: 'hsl(var(--foreground))', fontSize: '0.9375rem', fontFamily: 'inherit', outline: 'none', width: '100%',
    }

    return (
        <form onSubmit={handleSubmit} style={{ padding: '1.25rem', background: 'hsl(var(--card))', border: '1px solid hsl(var(--border)/0.6)', borderRadius: '0.875rem', display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            <h3 style={{ fontWeight: 600, fontSize: '1rem' }}>{initial ? 'Sửa bộ thẻ' : 'Tạo bộ thẻ mới'}</h3>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
                <div style={{ gridColumn: '1 / -1' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))', display: 'block', marginBottom: '0.3rem' }}>Tên bộ thẻ *</label>
                    <input name="name" defaultValue={initial?.name} required style={inputStyle} placeholder="VD: JLPT N5 — Từ cơ bản" />
                </div>

                <div>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))', display: 'block', marginBottom: '0.3rem' }}>Ngôn ngữ</label>
                    <select name="language_code" defaultValue={initial?.language_code ?? 'ja'} style={{ ...inputStyle }}>
                        {LANG_OPTIONS.map(l => <option key={l.value} value={l.value}>{l.label}</option>)}
                    </select>
                </div>

                <div>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))', display: 'block', marginBottom: '0.3rem' }}>Công khai</label>
                    <select name="is_public" defaultValue={initial?.is_public !== false ? 'true' : 'false'} style={{ ...inputStyle }}>
                        <option value="true">✅ Công khai</option>
                        <option value="false">🔒 Riêng tư</option>
                    </select>
                </div>

                <div style={{ gridColumn: '1 / -1' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))', display: 'block', marginBottom: '0.3rem' }}>Mô tả</label>
                    <textarea name="description" defaultValue={initial?.description ?? ''} rows={2}
                        style={{ ...inputStyle, resize: 'vertical' }} placeholder="Mô tả ngắn về bộ thẻ..." />
                </div>

                <div style={{ gridColumn: '1 / -1' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))', display: 'block', marginBottom: '0.5rem' }}>Emoji</label>
                    <div style={{ display: 'flex', gap: '0.375rem', flexWrap: 'wrap' }}>
                        {EMOJIS.map(e => (
                            <button key={e} type="button" onClick={() => setSelectedEmoji(e)}
                                style={{ fontSize: '1.25rem', width: 38, height: 38, borderRadius: '0.5rem', border: `2px solid ${selectedEmoji === e ? 'hsl(var(--primary))' : 'hsl(var(--border))'}`, background: selectedEmoji === e ? 'hsl(var(--primary)/0.1)' : 'transparent', cursor: 'pointer', transition: 'all 0.15s' }}>
                                {e}
                            </button>
                        ))}
                    </div>
                </div>
            </div>

            {error && <p style={{ fontSize: '0.8125rem', color: 'hsl(var(--destructive))' }}>⚠ {error}</p>}

            <div style={{ display: 'flex', gap: '0.625rem', justifyContent: 'flex-end', paddingTop: '0.5rem', borderTop: '1px solid hsl(var(--border)/0.4)' }}>
                <button type="button" onClick={onCancel} disabled={isPending}
                    style={{ padding: '0.5rem 1rem', background: 'transparent', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--muted-foreground))', cursor: 'pointer', fontSize: '0.875rem' }}>
                    Hủy
                </button>
                <button type="submit" disabled={isPending}
                    style={{ padding: '0.5rem 1.25rem', background: 'linear-gradient(135deg,hsl(262 83% 65%),hsl(220 83% 65%))', border: 'none', borderRadius: '0.5rem', color: 'white', fontWeight: 600, fontSize: '0.875rem', cursor: isPending ? 'not-allowed' : 'pointer', opacity: isPending ? 0.7 : 1 }}>
                    {isPending ? 'Đang lưu...' : (initial ? 'Cập nhật' : 'Tạo bộ thẻ')}
                </button>
            </div>
        </form>
    )
}

export default function DeckManager({ siteId, decks }: { siteId: string; decks: Deck[] }) {
    const router = useRouter()
    const [showForm, setShowForm] = useState(false)
    const [editDeck, setEditDeck] = useState<Deck | null>(null)
    const [deleting, setDeleting] = useState<string | null>(null)
    const [, startTransition] = useTransition()

    const handleDelete = (deck: Deck) => {
        const wordCount = deck.vocabulary?.[0]?.count ?? 0
        const msg = wordCount > 0
            ? `Bộ thẻ "${deck.name}" có ${wordCount} từ vựng. Xóa sẽ mất hết. Tiếp tục?`
            : `Xóa bộ thẻ "${deck.name}"?`
        if (!confirm(msg)) return
        setDeleting(deck.id)
        startTransition(async () => {
            await deleteDeck(deck.id, siteId)
            setDeleting(null)
            router.refresh()
        })
    }

    return (
        <div>
            <div className={s.pageHeader}>
                <div>
                    <h1 className={s.pageTitle}>Bộ thẻ</h1>
                    <p className={s.pageSubtitle}>{decks.length} bộ thẻ · {decks.reduce((acc, d) => acc + (d.vocabulary?.[0]?.count ?? 0), 0)} từ vựng</p>
                </div>
                <button id="create-deck-btn" onClick={() => { setShowForm(true); setEditDeck(null) }} className={s.btnPrimary}>
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><line x1="12" y1="5" x2="12" y2="19" /><line x1="5" y1="12" x2="19" y2="12" /></svg>
                    Tạo bộ thẻ
                </button>
            </div>

            {(showForm || editDeck) && (
                <div style={{ marginBottom: '1.5rem' }}>
                    <DeckForm
                        siteId={siteId}
                        initial={editDeck ?? undefined}
                        onSave={() => { setShowForm(false); setEditDeck(null); router.refresh() }}
                        onCancel={() => { setShowForm(false); setEditDeck(null) }}
                    />
                </div>
            )}

            {decks.length === 0 ? (
                <div className={`${s.emptyState} glass`}>
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                        <polygon points="12 2 2 7 12 12 22 7 12 2" /><polyline points="2 17 12 22 22 17" /><polyline points="2 12 12 17 22 12" />
                    </svg>
                    <h3 className={s.emptyTitle}>Chưa có bộ thẻ nào</h3>
                    <p>Tạo bộ thẻ để phân loại từ vựng</p>
                </div>
            ) : (
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))', gap: '1rem' }}>
                    {decks.map(deck => {
                        const color = COLORS[deck.language_code] ?? 'hsl(220 83% 60%)'
                        const wordCount = deck.vocabulary?.[0]?.count ?? 0
                        return (
                            <div key={deck.id} className="glass" style={{ borderRadius: '0.875rem', overflow: 'hidden', border: '1px solid hsl(var(--border)/0.6)', transition: 'transform 0.15s, box-shadow 0.15s', cursor: 'default' }}
                                onMouseEnter={e => { (e.currentTarget as HTMLElement).style.transform = 'translateY(-2px)'; (e.currentTarget as HTMLElement).style.boxShadow = `0 8px 24px ${color}25` }}
                                onMouseLeave={e => { (e.currentTarget as HTMLElement).style.transform = 'none'; (e.currentTarget as HTMLElement).style.boxShadow = 'none' }}>
                                {/* Card Header */}
                                <div style={{ padding: '1.25rem 1.25rem 1rem', borderBottom: '1px solid hsl(var(--border)/0.3)' }}>
                                    <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: '0.5rem' }}>
                                        <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                                            <div style={{ width: 44, height: 44, borderRadius: '0.75rem', background: `${color}18`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '1.375rem', flexShrink: 0, border: `1px solid ${color}30` }}>
                                                {deck.emoji ?? '📚'}
                                            </div>
                                            <div>
                                                <h3 style={{ fontWeight: 600, fontSize: '1rem', lineHeight: 1.3 }}>{deck.name}</h3>
                                                <span style={{ fontSize: '0.75rem', color: 'hsl(var(--muted-foreground))' }}>
                                                    {LANG_OPTIONS.find(l => l.value === deck.language_code)?.label ?? deck.language_code}
                                                </span>
                                            </div>
                                        </div>
                                        <div style={{ display: 'flex', gap: '0.25rem', flexShrink: 0 }}>
                                            <button onClick={() => { setEditDeck(deck); setShowForm(false) }}
                                                title="Sửa" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', width: 28, height: 28, background: 'transparent', border: '1px solid hsl(var(--border))', borderRadius: '0.375rem', color: 'hsl(var(--muted-foreground))', cursor: 'pointer' }}>
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" /><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" /></svg>
                                            </button>
                                            <button onClick={() => handleDelete(deck)} disabled={deleting === deck.id}
                                                title="Xóa" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', width: 28, height: 28, background: 'transparent', border: '1px solid hsl(var(--destructive)/0.3)', borderRadius: '0.375rem', color: 'hsl(var(--destructive))', cursor: 'pointer', opacity: deleting === deck.id ? 0.5 : 1 }}>
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="3 6 5 6 21 6" /><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6" /></svg>
                                            </button>
                                        </div>
                                    </div>
                                    {deck.description && <p style={{ marginTop: '0.625rem', fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))', lineHeight: 1.5 }}>{deck.description}</p>}
                                </div>

                                {/* Card Footer */}
                                <div style={{ padding: '0.875rem 1.25rem', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '0.375rem', fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))' }}>
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z" /><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z" /></svg>
                                        <strong style={{ color: 'hsl(var(--foreground))' }}>{wordCount}</strong> từ vựng
                                    </div>
                                    <div style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
                                        {!deck.is_public && <span style={{ fontSize: '0.6875rem', padding: '0.1rem 0.4rem', background: 'hsl(var(--secondary))', borderRadius: '0.375rem', color: 'hsl(var(--muted-foreground))' }}>🔒 Riêng tư</span>}
                                        <a href={`/sites/${siteId}/vocabulary?deckId=${deck.id}`}
                                            style={{ fontSize: '0.8125rem', color: `${color}`, fontWeight: 500, textDecoration: 'none', display: 'flex', alignItems: 'center', gap: '0.2rem' }}>
                                            Xem từ <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="9 18 15 12 9 6" /></svg>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        )
                    })}
                </div>
            )}
        </div>
    )
}
