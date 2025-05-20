import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  var isLoading = false.obs;
  var appointments = <int, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  void fetchAppointments() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      appointments.value = {
        1: {
          'id': 1,
          'hospitalName': 'Phòng khám XYZ',
          'doctorName': 'Bác sĩ A',
          'department': 'Nội tổng quát',
          'date': '05/04/2025',
          'time': '10:00',
          'status': 'Đã xác nhận',
        },
        2: {
          'id': 2,
          'hospitalName': 'Phòng khám ABC',
          'doctorName': 'Bác sĩ B',
          'department': 'Da liễu',
          'date': '06/04/2025',
          'time': '14:30',
          'status': 'Đang chờ',
        },
      };
    } finally {
      isLoading.value = false;
    }
  }

  void addAppointment(Map<String, dynamic> newAppointment) {
    final newId = (appointments.keys.isEmpty ? 1 : appointments.keys.last + 1);
    appointments[newId] = {'id': newId, ...newAppointment};
    appointments.refresh();
    Get.snackbar(
      'Thành công',
      'Lịch hẹn mới đã được tạo!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void cancelAppointment(int id) {
    if (appointments.containsKey(id)) {
      appointments[id]!['status'] = 'Đã hủy';
      appointments.refresh();
      Get.snackbar(
        'Hủy lịch',
        'Lịch hẹn đã được hủy!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void rescheduleAppointment(int id, String newDate, String newTime) {
    if (appointments.containsKey(id)) {
      appointments[id]!['date'] = newDate;
      appointments[id]!['time'] = newTime;
      appointments[id]!['status'] = 'Đã xác nhận';
      appointments.refresh();
      Get.snackbar(
        'Đổi lịch',
        'Lịch hẹn đã được cập nhật!',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  void showNewAppointmentDialog(BuildContext context) {
    final doctorController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đặt lịch hẹn mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: doctorController,
              decoration: const InputDecoration(labelText: 'Tên bác sĩ'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Ngày'),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Giờ'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              addAppointment({
                'hospitalName': 'Phòng khám ABC',
                'doctorName': doctorController.text,
                'department': 'Đa khoa',
                'date': dateController.text,
                'time': timeController.text,
                'status': 'Đang chờ',
              });
              Navigator.pop(context);
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}
