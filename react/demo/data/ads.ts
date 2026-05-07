import type { ComponentProps } from 'react'
import type { Ionicons } from '@expo/vector-icons'

type IconName = ComponentProps<typeof Ionicons>['name']

// ─── Enums ────────────────────────────────────────────────────────────────────

export enum AdCategory {
  basic = 'basic',
  mix   = 'mix',
}

// ─── AdViewType ───────────────────────────────────────────────────────────────

export const AdViewType = {
  banner:     { label: 'Banner',     ids: ['13450'] },
  popup:      { label: 'Popup',      ids: ['13994'] },
  // inPage:     { label: 'InPage',     ids: ['13691'] },
  // welcome:    { label: 'Welcome',    ids: ['14028'] },
  // catfish:    { label: 'Catfish',    ids: ['13991'] },
  // home:       { label: 'Home',       ids: ['19217'] },
  list:       { label: 'FlatList',        ids: ['13450', '19325', '19326', '19327', '19328', '19329'] },
  flatList:   { label: 'VirtualizedList', ids: ['13450', '19325', '19326', '19327', '19328', '19329'] },
} as const

export type AdViewTypeKey = keyof typeof AdViewType

// ─── AdItem model ─────────────────────────────────────────────────────────────

export type AdItem = {
  id: number
  type: AdViewTypeKey
  category: AdCategory
}

export const AD_ITEMS: AdItem[] = [
  { id: 1, type: 'banner',     category: AdCategory.basic },
  { id: 2, type: 'popup',      category: AdCategory.basic },
  // { id: 3, type: 'inPage',     category: AdCategory.basic },
  // { id: 4, type: 'welcome',    category: AdCategory.basic },
  // { id: 5, type: 'catfish',    category: AdCategory.basic },
  // { id: 6, type: 'home',       category: AdCategory.basic },
  { id: 7, type: 'list',       category: AdCategory.mix   },
  { id: 8, type: 'flatList',   category: AdCategory.mix   },
]

// ─── UI config (icon / color) — tách khỏi model để dễ thay đổi ───────────────

export type AdUiConfig = {
  icon: IconName
  iconColor: string
  iconBg: string
}

export const AD_UI_CONFIG: Record<AdViewTypeKey, AdUiConfig> = {
  banner:     { icon: 'document-text-outline',    iconColor: '#3B82F6', iconBg: '#EFF6FF' },
  popup:      { icon: 'open-outline',             iconColor: '#8B5CF6', iconBg: '#F5F3FF' },
  // inPage:     { icon: 'newspaper-outline',        iconColor: '#10B981', iconBg: '#ECFDF5' },
  // welcome:    { icon: 'hand-right-outline',       iconColor: '#F59E0B', iconBg: '#FFFBEB' },
  // catfish:    { icon: 'arrow-down-circle-outline',iconColor: '#3B82F6', iconBg: '#EFF6FF' },
  // home:       { icon: 'home-outline',             iconColor: '#10B981', iconBg: '#ECFDF5' },
  list:       { icon: 'grid-outline',             iconColor: '#8B5CF6', iconBg: '#F5F3FF' },
  flatList:   { icon: 'infinite-outline',          iconColor: '#EF4444', iconBg: '#FEF2F2' },
}

// ─── Category config ──────────────────────────────────────────────────────────

export type CategoryConfig = {
  label: string
  emoji: string
  barColor: string
}

export const CATEGORY_CONFIG: Record<AdCategory, CategoryConfig> = {
  [AdCategory.basic]: { label: 'BASIC ADS', emoji: '🎯', barColor: '#EF4444' },
  [AdCategory.mix]:   { label: 'MIX ADS',   emoji: '🧩', barColor: '#22C55E' },
}
