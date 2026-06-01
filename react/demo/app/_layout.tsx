import { useEffect } from 'react'
import { NativeModules } from 'react-native'
import { Stack } from 'expo-router'
import { StatusBar } from 'expo-status-bar'
import { initAds, setupWelcomeAd } from '@mysoha/rn_ads_sdk'

const APP_ID      = '670519688'
const APP_NAME    = 'React Native Advertising Demo'
const APP_VERSION = '2.1.8'

export default function RootLayout() {
  useEffect(() => {
    if (!NativeModules.AdsModule) return
    initAds(APP_ID, APP_NAME, APP_VERSION)
//      setupWelcomeAd({
//                   logo: 'ic_launcher_foreground',
//                   titleLogo: 'ic_launcher_foreground',
//                   backgroundColor: 0xFF1B3A6E,
//                   titleColor: 0xFFFFFFFF,
//                   closeColor: true,
//                   timeAnimation: 100,
//                   timeDelayAnimation: 1000,
//                   timeOut: 3000,
//             })
  }, [])

  return (
    <>
      <StatusBar style="light" />
      <Stack screenOptions={{ headerShown: false }} />
    </>
  )
}
