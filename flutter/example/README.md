# flu_vcc_ads_example

Demo app for the `flu_vcc_ads` Flutter plugin.

## Getting Started

### 1. Run setup script

```bash
bash setup_local.sh
```

Script tự động kiểm tra:
- Nếu tìm thấy `../core` (local SDK) → dùng path dependency
- Nếu không tìm thấy → dùng pub.dev version

Script sẽ chạy `flutter pub get` tự động sau khi setup.

### 2. Run app

```bash
flutter run
```

---

## Dependency Strategy

| Trường hợp | Nguồn package |
|------------|---------------|
| Clone chỉ repo example | pub.dev `^1.0.2` |
| Clone cả example + core/ | path `../core` (local) |

File `pubspec_overrides.yaml` được tạo tự động bởi `setup_local.sh` và không được commit lên git.

> **Lưu ý:** Nếu package chưa được publish lên pub.dev, trường hợp "Clone chỉ repo example" sẽ không chạy được. Bắt buộc phải clone cả `core/` và chạy `bash setup_local.sh` để dùng local path.
