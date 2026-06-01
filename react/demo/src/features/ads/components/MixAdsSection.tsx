import { View, Text, StyleSheet } from 'react-native'
import AdCard from './AdCard'
import { AD_ITEMS, AdCategory, CATEGORY_CONFIG } from '../data/ads'

const items = AD_ITEMS.filter((i) => i.category === AdCategory.mix)
const config = CATEGORY_CONFIG[AdCategory.mix]

export default function MixAdsSection() {
  return (
    <View>
      <View style={styles.sectionRow}>
        <View style={[styles.sectionBar, { backgroundColor: config.barColor }]} />
        <Text style={styles.sectionEmoji}>{config.emoji}</Text>
        <Text style={styles.sectionLabel}>{config.label}</Text>
      </View>
      {items.map((item) => (
        <AdCard key={item.id} item={item} />
      ))}
    </View>
  )
}

const styles = StyleSheet.create({
  sectionRow: {
    flexDirection: 'row', alignItems: 'center', gap: 6,
    paddingHorizontal: 16, paddingTop: 20, paddingBottom: 10,
  },
  sectionBar: { width: 3, height: 16, borderRadius: 2 },
  sectionEmoji: { fontSize: 14 },
  sectionLabel: { fontSize: 11, fontWeight: '700', color: '#374151', letterSpacing: 0.8 },
})
