import 'package:flutter/foundation.dart';
import '../models/camera_feed.dart';
import '../services/api_service.dart';

class CameraProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<CameraFeed> _cameraFeeds = [];
  bool _isLoading = false;
  String? _error;
  CameraFeed? _selectedCamera;

  List<CameraFeed> get cameraFeeds => _cameraFeeds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  CameraFeed? get selectedCamera => _selectedCamera;

  // Lấy danh sách camera feeds
  Future<void> fetchCameraFeeds() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _cameraFeeds = await _apiService.getCameraFeeds();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Lấy thông tin chi tiết camera
  Future<void> fetchCameraFeed(String cameraId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _selectedCamera = await _apiService.getCameraFeed(cameraId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Chọn camera
  void selectCamera(CameraFeed camera) {
    _selectedCamera = camera;
    notifyListeners();
  }

  // Bỏ chọn camera
  void deselectCamera() {
    _selectedCamera = null;
    notifyListeners();
  }

  // Lọc camera theo trạng thái
  List<CameraFeed> getCamerasByStatus(String status) {
    return _cameraFeeds.where((camera) => camera.status == status).toList();
  }

  // Lọc camera đang hoạt động
  List<CameraFeed> getActiveCameras() {
    return _cameraFeeds.where((camera) => camera.isActive).toList();
  }

  // Lọc camera theo vị trí
  List<CameraFeed> getCamerasByLocation(String location) {
    return _cameraFeeds.where((camera) => 
        camera.location.toLowerCase().contains(location.toLowerCase())).toList();
  }

  // Cập nhật trạng thái camera
  void updateCameraStatus(String cameraId, String status) {
    final index = _cameraFeeds.indexWhere((camera) => camera.id == cameraId);
    if (index != -1) {
      _cameraFeeds[index] = _cameraFeeds[index].copyWith(
        status: status,
        lastUpdate: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Xóa lỗi
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
