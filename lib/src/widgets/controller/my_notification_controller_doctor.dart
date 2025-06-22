import 'package:get/get.dart';

class MyNotificationControllerDoctor extends GetxController {
  final notifications = [
    {
      'title': 'Lịch hẹn sắp đến',
      'description': 'Bạn có cuộc hẹn với bệnh nhân Nguyễn Văn A vào lúc 08:30 hôm nay.',
      'time': '08:10, 23/06/2025',
      'hour': '08:30',
      'patient': 'Nguyễn Văn A',
      'isRead': false,
      'type': 'booked'
    },
    {
      'title': 'Đặt lịch thành công',
      'description': 'Bạn đã xác nhận lịch khám với bệnh nhân Trần Thị B vào lúc 09:45 ngày 23/06/2025.',
      'time': '07:12, 23/06/2025',
      'hour': '09:45',
      'patient': 'Trần Thị B',
      'isRead': false,
      'type': 'success'
    },
    {
      'title': 'Từ chối lịch khám',
      'description': 'Bạn vừa từ chối lịch khám với bệnh nhân Phạm Văn C vào lúc 10:30 hôm nay.',
      'time': '06:20, 23/06/2025',
      'hour': '10:30',
      'patient': 'Phạm Văn C',
      'isRead': true,
      'type': 'reject'
    },
  ].obs;

  void markAllAsRead() {
    for (var n in notifications) {
      n['isRead'] = true;
    }
    notifications.refresh();
  }

  void deleteNotification(int index) {
    notifications.removeAt(index);
  }

  void markAsRead(int index) {
    notifications[index]['isRead'] = true;
    notifications.refresh();
  }
}
