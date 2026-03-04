'use client'

import { useState, useTransition, useRef, useCallback } from 'react'
import { toRomaji } from 'wanakana'
import { useRouter } from 'next/navigation'
import { bulkImportVocab } from '@/app/actions/vocabulary'
import s from '@/app/(dashboard)/shared.module.css'

type Deck = { id: string; name: string; emoji: string | null }

type ParsedRow = {
    word: string; reading?: string; romanization?: string
    meaning_vi: string; meaning_en?: string
    part_of_speech?: string; jlpt_level?: string; tags?: string
    _valid: boolean; _error?: string
}

// romanization không cần — tự động generate từ reading bằng wanakana
const CSV_COLUMNS = ['word', 'reading', 'meaning_vi', 'meaning_en', 'part_of_speech', 'jlpt_level', 'tags']
const REQUIRED = ['word', 'meaning_vi']

// Template không có cột romanization — tự động tạo từ hiragana (reading)
const TEMPLATE_CSV = `word,reading,meaning_vi,meaning_en,part_of_speech,jlpt_level,tags
こんにちは,こんにちは,Xin chào (ban ngày),Hello,感動詞,N5,greeting
ありがとう,ありがとう,Cảm ơn,Thank you,感動詞,N5,greeting
私,わたし,Tôi,I/Me,名詞,N5,
`

function parseCSV(text: string): ParsedRow[] {
    const lines = text.trim().split('\n').filter(l => l.trim())
    if (lines.length < 2) return []

    const headers = lines[0].split(',').map(h => h.trim().toLowerCase().replace(/"/g, ''))

    return lines.slice(1).map((line, i) => {
        // Handle quoted fields
        const values: string[] = []
        let inQuote = false, cur = ''
        for (const ch of line) {
            if (ch === '"') { inQuote = !inQuote; continue }
            if (ch === ',' && !inQuote) { values.push(cur.trim()); cur = ''; continue }
            cur += ch
        }
        values.push(cur.trim())

        const row: Record<string, string> = {}
        headers.forEach((h, idx) => { row[h] = values[idx] ?? '' })

        const reading = row['reading'] || undefined
        const parsed: ParsedRow = {
            word: row['word'] ?? '',
            reading,
            // auto-generate romaji từ hiragana bằng wanakana
            romanization: reading ? toRomaji(reading) : undefined,
            meaning_vi: row['meaning_vi'] ?? '',
            meaning_en: row['meaning_en'] || undefined,
            part_of_speech: row['part_of_speech'] || undefined,
            jlpt_level: row['jlpt_level'] || undefined,
            tags: row['tags'] || undefined,
            _valid: true,
        }

        // Validate
        const missing = REQUIRED.filter(k => !row[k]?.trim())
        if (missing.length) {
            parsed._valid = false
            parsed._error = `Thiếu: ${missing.join(', ')}`
        }

        return parsed
    })
}

export default function VocabImporter({ siteId, decks }: { siteId: string; decks: Deck[] }) {
    const router = useRouter()
    const fileRef = useRef<HTMLInputElement>(null)
    const [isPending, startTransition] = useTransition()
    const [isDragging, setIsDragging] = useState(false)
    const [rows, setRows] = useState<ParsedRow[]>([])
    const [selectedDeck, setSelectedDeck] = useState(decks[0]?.id ?? '')
    const [fileName, setFileName] = useState('')
    const [result, setResult] = useState<{ count?: number; error?: string } | null>(null)

    const processFile = (file: File) => {
        if (!file.name.endsWith('.csv')) {
            alert('Vui lòng chọn file .csv')
            return
        }
        setFileName(file.name)
        setResult(null)
        const reader = new FileReader()
        reader.onload = (e) => {
            const text = e.target?.result as string
            setRows(parseCSV(text))
        }
        reader.readAsText(file, 'UTF-8')
    }

    const onDrop = useCallback((e: React.DragEvent) => {
        e.preventDefault()
        setIsDragging(false)
        const file = e.dataTransfer.files[0]
        if (file) processFile(file)
    }, [])

    const validRows = rows.filter(r => r._valid)
    const invalidRows = rows.filter(r => !r._valid)

    const handleImport = () => {
        if (!selectedDeck) { alert('Vui lòng chọn bộ thẻ'); return }
        if (validRows.length === 0) { alert('Không có dòng hợp lệ để import'); return }
        if (!confirm(`Import ${validRows.length} từ vựng vào bộ thẻ đã chọn?`)) return

        startTransition(async () => {
            const res = await bulkImportVocab(siteId, selectedDeck, validRows)
            setResult(res)
            if (res.success) {
                setRows([])
                setFileName('')
            }
        })
    }

    return (
        <div style={{ maxWidth: 860, margin: '0 auto' }}>
            {/* Header */}
            <div className={s.pageHeader}>
                <div>
                    <h1 className={s.pageTitle}>Import từ vựng</h1>
                    <p className={s.pageSubtitle}>Upload file CSV để nhập hàng loạt từ vựng</p>
                </div>
                <a
                    href={`data:text/csv;charset=utf-8,${encodeURIComponent(TEMPLATE_CSV)}`}
                    download="vocab-template.csv"
                    style={{ display: 'inline-flex', alignItems: 'center', gap: '0.375rem', padding: '0.5rem 1rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.625rem', color: 'hsl(var(--foreground))', fontSize: '0.875rem', fontWeight: 500, textDecoration: 'none' }}
                >
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" /><polyline points="7 10 12 15 17 10" /><line x1="12" y1="15" x2="12" y2="3" /></svg>
                    Tải template CSV
                </a>
            </div>

            {/* Format guide */}
            <div className="glass" style={{ padding: '1rem 1.25rem', borderRadius: '0.875rem', marginBottom: '1.25rem', borderLeft: '3px solid hsl(220 83% 60%)' }}>
                <p style={{ fontSize: '0.8125rem', fontWeight: 600, marginBottom: '0.375rem' }}>📋 Định dạng CSV</p>
                <code style={{ fontSize: '0.75rem', color: 'hsl(var(--muted-foreground))', fontFamily: 'monospace', display: 'block', lineHeight: 1.8 }}>
                    word, reading, romanization, meaning_vi*, meaning_en, part_of_speech, jlpt_level, tags
                </code>
                <p style={{ fontSize: '0.75rem', color: 'hsl(var(--muted-foreground))', marginTop: '0.375rem' }}>
                    * Bắt buộc: <strong>word</strong>, <strong>meaning_vi</strong>. Tags phân cách bằng dấu phẩy trong ngoặc kép.
                </p>
            </div>

            {/* Drop zone */}
            <div
                onDragOver={e => { e.preventDefault(); setIsDragging(true) }}
                onDragLeave={() => setIsDragging(false)}
                onDrop={onDrop}
                onClick={() => fileRef.current?.click()}
                style={{
                    marginBottom: '1.25rem', padding: '3rem 2rem', borderRadius: '1rem', textAlign: 'center', cursor: 'pointer',
                    border: `2px dashed ${isDragging ? 'hsl(var(--primary))' : 'hsl(var(--border))'}`,
                    background: isDragging ? 'hsl(var(--primary)/0.05)' : 'hsl(var(--card)/0.4)',
                    transition: 'all 0.2s',
                }}
            >
                <input ref={fileRef} type="file" accept=".csv" style={{ display: 'none' }}
                    onChange={e => { const f = e.target.files?.[0]; if (f) processFile(f) }}
                />
                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5"
                    style={{ color: isDragging ? 'hsl(var(--primary))' : 'hsl(var(--muted-foreground))', margin: '0 auto 0.875rem', display: 'block' }}>
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                    <polyline points="17 8 12 3 7 8" /><line x1="12" y1="3" x2="12" y2="15" />
                </svg>
                {fileName ? (
                    <p style={{ fontWeight: 600, color: 'hsl(var(--foreground))' }}>📄 {fileName}</p>
                ) : (
                    <>
                        <p style={{ fontWeight: 600, color: isDragging ? 'hsl(var(--primary))' : 'hsl(var(--foreground))' }}>
                            {isDragging ? 'Thả file vào đây' : 'Kéo thả file CSV vào đây'}
                        </p>
                        <p style={{ fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))', marginTop: '0.25rem' }}>hoặc click để chọn file</p>
                    </>
                )}
            </div>

            {/* Result */}
            {result && (
                <div style={{
                    padding: '0.875rem 1.125rem', borderRadius: '0.75rem', marginBottom: '1.25rem',
                    background: result.error ? 'hsl(var(--destructive)/0.08)' : 'hsl(142 72% 42%/0.08)',
                    border: `1px solid ${result.error ? 'hsl(var(--destructive)/0.3)' : 'hsl(142 72% 42%/0.3)'}`,
                    color: result.error ? 'hsl(var(--destructive))' : 'hsl(142 72% 42%)',
                    fontSize: '0.9rem', fontWeight: 500, display: 'flex', alignItems: 'center', gap: '0.5rem',
                }}>
                    {result.error
                        ? <><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="12" r="10" /><line x1="15" y1="9" x2="9" y2="15" /><line x1="9" y1="9" x2="15" y2="15" /></svg> Lỗi: {result.error}</>
                        : <><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="20 6 9 17 4 12" /></svg> Import thành công {result.count} từ vựng!</>
                    }
                </div>
            )}

            {/* Preview */}
            {rows.length > 0 && (
                <div>
                    {/* Stats + Deck selector */}
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '0.875rem', flexWrap: 'wrap', gap: '0.75rem' }}>
                        <div style={{ display: 'flex', gap: '0.75rem' }}>
                            <span style={{ fontSize: '0.875rem', fontWeight: 600, color: 'hsl(142 72% 42%)' }}>✅ {validRows.length} hợp lệ</span>
                            {invalidRows.length > 0 && <span style={{ fontSize: '0.875rem', fontWeight: 600, color: 'hsl(var(--destructive))' }}>❌ {invalidRows.length} lỗi</span>}
                        </div>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '0.625rem' }}>
                            <label style={{ fontSize: '0.8125rem', fontWeight: 500, color: 'hsl(var(--muted-foreground))' }}>Import vào bộ thẻ:</label>
                            <select value={selectedDeck} onChange={e => setSelectedDeck(e.target.value)}
                                style={{ padding: '0.4rem 0.75rem', background: 'hsl(var(--secondary))', border: '1px solid hsl(var(--border))', borderRadius: '0.5rem', color: 'hsl(var(--foreground))', fontSize: '0.875rem', outline: 'none' }}>
                                {decks.length === 0 && <option value="">— Chưa có bộ thẻ —</option>}
                                {decks.map(d => <option key={d.id} value={d.id}>{d.emoji} {d.name}</option>)}
                            </select>
                            <button id="start-import-btn" onClick={handleImport} disabled={isPending || validRows.length === 0 || !selectedDeck}
                                style={{ padding: '0.4rem 1.125rem', background: 'linear-gradient(135deg,hsl(262 83% 65%),hsl(220 83% 65%))', border: 'none', borderRadius: '0.5rem', color: 'white', fontWeight: 600, fontSize: '0.875rem', cursor: isPending ? 'not-allowed' : 'pointer', opacity: isPending || validRows.length === 0 ? 0.6 : 1, whiteSpace: 'nowrap' }}>
                                {isPending ? 'Đang import...' : `Import ${validRows.length} từ`}
                            </button>
                        </div>
                    </div>

                    {/* Preview table */}
                    <div style={{ borderRadius: '0.875rem', border: '1px solid hsl(var(--border)/0.6)', overflow: 'hidden' }}>
                        <div style={{ display: 'grid', gridTemplateColumns: '1.5fr 1.2fr 1.5fr 0.8fr 0.8fr 100px', gap: '0.625rem', padding: '0.625rem 1rem', fontSize: '0.6875rem', fontWeight: 700, color: 'hsl(var(--muted-foreground))', textTransform: 'uppercase', letterSpacing: '0.06em', background: 'hsl(var(--secondary))' }}>
                            <div>Từ</div><div>Cách đọc</div><div>Nghĩa VI</div><div>JLPT</div><div>Từ loại</div><div>Trạng thái</div>
                        </div>
                        <div style={{ maxHeight: 400, overflowY: 'auto' }}>
                            {rows.map((row, i) => (
                                <div key={i} style={{ display: 'grid', gridTemplateColumns: '1.5fr 1.2fr 1.5fr 0.8fr 0.8fr 100px', gap: '0.625rem', padding: '0.625rem 1rem', borderTop: '1px solid hsl(var(--border)/0.4)', alignItems: 'center', background: row._valid ? 'transparent' : 'hsl(var(--destructive)/0.04)' }}>
                                    <div style={{ fontWeight: 500, fontSize: '0.9375rem' }}>{row.word || <span style={{ color: 'hsl(var(--destructive))' }}>—</span>}</div>
                                    <div style={{ fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))' }}>{row.reading || '—'}</div>
                                    <div style={{ fontSize: '0.875rem' }}>{row.meaning_vi || <span style={{ color: 'hsl(var(--destructive))' }}>—</span>}</div>
                                    <div style={{ fontSize: '0.8125rem' }}>{row.jlpt_level || '—'}</div>
                                    <div style={{ fontSize: '0.8125rem', color: 'hsl(var(--muted-foreground))' }}>{row.part_of_speech || '—'}</div>
                                    <div>
                                        {row._valid
                                            ? <span style={{ fontSize: '0.75rem', color: 'hsl(142 72% 42%)', fontWeight: 600 }}>✅ OK</span>
                                            : <span style={{ fontSize: '0.75rem', color: 'hsl(var(--destructive))', fontWeight: 600 }} title={row._error}>❌ {row._error}</span>
                                        }
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            )}
        </div>
    )
}
