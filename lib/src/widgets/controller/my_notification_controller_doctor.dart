import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebookingdoc/src/Global/app_color.dart';

class MyNotificationControllerDoctor extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var unreadCount = 0.obs;
  IO.Socket? socket;
  String? userId; // Sử dụng user_id thay vì doctorId

  @override
  void onInit() {
    super.onInit();
    _initializeDoctorData();
  }

  Future<void> _initializeDoctorData() async {
    final user = await getUserFromPrefs();
    if (user != null && user['uuid'] != null) {
      userId = user['uuid'];
      await Future.wait([
        fetchNotifications(),
        fetchUnreadCount(),
      ]);
      setupSocket();
    } else {
      isLoading.value = false;
      Get.snackbar('Lỗi', 'Vui lòng đăng nhập để xem thông báo');
    }
  }

  Future<Map<String, dynamic>?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data'); // Key lưu thông tin user
    if (userJson != null) {
      try {
        return jsonDecode(userJson);
      } catch (e) {
        print('Lỗi parse user data: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> fetchNotifications() async {
    if (userId == null) return;
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.16:3210/api/notifications?userId=$userId&page=1&limit=20'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['notifications'] != null) {
          notifications.value = List<Map<String, dynamic>>.from(data['data']['notifications']);
          isLoading.value = false;
        } else {
          throw Exception('Dữ liệu thông báo không đúng định dạng');
        }
      } else {
        throw Exception('Không tải được thông báo: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Lỗi', 'Không thể tải thông báo: $e');
    }
  }

  Future<void> fetchUnreadCount() async {
    if (userId == null) return;
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.16:3210/api/notifications/unreadCount/$userId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['count'] != null) {
          unreadCount.value = data['data']['count'];
        } else {
          throw Exception('Dữ liệu số thông báo chưa đọc không đúng định dạng');
        }
      } else {
        throw Exception('Không tải được số thông báo chưa đọc: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lấy số thông báo chưa đọc: $e');
    }
  }

  Future<void> markAsRead(int index) async {
    if (userId == null || index < 0 || index >= notifications.length) return;
    final notificationId = notifications[index]['uuid'];
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.16:3210/api/notifications/markAsRead/$notificationId'),
      );
      if (response.statusCode == 200) {
        notifications[index]['isRead'] = 1;
        if (unreadCount.value > 0) unreadCount.value--;
        notifications.refresh();
      } else {
        throw Exception('Không đánh dấu thông báo đã đọc: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Lỗi đánh dấu thông báo đã đọc: $e');
    }
  }

  Future<void> markAllAsRead() async {
    if (userId == null) return;
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.16:3210/api/notifications/markAllAsRead/$userId'),
      );
      if (response.statusCode == 200) {
        for (var notification in notifications) {
          notification['isRead'] = 1;
        }
        unreadCount.value = 0;
        notifications.refresh();
      } else {
        throw Exception('Không đánh dấu tất cả thông báo đã đọc: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Lỗi đánh dấu tất cả thông báo đã đọc: $e');
    }
  }

  Future<void> deleteNotification(int index) async {
    if (userId == null || index < 0 || index >= notifications.length) return;
    final notificationId = notifications[index]['uuid'];
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.16:3210/api/notifications/delete/$notificationId'),
      );
      if (response.statusCode == 200) {
        notifications.removeAt(index);
        fetchUnreadCount(); // Cập nhật lại số lượng chưa đọc
        notifications.refresh();
      } else {
        throw Exception('Không xóa được thông báo: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Lỗi xóa thông báo: $e');
    }
  }

  void setupSocket() {
    if (userId == null) return;

    socket = IO.io('http://192.168.1.16:3210', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      print('Connected to socket server');
      socket!.emit('join', userId);
    });

    socket!.on('new-notification', (data) {
      if (data != null && data['uuid'] != null) {
        notifications.insert(0, data);
        if (data['isRead'] == 0) {
          unreadCount.value++;
        }
        notifications.refresh();
      } else {
        print('Dữ liệu thông báo không hợp lệ: $data');
      }
    });

    socket!.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }

  @override
  void onClose() {
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
    }
    super.onClose();
  }
}

class MyNotificationDoctor extends StatelessWidget {
  MyNotificationDoctor({super.key});

  final controller = Get.put(MyNotificationControllerDoctor());

  void showMarkAllReadBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Xác nhận đánh dấu tất cả đã đọc?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColor.main),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Hủy"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColor.fourthMain),
                    onPressed: () {
                      controller.markAllAsRead();
                      Navigator.pop(context);
                    },
                    child: Text("Xác nhận", style: TextStyle(color: AppColor.main)),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Color _typeColor(String? type) {
    switch (type) {
      case 'booked':
        return Colors.orange;
      case 'success':
        return Colors.green;
      case 'reject':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _typeIcon(String? type) {
    switch (type) {
      case 'booked':
        return Icons.schedule;
      case 'success':
        return Icons.check_circle_outline;
      case 'reject':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColor.fourthMain,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 4,
          backgroundColor: AppColor.fourthMain,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            'Thông báo',
            style: TextStyle(
              color: AppColor.main,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              tooltip: 'Đánh dấu tất cả đã đọc',
              icon: Icon(Icons.done_all, color: AppColor.main),
              onPressed: () {
                showMarkAllReadBottomSheet(context);
              },
            ),
          ],
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.notifications.isEmpty
                  ? const Center(
                      child: Text(
                        'Không có thông báo nào',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.notifications.length,
                      itemBuilder: (context, index) {
                        final item = controller.notifications[index];
                        final color = _typeColor(item['type'] as String?);
                        final icon = _typeIcon(item['type'] as String?);
                        return Dismissible(
                          key: Key((item['title'] ?? '') as String),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            controller.deleteNotification(index);
                          },
                          background: Container(
                            padding: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                            color: Colors.red.shade400,
                            child: const Icon(Icons.delete, color: Colors.white, size: 24),
                          ),
                          child: GestureDetector(
                            onTap: () => controller.markAsRead(index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: item['isRead'] != null && item['isRead'] == 1
                                    ? Colors.white
                                    : color.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: color.withOpacity(0.22),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: color.withOpacity(0.13),
                                    child: Icon(icon, color: color),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (item['title'] ?? '') as String,
                                          style: TextStyle(
                                            fontWeight: item['isRead'] != null && item['isRead'] == 1
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                            fontSize: 16,
                                            color: color,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        if (item['hour'] != null && item['patient'] != null)
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(text: "Bạn có cuộc hẹn với bệnh nhân "),
                                                TextSpan(
                                                  text: item['patient'] as String,
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                const TextSpan(text: " vào lúc "),
                                                TextSpan(
                                                  text: item['hour']?.toString(),
                                                  style: TextStyle(
                                                    color: color,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const TextSpan(text: "."),
                                              ],
                                            ),
                                            style: const TextStyle(fontSize: 14),
                                          )
                                        else
                                          Text(
                                            (item['description'] ?? '') as String,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        const SizedBox(height: 8),
                                        Text(
                                          (item['time'] ?? '') as String,
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
                            ),
                          ),
                        );
                      },
                    );
        }),
      ),
    );
  }
}