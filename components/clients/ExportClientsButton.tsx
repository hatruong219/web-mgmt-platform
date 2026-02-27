'use client'

import { useState } from 'react'
import { exportClientsCSV } from '@/app/actions/clients'

interface ExportClientsButtonProps {
  siteId: string
  siteName: string
}

export function ExportClientsButton({ siteId, siteName }: ExportClientsButtonProps) {
  const [loading, setLoading] = useState(false)

  const handleExport = async () => {
    setLoading(true)
    
    const result = await exportClientsCSV(siteId)
    
    if (result.error) {
      alert(result.error)
      setLoading(false)
      return
    }

    if (result.data) {
      const blob = new Blob([result.data], { type: 'text/csv;charset=utf-8;' })
      const url = URL.createObjectURL(blob)
      const link = document.createElement('a')
      link.href = url
      link.download = `${siteName.toLowerCase().replace(/\s+/g, '-')}-clients-${new Date().toISOString().split('T')[0]}.csv`
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
      URL.revokeObjectURL(url)
    }

    setLoading(false)
  }

  return (
    <button
      onClick={handleExport}
      disabled={loading}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '0.5rem',
        padding: '0.625rem 1rem',
        background: 'hsl(var(--secondary))',
        border: '1px solid hsl(var(--border))',
        borderRadius: '0.625rem',
        color: 'hsl(var(--foreground))',
        fontSize: '0.875rem',
        fontWeight: 500,
        cursor: loading ? 'not-allowed' : 'pointer',
        opacity: loading ? 0.6 : 1,
        transition: 'all 0.15s',
      }}
    >
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
        <polyline points="7 10 12 15 17 10" />
        <line x1="12" y1="15" x2="12" y2="3" />
      </svg>
      {loading ? 'Đang xuất...' : 'Export CSV'}
    </button>
  )
}
