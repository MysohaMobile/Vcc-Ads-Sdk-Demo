# Ads SDK Demo

Ứng dụng Expo demo để kiểm thử `@mysoha/rn_ads_sdk` trên Android và iOS.

---
## Yêu cầu

- Node.js 18+
- Android: Android Studio + emulator hoặc thiết bị thật (API 24+)
- iOS: Xcode + Simulator hoặc thiết bị thật

---
## Cài đặt & chạy

```bash
npm install
```

### Android
```bash
npm run android
```

In the output, you'll find options to open the app in a

- [development build](https://docs.expo.dev/develop/development-builds/introduction/)
- [Android emulator](https://docs.expo.dev/workflow/android-studio-emulator/)
- [iOS simulator](https://docs.expo.dev/workflow/ios-simulator/)
- [Expo Go](https://expo.dev/go), a limited sandbox for trying out app development with Expo

You can start developing by editing the files inside the **app** directory. This project uses [file-based routing](https://docs.expo.dev/router/introduction).

## Get a fresh project

When you're ready, run:

```bash
cd ios && pod install && cd ..
npm run ios
```

### Dev server (Expo)
```bash
npm run start
```

---
## Cấu trúc

```
demo/
├── app/
│   ├── _layout.tsx       # root layout — gọi initAds() khi app mount
│   ├── index.tsx         # màn hình home — danh sách các loại quảng cáo
│   └── ad-screen.tsx     # màn hình chi tiết — xử lý tất cả các format
├── src/features/ads/
│   ├── data/ads.ts       # registry: loại ad → label, adId, icon/màu
│   └── components/       # AdCard, BasicAdsSection, MixAdsSection
└── withAndroidSetup.js   # Expo config plugin — cấu hình Android native
```

---
## Các loại quảng cáo được hỗ trợ

### BASIC

| Loại | AdId | Mô tả |
|---|---|---|
| Banner | 13450 | Banner inline, resize theo `onAdSize` |
| Popup | 19597 | Popup toàn màn hình (`popupFullScreen=true`) |
| NonPopup | 19597 | Popup render inline trong view (`popupFullScreen=false`) |
| Welcome | 14028 | Màn chào toàn màn hình, tự động hiển thị sau khi request |

### MIX (quảng cáo trong danh sách)

| Loại | AdIds | Mô tả |
|---|---|---|
| FlatList | 13450, 19325–19329 | Xen kẽ quảng cáo sau mỗi 10 bài viết, dùng `FlatList` |
| VirtualizedList | 13450, 19325–19329 | Tương tự FlatList nhưng dùng `VirtualizedList` với infinite scroll |

---
## Lưu ý khi phát triển
- `withAndroidSetup.js` tự động inject Maven repo, fix theme conflict và exclude `META-INF` okhttp — không chỉnh tay `android/` nếu không cần thiết.
- Biến `DEVICE_ID` trong `ad-screen.tsx` là giá trị cứng dùng để test — thay bằng IDFA/GAID thực khi tích hợp vào app production.
- Quảng cáo trong danh sách (FlatList/VirtualizedList) dùng chung một tag cho cả màn hình, mỗi slot dùng một adId **khác nhau** (không lặp). SDK route event theo `tag + adId` nên không cần subscribe riêng từng slot.
