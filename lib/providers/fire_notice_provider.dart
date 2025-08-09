import 'package:flutter/foundation.dart';
import '../models/fire_notice.dart';
import '../services/api_service.dart';

class FireNoticeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<FireNotice> _fireNotices = [];
  bool _isLoading = false;
  String? _error;

  List<FireNotice> get fireNotices => _fireNotices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Lấy danh sách thông báo báo cháy
  Future<void> fetchFireNotices() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _fireNotices = await _apiService.getFireNotices();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Lấy thông báo báo cháy theo ID
  Future<FireNotice?> fetchFireNotice(String noticeId) async {
    try {
      return await _apiService.getFireNotice(noticeId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Thêm thông báo mới
  void addFireNotice(FireNotice notice) {
    _fireNotices.insert(0, notice);
    notifyListeners();
  }

  // Cập nhật thông báo
  void updateFireNotice(FireNotice updatedNotice) {
    final index = _fireNotices.indexWhere((notice) => notice.id == updatedNotice.id);
    if (index != -1) {
      _fireNotices[index] = updatedNotice;
      notifyListeners();
    }
  }

  // Xóa thông báo
  void removeFireNotice(String noticeId) {
    _fireNotices.removeWhere((notice) => notice.id == noticeId);
    notifyListeners();
  }

  // Lọc thông báo theo mức độ nghiêm trọng
  List<FireNotice> getNoticesBySeverity(String severity) {
    return _fireNotices.where((notice) => notice.severity == severity).toList();
  }

  // Lọc thông báo đang hoạt động
  List<FireNotice> getActiveNotices() {
    return _fireNotices.where((notice) => notice.isActive).toList();
  }

  // Xóa lỗi
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
