import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import ArticleEditor from '@/components/articles/ArticleEditor'
import type { Metadata } from 'next'

interface Props {
    params: Promise<{ siteId: string; articleId: string }>
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
    const { articleId } = await params
    if (articleId === 'new') return { title: 'Bài viết mới' }
    const supabase = await createClient()
    const { data } = await supabase.from('articles').select('title').eq('id', articleId).single()
    return { title: data?.title ?? 'Chỉnh sửa' }
}

export default async function ArticleEditorPage({ params }: Props) {
    const { siteId, articleId } = await params
    const supabase = await createClient()

    const { data: site } = await supabase.from('sites').select('name').eq('id', siteId).single()
    if (!site) notFound()

    let article = null
    if (articleId !== 'new') {
        const { data } = await supabase.from('articles').select('*').eq('id', articleId).single()
        if (!data) notFound()
        article = data
    }

    return <ArticleEditor siteId={siteId} siteName={site.name} article={article} />
}
