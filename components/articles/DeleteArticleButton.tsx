'use client'

import { useRouter } from 'next/navigation'
import { useTransition } from 'react'
import { createClient } from '@/lib/supabase/client'

interface Props {
    articleId: string
    siteId: string
}

export default function DeleteArticleButton({ articleId, siteId }: Props) {
    const router = useRouter()
    const [isPending, startTransition] = useTransition()

    const handleDelete = async () => {
        if (!confirm('Bạn có chắc muốn xóa bài viết này?')) return

        const supabase = createClient()
        startTransition(async () => {
            await supabase.from('articles').delete().eq('id', articleId)
            router.refresh()
        })
    }

    return (
        <button
            onClick={handleDelete}
            disabled={isPending}
            className="del-btn"
            title="Xóa bài viết"
        >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <polyline points="3 6 5 6 21 6" />
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
            </svg>

            <style jsx>{`
        .del-btn {
          display:flex; align-items:center; justify-content:center; width:36px; height:36px;
          margin-right:0.75rem; background:transparent; border:1px solid transparent; border-radius:0.5rem;
          color:hsl(var(--muted-foreground)); cursor:pointer; transition:all .15s; flex-shrink:0;
        }
        .del-btn:hover { background:hsl(var(--destructive)/.1); border-color:hsl(var(--destructive)/.3); color:hsl(var(--destructive)); }
        .del-btn:disabled { opacity:0.5; cursor:not-allowed; }
      `}</style>
        </button>
    )
}
