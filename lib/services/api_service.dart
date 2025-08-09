import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/camera_feed.dart';
import '../models/fire_notice.dart';

class ApiService {
  // Sử dụng JSONPlaceholder để test API calls
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration timeout = Duration(seconds: 30);

  // Lấy danh sách camera feeds
  Future<List<CameraFeed>> getCameraFeeds() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/cameras'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CameraFeed.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load camera feeds: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching camera feeds: $e');
      // Trả về dữ liệu mẫu nếu API không khả dụng
      return _getMockCameraFeeds();
    }
  }

  // Lấy thông tin chi tiết camera
  Future<CameraFeed> getCameraFeed(String cameraId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/cameras/$cameraId'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CameraFeed.fromJson(data);
      } else {
        throw Exception('Failed to load camera feed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching camera feed: $e');
      throw Exception('Failed to load camera feed');
    }
  }

  // Lấy danh sách thông báo báo cháy
  Future<List<FireNotice>> getFireNotices() async {
    try {
      // Sử dụng JSONPlaceholder để test
      final response = await http
          .get(Uri.parse('$baseUrl/posts'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        // Kiểm tra content-type để đảm bảo response là JSON
        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.contains('application/json')) {
          print('Warning: Response is not JSON. Content-Type: $contentType');
          print('Response body preview: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}');
          // Trả về dữ liệu mẫu nếu response không phải JSON
          return _getMockFireNotices();
        }

        final List<dynamic> data = json.decode(response.body);
        // Chuyển đổi JSONPlaceholder data thành FireNotice format
        return data.take(5).map((json) => FireNotice(
          id: json['id'].toString(),
          title: json['title'] ?? 'Thông báo báo cháy',
          message: json['body'] ?? 'Nội dung thông báo',
          location: 'Khu vực ${json['id']}',
          timestamp: DateTime.now().subtract(Duration(minutes: json['id'] * 5)),
          severity: json['id'] % 3 == 0 ? 'high' : (json['id'] % 2 == 0 ? 'medium' : 'low'),
          isActive: true,
        )).toList();
      } else {
        print('API returned status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load fire notices: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching fire notices: $e');
      // Trả về dữ liệu mẫu nếu API không khả dụng
      return _getMockFireNotices();
    }
  }

  // Lấy thông báo báo cháy theo ID
  Future<FireNotice> getFireNotice(String noticeId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/fire-notices/$noticeId'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FireNotice.fromJson(data);
      } else {
        throw Exception('Failed to load fire notice: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching fire notice: $e');
      throw Exception('Failed to load fire notice');
    }
  }

  // Dữ liệu mẫu cho camera feeds
  List<CameraFeed> _getMockCameraFeeds() {
    return [
      CameraFeed(
        id: '1',
        name: 'Camera Chính',
        location: 'Tầng 1 - Sảnh chính',
        streamUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        isActive: true,
        status: 'online',
        lastUpdate: DateTime.now(),
      ),
      CameraFeed(
        id: '2',
        name: 'Camera Hành lang',
        location: 'Tầng 2 - Hành lang A',
        streamUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        isActive: true,
        status: 'online',
        lastUpdate: DateTime.now(),
      ),
      CameraFeed(
        id: '3',
        name: 'Camera Bãi xe',
        location: 'Tầng hầm - Bãi xe',
        streamUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        isActive: false,
        status: 'offline',
        lastUpdate: DateTime.now().subtract(Duration(hours: 2)),
      ),
    ];
  }

  // Dữ liệu mẫu cho fire notices
  List<FireNotice> _getMockFireNotices() {
    return [
      FireNotice(
        id: '1',
        title: 'Cảnh báo khói tại tầng 1',
        message: 'Phát hiện khói bất thường tại khu vực sảnh chính',
        location: 'Tầng 1 - Sảnh chính',
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        severity: 'medium',
        isActive: true,
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      ),
      FireNotice(
        id: '2',
        title: 'Cảnh báo nhiệt độ cao',
        message: 'Nhiệt độ tại khu vực bếp vượt quá ngưỡng an toàn',
        location: 'Tầng 1 - Khu vực bếp',
        timestamp: DateTime.now().subtract(Duration(minutes: 15)),
        severity: 'high',
        isActive: true,
        imageUrl: 'https://picsum.photos/400/300',
      ),
    ];
  }
}
