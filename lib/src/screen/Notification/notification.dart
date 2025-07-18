import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyNotification extends StatefulWidget {
  const MyNotification({Key? key}) : super(key: key);

  @override
  _MyNotificationScreenState createState() => _MyNotificationScreenState();
}

class _MyNotificationScreenState extends State<MyNotification> {
  List<dynamic> notifications = [];
  bool isLoading = true;
  int unreadCount = 0;
  late IO.Socket socket;
  String? userId;
  String? token;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    final user = await getUserFromPrefs();
    if (user != null && user.uuid.isNotEmpty) {
      setState(() {
        userId = user.uuid;
      });
      fetchNotifications();
      fetchUnreadCount();
      setupSocket();
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng đăng nhập để xem thông báo')),
      );
    }
  }

  Future<User?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  void setupSocket() {
    socket = IO.io('http://192.168.1.17:3210', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket server');
      socket.emit('join', userId);
    });

    socket.on('new-notification', (data) {
      setState(() {
        notifications.insert(0, data);
        if (data['is_read'] == 0) {
          unreadCount++;
        }
      });
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.17:3210/api/notifications?userId=$userId&page=1&limit=20'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          notifications = data['data']['notifications'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải thông báo: $e')),
      );
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.17:3210/api/notifications/unreadCount/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          unreadCount = data['data']['count'];
        });
      } else {
        throw Exception('Failed to load unread count: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi lấy số thông báo chưa đọc: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể lấy số thông báo chưa đọc: $e')),
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.17:3210/api/notifications/markAsRead/$notificationId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          notifications = notifications.map((n) {
            if (n['uuid'] == notificationId) {
              n['is_read'] = 1;
              unreadCount--;
            }
            return n;
          }).toList();
        });
      } else {
        throw Exception('Failed to mark notification as read: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đánh dấu thông báo đã đọc: $e')),
      );
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.17:3210/api/notifications/markAllAsRead/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          notifications = notifications.map((n) {
            n['is_read'] = 1;
            return n;
          }).toList();
          unreadCount = 0;
        });
      } else {
        throw Exception('Failed to mark all notifications as read: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đánh dấu tất cả thông báo đã đọc: $e')),
      );
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.17:3210/api/notifications/delete/$notificationId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          notifications = notifications.where((n) => n['uuid'] != notificationId).toList();
          fetchUnreadCount();
        });
      } else {
        throw Exception('Failed to delete notification: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi xóa thông báo: $e')),
      );
    }
  }

  String formatDateTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateTime;
    }
  }

  String getNotificationTypeLabel(String type) {
    switch (type) {
      case 'appointment_created':
        return 'Lịch hẹn mới';
      case 'appointment_confirmed':
        return 'Lịch hẹn xác nhận';
      case 'appointment_cancelled':
        return 'Lịch hẹn hủy';
      case 'appointment_rejected':
        return 'Lịch hẹn từ chối';
      case 'appointment_reminder':
        return 'Nhắc nhở lịch hẹn';
      case 'payment_success':
        return 'Thanh toán thành công';
      case 'payment_pending':
        return 'Thanh toán chờ xử lý';
      case 'payment_confirmed':
        return 'Thanh toán xác nhận';
      case 'payment_refunded':
        return 'Hoàn tiền';
      case 'payment_cancelled':
        return 'Thanh toán hủy';
      default:
        return 'Thông báo';
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo ($unreadCount chưa Hawkins đọc)'),
        actions: [
          TextButton(
            onPressed: unreadCount > 0 ? markAllAsRead : null,
            child: Text(
              'Đánh dấu tất cả đã đọc',
              style: TextStyle(
                color: unreadCount > 0 ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text('Không có thông báo nào'))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: Icon(
                          notification['type'].contains('appointment')
                              ? Icons.calendar_today
                              : Icons.payment,
                          color: notification['is_read'] == 0 ? Colors.blue : Colors.grey,
                        ),
                        title: Text(
                          notification['title'],
                          style: TextStyle(
                            fontWeight: notification['is_read'] == 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notification['content']),
                            SizedBox(height: 4),
                            Text(
                              'Loại: ${getNotificationTypeLabel(notification['type'])}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              'Thời gian: ${formatDateTime(notification['created_at'])}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteNotification(notification['uuid']),
                        ),
                        onTap: () {
                          if (notification['is_read'] == 0) {
                            markAsRead(notification['uuid']);
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}