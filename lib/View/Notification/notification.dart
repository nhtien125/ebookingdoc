import 'package:ebookingdoc/Controller/Notification/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyNotification extends StatelessWidget {
  MyNotification({super.key});

  final controller = Get.put(MyNotificationController());

  // Danh sách thông báo
  final List<Map<String, String>> notifications = [
    {
      'title': 'Cuộc hẹn đã bị huỷ',
      'time': 'Today | 15:36 PM',
      'description': 'Bạn đã huỷ cuộc hẹn với bác sĩ thành công!',
    },
    {
      'title': 'Cuộc hẹn đã được đăng ký',
      'time': 'Yesterday | 09:23 AM',
      'description': 'Bạn đã thay đổi lịch hẹn khám với bác sĩ!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Đánh dấu đã đọc',
            icon: Icon(Icons.done_all, color: Colors.black87),
            onPressed: () {
              // Xử lý đánh dấu đã đọc
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.notifications, color: Colors.blue, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['description'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['time'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
