import { View, StyleSheet, useWindowDimensions } from 'react-native'
import { useEffect } from 'react'
import { usePathname } from 'expo-router'
import { initAds, requestAds, RNAdView } from '@mysoha/rn_ads_sdk'

const AD_ID = '13926'
const REQUEST_ID = '1'

export default function HomeScreen() {
  const tag = usePathname()
  const { width, height } = useWindowDimensions()

  useEffect(() => {
    initAds('670519688', 'React Native Advertising Demo', '2.1.8')
    requestAds(tag, REQUEST_ID, [AD_ID])
  }, [tag])

  return (
    <View style={styles.container}>
      <RNAdView
        tag={tag}
        adId={AD_ID}
        requestId={REQUEST_ID}
        style={{ width, height, position: 'absolute', top: 0, left: 0 }}
      />
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
})