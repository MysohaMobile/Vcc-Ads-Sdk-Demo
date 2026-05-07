import { View, Text, ScrollView, TouchableOpacity, StyleSheet } from 'react-native'
import { useState } from 'react'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import { Ionicons } from '@expo/vector-icons'
import BasicAdsSection from '../components/BasicAdsSection'
import MixAdsSection from '../components/MixAdsSection'

function DemoTab() {
  return (
    <ScrollView
      style={styles.scroll}
      contentContainerStyle={styles.scrollContent}
      showsVerticalScrollIndicator={false}
    >
      <BasicAdsSection />
      <MixAdsSection />
    </ScrollView>
  )
}

function ManualTab() {
  return (
    <View style={styles.manualPlaceholder}>
      <Ionicons name="construct-outline" size={48} color="#D1D5DB" />
      <Text style={styles.manualText}>Đang phát triển</Text>
    </View>
  )
}

export default function HomeScreen() {
  const [tab, setTab] = useState<'demo' | 'manual'>('demo')
  const insets = useSafeAreaInsets()

  return (
    <View style={styles.root}>
      <View style={[styles.header, { paddingTop: insets.top + 10 }]}>
        <View style={styles.brandRow}>
          <View style={styles.logoBox}>
            <Text style={styles.logoLetter}>V</Text>
          </View>
          <View>
            <Text style={styles.brandName}>VCCorp Ads SDK</Text>
            <Text style={styles.brandSub}>Demo & Playground</Text>
          </View>
        </View>

        <View style={styles.tabRow}>
          {(['demo', 'manual'] as const).map((t) => (
            <TouchableOpacity key={t} style={styles.tabBtn} onPress={() => setTab(t)}>
              <Ionicons
                name={t === 'demo' ? 'apps-outline' : 'options-outline'}
                size={15}
                color={tab === t ? '#fff' : 'rgba(255,255,255,0.45)'}
              />
              <Text style={[styles.tabLabel, tab === t && styles.tabLabelActive]}>
                {t === 'demo' ? 'Demo' : 'Manual Request'}
              </Text>
              {tab === t && <View style={styles.tabUnderline} />}
            </TouchableOpacity>
          ))}
        </View>
      </View>

      {tab === 'demo' ? <DemoTab /> : <ManualTab />}
    </View>
  )
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: '#F0F2F5' },
  header: { paddingHorizontal: 20, backgroundColor: '#1B3A6E' },
  brandRow: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingBottom: 14 },
  logoBox: {
    width: 40, height: 40, borderRadius: 10,
    backgroundColor: 'rgba(255,255,255,0.18)',
    alignItems: 'center', justifyContent: 'center',
  },
  logoLetter: { color: '#fff', fontSize: 18, fontWeight: '700' },
  brandName: { color: '#fff', fontSize: 15, fontWeight: '700' },
  brandSub: { color: 'rgba(255,255,255,0.6)', fontSize: 11, marginTop: 1 },
  tabRow: { flexDirection: 'row' },
  tabBtn: {
    flexDirection: 'row', alignItems: 'center', gap: 5,
    paddingHorizontal: 12, paddingVertical: 10,
  },
  tabLabel: { color: 'rgba(255,255,255,0.45)', fontSize: 13, fontWeight: '500' },
  tabLabelActive: { color: '#fff', fontWeight: '600' },
  tabUnderline: {
    position: 'absolute', bottom: 0, left: 12, right: 12,
    height: 2, backgroundColor: '#fff', borderRadius: 1,
  },
  scroll: { flex: 1 },
  scrollContent: { paddingTop: 4, paddingBottom: 32 },
  manualPlaceholder: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: 12 },
  manualText: { fontSize: 15, color: '#9CA3AF' },
})
