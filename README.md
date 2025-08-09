# Fire Notice - Ứng dụng Báo cháy

Ứng dụng báo cháy thông minh với khả năng giám sát camera trực tuyến và nhận thông báo từ Firebase.

## Tính năng chính

### 🔥 Thông báo Báo cháy
- Nhận thông báo real-time từ Firebase Cloud Messaging
- Hiển thị danh sách cảnh báo với mức độ nghiêm trọng
- Thông tin chi tiết về vị trí, thời gian và mô tả sự cố
- Hỗ trợ hiển thị hình ảnh và video đính kèm

### 📹 Giám sát Camera
- Xem video trực tuyến từ các camera giám sát
- Hiển thị trạng thái camera (online/offline)
- Giao diện video player với điều khiển đầy đủ
- Hỗ trợ chế độ toàn màn hình

### 📊 Tổng quan Hệ thống
- Dashboard hiển thị số liệu tổng quan
- Thống kê camera hoạt động/offline
- Số lượng cảnh báo đang hoạt động
- Giao diện hiện đại với theme tối

## Cài đặt

### Yêu cầu hệ thống
- Flutter SDK 3.8.1+
- Dart 3.0+
- Android Studio / VS Code
- iOS Simulator hoặc Android Emulator

### Bước 1: Clone dự án
```bash
git clone <repository-url>
cd fire_notice
```

### Bước 2: Cài đặt dependencies
```bash
flutter pub get
```

### Bước 3: Cấu hình Firebase
1. Tạo project mới trên [Firebase Console](https://console.firebase.google.com/)
2. Thêm ứng dụng Android/iOS
3. Tải file cấu hình:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`
4. Cập nhật `lib/firebase_options.dart` với thông tin project của bạn

### Bước 4: Cấu hình Backend API
Cập nhật URL API trong `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://your-backend-api.com/api';
```

### Bước 5: Chạy ứng dụng
```bash
flutter run
```

## Cấu trúc dự án

```
lib/
├── main.dart                 # Entry point
├── firebase_options.dart     # Cấu hình Firebase
├── models/                   # Data models
│   ├── fire_notice.dart     # Model thông báo báo cháy
│   └── camera_feed.dart     # Model camera feed
├── services/                 # Business logic
│   ├── api_service.dart     # API calls
│   └── firebase_service.dart # Firebase services
├── providers/                # State management
│   ├── fire_notice_provider.dart
│   └── camera_provider.dart
├── screens/                  # UI screens
│   ├── home_screen.dart     # Màn hình chính
│   └── camera_view_screen.dart # Xem camera
└── widgets/                  # Reusable components
    ├── status_card.dart     # Card thống kê
    ├── camera_grid.dart     # Grid camera
    └── notice_list.dart     # Danh sách thông báo
```

## API Endpoints

### Camera Feeds
- `GET /api/cameras` - Lấy danh sách camera
- `GET /api/cameras/{id}` - Lấy thông tin camera cụ thể

### Fire Notices
- `GET /api/fire-notices` - Lấy danh sách thông báo
- `GET /api/fire-notices/{id}` - Lấy thông báo cụ thể

## Firebase Configuration

### Cloud Messaging
- Topic: `fire_notices` (để nhận thông báo báo cháy)
- Notification channel: `fire_notice_channel`

### Permissions
- Camera access
- Internet access
- Notification permissions

## Tính năng nâng cao

### 🔄 Background Processing
- Nhận thông báo khi app đang chạy nền
- Xử lý thông báo khi app đóng

### 📱 Responsive Design
- Giao diện tối ưu cho mobile
- Hỗ trợ orientation changes
- Adaptive layout cho tablet

### 🎨 Custom Theme
- Dark theme chuyên nghiệp
- Color scheme phù hợp với ứng dụng báo cháy
- Smooth animations và transitions

## Troubleshooting

### Lỗi thường gặp

1. **Firebase không kết nối**
   - Kiểm tra file cấu hình Firebase
   - Đảm bảo internet connection
   - Verify project ID và API keys

2. **Video không phát được**
   - Kiểm tra URL stream có hợp lệ
   - Đảm bảo format video được hỗ trợ
   - Check network permissions

3. **Thông báo không nhận được**
   - Kiểm tra FCM token
   - Verify notification permissions
   - Check Firebase project settings

### Debug Mode
```bash
flutter run --debug
```

## Đóng góp

1. Fork dự án
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

## License

Dự án này được phân phối dưới MIT License. Xem file `LICENSE` để biết thêm chi tiết.

## Liên hệ

- Email: support@firenotice.com
- Website: https://firenotice.com
- Documentation: https://docs.firenotice.com

---

**Lưu ý**: Đây là ứng dụng demo với dữ liệu mẫu. Để sử dụng trong production, cần cấu hình Firebase thực tế và backend API.
# fire_notice
