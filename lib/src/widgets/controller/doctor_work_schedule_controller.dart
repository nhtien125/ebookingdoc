import 'dart:convert';
import 'package:ebookingdoc/src/constants/services/ScheduleService.dart';
import 'package:ebookingdoc/src/data/model/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ----- CONTROLLER -----
class DoctorWorkScheduleController extends GetxController {
  final isLoading = false.obs;
  final RxList<Schedule> schedules = <Schedule>[].obs;
  final selectedDate = Rxn<DateTime>();

  String? doctorId;
  final ScheduleService scheduleService = ScheduleService();

  @override
  void onInit() {
    super.onInit();
    print('[onInit] Controller khởi tạo!');
    loadDoctorIdAndFetch();
  }

  Future<void> loadDoctorIdAndFetch() async {
    doctorId = await getDoctorIdFromPrefs();
    print('[loadDoctorIdAndFetch] doctorId: $doctorId');
    if (doctorId != null) {
      await fetchSchedulesByDoctorId(doctorId!);
      selectedDate.value = DateTime.now();
      print(
          '[loadDoctorIdAndFetch] selectedDate set to today: ${DateFormat('yyyy-MM-dd – EEEE', 'vi').format(DateTime.now())}');
    } else {

    }
  }

  Future<String?> getDoctorIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final doctorJson = prefs.getString('doctor_data');
    print('[getDoctorIdFromPrefs] doctorJson: $doctorJson');
    if (doctorJson != null) {
      final doctor = jsonDecode(doctorJson);
      print('[getDoctorIdFromPrefs] doctor: $doctor');
      return doctor['uuid'];
    }
    return null;
  }

  Future<void> fetchSchedulesByDoctorId(String doctorId) async {
    isLoading.value = true;
    print(
        '[fetchSchedulesByDoctorId] Bắt đầu fetch schedules cho doctorId: $doctorId');
    try {
      final result = await scheduleService.getSchedulesByDoctorId(doctorId);
      print('[fetchSchedulesByDoctorId] API result: $result');
      if (result != null) {
        schedules.value = result;
        print(
            '[fetchSchedulesByDoctorId] Đã gán schedules: ${result.map((e) => e.uuid).toList()}');
      } else {
        schedules.clear();
        print('[fetchSchedulesByDoctorId] Không có schedule nào.');
      }
    } catch (e) {
      print('[fetchSchedulesByDoctorId] Error: $e');
      schedules.clear();
    } finally {
      isLoading.value = false;
      print('[fetchSchedulesByDoctorId] isLoading: false');
    }
  }

  List<Schedule> get filteredSchedules {
    final DateTime selected = selectedDate.value ?? DateTime.now();
    final dStr =
        "${selected.year.toString().padLeft(4, '0')}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}";
    final filtered =
        schedules.where((s) => s.workDate.startsWith(dStr)).toList();
    print(
        '[filteredSchedules] selectedDate: $dStr, số lượng lịch: ${filtered.length}');
    return filtered;
  }

  void selectDate(DateTime date) {
    print(
        '[selectDate] User chọn ngày: ${DateFormat('yyyy-MM-dd – EEEE', 'vi').format(date)}');
    selectedDate.value = date;
  }

  Future<void> updateSchedule(String uuid, Schedule newSchedule) async {
    if (doctorId == null) {
      return;
    }
    isLoading.value = true;
    try {
      final success = await scheduleService.updateSchedule(uuid, newSchedule);
      if (success) {
        await fetchSchedulesByDoctorId(doctorId!);
        Get.snackbar("Thành công", "Cập nhật lịch thành công!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Thất bại", "Cập nhật lịch thất bại!",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('[updateSchedule] Error: $e');
      Get.snackbar("Lỗi", "Lỗi khi cập nhật lịch!",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSchedule(Schedule schedule) async {
    if (doctorId == null) {
    
      return;
    }
    isLoading.value = true;
    print('[addSchedule] Gọi API thêm schedule: ${schedule.toJson()}');
    try {
      final success = await scheduleService.addSchedule(schedule);
      if (success) {
        print('[addSchedule] Thêm lịch thành công!');
        // Tải lại danh sách mới từ backend
        await fetchSchedulesByDoctorId(doctorId!);
        Get.snackbar("Thành công", "Đã thêm lịch làm việc mới!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        print('[addSchedule] Thêm lịch thất bại!');
        Get.snackbar("Thất bại", "Thêm lịch thất bại!",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('[addSchedule] Exception: $e');
      Get.snackbar("Lỗi", "Lỗi khi thêm lịch!",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Trong DoctorWorkScheduleController
  Future<void> deleteSchedule(String uuid) async {
    if (doctorId == null) {
    
      return;
    }
    isLoading.value = true;
    try {
      final success = await scheduleService.deleteSchedule(uuid);
      if (success) {
        await fetchSchedulesByDoctorId(doctorId!);
        Get.snackbar("Thành công", "Đã xóa lịch!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Thất bại", "Xóa lịch thất bại!",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('[deleteSchedule] Error: $e');
      Get.snackbar("Lỗi", "Lỗi khi xóa lịch!",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
