import 'dart:ui';

import 'package:ebookingdoc/src/data/model/AppointmentScreen_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppointmentStatus { pending, confirmed, rejected }

var appointments = <Appointment>[].obs;

class PatientAppointment {
  final String id;
  final String name;
  final String time;
  final String date;
  final String symptom;
  Rx<AppointmentStatus> status;

  PatientAppointment({
    required this.id,
    required this.name,
    required this.time,
    required this.date,
    required this.symptom,
    required AppointmentStatus status,
  }) : status = status.obs;
}

class ConfirmScheduleController extends GetxController {
  var appointments = <PatientAppointment>[
    PatientAppointment(
      id: "1",
      name: "Nguyễn Thị Hoa",
      time: "08:30",
      date: "25/06/2025",
      symptom: "Đau ngực, khó thở",
      status: AppointmentStatus.pending,
    ),
    PatientAppointment(
      id: "2",
      name: "Trần Văn Bình",
      time: "09:15",
      date: "25/06/2025",
      symptom: "Huyết áp cao, chóng mặt",
      status: AppointmentStatus.pending,
    ),
    PatientAppointment(
      id: "3",
      name: "Phạm Quỳnh Như",
      time: "10:00",
      date: "25/06/2025",
      symptom: "Nhịp tim không đều",
      status: AppointmentStatus.confirmed,
    ),
    PatientAppointment(
      id: "4",
      name: "Lê Hoàng Sơn",
      time: "11:00",
      date: "25/06/2025",
      symptom: "Khó thở khi vận động",
      status: AppointmentStatus.rejected,
    ),
  ].obs;

  void confirmAppointment(PatientAppointment appt) {
    appt.status.value = AppointmentStatus.confirmed;
    Get.snackbar("Xác nhận thành công", "Đã xác nhận lịch cho ${appt.name}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF19C37D),
        colorText: Colors.white);
    Get.back(); // Quay lại màn hình trước
  }

  void rejectAppointment(PatientAppointment appt) {
    appt.status.value = AppointmentStatus.rejected;
    Get.snackbar("Từ chối thành công", "Đã từ chối lịch của ${appt.name}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE9573F),
        colorText: Colors.white);
    Get.back(); // Quay lại màn hình trước
  }
}
