export type ModuleId =
  | 'settings'
  | 'articles'
  | 'media'
  | 'members'
  | 'clients'
  | 'vocabulary'
  | 'decks'
  | 'lessons'
  | 'user-progress'
  | 'vocabulary-import'
  | 'feedbacks'

export interface ModuleInfo {
  id: ModuleId
  name: string
  name_en?: string
  description?: string
  icon: string
  route_segment: string
  category: string
  is_system: boolean
}

export interface SiteModule {
  module_id: ModuleId
  order_index: number
  config: Record<string, unknown>
  is_enabled: boolean
  modules: ModuleInfo
}

export interface AvailableModule {
  id: ModuleId
  name: string
  name_en?: string
  description?: string
  icon: string
  route_segment: string
  category: string
  is_system: boolean
  order_index: number
}
