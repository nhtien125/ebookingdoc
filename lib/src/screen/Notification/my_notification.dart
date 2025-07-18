import 'package:ebookingdoc/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyNotificationDoctor extends StatefulWidget {
  const MyNotificationDoctor({Key? key}) : super(key: key);

  @override
  _MyNotificationDoctorScreenState createState() => _MyNotificationDoctorScreenState();
}

class _MyNotificationDoctorScreenState extends State<MyNotificationDoctor> {
  List<dynamic> notifications = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  int unreadCount = 0;
  int currentPage = 1;
  final int itemsPerPage = 20;
  bool hasMoreData = true;
  IO.Socket? socket;
  String? userId;
  final ScrollController _scrollController = ScrollController();

  static const String BASE_URL = 'http://192.168.1.16:3210';
  static const Duration REQUEST_TIMEOUT = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _disconnectSocket();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore && hasMoreData) {
        _loadMoreNotifications();
      }
    }
  }

  Future<void> _initializeUserData() async {
    try {
      final user = await getUserFromPrefs();
      if (user != null && user.uuid.isNotEmpty) {
        setState(() {
          userId = user.uuid;
        });
        await Future.wait([
          fetchNotifications(),
          fetchUnreadCount(),
        ]);
        setupSocket();
      } else {
        setState(() {
          isLoading = false;
        });
        _showSnackBar('Vui lòng đăng nhập để xem thông báo');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Lỗi khởi tạo: $e');
    }
  }

  Future<User?> getUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      print('Lỗi parse user data: $e');
    }
    return null;
  }

  void setupSocket() {
    if (userId == null) return;

    try {
      socket = IO.io(BASE_URL, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'timeout': 20000,
      });

      socket!.connect();

      socket!.onConnect((_) {
        print('Connected to socket server');
        socket!.emit('join', userId);
      });

      socket!.on('new-notification', _handleNewNotification);

      socket!.onDisconnect((_) {
        print('Disconnected from socket server');
      });

      socket!.onError((error) {
        print('Socket error: $error');
      });
    } catch (e) {
      print('Error setting up socket: $e');
    }
  }

  void _handleNewNotification(dynamic data) {
    if (data != null && data['uuid'] != null) {
      setState(() {
        notifications.insert(0, data);
        if (data['is_read'] == 0) {
          unreadCount++;
        }
      });

      _showLocalNotification(
        data['title'] ?? 'Thông báo mới',
        data['content'] ?? 'Bạn có thông báo mới!',
      );
    } else {
      print('Dữ liệu thông báo không hợp lệ: $data');
    }
  }

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (userId == null) return;

    if (isRefresh) {
      setState(() {
        currentPage = 1;
        hasMoreData = true;
      });
    }

    try {
      final response = await http
          .get(
            Uri.parse(
                '$BASE_URL/api/notifications?userId=$userId&page=$currentPage&limit=$itemsPerPage'),
          )
          .timeout(REQUEST_TIMEOUT);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['notifications'] != null) {
          final List<dynamic> newNotifications = data['data']['notifications'];

          setState(() {
            if (isRefresh) {
              notifications = newNotifications;
            } else {
              notifications.addAll(newNotifications);
            }
            isLoading = false;
            hasMoreData = newNotifications.length == itemsPerPage;
          });
        } else {
          throw Exception('Dữ liệu thông báo không đúng định dạng');
        }
      } else {
        throw Exception('Không tải được thông báo: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Không thể tải thông báo: $e');
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (isLoading || isLoadingMore || !hasMoreData) return;

    setState(() {
      isLoadingMore = true;
      currentPage++;
    });

    try {
      final response = await http
          .get(
            Uri.parse(
                '$BASE_URL/api/notifications?userId=$userId&page=$currentPage&limit=$itemsPerPage'),
          )
          .timeout(REQUEST_TIMEOUT);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['notifications'] != null) {
          final List<dynamic> newNotifications = data['data']['notifications'];

          setState(() {
            notifications.addAll(newNotifications);
            hasMoreData = newNotifications.length == itemsPerPage;
          });
        }
      }
    } catch (e) {
      _showSnackBar('Không thể tải thêm thông báo: $e');
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future<void> fetchUnreadCount() async {
    if (userId == null) return;

    try {
      final response = await http
          .get(
            Uri.parse('$BASE_URL/api/notifications/unreadCount/$userId'),
          )
          .timeout(REQUEST_TIMEOUT);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['count'] != null) {
          setState(() {
            unreadCount = data['data']['count'];
          });
        }
      } else {
        throw Exception('Lỗi tải số thông báo: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Không thể tải số thông báo chưa đọc: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await http
          .put(
            Uri.parse('$BASE_URL/api/notifications/markAsRead/$notificationId'),
          )
          .timeout(REQUEST_TIMEOUT);

      if (response.statusCode == 200) {
        setState(() {
          notifications = notifications.map((n) {
            if (n['uuid'] == notificationId && n['is_read'] == 0) {
              n['is_read'] = 1;
              unreadCount = (unreadCount > 0) ? unreadCount - 1 : 0;
            }
            return n;
          }).toList();
        });
      } else {
        throw Exception(
            'Không đánh dấu thông báo đã đọc: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Lỗi đánh dấu thông báo đã đọc: $e');
    }
  }

  Future<void> markAllAsRead() async {
    if (userId == null || unreadCount == 0) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http
          .put(
            Uri.parse('$BASE_URL/api/notifications/markAllAsRead/$userId'),
          )
          .timeout(REQUEST_TIMEOUT);

      if (response.statusCode == 200) {
        setState(() {
          notifications = notifications.map((n) {
            n['is_read'] = 1;
            return n;
          }).toList();
          unreadCount = 0;
        });
        Navigator.of(context).pop();
        _showSnackBar('Đã đánh dấu tất cả thông báo đã đọc');
      } else {
        throw Exception(
            'Không đánh dấu tất cả thông báo đã đọc: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showSnackBar('Lỗi đánh dấu tất cả thông báo đã đọc: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn xóa thông báo này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final response = await http
          .delete(
            Uri.parse('$BASE_URL/api/notifications/delete/$notificationId'),
          )
          .timeout(REQUEST_TIMEOUT);

      if (response.statusCode == 200) {
        setState(() {
          final notificationToRemove = notifications.firstWhere(
            (n) => n['uuid'] == notificationId,
            orElse: () => null,
          );

          if (notificationToRemove != null &&
              notificationToRemove['is_read'] == 0) {
            unreadCount = (unreadCount > 0) ? unreadCount - 1 : 0;
          }

          notifications =
              notifications.where((n) => n['uuid'] != notificationId).toList();
        });
        _showSnackBar('Đã xóa thông báo');
      } else {
        throw Exception('Không xóa được thông báo: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Lỗi xóa thông báo: $e');
    }
  }

  Future<void> _refreshNotifications() async {
    await Future.wait([
      fetchNotifications(isRefresh: true),
      fetchUnreadCount(),
    ]);
  }

  void _disconnectSocket() {
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _showLocalNotification(String title, String content) {
    // Implementation for local notification
    // This would require setting up Flutter Local Notifications plugin
  }

  String formatDateTime(String dateTime) {
    try {
      DateTime date;
      // Xử lý cả "Dec 17 2024 07:00:00 GMT+0700" và "2025-07-18T14:40:00Z"
      if (dateTime.contains('GMT')) {
        // Lấy phần ngày và giờ, bỏ "GMT+0700"
        final parts = dateTime.split(' ');
        date = DateFormat("MMM dd yyyy HH:mm:ss", "en_US")
            .parse("${parts[0]} ${parts[1]} ${parts[2]} ${parts[3]}")
            .toLocal();
      } else {
        date = DateTime.parse(dateTime).toUtc().add(const Duration(hours: 7));
      }
      final now = DateTime.now().toUtc().add(const Duration(hours: 7));
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Hôm nay, ${DateFormat('HH:mm').format(date)}';
      } else if (difference.inDays == 1) {
        return 'Hôm qua, ${DateFormat('HH:mm').format(date)}';
      } else if (difference.inDays < 7) {
        return '${_getWeekday(date.weekday)}, ${DateFormat('HH:mm').format(date)}';
      } else {
        return '${DateFormat('dd/MM/yyyy HH:mm').format(date)}';
      }
    } catch (e) {
      print('Lỗi định dạng thời gian: $e - Raw: $dateTime');
      return 'Không xác định'; // Trả về mặc định nếu lỗi
    }
  }

  String _getWeekday(int weekday) {
    const Map<int, String> weekdays = {
      1: 'Thứ Hai',
      2: 'Thứ Ba',
      3: 'Thứ Tư',
      4: 'Thứ Năm',
      5: 'Thứ Sáu',
      6: 'Thứ Bảy',
      7: 'Chủ Nhật',
    };
    return weekdays[weekday] ?? 'Ngày';
  }

  String getNotificationTypeLabel(String type) {
    const typeLabels = {
      'appointment_created': 'Lịch hẹn mới',
      'appointment_confirmed': 'Lịch hẹn xác nhận',
      'appointment_cancelled': 'Lịch hẹn hủy',
      'appointment_rejected': 'Lịch hẹn từ chối',
      'appointment_completed': 'Lịch hẹn đã khám',
      'appointment_updated': 'Cập nhật lịch hẹn',
      'payment_success': 'Thanh toán thành công',
      'payment_pending': 'Thanh toán chờ xử lý',
      'payment_confirmed': 'Thanh toán xác nhận',
      'payment_refunded': 'Hoàn tiền',
      'payment_cancelled': 'Thanh toán hủy',
    };
    return typeLabels[type] ?? 'Thông báo';
  }

  Color _getNotificationColor(String type) {
    if (type.contains('appointment')) {
      return Colors.blue;
    } else if (type.contains('payment')) {
      return Colors.green;
    }
    return Colors.grey;
  }

  IconData _getNotificationIcon(String type) {
    if (type.contains('appointment')) {
      return Icons.calendar_today;
    } else if (type.contains('payment')) {
      return Icons.payment;
    }
    return Icons.notifications;
  }

  Widget _buildNotificationItem(dynamic notification, int index) {
    final isRead = notification['is_read'] == 1;
    final type = notification['type'] ?? 'unknown';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: isRead ? 1 : 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isRead ? Colors.grey.shade300 : _getNotificationColor(type),
          child: Icon(
            _getNotificationIcon(type),
            color: isRead ? Colors.grey : Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification['title'] ?? 'Không có tiêu đề',
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            color: isRead ? Colors.grey.shade600 : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['content'] ?? 'Không có nội dung',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isRead ? Colors.grey.shade600 : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    getNotificationTypeLabel(type),
                    style: TextStyle(
                      fontSize: 11,
                      color: _getNotificationColor(type),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatDateTime(notification['created_at'] ?? ''),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'mark_read':
                if (!isRead) markAsRead(notification['uuid']);
                break;
              case 'delete':
                deleteNotification(notification['uuid']);
                break;
            }
          },
          itemBuilder: (context) => [
            if (!isRead)
              const PopupMenuItem(
                value: 'mark_read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read),
                    SizedBox(width: 8),
                    Text('Đánh dấu đã đọc'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Xóa', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          if (!isRead) {
            markAsRead(notification['uuid']);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Thông báo${unreadCount > 0 ? ' ($unreadCount chưa đọc)' : ''}'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: markAllAsRead,
              child: const Text(
                'Đánh dấu tất cả đã đọc',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Không có thông báo nào',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: notifications.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == notifications.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return _buildNotificationItem(
                          notifications[index], index);
                    },
                  ),
      ),
    );
  }
}