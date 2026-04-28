# VCCorp Ads SDK Demo

App demo và playground cho VCCorp Ads SDK trên các nền tảng.

## Phiên bản

| Platform | Package | Phiên bản | Yêu cầu |
|----------|---------|-----------|---------|
| Flutter | `vcc_ads_sdk` | `1.0.0` | Dart SDK `>=3.4.3 <4.0.0` |
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

- Package `vcc_ads_sdk` đã được publish lên pub.dev tại phiên bản `1.0.0`.
- Chạy `bash setup_local.sh` trong thư mục `flutter/demo` trước khi build.
- Các Ad ID là môi trường **test** — không dùng cho production.

---

## React Native

### Tính năng

| Component | Mô tả | Platform |
|-----------|-------|---------|
| **MySdkView** | Native view cho Live Stream | Android, iOS |


