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
    print('Khởi tạo ConfirmScheduleController, lấy doctorId và làm mới dữ liệu...');
    initializeData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && doctorId != null) {
      print('Ứng dụng vào foreground, kiểm tra và làm mới dữ liệu...');
      if (appointments.isEmpty) {
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

  Future<void> initializeData() async {
    doctorId = await getDoctorIdFromPrefs();
    if (doctorId != null && appointments.isEmpty) {
      await fetchSchedulesByDoctorId(doctorId!);
    } else if (doctorId == null) {
      print('Lỗi: Không thể lấy doctorId từ SharedPreferences');
      Get.snackbar(
        'Lỗi',
        'Không tìm thấy ID bác sĩ trong SharedPreferences',
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
    if (doctorId != null) {
      appointments.clear();
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

  // Thêm logging chi tiết trong controller để debug
Future<void> confirmAppointment(Appointment appt) async {
  print('=== CONFIRM APPOINTMENT DEBUG ===');
  print('Appointment UUID: ${appt.uuid}');
  print('Current status: ${appt.status.value} (${appointmentStatusToInt(appt.status.value)})');
  print('Target status: ${AppointmentStatus.confirmed} (${appointmentStatusToInt(AppointmentStatus.confirmed)})');
  
  isLoading.value = true;
  final oldStatus = appt.status.value;
  appt.status.value = AppointmentStatus.confirmed;
  
  try {
    final targetStatusInt = appointmentStatusToInt(AppointmentStatus.confirmed);
    print('Calling API updateStatus with: UUID=${appt.uuid}, Status=$targetStatusInt');
    
    final success = await _appointmentService.updateStatus(
      appt.uuid,
      targetStatusInt,
    );
    
    print('API updateStatus result: $success');
    
    if (success) {
      // Verify the update immediately
      print('Verifying update by refetching...');
      if (doctorId != null) {
        await fetchSchedulesByDoctorId(doctorId!);
        
        // Check if the appointment was actually updated
        final updatedAppt = appointments.firstWhereOrNull((a) => a.uuid == appt.uuid);
        if (updatedAppt != null) {
          print('After refetch - Status: ${updatedAppt.status.value} (${appointmentStatusToInt(updatedAppt.status.value)})');
        }
      }
      
      Get.snackbar(
        "Xác nhận thành công",
        "Đã xác nhận lịch cho ${getPatientNameById(appt.patientId) ?? ''}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF19C37D),
        colorText: Colors.white,
      );
    } else {
      print('API returned false, reverting status');
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
    print('Exception in confirmAppointment: $e');
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
  print('=== END CONFIRM APPOINTMENT DEBUG ===');
}

Future<void> markAsDone(Appointment appt) async {
  print('=== MARK AS DONE DEBUG ===');
  print('Appointment UUID: ${appt.uuid}');
  print('Current status: ${appt.status.value} (${appointmentStatusToInt(appt.status.value)})');
  print('Target status: ${AppointmentStatus.done} (${appointmentStatusToInt(AppointmentStatus.done)})');
  
  isLoading.value = true;
  final oldStatus = appt.status.value;
  appt.status.value = AppointmentStatus.done;
  final statusInt = appointmentStatusToInt(AppointmentStatus.done);
  
  try {
    final now = DateTime.now();
    final apptDateTime = DateTime.parse(appt.dateTime!);
    final timeDifference = now.difference(apptDateTime).inHours;

    if (now.isBefore(apptDateTime) || timeDifference < 5) {
      Get.snackbar(
        "Lỗi",
        "Chỉ có thể đánh dấu 'Đã khám' khi thời gian hiện tại lớn hơn lịch hẹn ít nhất 5 tiếng!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      appt.status.value = oldStatus;
      return;
    }

    print('Calling API updateStatus with: UUID=${appt.uuid}, Status=$statusInt');
    final success = await _appointmentService.updateStatus(appt.uuid, statusInt);
    print('API updateStatus result: $success');
    
    if (success) {
      print('Success! Verifying update by refetching...');
      
      // Verify the update immediately
      if (doctorId != null) {
        await fetchSchedulesByDoctorId(doctorId!);
        
        // Check if the appointment was actually updated
        final updatedAppt = appointments.firstWhereOrNull((a) => a.uuid == appt.uuid);
        if (updatedAppt != null) {
          print('After refetch - Status: ${updatedAppt.status.value} (${appointmentStatusToInt(updatedAppt.status.value)})');
        }
      }
      
      Get.snackbar(
        "Hoàn thành khám",
        "Đã đánh dấu lịch khám của ${getPatientNameById(appt.patientId) ?? ''} là hoàn thành",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } else {
      print('API returned false, reverting status');
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
    print('Exception in markAsDone: $e');
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
  print('=== END MARK AS DONE DEBUG ===');
}

// Cải thiện hàm fetchSchedulesByDoctorId để debug rõ hơn
Future<void> fetchSchedulesByDoctorId(String doctorId) async {
  print('=== FETCH SCHEDULES DEBUG ===');
  print('DoctorId: $doctorId');
  
  isLoading.value = true;
  appointments.clear();
  
  try {
    final result = await _appointmentService.getByDoctorId(doctorId);
    print('Received ${result.length} appointments from API:');
    
    for (int i = 0; i < result.length; i++) {
      final a = result[i];
      print('[$i] UUID: ${a.uuid}, PatientId: ${a.patientId}, Status: ${a.status.value} (${appointmentStatusToInt(a.status.value)})');
    }
    
    appointments.assignAll(result);
    
    // Debug status counts
    print('Status counts:');
    print('- Pending: ${pendingAppointments.length}');
    print('- Confirmed: ${confirmedAppointments.length}');
    print('- Done: ${doneAppointments.length}');
    print('- Cancelled: ${cancelledAppointments.length}');
    print('- Rejected: ${rejectedAppointments.length}');

    // Fetch patient details...
    final ids = appointments
        .map((a) => a.patientId)
        .where((id) => id != null)
        .toSet()
        .toList();

    patient.clear();
    for (final id in ids) {
      if (id != null) {
        final result = await _patientService.getPatientsById(id);
        if (result.isNotEmpty) {
          patient.addAll(result);
        }
      }
    }
    
  } catch (e) {
    print('Exception in fetchSchedulesByDoctorId: $e');
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
  print('=== END FETCH SCHEDULES DEBUG ===');
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


  bool canMarkAsDone(Appointment appt) {
    if (appt.dateTime == null) return false;
    final now = DateTime.now();
    final apptDateTime = DateTime.parse(appt.dateTime!);
    final timeDifference = now.difference(apptDateTime).inHours;
    return !now.isBefore(apptDateTime) && timeDifference >= 5;
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