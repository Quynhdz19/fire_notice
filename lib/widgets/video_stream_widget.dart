import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:async'; // Added missing import for Timer

class VideoStreamWidget extends StatefulWidget {
  final String serverUrl;
  final double height;
  final double width;

  const VideoStreamWidget({
    super.key,
    this.serverUrl = 'http://localhost:5000',
    this.height = 300,
    this.width = double.infinity,
  });

  @override
  State<VideoStreamWidget> createState() => _VideoStreamWidgetState();
}

class _VideoStreamWidgetState extends State<VideoStreamWidget> {
  bool _isConnected = false;
  bool _isStreaming = false;
  String _errorMessage = '';
  Uint8List? _currentFrame;
  Timer? _frameTimer;

  @override
  void initState() {
    super.initState();
    _checkServerStatus();
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkServerStatus() async {
    try {
      final response = await http
          .get(Uri.parse('${widget.serverUrl}/status'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _isConnected = data['camera_connected'] ?? false;
          _isStreaming = data['is_streaming'] ?? false;
          _errorMessage = '';
        });

        if (_isConnected && !_isStreaming) {
          _startStream();
        }
      } else {
        setState(() {
          _isConnected = false;
          _errorMessage = 'Không thể kết nối server';
        });
      }
    } catch (e) {
      setState(() {
        _isConnected = false;
        _errorMessage = 'Lỗi kết nối: $e';
      });
    }
  }

  Future<void> _startStream() async {
    try {
      final response = await http
          .get(Uri.parse('${widget.serverUrl}/start_stream'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() {
          _isStreaming = true;
          _errorMessage = '';
        });
        _startFrameCapture();
      } else {
        setState(() {
          _errorMessage = 'Không thể bắt đầu stream';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi bắt đầu stream: $e';
      });
    }
  }

  Future<void> _stopStream() async {
    try {
      await http
          .get(Uri.parse('${widget.serverUrl}/stop_stream'))
          .timeout(const Duration(seconds: 5));

      setState(() {
        _isStreaming = false;
      });
      _frameTimer?.cancel();
    } catch (e) {
      // Ignore errors when stopping
    }
  }

  void _startFrameCapture() {
    _frameTimer?.cancel();
    _frameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _captureFrame();
    });
  }

  Future<void> _captureFrame() async {
    try {
      final response = await http
          .get(Uri.parse('${widget.serverUrl}/capture_frame'))
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['frame'] != null) {
          final frameBytes = base64.decode(data['frame']);
          setState(() {
            _currentFrame = frameBytes;
            _errorMessage = '';
          });
        }
      }
    } catch (e) {
      // Ignore frame capture errors to avoid spam
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (!_isConnected) {
      return _buildErrorState(
        icon: Icons.wifi_off,
        title: 'Không thể kết nối',
        subtitle: _errorMessage.isNotEmpty ? _errorMessage : 'Server không khả dụng',
        action: ElevatedButton(
          onPressed: _checkServerStatus,
          child: const Text('Thử lại'),
        ),
      );
    }

    if (!_isStreaming) {
      return _buildErrorState(
        icon: Icons.videocam_off,
        title: 'Stream chưa bắt đầu',
        subtitle: 'Nhấn nút để bắt đầu video stream',
        action: ElevatedButton(
          onPressed: _startStream,
          child: const Text('Bắt đầu Stream'),
        ),
      );
    }

    if (_currentFrame == null) {
      return _buildLoadingState();
    }

    return _buildVideoFrame();
  }

  Widget _buildErrorState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget action,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          action,
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            'Đang kết nối video stream...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoFrame() {
    return Stack(
      children: [
        // Video frame
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(
            _currentFrame!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorState(
                icon: Icons.broken_image,
                title: 'Lỗi hiển thị video',
                subtitle: 'Không thể hiển thị frame',
                action: ElevatedButton(
                  onPressed: _captureFrame,
                  child: const Text('Thử lại'),
                ),
              );
            },
          ),
        ),
        
        // Controls overlay
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            children: [
              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fiber_manual_record,
                      size: 8,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              // Stop button
              GestureDetector(
                onTap: _stopStream,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.stop,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Error message overlay
        if (_errorMessage.isNotEmpty)
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
