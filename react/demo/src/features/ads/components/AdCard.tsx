import { View, Text, TouchableOpacity, StyleSheet } from 'react-native'
import { useRouter } from 'expo-router'
import { Ionicons } from '@expo/vector-icons'
import { AdViewType, AD_UI_CONFIG, type AdItem } from '../data/ads'

export default function AdCard({ item }: { item: AdItem }) {
  const router = useRouter()
  const viewType = AdViewType[item.type]
  const ui = AD_UI_CONFIG[item.type]
  const subtitle = viewType.ids.length > 1
    ? `IDs: ${viewType.ids.join(', ')}`
    : `ID: ${viewType.ids[0]}`

  return (
    <View style={styles.cardWrapper}>
      <View style={[styles.leftAccent, { backgroundColor: ui.iconColor }]} />
      <TouchableOpacity
        style={styles.cardInner}
        activeOpacity={0.7}
        onPress={() =>
          router.push({
            pathname: '/ad-screen',
            params: {
              title: viewType.label,
              adId: viewType.ids[0],
              adIds: viewType.ids.join(','),
            },
          })
        }
      >
        <View style={[styles.iconBox, { backgroundColor: ui.iconBg }]}>
          <Ionicons name={ui.icon} size={22} color={ui.iconColor} />
        </View>
        <View style={styles.cardBody}>
          <Text style={styles.cardTitle}>{viewType.label}</Text>
          <Text style={styles.cardSub} numberOfLines={1}>{subtitle}</Text>
        </View>
        <Ionicons name="chevron-forward" size={18} color="#D1D5DB" />
      </TouchableOpacity>
    </View>
  )
}

const styles = StyleSheet.create({
  cardWrapper: {
    marginHorizontal: 12, marginBottom: 8, borderRadius: 12,
    backgroundColor: '#fff', overflow: 'hidden',
    shadowColor: '#000', shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05, shadowRadius: 4, elevation: 2,
  },
  leftAccent: { position: 'absolute', left: 0, top: 0, bottom: 0, width: 4 },
  cardInner: {
    flexDirection: 'row', alignItems: 'center',
    paddingLeft: 18, paddingRight: 14, paddingVertical: 14, gap: 12,
  },
  iconBox: { width: 44, height: 44, borderRadius: 10, alignItems: 'center', justifyContent: 'center' },
  cardBody: { flex: 1 },
  cardTitle: { fontSize: 15, fontWeight: '600', color: '#111827' },
  cardSub: { fontSize: 12, color: '#9CA3AF', marginTop: 2 },
})
