package com.demo.flu_vcc_ads_example

import android.app.Application
import vcc.ads.vcc_ads_sdk.VccAdsPlugin

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        VccAdsPlugin.setupSdk(
            appId = "670519688",
            appName = "flu_vcc_ads_example",
            appVersion = "1.0.0",
            deviceId = "0DC79D1A-0B08-4230-A26E-2D1D8F0878AA",
            adUrl = "https://soha.vn/tan-thuy-hoang-chet-nhu-the-nao-he-lo-3-nguyen-nhan-khong-chi-do-thuoc-truong-sinh-20211107234501608.htm",
            bundle = "vcc.mobilenewsreader.sohanews",
        )
    }
}
