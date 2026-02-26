'use client'

import { useRouter, usePathname } from 'next/navigation'
import { useState } from 'react'

interface Props {
    currentStatus: string
    currentQuery: string
    siteId: string
}

const STATUSES = [
    { value: 'all', label: 'Tất cả' },
    { value: 'draft', label: 'Bản nháp' },
    { value: 'published', label: 'Đã xuất bản' },
    { value: 'archived', label: 'Lưu trữ' },
]

export default function ArticleFilters({ currentStatus, currentQuery, siteId }: Props) {
    const router = useRouter()
    const [query, setQuery] = useState(currentQuery)

    const updateFilters = (status?: string, q?: string) => {
        const params = new URLSearchParams()
        const s = status ?? currentStatus
        const search = q ?? query
        if (s && s !== 'all') params.set('status', s)
        if (search) params.set('q', search)
        router.push(`/sites/${siteId}/articles?${params.toString()}`)
    }

    const handleSearch = (e: React.FormEvent) => {
        e.preventDefault()
        updateFilters(undefined, query)
    }

    return (
        <div className="filters">
            {/* Status tabs */}
            <div className="filter-tabs">
                {STATUSES.map((s) => (
                    <button
                        key={s.value}
                        onClick={() => updateFilters(s.value)}
                        className={`filter-tab ${currentStatus === s.value ? 'active' : ''}`}
                    >
                        {s.label}
                    </button>
                ))}
            </div>

            {/* Search */}
            <form onSubmit={handleSearch} className="search-form">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="search-icon">
                    <circle cx="11" cy="11" r="8" /><line x1="21" y1="21" x2="16.65" y2="16.65" />
                </svg>
                <input
                    id="article-search"
                    type="text"
                    value={query}
                    onChange={(e) => setQuery(e.target.value)}
                    placeholder="Tìm bài viết..."
                    className="search-input"
                />
            </form>

            <style jsx>{`
        .filters { display:flex; align-items:center; justify-content:space-between; gap:1rem; margin-bottom:1.25rem; flex-wrap:wrap; }
        .filter-tabs { display:flex; gap:0.25rem; background:hsl(var(--secondary)); border-radius:0.625rem; padding:0.25rem; }
        .filter-tab {
          padding:0.5rem 0.875rem; background:transparent; border:none; border-radius:0.5rem;
          color:hsl(var(--muted-foreground)); font-size:0.8125rem; font-weight:500; font-family:inherit;
          cursor:pointer; transition:all .15s; white-space:nowrap;
        }
        .filter-tab:hover { color:hsl(var(--foreground)); }
        .filter-tab.active { background:hsl(var(--primary)/.15); color:hsl(var(--primary)); }
        .search-form { position:relative; }
        .search-icon { position:absolute; left:0.75rem; top:50%; transform:translateY(-50%); color:hsl(var(--muted-foreground)); }
        .search-input {
          padding:0.5rem 0.75rem 0.5rem 2.25rem; background:hsl(var(--secondary)); border:1px solid hsl(var(--border));
          border-radius:0.625rem; color:hsl(var(--foreground)); font-size:0.875rem; font-family:inherit;
          outline:none; width:220px; transition:border-color .2s, box-shadow .2s;
        }
        .search-input:focus { border-color:hsl(var(--primary)); box-shadow:0 0 0 3px hsl(var(--primary)/.12); }
      `}</style>
        </div>
    )
}
