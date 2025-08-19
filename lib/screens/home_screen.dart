import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fire_notice_provider.dart';

import '../widgets/status_card.dart';
import '../widgets/notice_list.dart';
import '../widgets/video_stream_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FireNoticeProvider>().fetchFireNotices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF0A0E21),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Fire Notice',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A1F35),
                        Color(0xFF0A0E21),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // Navigate to notifications
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    // Navigate to settings
                  },
                ),
              ],
            ),
            
            // Status Overview
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tổng quan hệ thống',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<FireNoticeProvider>(
                      builder: (context, fireProvider, child) {
                        final activeNotices = fireProvider.getActiveNotices();
                        final totalNotices = fireProvider.fireNotices.length;
                        
                        return Row(
                          children: [
                            Expanded(
                              child: StatusCard(
                                title: 'Cảnh báo',
                                value: activeNotices.length.toString(),
                                color: Colors.red,
                                icon: Icons.warning,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: StatusCard(
                                title: 'Tổng thông báo',
                                value: totalNotices.toString(),
                                color: Colors.blue,
                                icon: Icons.notifications,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: StatusCard(
                                title: 'Video Stream',
                                value: 'Live',
                                color: Colors.green,
                                icon: Icons.videocam,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Video Stream Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Video Stream từ Backend',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const VideoStreamWidget(
                      serverUrl: 'http://localhost:5000',
                      height: 300,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),

            // Fire Notices
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Thông báo báo cháy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to all notices
                          },
                          child: const Text(
                            'Xem tất cả',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const NoticeList(),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }
}
