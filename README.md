# VCCorp Ads SDK Demo

App demo và playground cho VCCorp Ads SDK trên các nền tảng.

## Phiên bản

| Platform | Package | Phiên bản | Yêu cầu |
|----------|---------|-----------|---------|
| Flutter | `flu_vcc_ads` | `1.0.2-dev2` | Dart SDK `>=3.4.3 <4.0.0` |
| React Native | `react-native-my-sdk` | `0.1.0` | React Native `>=0.72`, New Architecture (Fabric) |

---

## Flutter

### Các loại quảng cáo hỗ trợ

#### Basic Ads

| Loại | Mô tả | Ad ID |
|------|-------|-------|
| **Banner** | Quảng cáo dạng băng ngang | `13450` |
| **Popup** | Quảng cáo dạng cửa sổ bật lên | `13994` |
| **InPage** | Quảng cáo nhúng trong trang | `13691` |
| **Welcome** | Quảng cáo mở màn mới | `14028` |
| **Catfish** | Quảng cáo dính dưới đáy màn hình | `13991` |
| **Home** | Quảng cáo trang chủ | `19217` |

#### Mix Ads

| Loại | Mô tả | Ad IDs |
|------|-------|--------|
| **List** | Quảng cáo xen kẽ trong danh sách | `13450, 19325, 14028, 19326, 19327, 19328, 19329` |
| **StickyList** | Danh sách có quảng cáo dính (pinned) | `13450, 19325, 19326, 19327, 19328, 19329` |

### Lưu ý

- Package `flu_vcc_ads` chưa được publish lên pub.dev. Bắt buộc phải có source SDK local để chạy.
- Chạy `bash setup_local.sh` trong thư mục `flutter/demo` trước khi build.
- Các Ad ID là môi trường **test** — không dùng cho production.

---

## React Native

### Tính năng

| Component | Mô tả | Platform |
|-----------|-------|---------|
| **MySdkView** | Native view cho Live Stream | Android, iOS |

### Lưu ý

- Yêu cầu bật **New Architecture (Fabric)** trên React Native.
- Package được publish lên npm registry nội bộ `https://npm-mwg.sohatv.vn/` — cần cấu hình `.npmrc` trỏ đúng registry trước khi cài.
- Chạy `pod install` trong thư mục `ios/` sau khi cài package.

---

## Cập nhật source

Thư mục platform được đồng bộ từ server nội bộ, dùng script:

```bash
bash platform-sync.sh
```

| Option | Chức năng |
|--------|-----------|
| `1` | Pull code mới từ server nội bộ |
| `2` | Xóa `.git` bên trong và push lên GitHub |
| `0` | Thoát |

Cấu hình repo trong file `platform-sync.conf`.
