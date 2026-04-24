# VCCorp Ads SDK Demo

App demo và playground cho VCCorp Ads SDK trên các nền tảng.

## Phiên bản

| Platform | Package | Phiên bản |
|----------|---------|-----------|
| Flutter | `flu_vcc_ads` | `1.0.2-dev2` |

**Yêu cầu môi trường Flutter:** Dart SDK `>=3.4.3 <4.0.0`

---

## Các loại quảng cáo hỗ trợ

### Basic Ads

| Loại | Mô tả                            | Ad ID |
|------|----------------------------------|-------|
| **Banner** | Quảng cáo dạng băng ngang        | `13450` |
| **Popup** | Quảng cáo dạng cửa sổ bật lên    | `13994` |
| **InPage** | Quảng cáo nhúng trong trang      | `13691` |
| **Welcome** | Quảng cáo mở màn mới             | `14028` |
| **Catfish** | Quảng cáo dính dưới đáy màn hình | `13991` |
| **Home** | Quảng cáo trang chủ              | `19217` |

### Mix Ads

| Loại | Mô tả | Ad IDs |
|------|-------|--------|
| **List** | Quảng cáo xen kẽ trong danh sách | `13450, 19325, 14028, 19326, 19327, 19328, 19329` |
| **StickyList** | Danh sách có quảng cáo dính (pinned) | `13450, 19325, 19326, 19327, 19328, 19329` |

---

## Lưu ý

- Package `flu_vcc_ads` chưa được publish lên pub.dev. Bắt buộc phải có source SDK local để chạy.
- Các Ad ID trong demo là ID môi trường **test** — không dùng cho production.
