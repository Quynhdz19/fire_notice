class CameraFeed {
  final String id;
  final String name;
  final String location;
  final String streamUrl;
  final bool isActive;
  final String status; // online, offline, error
  final DateTime lastUpdate;

  CameraFeed({
    required this.id,
    required this.name,
    required this.location,
    required this.streamUrl,
    required this.isActive,
    required this.status,
    required this.lastUpdate,
  });

  factory CameraFeed.fromJson(Map<String, dynamic> json) {
    return CameraFeed(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
      isActive: json['isActive'] ?? true,
      status: json['status'] ?? 'offline',
      lastUpdate: DateTime.parse(json['lastUpdate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'streamUrl': streamUrl,
      'isActive': isActive,
      'status': status,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  CameraFeed copyWith({
    String? id,
    String? name,
    String? location,
    String? streamUrl,
    bool? isActive,
    String? status,
    DateTime? lastUpdate,
  }) {
    return CameraFeed(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      streamUrl: streamUrl ?? this.streamUrl,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
