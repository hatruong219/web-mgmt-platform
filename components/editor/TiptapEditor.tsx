'use client'

import { useEditor, EditorContent } from '@tiptap/react'
import StarterKit from '@tiptap/starter-kit'
import Image from '@tiptap/extension-image'
import LinkExtension from '@tiptap/extension-link'
import Placeholder from '@tiptap/extension-placeholder'
import { useCallback, useState } from 'react'
import MediaPickerModal from '@/components/media/MediaPickerModal'

interface TiptapEditorProps {
    content: string
    onChange: (html: string) => void
    siteId?: string
    placeholder?: string
}

export default function TiptapEditor({ content, onChange, siteId, placeholder = 'Bắt đầu viết nội dung...' }: TiptapEditorProps) {
    const [showMediaPicker, setShowMediaPicker] = useState(false)
    const editor = useEditor({
        extensions: [
            StarterKit.configure({
                heading: { levels: [1, 2, 3] },
            }),
            Image.configure({ inline: false, allowBase64: true }),
            LinkExtension.configure({ openOnClick: false }),
            Placeholder.configure({ placeholder }),
        ],
        content,
        immediatelyRender: false,
        onUpdate: ({ editor }) => {
            onChange(editor.getHTML())
        },
        editorProps: {
            attributes: {
                class: 'tiptap-editor',
            },
        },
    })

    const addImage = useCallback(() => {
        if (!editor) return
        if (siteId) {
            // Mở Media Picker modal
            setShowMediaPicker(true)
        } else {
            // Fallback: nhập URL
            const url = window.prompt('Image URL:')
            if (url) editor.chain().focus().setImage({ src: url }).run()
        }
    }, [editor, siteId])

    const handleMediaSelect = useCallback((url: string) => {
        if (!editor) return
        editor.chain().focus().setImage({ src: url }).run()
    }, [editor])

    const addLink = useCallback(() => {
        if (!editor) return
        const url = window.prompt('Link URL:')
        if (url) editor.chain().focus().setLink({ href: url }).run()
    }, [editor])

    if (!editor) return null

    return (
        <div className="editor-wrapper">
            {/* Media Picker Modal */}
            {siteId && (
                <MediaPickerModal
                    siteId={siteId}
                    open={showMediaPicker}
                    onClose={() => setShowMediaPicker(false)}
                    onSelect={handleMediaSelect}
                />
            )}

            {/* Toolbar */}
            <div className="toolbar">
                <div className="toolbar-group">
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().toggleBold().run()}
                        className={`toolbar-btn ${editor.isActive('bold') ? 'active' : ''}`}
                        title="Bold"
                    >
                        <strong>B</strong>
                    </button>
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().toggleItalic().run()}
                        className={`toolbar-btn ${editor.isActive('italic') ? 'active' : ''}`}
                        title="Italic"
                    >
                        <em>I</em>
                    </button>
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().toggleStrike().run()}
                        className={`toolbar-btn ${editor.isActive('strike') ? 'active' : ''}`}
                        title="Strikethrough"
                    >
                        <s>S</s>
                    </button>
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().toggleCode().run()}
                        className={`toolbar-btn ${editor.isActive('code') ? 'active' : ''}`}
                        title="Inline code"
                    >
                        {'</>'}
                    </button>
                </div>

                <div className="toolbar-divider" />

                <div className="toolbar-group">
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().toggleHeading({ level: 1 }).run()}
                        className={`toolbar-btn ${editor.isActive('heading', { level: 1 }) ? 'active' : ''}`}
                        title="Heading 1"
                    >
                        H1
                    </button>
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()}
                        className={`toolbar-btn ${editor.isActive('heading', { level: 2 }) ? 'active' : ''}`}
                        title="Heading 2"
                    >
                        H2
                    </button>
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().toggleHeading({ level: 3 }).run()}
                        className={`toolbar-btn ${editor.isActive('heading', { level: 3 }) ? 'active' : ''}`}
                        title="Heading 3"
                    >
                        H3
                    </button>
                </div>

                <div className="toolbar-divider" />

                <div className="toolbar-group">
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().toggleBulletList().run()}
                        className={`toolbar-btn ${editor.isActive('bulletList') ? 'active' : ''}`}
                        title="Bullet list"
                    >
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <line x1="8" y1="6" x2="21" y2="6" /><line x1="8" y1="12" x2="21" y2="12" /><line x1="8" y1="18" x2="21" y2="18" />
                            <circle cx="4" cy="6" r="1" fill="currentColor" /><circle cx="4" cy="12" r="1" fill="currentColor" /><circle cx="4" cy="18" r="1" fill="currentColor" />
                        </svg>
                    </button>
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().toggleOrderedList().run()}
                        className={`toolbar-btn ${editor.isActive('orderedList') ? 'active' : ''}`}
                        title="Ordered list"
                    >
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <line x1="10" y1="6" x2="21" y2="6" /><line x1="10" y1="12" x2="21" y2="12" /><line x1="10" y1="18" x2="21" y2="18" />
                            <text x="4" y="8" fontSize="8" fill="currentColor" fontWeight="bold">1</text>
                            <text x="4" y="14" fontSize="8" fill="currentColor" fontWeight="bold">2</text>
                            <text x="4" y="20" fontSize="8" fill="currentColor" fontWeight="bold">3</text>
                        </svg>
                    </button>
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().toggleBlockquote().run()}
                        className={`toolbar-btn ${editor.isActive('blockquote') ? 'active' : ''}`}
                        title="Blockquote"
                    >
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M3 21c3 0 7-1 7-8V5c0-1.25-.756-2.017-2-2H4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2 1 0 1 0 1 1v1c0 1-1 2-2 2s-1 .008-1 1.031V21z" />
                            <path d="M15 21c3 0 7-1 7-8V5c0-1.25-.757-2.017-2-2h-4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2h.75c0 2.25.25 4-2.75 4v3z" />
                        </svg>
                    </button>
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().toggleCodeBlock().run()}
                        className={`toolbar-btn ${editor.isActive('codeBlock') ? 'active' : ''}`}
                        title="Code block"
                    >
                        {'{ }'}
                    </button>
                </div>

                <div className="toolbar-divider" />

                <div className="toolbar-group">
                    <button type="button" onClick={addImage} className="toolbar-btn" title="Add image">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" /><circle cx="8.5" cy="8.5" r="1.5" /><polyline points="21 15 16 10 5 21" />
                        </svg>
                    </button>
                    <button type="button" onClick={addLink} className="toolbar-btn" title="Add link">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71" />
                            <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71" />
                        </svg>
                    </button>
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().setHorizontalRule().run()}
                        className="toolbar-btn"
                        title="Horizontal rule"
                    >
                        ―
                    </button>
                </div>

                <div className="toolbar-divider" />

                <div className="toolbar-group">
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().undo().run()}
                        disabled={!editor.can().undo()}
                        className="toolbar-btn"
                        title="Undo"
                    >
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <polyline points="1 4 1 10 7 10" /><path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10" />
                        </svg>
                    </button>
                    <button
                        type="button"
                        onClick={() => editor.chain().focus().redo().run()}
                        disabled={!editor.can().redo()}
                        className="toolbar-btn"
                        title="Redo"
                    >
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <polyline points="23 4 23 10 17 10" /><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10" />
                        </svg>
                    </button>
                </div>
            </div>

            {/* Editor content */}
            <EditorContent editor={editor} />

            <style jsx>{`
        .editor-wrapper {
          border: 1px solid hsl(var(--border));
          border-radius: 0.875rem;
          background: hsl(var(--card));
          overflow: hidden;
        }
        .toolbar {
          display: flex;
          align-items: center;
          gap: 0.25rem;
          padding: 0.5rem 0.75rem;
          border-bottom: 1px solid hsl(var(--border));
          background: hsl(var(--secondary));
          flex-wrap: wrap;
        }
        .toolbar-group { display: flex; align-items: center; gap: 0.125rem; }
        .toolbar-divider {
          width: 1px;
          height: 20px;
          background: hsl(var(--border));
          margin: 0 0.25rem;
        }
        .toolbar-btn {
          display: flex;
          align-items: center;
          justify-content: center;
          min-width: 30px;
          height: 30px;
          padding: 0 0.375rem;
          background: transparent;
          border: none;
          border-radius: 0.375rem;
          color: hsl(var(--muted-foreground));
          font-size: 0.8125rem;
          font-family: inherit;
          cursor: pointer;
          transition: all 0.12s;
        }
        .toolbar-btn:hover { background: hsl(var(--border)); color: hsl(var(--foreground)); }
        .toolbar-btn.active { background: hsl(var(--primary) / 0.15); color: hsl(var(--primary)); }
        .toolbar-btn:disabled { opacity: 0.4; cursor: not-allowed; }
      `}</style>
        </div>
    )
}
