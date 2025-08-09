# 🔥 Firebase Setup Guide cho Fire Notice App

## 📋 **Yêu cầu trước khi bắt đầu:**
- Tài khoản Google
- Flutter SDK đã cài đặt
- Android Studio hoặc VS Code

## 🚀 **Bước 1: Tạo Firebase Project**

1. **Truy cập Firebase Console:**
   - Mở [Firebase Console](https://console.firebase.google.com/)
   - Đăng nhập bằng tài khoản Google

2. **Tạo Project mới:**
   - Click "Create a project"
   - Đặt tên project (ví dụ: "fire-notice-app")
   - Chọn có/không bật Google Analytics
   - Click "Create project"

3. **Lấy thông tin Project:**
   - Ghi nhớ **Project ID**
   - Ghi nhớ **Sender ID** (sẽ cần sau)

## 📱 **Bước 2: Cấu hình Android App**

1. **Thêm Android app:**
   - Trong Firebase Console → Project Overview
   - Click biểu tượng Android
   - Nhập **Android package name**: `com.example.fire_notice`
   - Nhập **App nickname**: "Fire Notice"
   - Click "Register app"

2. **Tải file cấu hình:**
   - Tải `google-services.json`
   - Đặt file vào `android/app/google-services.json`

3. **Cấu hình build.gradle:**
   - File `android/app/build.gradle.kts` đã được cấu hình sẵn
   - Không cần thay đổi gì thêm

## 🍎 **Bước 3: Cấu hình iOS App (nếu cần)**

1. **Thêm iOS app:**
   - Trong Firebase Console → Project Overview
   - Click biểu tượng iOS
   - Nhập **iOS bundle ID**: `com.example.fireNotice`
   - Nhập **App nickname**: "Fire Notice iOS"
   - Click "Register app"

2. **Tải file cấu hình:**
   - Tải `GoogleService-Info.plist`
   - Đặt file vào `ios/Runner/GoogleService-Info.plist`

## 🔧 **Bước 4: Cài đặt FlutterFire CLI**

```bash
# Cài đặt FlutterFire CLI
dart pub global activate flutterfire_cli

# Cấu hình Firebase cho Flutter project
flutterfire configure
```

Lệnh `flutterfire configure` sẽ:
- Tự động tạo `lib/firebase_options.dart` với credentials thực
- Cấu hình cho tất cả platforms
- Cập nhật dependencies nếu cần

## 📝 **Bước 5: Cập nhật Firebase Options**

Sau khi chạy `flutterfire configure`, file `lib/firebase_options.dart` sẽ được tạo tự động với credentials thực.

## 🔄 **Bước 6: Bật Firebase Services**

1. **Firebase Cloud Messaging (FCM):**
   - Trong Firebase Console → Project Settings
   - Tab "Cloud Messaging"
   - Copy **Server key** (sẽ cần để gửi notifications từ backend)

2. **Firebase Analytics (tùy chọn):**
   - Trong Firebase Console → Analytics
   - Bật nếu muốn theo dõi user behavior

## 🚀 **Bước 7: Test Firebase Integration**

1. **Uncomment Firebase initialization trong `lib/main.dart`:**
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     
     // Initialize Firebase
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     
     // Initialize Firebase Service
     await FirebaseService().initialize();
     
     runApp(const MyApp());
   }
   ```

2. **Build và test app:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 📱 **Bước 8: Test Push Notifications**

1. **Gửi test notification:**
   - Trong Firebase Console → Cloud Messaging
   - Click "Send your first message"
   - Nhập title và message
   - Chọn target (Android/iOS)
   - Click "Send"

2. **Kiểm tra trong app:**
   - App sẽ hiển thị notification
   - Kiểm tra log để xem FCM token

## 🔍 **Troubleshooting**

### **Lỗi "Application ID not set":**
- Kiểm tra `google-services.json` đã đặt đúng vị trí
- Kiểm tra package name trong `build.gradle.kts` khớp với Firebase
- Chạy `flutter clean` và build lại

### **Lỗi "Permission denied":**
- Kiểm tra internet connection
- Kiểm tra Firebase project settings
- Kiểm tra SHA-1 fingerprint (nếu cần)

### **Lỗi "Plugin not found":**
- Chạy `flutter pub get`
- Kiểm tra `pubspec.yaml` dependencies
- Restart IDE

## 📚 **Tài liệu tham khảo:**

- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)
- [Firebase Console](https://console.firebase.google.com/)
- [FCM Setup Guide](https://firebase.google.com/docs/cloud-messaging/flutter/client)

## ✅ **Kiểm tra cuối cùng:**

- [ ] Firebase project đã tạo
- [ ] `google-services.json` đã đặt đúng vị trí
- [ ] `flutterfire configure` đã chạy thành công
- [ ] Firebase initialization đã uncomment
- [ ] App build thành công
- [ ] Push notification test thành công

---

**Lưu ý:** Sau khi cấu hình Firebase xong, bạn có thể uncomment phần Firebase initialization trong `lib/main.dart` để sử dụng đầy đủ tính năng Firebase.
