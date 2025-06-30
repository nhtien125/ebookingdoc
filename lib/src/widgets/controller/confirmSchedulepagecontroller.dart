import 'dart:convert';
import 'package:ebookingdoc/src/constants/services/patient_service.dart';
import 'package:ebookingdoc/src/data/model/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/constants/services/appointmentService.dart';
import 'package:ebookingdoc/src/data/model/appointment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmScheduleController extends GetxController {
  final RxList<Appointment> appointments = <Appointment>[].obs;
  final AppointmentService _appointmentService = AppointmentService();
  final PatientService _patientService = PatientService();
  final RxList<Patient> patient = <Patient>[].obs;
  final isLoading = false.obs;
  String? doctorId;

  @override
  void onInit() {
    super.onInit();
    loadDoctorIdAndFetch();
  }

  Color statusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.rejected:
        return Colors.redAccent;
      case AppointmentStatus.cancelled:
        return Colors.grey;
    }
  }

  String statusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return "Chờ xác nhận";
      case AppointmentStatus.confirmed:
        return "Đã xác nhận";
      case AppointmentStatus.rejected:
        return "Đã từ chối";
      case AppointmentStatus.cancelled:
        return "Đã hủy";
    }
  }

  Future<void> loadDoctorIdAndFetch() async {
    doctorId = await getDoctorIdFromPrefs();
    if (doctorId != null) {
      await fetchSchedulesByDoctorId(doctorId!);
    } else {
      Get.snackbar(
        "Lỗi",
        "Không tìm thấy thông tin bác sĩ!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<String?> getDoctorIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final doctorJson = prefs.getString('doctor_data');
    if (doctorJson != null) {
      final doctor = jsonDecode(doctorJson);
      return doctor['uuid'];
    }
    return null;
  }

 Future<void> fetchSchedulesByDoctorId(String doctorId) async {
  isLoading.value = true;
  try {
    final result = await _appointmentService.getByDoctorId(doctorId);
    appointments.assignAll(result);

    print('Appointments lấy được:');
    for (final a in appointments) {
      print('appointment: ${a.uuid}, patientId: ${a.patientId}');
    }

    // Lấy toàn bộ patientId duy nhất từ lịch hẹn
    final ids = appointments
        .map((a) => a.patientId)
        .where((id) => id != null)
        .toSet()
        .toList();

    print('Danh sách ids bệnh nhân cần fetch: $ids');

    patient.clear();
    for (final id in ids) {
      if (id != null) {
        print('Đang fetch patientId: $id');
        final result = await _patientService.getPatientsById(id);
        print('Kết quả fetch: ${result.map((e) => '${e.uuid}:${e.name}').join(', ')}');
        if (result.isNotEmpty) {
          patient.addAll(result); // add vào list
        }
      }
    }

    print('List patient sau khi fetch: ${patient.map((e) => '${e.uuid}:${e.name}').join(', ')}');
  } finally {
    isLoading.value = false;
  }
}


  // Hàm lấy tên bệnh nhân từ RxList<Patient>
String? getPatientNameById(String? patientId) {
  print('DEBUG GET PATIENT NAME: patientId=$patientId');
  print('List patient hiện tại: ${patient.map((e) => '${e.uuid}:${e.name}').join(', ')}');

  final p = patient.firstWhereOrNull((e) => e.uuid == patientId);

  if (p == null) {
    print('Không tìm thấy patientId=$patientId trong danh sách.');
    return null;
  } else {
    print('Tìm thấy: ${p.name}');
    return p.name;
  }
}

  Future<void> confirmAppointment(Appointment appt) async {
    isLoading.value = true;
    final oldStatus = appt.status.value;
    appt.status.value = AppointmentStatus.confirmed;
    try {
      final success = await _appointmentService.updateStatus(
        appt.uuid,
        appointmentStatusToInt(AppointmentStatus.confirmed),
      );
      if (success) {
        Get.snackbar(
          "Xác nhận thành công",
          "Đã xác nhận lịch cho ${getPatientNameById(appt.patientId) ?? ''}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF19C37D),
          colorText: Colors.white,
        );
        Get.back();
      } else {
        appt.status.value = oldStatus;
        Get.snackbar(
          "Lỗi",
          "Cập nhật trạng thái thất bại!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectAppointment(Appointment appt) async {
    isLoading.value = true;
    final oldStatus = appt.status.value;
    appt.status.value = AppointmentStatus.rejected;
    try {
      final success = await _appointmentService.updateStatus(
        appt.uuid,
        appointmentStatusToInt(AppointmentStatus.rejected),
      );
      if (success) {
        Get.snackbar(
          "Từ chối thành công",
          "Đã từ chối lịch của ${getPatientNameById(appt.patientId) ?? ''}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFE9573F),
          colorText: Colors.white,
        );
        Get.back();
      } else {
        appt.status.value = oldStatus;
        Get.snackbar(
          "Lỗi",
          "Cập nhật trạng thái thất bại!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelAppointment(Appointment appt) async {
    isLoading.value = true;
    final oldStatus = appt.status.value;
    appt.status.value = AppointmentStatus.cancelled;
    try {
      final success = await _appointmentService.updateStatus(
        appt.uuid,
        appointmentStatusToInt(AppointmentStatus.cancelled),
      );
      if (success) {
        Get.snackbar(
          "Hủy lịch thành công",
          "Đã hủy lịch của ${getPatientNameById(appt.patientId) ?? ''}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey,
          colorText: Colors.white,
        );
        Get.back();
      } else {
        appt.status.value = oldStatus;
        Get.snackbar(
          "Lỗi",
          "Cập nhật trạng thái thất bại!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<Appointment> get pendingAppointments => appointments
      .where((a) => a.status.value == AppointmentStatus.pending)
      .toList();

  List<Appointment> get confirmedAppointments => appointments
      .where((a) => a.status.value == AppointmentStatus.confirmed)
      .toList();

  List<Appointment> get rejectedAppointments => appointments
      .where((a) => a.status.value == AppointmentStatus.rejected)
      .toList();

  List<Appointment> get cancelledAppointments => appointments
      .where((a) => a.status.value == AppointmentStatus.cancelled)
      .toList();
}
