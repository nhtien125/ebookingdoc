import 'package:get/get.dart';

class MyNotificationController extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    notifications.assignAll([
      {
        'title': 'Cuộc hẹn đã bị huỷ',
        'time': 'Today | 15:36 PM',
        'description': 'Bạn đã huỷ cuộc hẹn với bác sĩ thành công!',
        'isRead': false,
      },
      {
        'title': 'Cuộc hẹn đã được đăng ký',
        'time': 'Yesterday | 09:23 AM',
        'description': 'Bạn đã thay đổi lịch hẹn khám với bác sĩ!',
        'isRead': false,
      },
    ]);
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification['isRead'] = true;
    }
    notifications.refresh();
  }

  void markAsRead(int index) {
    notifications[index]['isRead'] = true;
    notifications.refresh();
  }

  void deleteNotification(int index) {
    notifications.removeAt(index);
  }
}
