'use client'

import { useState, useTransition, useRef } from 'react'
import { useRouter } from 'next/navigation'
import { createVocabWord, updateVocabWord, deleteVocabWord } from '@/app/actions/vocabulary'
import s from '@/app/(dashboard)/shared.module.css'

type VocabWord = {
    id: string
    word: string
    reading: string | null
    romanization: string | null
    meaning_vi: string
    meaning_en: string | null
    part_of_speech: string | null
    jlpt_level: string | null
    language_code: string
    tags: string[]
    is_active: boolean
    deck_id: string
    order_index: number
    created_at: string
}

type Deck = { id: string; name: string; emoji: string | null; language_code: string }

interface Props {
    siteId: string
    words: VocabWord[]
    decks: Deck[]
    totalCount: number
    totalWords: number
    currentPage: number
    totalPages: number
    filters: { q?: string; deckId?: string; jlpt?: string }
}

const JLPT_LEVELS = ['N1', 'N2', 'N3', 'N4', 'N5']
const POS_LIST = ['名詞', '動詞', '形容詞', '副詞', '助詞', '助動詞', '感動詞', '接続詞', 'その他']

function WordForm({
    siteId, decks, initial, onSave, onCancel,
}: {
    siteId: string
    decks: Deck[]
    initial?: VocabWord
    onSave: () => void
    onCancel: () => void
}) {
    const [isPending, startTransition] = useTransition()
    const [error, setError] = useState('')
    const formRef = useRef<HTMLFormElement>(null)

    const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault()
        setError('')
        const fd = new FormData(e.currentTarget)
        fd.set('site_id', siteId)

        startTransition(async () => {
            const res = initial
                ? await updateVocabWord(initial.id, siteId, fd)
                : await createVocabWord(fd)
            if (res.error) { setError(res.error); return }
            onSave()
        })
    }

    return (
        <form ref={formRef} onSubmit={handleSubmit} style={{
            display: 'flex', flexDirection: 'column', gap: '0.875rem',
            padding: '1.25rem', background: 'hsl(var(--card))',
            border: '1px solid hsl(var(--border) / 0.6)', borderRadius: '0.875rem',
        }}>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '0.75rem' }}>
                {/* Word */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.3rem' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))' }}>Từ *</label>
                    <input name="word" defaultValue={initial?.word} required
                        style={{ padding: '0.5rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--foreground))', fontSize: '0.9375rem', fontFamily: 'inherit', outline: 'none' }}
                    />
                </div>
                {/* Reading */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.3rem' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))' }}>Cách đọc (ふりがな)</label>
                    <input name="reading" defaultValue={initial?.reading ?? ''}
                        style={{ padding: '0.5rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--foreground))', fontSize: '0.9375rem', fontFamily: 'inherit', outline: 'none' }}
                    />
                </div>
                {/* Romanization */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.3rem' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))' }}>Romaji</label>
                    <input name="romanization" defaultValue={initial?.romanization ?? ''}
                        style={{ padding: '0.5rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--foreground))', fontSize: '0.9375rem', fontFamily: 'inherit', outline: 'none' }}
                    />
                </div>

                {/* Meaning VI */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.3rem' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))' }}>Nghĩa tiếng Việt *</label>
                    <input name="meaning_vi" defaultValue={initial?.meaning_vi} required
                        style={{ padding: '0.5rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--foreground))', fontSize: '0.9375rem', fontFamily: 'inherit', outline: 'none' }}
                    />
                </div>
                {/* Meaning EN */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.3rem' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))' }}>Nghĩa tiếng Anh</label>
                    <input name="meaning_en" defaultValue={initial?.meaning_en ?? ''}
                        style={{ padding: '0.5rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--foreground))', fontSize: '0.9375rem', fontFamily: 'inherit', outline: 'none' }}
                    />
                </div>

                {/* Deck */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.3rem' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))' }}>Bộ thẻ *</label>
                    <select name="deck_id" defaultValue={initial?.deck_id} required
                        style={{ padding: '0.5rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--foreground))', fontSize: '0.875rem', fontFamily: 'inherit', outline: 'none' }}
                    >
                        <option value="">— Chọn bộ thẻ —</option>
                        {decks.map(d => (
                            <option key={d.id} value={d.id}>{d.emoji} {d.name}</option>
                        ))}
                    </select>
                </div>

                {/* Part of speech */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.3rem' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))' }}>Từ loại</label>
                    <select name="part_of_speech" defaultValue={initial?.part_of_speech ?? ''}
                        style={{ padding: '0.5rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--foreground))', fontSize: '0.875rem', fontFamily: 'inherit', outline: 'none' }}
                    >
                        <option value="">—</option>
                        {POS_LIST.map(p => <option key={p} value={p}>{p}</option>)}
                    </select>
                </div>

                {/* JLPT */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.3rem' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))' }}>JLPT Level</label>
                    <select name="jlpt_level" defaultValue={initial?.jlpt_level ?? ''}
                        style={{ padding: '0.5rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--foreground))', fontSize: '0.875rem', fontFamily: 'inherit', outline: 'none' }}
                    >
                        <option value="">—</option>
                        {JLPT_LEVELS.map(lvl => <option key={lvl} value={lvl}>{lvl}</option>)}
                    </select>
                </div>

                {/* Tags */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.3rem' }}>
                    <label style={{ fontSize: '0.75rem', fontWeight: 600, color: 'hsl(var(--muted-foreground))' }}>Tags (phân cách bằng dấu phẩy)</label>
                    <input name="tags" defaultValue={initial?.tags?.join(', ') ?? ''}
                        placeholder="greeting, daily, ..."
                        style={{ padding: '0.5rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--foreground))', fontSize: '0.875rem', fontFamily: 'inherit', outline: 'none' }}
                    />
                </div>
            </div>

            {error && <p style={{ fontSize: '0.8125rem', color: 'hsl(var(--destructive))' }}>⚠ {error}</p>}

            <div style={{ display: 'flex', gap: '0.625rem', justifyContent: 'flex-end', paddingTop: '0.5rem', borderTop: '1px solid hsl(var(--border) / 0.4)' }}>
                <button type="button" onClick={onCancel} disabled={isPending}
                    style={{ padding: '0.5rem 1rem', background: 'transparent', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--muted-foreground))', cursor: 'pointer', fontSize: '0.875rem' }}>
                    Hủy
                </button>
                <button type="submit" disabled={isPending}
                    style={{ padding: '0.5rem 1.25rem', background: 'linear-gradient(135deg,hsl(262 83% 65%),hsl(220 83% 65%))', border: 'none', borderRadius: '0.5rem', color: 'white', fontWeight: 600, fontSize: '0.875rem', cursor: isPending ? 'not-allowed' : 'pointer', opacity: isPending ? 0.7 : 1 }}>
                    {isPending ? 'Đang lưu...' : (initial ? 'Cập nhật' : 'Thêm từ')}
                </button>
            </div>
        </form>
    )
}

function JlptBadge({ level }: { level: string | null }) {
    if (!level) return null
    const colors: Record<string, string> = {
        N1: 'hsl(0 72% 55%)', N2: 'hsl(25 90% 55%)', N3: 'hsl(38 92% 50%)',
        N4: 'hsl(142 72% 42%)', N5: 'hsl(220 83% 60%)',
    }
    const color = colors[level] || 'hsl(var(--muted-foreground))'
    return (
        <span style={{ fontSize: '0.6875rem', fontWeight: 700, padding: '0.1rem 0.4rem', borderRadius: '0.375rem', background: `color-mix(in srgb, ${color} 15%, transparent)`, color, letterSpacing: '0.04em' }}>
            {level}
        </span>
    )
}

export default function VocabularyList({ siteId, words, decks, totalCount, totalWords, currentPage, totalPages, filters }: Props) {
    const router = useRouter()
    const [showForm, setShowForm] = useState(false)
    const [editWord, setEditWord] = useState<VocabWord | null>(null)
    const [deleting, setDeleting] = useState<string | null>(null)
    const [isPending, startTransition] = useTransition()

    const [q, setQ] = useState(filters.q ?? '')
    const [deckId, setDeckId] = useState(filters.deckId ?? '')
    const [jlpt, setJlpt] = useState(filters.jlpt ?? '')

    const pushFilter = ({ qv = q, dv = deckId, jv = jlpt }: { qv?: string; dv?: string; jv?: string }) => {
        const params = new URLSearchParams()
        if (qv) params.set('q', qv)
        if (dv) params.set('deckId', dv)
        if (jv) params.set('jlpt', jv)
        router.push(`/sites/${siteId}/vocabulary?${params.toString()}`)
    }

    const handleDelete = (id: string) => {
        if (!confirm('Xóa từ này?')) return
        setDeleting(id)
        startTransition(async () => {
            await deleteVocabWord(id, siteId)
            setDeleting(null)
        })
    }

    return (
        <div>
            {/* Header */}
            <div className={s.pageHeader}>
                <div>
                    <h1 className={s.pageTitle}>Từ vựng</h1>
                    <p className={s.pageSubtitle}>{totalWords.toLocaleString()} từ · {decks.length} bộ thẻ</p>
                </div>
                <div style={{ display: 'flex', gap: '0.625rem' }}>
                    <a href={`/sites/${siteId}/import`} style={{ display: 'inline-flex', alignItems: 'center', gap: '0.375rem', padding: '0.5rem 1rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.625rem', color: 'hsl(var(--foreground))', fontSize: '0.875rem', fontWeight: 500, textDecoration: 'none' }}>
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" /><polyline points="17 8 12 3 7 8" /><line x1="12" y1="3" x2="12" y2="15" /></svg>
                        Import CSV
                    </a>
                    <button id="add-vocab-btn" onClick={() => { setShowForm(true); setEditWord(null) }}
                        className={s.btnPrimary}>
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><line x1="12" y1="5" x2="12" y2="19" /><line x1="5" y1="12" x2="19" y2="12" /></svg>
                        Thêm từ mới
                    </button>
                </div>
            </div>

            {/* Add / Edit form */}
            {(showForm || editWord) && (
                <div style={{ marginBottom: '1.25rem' }}>
                    <WordForm
                        siteId={siteId}
                        decks={decks}
                        initial={editWord ?? undefined}
                        onSave={() => { setShowForm(false); setEditWord(null); router.refresh() }}
                        onCancel={() => { setShowForm(false); setEditWord(null) }}
                    />
                </div>
            )}

            {/* Filters */}
            <div style={{ display: 'flex', gap: '0.75rem', marginBottom: '1rem', flexWrap: 'wrap' }}>
                <input
                    value={q}
                    onChange={e => setQ(e.target.value)}
                    onKeyDown={e => e.key === 'Enter' && pushFilter({ qv: q })}
                    placeholder="Tìm từ, nghĩa..."
                    style={{ flex: 1, minWidth: 180, padding: '0.5rem 0.875rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.625rem', color: 'hsl(var(--foreground))', fontSize: '0.875rem', outline: 'none' }}
                />
                <select value={deckId} onChange={e => { setDeckId(e.target.value); pushFilter({ dv: e.target.value }) }}
                    style={{ padding: '0.5rem 0.875rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.625rem', color: 'hsl(var(--foreground))', fontSize: '0.875rem', outline: 'none', cursor: 'pointer' }}>
                    <option value="">Tất cả bộ thẻ</option>
                    {decks.map(d => <option key={d.id} value={d.id}>{d.emoji} {d.name}</option>)}
                </select>
                <select value={jlpt} onChange={e => { setJlpt(e.target.value); pushFilter({ jv: e.target.value }) }}
                    style={{ padding: '0.5rem 0.875rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.625rem', color: 'hsl(var(--foreground))', fontSize: '0.875rem', outline: 'none', cursor: 'pointer' }}>
                    <option value="">Tất cả JLPT</option>
                    {JLPT_LEVELS.map(l => <option key={l} value={l}>{l}</option>)}
                </select>
                {(q || deckId || jlpt) && (
                    <button onClick={() => { setQ(''); setDeckId(''); setJlpt(''); router.push(`/sites/${siteId}/vocabulary`) }}
                        style={{ padding: '0.5rem 0.75rem', background: 'transparent', border: '1px solid hsl(var(--border))', borderRadius: '0.625rem', color: 'hsl(var(--muted-foreground))', fontSize: '0.8125rem', cursor: 'pointer' }}>
                        Xóa bộ lọc
                    </button>
                )}
            </div>

            {/* Table */}
            {words.length === 0 ? (
                <div className={`${s.emptyState} glass`}>
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z" /><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z" />
                    </svg>
                    <h3 className={s.emptyTitle}>Chưa có từ vựng nào</h3>
                    <p>Thêm từ mới hoặc import hàng loạt qua CSV</p>
                </div>
            ) : (
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.375rem' }}>
                    {/* Header row */}
                    <div style={{ display: 'grid', gridTemplateColumns: '2fr 2fr 2fr 1fr 90px 80px', gap: '0.75rem', padding: '0.5rem 1rem', fontSize: '0.6875rem', fontWeight: 700, color: 'hsl(var(--muted-foreground))', textTransform: 'uppercase', letterSpacing: '0.06em' }}>
                        <div>Từ / Cách đọc</div><div>Nghĩa</div><div>Bộ thẻ</div><div>JLPT</div><div>Từ loại</div><div></div>
                    </div>

                    {words.map(w => (
                        <div key={w.id} className="glass" style={{ display: 'grid', gridTemplateColumns: '2fr 2fr 2fr 1fr 90px 80px', gap: '0.75rem', padding: '0.75rem 1rem', borderRadius: '0.75rem', alignItems: 'center', opacity: w.is_active ? 1 : 0.5, transition: 'opacity 0.2s' }}>
                            {/* Word */}
                            <div>
                                <div style={{ fontSize: '1.0625rem', fontWeight: 600, letterSpacing: '0.02em' }}>{w.word}</div>
                                {w.reading && <div style={{ fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))' }}>{w.reading}</div>}
                                {w.romanization && <div style={{ fontSize: '0.75rem', color: 'hsl(var(--muted-foreground) / 0.7)', fontStyle: 'italic' }}>{w.romanization}</div>}
                            </div>
                            {/* Meaning */}
                            <div>
                                <div style={{ fontSize: '0.9375rem' }}>{w.meaning_vi}</div>
                                {w.meaning_en && <div style={{ fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))' }}>{w.meaning_en}</div>}
                                {w.tags.length > 0 && (
                                    <div style={{ display: 'flex', gap: '0.25rem', flexWrap: 'wrap', marginTop: '0.25rem' }}>
                                        {w.tags.slice(0, 3).map(t => <span key={t} style={{ fontSize: '0.625rem', padding: '0.1rem 0.35rem', background: 'hsl(var(--secondary))', borderRadius: '9999px', color: 'hsl(var(--muted-foreground))' }}>#{t}</span>)}
                                    </div>
                                )}
                            </div>
                            {/* Deck */}
                            <div style={{ fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))' }}>
                                {decks.find(d => d.id === w.deck_id)?.name ?? '—'}
                            </div>
                            {/* JLPT */}
                            <div><JlptBadge level={w.jlpt_level} /></div>
                            {/* Part of speech */}
                            <div style={{ fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))' }}>{w.part_of_speech ?? '—'}</div>
                            {/* Actions */}
                            <div style={{ display: 'flex', gap: '0.375rem', justifyContent: 'flex-end' }}>
                                <button onClick={() => { setEditWord(w); setShowForm(false) }}
                                    title="Sửa" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', width: 28, height: 28, background: 'transparent', border: '1px solid hsl(var(--border))', borderRadius: '0.375rem', color: 'hsl(var(--muted-foreground))', cursor: 'pointer' }}>
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" /><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" /></svg>
                                </button>
                                <button onClick={() => handleDelete(w.id)} disabled={deleting === w.id}
                                    title="Xóa" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', width: 28, height: 28, background: 'transparent', border: '1px solid hsl(var(--destructive) / 0.3)', borderRadius: '0.375rem', color: 'hsl(var(--destructive))', cursor: 'pointer', opacity: deleting === w.id ? 0.5 : 1 }}>
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="3 6 5 6 21 6" /><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6" /><path d="M10 11v6M14 11v6" /></svg>
                                </button>
                            </div>
                        </div>
                    ))}
                </div>
            )}

            {/* Pagination */}
            {totalPages > 1 && (
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginTop: '1.5rem', padding: '0.875rem 1rem', background: 'hsl(var(--card))', border: '1px solid hsl(var(--border) / 0.5)', borderRadius: '0.75rem' }}>
                    <span style={{ fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))' }}>
                        {((currentPage - 1) * 30) + 1}–{Math.min(currentPage * 30, totalCount)} / {totalCount} từ
                    </span>
                    <div style={{ display: 'flex', gap: '0.375rem' }}>
                        {currentPage > 1 && (
                            <button onClick={() => router.push(`/sites/${siteId}/vocabulary?${new URLSearchParams({ ...(q && { q }), ...(deckId && { deckId }), ...(jlpt && { jlpt }), page: String(currentPage - 1) })}`)}
                                style={{ padding: '0.375rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', cursor: 'pointer', fontSize: '0.8125rem', color: 'hsl(var(--foreground))' }}>← Trước</button>
                        )}
                        {currentPage < totalPages && (
                            <button onClick={() => router.push(`/sites/${siteId}/vocabulary?${new URLSearchParams({ ...(q && { q }), ...(deckId && { deckId }), ...(jlpt && { jlpt }), page: String(currentPage + 1) })}`)}
                                style={{ padding: '0.375rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', cursor: 'pointer', fontSize: '0.8125rem', color: 'hsl(var(--foreground))' }}>Tiếp →</button>
                        )}
                    </div>
                </div>
            )}
        </div>
    )
}
