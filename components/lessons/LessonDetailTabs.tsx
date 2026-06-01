'use client'

import { useState } from 'react'
import type { MnnVocabulary, MnnGrammar, MnnExercise } from '@/types/database'
import VocabularyTab from './VocabularyTab'
import GrammarTab from './GrammarTab'
import ExercisesTab from './ExercisesTab'

type Tab = 'vocabulary' | 'grammar' | 'exercises'

interface Props {
  lessonId: string
  vocabulary: MnnVocabulary[]
  grammar: MnnGrammar[]
  exercises: MnnExercise[]
  siteId: string
}

const TABS: Array<{ id: Tab; label: string }> = [
  { id: 'vocabulary', label: 'Từ vựng' },
  { id: 'grammar', label: 'Ngữ pháp' },
  { id: 'exercises', label: 'Bài tập' },
]

export default function LessonDetailTabs({ lessonId, vocabulary, grammar, exercises, siteId }: Props) {
  const [activeTab, setActiveTab] = useState<Tab>('vocabulary')

  return (
    <div>
      <div style={{ display: 'flex', gap: '0.25rem', marginBottom: '1.5rem', borderBottom: '1px solid hsl(var(--border))' }}>
        {TABS.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            style={{
              padding: '0.625rem 1.25rem',
              background: 'none',
              border: 'none',
              borderBottom: activeTab === tab.id ? '2px solid hsl(262 83% 65%)' : '2px solid transparent',
              color: activeTab === tab.id ? 'hsl(262 83% 65%)' : 'hsl(var(--muted-foreground))',
              fontWeight: activeTab === tab.id ? 600 : 400,
              fontSize: '0.875rem',
              cursor: 'pointer',
              transition: 'color .15s',
              marginBottom: -1,
            }}
          >
            {tab.label}
            <span style={{
              marginLeft: '0.5rem',
              padding: '0.125rem 0.5rem',
              background: activeTab === tab.id ? 'hsl(262 83% 65% / 0.15)' : 'hsl(var(--muted) / 0.6)',
              color: activeTab === tab.id ? 'hsl(262 83% 65%)' : 'hsl(var(--muted-foreground))',
              borderRadius: '999px',
              fontSize: '0.75rem',
              fontWeight: 500,
            }}>
              {tab.id === 'vocabulary' ? vocabulary.length : tab.id === 'grammar' ? grammar.length : exercises.length}
            </span>
          </button>
        ))}
      </div>

      {activeTab === 'vocabulary' && (
        <VocabularyTab vocabulary={vocabulary} lessonId={lessonId} siteId={siteId} />
      )}
      {activeTab === 'grammar' && (
        <GrammarTab grammar={grammar} lessonId={lessonId} siteId={siteId} />
      )}
      {activeTab === 'exercises' && (
        <ExercisesTab exercises={exercises} lessonId={lessonId} siteId={siteId} />
      )}
    </div>
  )
}
