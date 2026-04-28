# Vccorp Ads SDK - Flutter Demo

App demo cho Flutter plugin `vcc_ads_sdk` — minh hoạ cách tích hợp và hiển thị các loại quảng cáo trên Android & iOS.

---

## 📑 Mục lục

- [1. Những gì demo này minh hoạ](#1-những-gì-demo-này-minh-hoạ)
- [2. Cài đặt & Chạy](#2-cài-đặt--chạy)
- [3. Hướng dẫn sử dụng demo](#3-hướng-dẫn-sử-dụng-demo)

---

## 1. Những gì demo này minh hoạ

App gồm 2 tab chính:

### Tab "Demo"

Danh sách các loại quảng cáo được chia theo 2 nhóm:

| Nhóm | Loại quảng cáo |
|------|----------------|
| **Basic Ads** | Banner, Popup, InPage, Welcome, Catfish, Home |
| **Mix Ads** | List (nhiều slot trong danh sách bài viết), StickyList (slot dính khi scroll) |

Nhấn vào từng item để mở màn hình chi tiết — xem cách slot quảng cáo được render thực tế trong từng layout.

### Tab "Manual Request"

Cho phép nhập thủ công bất kỳ **Ad Slot ID** nào và request trực tiếp — dùng để test nhanh một slot ID cụ thể mà không cần sửa code.

---

## 2. Cài đặt & Chạy

### Yêu cầu

- Clone toàn bộ monorepo (bao gồm cả thư mục `core/`)
- Flutter >= 3.22.0

### Setup

Script tạo `pubspec_overrides.yaml` trỏ `vcc_ads_sdk` vào `../core` (local path) và chạy `flutter pub get` tự động.

> `pubspec_overrides.yaml` không được commit — mỗi dev chạy script này sau khi clone.

### Chạy app

```bash
flutter run
```

### iOS (cần thêm bước pod install)

```bash
cd ios && pod install && cd ..
flutter run
```

---

## 3. Hướng dẫn sử dụng demo

### Xem demo từng loại quảng cáo

1. Mở app → Tab **Demo**
2. Nhấn vào loại quảng cáo muốn xem (Banner, Popup, List, v.v.)
3. App tự động request và render quảng cáo trong layout tương ứng

### Test thủ công với Ad Slot ID tuỳ chỉnh

1. Mở app → Tab **Manual Request**
2. Nhập số **Ad Slot ID** vào ô input
3. Nhấn **Request** — quảng cáo hiển thị ngay bên dưới khi load xong
4. Nhập ID khác và nhấn Request lại để test slot tiếp theo

### Welcome Ad

Welcome Ad hiển thị toàn màn hình ngay khi mở app (nếu slot trả về loại `welcome`). Được cấu hình trong `MainActivity.kt` qua `VccAdsPlugin.setupWelcome(...)`.
