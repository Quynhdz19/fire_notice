class FireNotice {
  final String id;
  final String title;
  final String message;
  final String location;
  final DateTime timestamp;
  final String severity; // low, medium, high, critical
  final bool isActive;
  final String? videoUrl;
  final String? imageUrl;

  FireNotice({
    required this.id,
    required this.title,
    required this.message,
    required this.location,
    required this.timestamp,
    required this.severity,
    required this.isActive,
    this.videoUrl,
    this.imageUrl,
  });

  factory FireNotice.fromJson(Map<String, dynamic> json) {
    return FireNotice(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      location: json['location'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      severity: json['severity'] ?? 'low',
      isActive: json['isActive'] ?? true,
      videoUrl: json['videoUrl'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity,
      'isActive': isActive,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
    };
  }
}
