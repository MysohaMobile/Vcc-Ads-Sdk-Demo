import {
  View, Text, TouchableOpacity, StyleSheet,
  NativeModules, ActivityIndicator, FlatList, VirtualizedList,
} from 'react-native'
import { useEffect, useState, useCallback } from 'react'
import { useLocalSearchParams, useRouter } from 'expo-router'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import { Ionicons } from '@expo/vector-icons'
import { initAds, requestAds, RNAdView, type AdReadyEvent, type AdSizeEvent } from '@mysoha/rn_ads_sdk'

const APP_ID = '670519688'
const APP_NAME = 'React Native Advertising Demo'
const APP_VERSION = '2.1.8'
const REQUEST_ID = '1'
const ADS_PER_GROUP = 10
const PAGE_SIZE = 10

type ArticleRow = { type: 'article'; index: number }
type AdRow      = { type: 'ad'; adId: string }
type ListRow    = ArticleRow | AdRow

function buildPage(startIndex: number, count: number, ids: string[]): ListRow[] {
  const rows: ListRow[] = []
  for (let i = 0; i < count; i++) {
    const index = startIndex + i
    rows.push({ type: 'article', index })
    if (index % ADS_PER_GROUP === 0 && ids.length > 0) {
      const adId = ids[Math.floor(index / ADS_PER_GROUP - 1) % ids.length]
      rows.push({ type: 'ad', adId })
    }
  }
  return rows
}

function ArticleItem({ index }: { index: number }) {
  return (
    <View style={styles.articleRow}>
      <View style={styles.articleNumber}>
        <Text style={styles.articleNumberText}>{index}</Text>
      </View>
      <View style={styles.articleBody}>
        <Text style={styles.articleTitle}>Bài viết nội dung số {index}</Text>
        <Text style={styles.articleDesc}>Mô tả chi tiết bài viết...</Text>
      </View>
    </View>
  )
}

export default function AdScreen() {
  const { title, adId, adIds } = useLocalSearchParams<{
    title: string; adId: string; adIds: string
  }>()
  const router = useRouter()
  const insets = useSafeAreaInsets()
  const [loading, setLoading] = useState(true)
  const [rows, setRows] = useState<ListRow[]>([])
  const [paging, setPaging] = useState(false)
  const [page, setPage] = useState(1)
  const [adHeight, setAdHeight] = useState<number | null>(null)
  const [singleAdType, setSingleAdType] = useState<string | null>(null)

  const ids = adIds ? adIds.split(',').filter(Boolean) : adId ? [adId] : []
  const tag = `/${(title ?? 'ad').toLowerCase().replace(/\s+/g, '-')}`
  const hasNativeModule = !!NativeModules.AdsModule
  const isFlatList     = title === 'FlatList'
  const isVirtualizedList = title === 'VirtualizedList'
  const categoryLabel = isFlatList || isVirtualizedList ? 'MIX' : 'BASIC'

  useEffect(() => {
    if (!ids.length || !hasNativeModule) { setLoading(false); return }
    initAds(APP_ID, APP_NAME, APP_VERSION)
    requestAds(tag, REQUEST_ID, ids)
    const timer = setTimeout(() => setLoading(false), 3000)
    return () => clearTimeout(timer)
  }, [tag])

  // Khởi tạo trang đầu cho FlatList
  useEffect(() => {
    if (isVirtualizedList) setRows(buildPage(1, PAGE_SIZE, ids))
  }, [isVirtualizedList])

  const loadMore = useCallback(() => {
    if (paging) return
    setPaging(true)
    setTimeout(() => {
      const next = buildPage(page * PAGE_SIZE + 1, PAGE_SIZE, ids)
      setRows((prev) => [...prev, ...next])
      setPage((p) => p + 1)
      setPaging(false)
    }, 800)
  }, [paging, page, ids])

  const renderAdContent = () => {
    if (!hasNativeModule) {
      return (
        <View style={styles.placeholder}>
          <Ionicons name="construct-outline" size={40} color="#ccc" />
          <Text style={styles.placeholderTitle}>{title}</Text>
          <Text style={styles.placeholderSub}>Native module chưa được link</Text>
          <Text style={styles.placeholderSub}>Chạy từ core/ để test ads</Text>
        </View>
      )
    }

    if (isFlatList) {
      const listData: ListRow[] = buildPage(1, 100, ids)
      return (
        <FlatList
          data={listData}
          keyExtractor={(item, i) =>
            item.type === 'ad' ? `ad-${item.adId}-${i}` : `article-${item.index}`
          }
          ItemSeparatorComponent={() => <View style={styles.separator} />}
          renderItem={({ item }) =>
            item.type === 'ad'
              ? <RNAdView tag={tag} adId={item.adId} requestId={REQUEST_ID} style={styles.adView} />
              : <ArticleItem index={item.index} />
          }
        />
      )
    }

    if (isVirtualizedList) {
      return (
        <VirtualizedList<ListRow>
          data={rows}
          getItemCount={(data) => data?.length ?? 0}
          getItem={(data, index) => data[index]}
          keyExtractor={(item, i) =>
            item.type === 'ad' ? `ad-${item.adId}-${i}` : `article-${item.index}`
          }
          ItemSeparatorComponent={() => <View style={styles.separator} />}
          onEndReached={loadMore}
          onEndReachedThreshold={0.3}
          initialNumToRender={15}
          windowSize={5}
          ListFooterComponent={
            paging ? <ActivityIndicator style={styles.footerLoader} color="#1B3665" /> : null
          }
          renderItem={({ item }) =>
            item.type === 'ad'
              ? <RNAdView tag={tag} adId={item.adId} requestId={REQUEST_ID} style={styles.adView} />
              : <ArticleItem index={item.index} />
          }
        />
      )
    }

    const isFullscreen = singleAdType === 'popup' || singleAdType === 'non_popup'
    const singleStyle = isFullscreen || adHeight === null
      ? styles.adViewSingle
      : { ...styles.adViewSingle, flex: 0, height: adHeight } as const

    return (
      <RNAdView
        tag={tag}
        adId={ids[0] ?? ''}
        requestId={REQUEST_ID}
        style={singleStyle}
        onAdReady={(e: AdReadyEvent) => {
          setSingleAdType(e.nativeEvent.adType)
        }}
        onAdSize={(e: AdSizeEvent) => setAdHeight(e.nativeEvent.height)}
      />
    )
  }

  return (
    <View style={styles.container}>
      <View style={[styles.header, { paddingTop: insets.top + 8 }]}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Ionicons name="arrow-back" size={22} color="#fff" />
        </TouchableOpacity>
        <View style={styles.headerTitles}>
          <Text style={styles.headerTitle}>{title}</Text>
          <Text style={styles.headerSub}>{categoryLabel}</Text>
        </View>
      </View>

      <View style={styles.body}>{renderAdContent()}</View>

      {loading && (
        <View style={styles.loadingOverlay}>
          <ActivityIndicator size="large" color="#1B3665" />
          <Text style={styles.loadingText}>Đang tải quảng cáo...</Text>
        </View>
      )}
    </View>
  )
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff' },
  header: {
    backgroundColor: '#1B3A6E',
    flexDirection: 'row', alignItems: 'center',
    paddingHorizontal: 12, paddingBottom: 14, gap: 10,
  },
  backBtn: {
    width: 38, height: 38, borderRadius: 19,
    backgroundColor: 'rgba(255,255,255,0.15)',
    alignItems: 'center', justifyContent: 'center',
  },
  headerTitles: { flex: 1 },
  headerTitle: { color: '#fff', fontSize: 18, fontWeight: '700' },
  headerSub: { color: 'rgba(255,255,255,0.6)', fontSize: 12, marginTop: 1 },
  body: { flex: 1 },
  articleRow: {
    flexDirection: 'row', alignItems: 'center',
    paddingHorizontal: 16, paddingVertical: 14, gap: 12, backgroundColor: '#fff',
  },
  articleNumber: {
    width: 36, height: 36, borderRadius: 18,
    backgroundColor: '#2563EB', alignItems: 'center', justifyContent: 'center',
  },
  articleNumberText: { color: '#fff', fontSize: 14, fontWeight: '700' },
  articleBody: { flex: 1 },
  articleTitle: { fontSize: 14, fontWeight: '600', color: '#111827' },
  articleDesc: { fontSize: 12, color: '#9CA3AF', marginTop: 2 },
  separator: { height: 1, backgroundColor: '#F3F4F6', marginLeft: 64 },
  adView: { width: '100%', height: 250 },
  adViewSingle: { width: '100%', flex: 1 },
  adContainer: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  footerLoader: { paddingVertical: 20 },
  placeholder: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: 10 },
  placeholderTitle: { color: '#333', fontSize: 18, fontWeight: '600', marginTop: 8 },
  placeholderSub: { color: '#999', fontSize: 13 },
  loadingOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: '#fff', alignItems: 'center', justifyContent: 'center', gap: 12,
  },
  loadingText: { color: '#999', fontSize: 14 },
})
