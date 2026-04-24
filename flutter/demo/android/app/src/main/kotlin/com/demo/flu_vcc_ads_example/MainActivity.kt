package com.demo.flu_vcc_ads_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import vcc.ads.flu_vcc_ads.FluVccAdsPlugin

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(engine: FlutterEngine) {
        FluVccAdsPlugin.setupWelcome(
            logoRes = R.mipmap.ic_launcher,
            titleLogoRes = R.mipmap.ic_launcher,
            primaryColor = 0xFF6200EE,
            secondaryColor = 0xFF03DAC5,
            showSkip = true,
            duration = 3000,
            skipDelay = 1000,
            animDuration = 100
        )
        super.configureFlutterEngine(engine)
    }
}
