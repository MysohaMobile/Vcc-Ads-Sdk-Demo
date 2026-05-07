const { withProjectBuildGradle, withAndroidManifest, withAppBuildGradle } = require('@expo/config-plugins')

const MAVEN_URL = 'https://msh-jfrog.sohatv.vn:443/artifactory/sdk-v3-gradle-release-local/'

// Thêm Maven repo nội bộ vào project build.gradle
const withMavenUrl = (config) => {
  return withProjectBuildGradle(config, (mod) => {
    if (!mod.modResults.contents.includes(MAVEN_URL)) {
      mod.modResults.contents = mod.modResults.contents.replace(
        /allprojects\s*\{[^}]*repositories\s*\{/,
        (match) => `${match}\n    maven { url '${MAVEN_URL}' }`
      )
    }
    return mod
  })
}

// Fix theme conflict giữa app và vcc-sdk-v3
const withManifestThemeFix = (config) => {
  return withAndroidManifest(config, (mod) => {
    const manifest = mod.modResults.manifest
    if (!manifest.$) manifest.$ = {}
    manifest.$['xmlns:tools'] = 'http://schemas.android.com/tools'

    const app = manifest.application[0]
    if (!app.$) app.$ = {}
    app.$['tools:replace'] = 'android:theme'

    return mod
  })
}

// Fix duplicate META-INF file từ okhttp3 và jspecify
const withPackagingOptions = (config) => {
  return withAppBuildGradle(config, (mod) => {
    const gradle = mod.modResults.contents
    if (!gradle.includes('META-INF/versions/9/OSGI-INF/MANIFEST.MF')) {
      mod.modResults.contents = gradle.replace(
        /packagingOptions\s*\{(\s*jniLibs\s*\{[^}]*\})\s*\}/,
        `packagingOptions {$1\n        resources {\n            excludes += ['META-INF/versions/9/OSGI-INF/MANIFEST.MF']\n        }\n    }`
      )
    }
    return mod
  })
}

module.exports = (config) => {
  config = withMavenUrl(config)
  config = withManifestThemeFix(config)
  config = withPackagingOptions(config)
  return config
}
