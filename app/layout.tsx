import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: {
    template: '%s | Web Manager',
    default: 'Web Manager — Quản lý trang web cá nhân',
  },
  description: 'Nền tảng quản lý tập trung cho tất cả các website cá nhân. Viết bài, quản lý media, theo dõi analytics.',
  keywords: ['CMS', 'blog', 'quản lý nội dung', 'Next.js', 'Supabase'],
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="vi" suppressHydrationWarning>
      <body>{children}</body>
    </html>
  )
}
