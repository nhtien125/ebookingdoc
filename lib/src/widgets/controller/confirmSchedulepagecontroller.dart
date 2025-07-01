import 'dart:convert';
import 'package:ebookingdoc/src/constants/services/appointmentService.dart';
import 'package:ebookingdoc/src/constants/services/patient_service.dart';
import 'package:ebookingdoc/src/data/model/appointment_model.dart';
import 'package:ebookingdoc/src/data/model/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmScheduleController extends GetxController
    with WidgetsBindingObserver {
  final RxList<Appointment> appointments = <Appointment>[].obs;
  final AppointmentService _appointmentService = AppointmentService();
  final PatientService _patientService = PatientService();
  final RxList<Patient> patient = <Patient>[].obs;
  final isLoading = false.obs;
  String? doctorId;
  late TabController tabController;

  final List<Map<String, dynamic>> tabs = [
    {'label': 'Chờ xác nhận', 'status': AppointmentStatus.pending},
    {'label': 'Đã xác nhận', 'status': AppointmentStatus.confirmed},
    {'label': 'Đã khám', 'status': AppointmentStatus.done},
    {'label': 'Đã hủy', 'status': AppointmentStatus.cancelled},
    {'label': 'Đã từ chối', 'status': AppointmentStatus.rejected},
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(
        length: tabs.length, vsync: Navigator.of(Get.context!).overlay!);
    print(
        'Khởi tạo ConfirmScheduleController, lấy doctorId và làm mới dữ liệu...');
    loadDoctorIdAndFetch().then((_) {
      if (doctorId != null) {
        clearAndRefreshAppointments();
      } else {
        print('Lỗi: Không thể lấy doctorId từ SharedPreferences');
        Get.snackbar(
          'Lỗi',
          'Không tìm thấy ID bác sĩ trong SharedPreferences',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('Ứng dụng vào foreground, làm mới dữ liệu...');
      if (doctorId != null) {
        fetchSchedulesByDoctorId(doctorId!);
      }
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    super.onClose();
  }

  Future<void> loadDoctorIdAndFetch() async {
    doctorId = await getDoctorIdFromPrefs();
    if (doctorId != null) {
      await fetchSchedulesByDoctorId(doctorId!);
    } else {
      Get.snackbar(
        "Lỗi",
        "Không tìm thấy ID bác sĩ!",
        snackPosition: SnackPosition.BOTTOM,
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

  void clearAndRefreshAppointments() {
    appointments.clear(); // Xóa dữ liệu cũ
    print('Đã xóa danh sách appointments cũ, chuẩn bị làm mới...');
    if (doctorId != null) {
      fetchSchedulesByDoctorId(doctorId!);
    } else {
      print('Lỗi: doctorId là null, không thể làm mới');
      Get.snackbar(
        'Lỗi',
        'Không tìm thấy ID bác sĩ để làm mới dữ liệu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchSchedulesByDoctorId(String doctorId) async {
    isLoading.value = true;
    try {
      print('Bắt đầu fetchSchedulesByDoctorId với doctorId: $doctorId');
      final result = await _appointmentService.getByDoctorId(doctorId);
      print('Danh sách lịch hẹn lấy được từ API:');
      for (final a in result) {
        print(
            'appointment: ${a.uuid}, patientId: ${a.patientId}, status: ${a.status.value} (int: ${appointmentStatusToInt(a.status.value)})');
      }
      appointments.assignAll(result);
      print('Số lượng lịch hẹn Đã khám: ${doneAppointments.length}');

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
          print(
              'Kết quả fetch: ${result.map((e) => '${e.uuid}:${e.name}').join(', ')}');
          if (result.isNotEmpty) {
            patient.addAll(result);
          }
        }
      }

      print(
          'List patient sau khi fetch: ${patient.map((e) => '${e.uuid}:${e.name}').join(', ')}');
    } catch (e) {
      print('Lỗi trong fetchSchedulesByDoctorId: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể lấy danh sách lịch hẹn: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? getPatientNameById(String? patientId) {
    print('DEBUG GET PATIENT NAME: patientId=$patientId');
    print(
        'List patient hiện tại: ${patient.map((e) => '${e.uuid}:${e.name}').join(', ')}');

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

  Future<void> markAsDone(Appointment appt) async {
    isLoading.value = true;
    final oldStatus = appt.status.value;
    appt.status.value = AppointmentStatus.done;
    final statusInt = appointmentStatusToInt(AppointmentStatus.done);
    print(
        'Đang đánh dấu lịch hẹn ${appt.uuid} là Đã khám, status = $statusInt');
    try {
      final success = await _appointmentService.updateStatus(
        appt.uuid,
        statusInt,
      );
      if (success) {
        print(
            'Cập nhật trạng thái thành công cho lịch hẹn ${appt.uuid}, status = $statusInt');
        Get.snackbar(
          "Hoàn thành khám",
          "Đã đánh dấu lịch khám của ${getPatientNameById(appt.patientId) ?? ''} là hoàn thành",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else {
        print(
            'Cập nhật trạng thái thất bại cho lịch hẹn ${appt.uuid}, khôi phục status = ${appointmentStatusToInt(oldStatus)}');
        appt.status.value = oldStatus;
        Get.snackbar(
          "Lỗi",
          "Cập nhật trạng thái thất bại!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Lỗi trong markAsDone cho lịch hẹn ${appt.uuid}: $e');
      appt.status.value = oldStatus;
      Get.snackbar(
        "Lỗi",
        "Cập nhật trạng thái thất bại: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<Appointment> getTabAppointments(AppointmentStatus status) {
    return appointments.where((a) => a.status.value == status).toList();
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
      case AppointmentStatus.done:
        return Colors.blue;
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
      case AppointmentStatus.done:
        return "Đã khám";
    }
  }

  List<Appointment> get pendingAppointments =>
      getTabAppointments(AppointmentStatus.pending);
  List<Appointment> get confirmedAppointments =>
      getTabAppointments(AppointmentStatus.confirmed);
  List<Appointment> get doneAppointments =>
      getTabAppointments(AppointmentStatus.done);
  List<Appointment> get cancelledAppointments =>
      getTabAppointments(AppointmentStatus.cancelled);
  List<Appointment> get rejectedAppointments =>
      getTabAppointments(AppointmentStatus.rejected);
}
