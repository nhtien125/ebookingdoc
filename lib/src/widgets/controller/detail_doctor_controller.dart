import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/DoctorService.dart';
import 'package:ebookingdoc/src/constants/services/ReviewService.dart';
import 'package:ebookingdoc/src/constants/services/ScheduleService.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/constants/services/specialization_service.dart';
import 'package:ebookingdoc/src/constants/services/user_service.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/data/model/schedule_model.dart';
import 'package:ebookingdoc/src/data/model/review_model.dart';

class DetailDoctorController extends GetxController {
  final Rx<Doctor?> doctor = Rx<Doctor?>(null);
  final RxInt selectedDateIndex = 0.obs;
  final RxInt selectedTimeIndex = (-1).obs;
  final RxBool isLoading = true.obs;
  final RxList<Schedule> schedules = <Schedule>[].obs;
  final RxList<Review> reviews = <Review>[].obs;
  final Map<String, String> doctorNames = {};
  final Map<String, String> doctorSpecialties = {};
  final Map<String, String> doctorClinics = {};
  final Map<String, String> imageDoctor = {};

  final DoctorService doctorService = DoctorService();
  final UserService userService = UserService();
  final SpecializationService specializationService = SpecializationService();
  final ScheduleService _scheduleService = ScheduleService();
  final ReviewService _reviewService = ReviewService();
  final ClinicService clinicService = ClinicService();

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as String? ?? '';
    if (id.isNotEmpty) {
      loadAllData(id);
    } else {
      Get.snackbar('Lỗi', 'Không tìm thấy ID bác sĩ',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }

  Future<void> loadAllData(String id) async {
    try {
      isLoading.value = true;
      await Future.wait([
        fetchDoctorDetails(id),
        fetchSchedulesByDoctorId(id),
        fetchReviewsByDoctorId(id),
      ], eagerError: true);
    } catch (e) {
      if (kDebugMode) print('DEBUG | Error in loadAllData: $e');
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu bác sĩ',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDoctorDetails(String id) async {
    try {
      final doctorData = await doctorService.getDoctorById(id);
      if (doctorData == null) {
        if (kDebugMode) print('DEBUG | No doctor found for ID: $id');
        doctor.value = null;
        doctorNames.clear();
        imageDoctor.clear();
        doctorSpecialties.clear();
        doctorClinics.clear();
        Get.snackbar('Lỗi', 'Không tìm thấy bác sĩ',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      doctor.value = doctorData;
      final key = doctorData.userId ?? doctorData.uuid;
      String userName = 'Bác sĩ không xác định';
      String specialtyName = 'Chưa có chuyên khoa';
      String clinicName = 'Không có phòng khám';

      try {
        if (doctorData.userId?.isNotEmpty ?? false) {
          final userData = await userService.getUserById(doctorData.userId!);
          userName = userData?.name ?? userName;
          imageDoctor[key] =
              userData?.image ?? 'assets/images/default_doctor.jpg';
        }
        if (doctorData.specializationId?.isNotEmpty ?? false) {
          final specialtyData =
              await specializationService.getById(doctorData.specializationId!);
          specialtyName = specialtyData?.name ?? specialtyName;
        }
        if (doctorData.clinicId?.isNotEmpty ?? false) {
          final clinicData = await clinicService.getById(doctorData.clinicId!);
          clinicName = clinicData?.name ?? clinicName;
        }
      } catch (e) {
        if (kDebugMode)
          print('DEBUG | Error fetching metadata for doctor $id: $e');
      }

      doctorNames[key] = userName;
      doctorSpecialties[key] = specialtyName;
      doctorClinics[key] = clinicName;
      if (kDebugMode) print('DEBUG | Loaded doctor: $userName');
    } catch (e) {
      if (kDebugMode) print('DEBUG | Error fetching doctor details: $e');
      doctor.value = null;
      doctorNames.clear();
      imageDoctor.clear();
      doctorSpecialties.clear();
      doctorClinics.clear();
      Get.snackbar('Lỗi', 'Không thể tải thông tin bác sĩ',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchSchedulesByDoctorId(String doctorId) async {
    try {
      schedules.clear();
      final result = await _scheduleService.getSchedulesByDoctorId(doctorId);
      if (result.isNotEmpty) {
        schedules.addAll(result);
        if (kDebugMode)
          print(
              'DEBUG | Loaded ${result.length} schedules for doctor $doctorId');
      } else {
        if (kDebugMode)
          print('DEBUG | No schedules found for doctor $doctorId');
      }
    } catch (e) {
      schedules.clear();
      if (kDebugMode) print('DEBUG | Error fetching schedules: $e');
      Get.snackbar('Lỗi', 'Không thể tải lịch khám',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchReviewsByDoctorId(String doctorId) async {
    try {
      final result = await _reviewService.getReviewsByDoctorId(doctorId);
      reviews.value = result;
      if (kDebugMode)
        print('DEBUG | Loaded ${result.length} reviews for doctor $doctorId');
    } catch (e) {
      reviews.clear();
      if (kDebugMode) print('DEBUG | Error fetching reviews: $e');
      Get.snackbar('Lỗi', 'Không thể tải đánh giá',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void selectDate(int index) {
    selectedDateIndex.value = index;
    selectedTimeIndex.value = -1;
  }

  void selectTime(int index) {
    selectedTimeIndex.value = index;
  }

  void bookAppointment() {
    final dates = schedules
        .map((s) => DateTime.parse(s.workDate))
        .toSet()
        .toList()
      ..sort();

    if (selectedDateIndex.value < 0 ||
        selectedDateIndex.value >= dates.length) {
      Get.snackbar('Lỗi', 'Vui lòng chọn ngày hợp lệ',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final selectedDate = dates[selectedDateIndex.value];
    final allSlots = schedules.where((s) {
      final d = DateTime.parse(s.workDate);
      return d.year == selectedDate.year &&
          d.month == selectedDate.month &&
          d.day == selectedDate.day;
    }).toList();

    // Remove duplicates based on start time and end time (same logic as in UI)
    final uniqueSlots = <Schedule>[];
    final seenTimes = <String>{};

    for (final slot in allSlots) {
      final timeKey = '${slot.startTime}-${slot.endTime}';
      if (!seenTimes.contains(timeKey)) {
        seenTimes.add(timeKey);
        uniqueSlots.add(slot);
      }
    }

    // Sort slots by start time (same logic as in UI)
    uniqueSlots.sort((a, b) {
      final timeA = a.startTime ?? '';
      final timeB = b.startTime ?? '';
      return timeA.compareTo(timeB);
    });

    if (selectedTimeIndex.value < 0 ||
        selectedTimeIndex.value >= uniqueSlots.length) {
      Get.snackbar('Lỗi', 'Vui lòng chọn khung giờ hợp lệ',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final selectedSchedule = uniqueSlots[selectedTimeIndex.value];
    if (doctor.value == null) {
      Get.snackbar('Lỗi', 'Không tìm thấy thông tin bác sĩ',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.toNamed(
      Routes.appointmentScreen,
      arguments: {
        'doctor': doctor.value!.toJson(),
        'date': selectedDate,
        'schedule': selectedSchedule.toJson(),
        'slot':
            '${selectedSchedule.startTime?.substring(0, 5)} - ${selectedSchedule.endTime?.substring(0, 5)}',
      },
    );
    if (kDebugMode)
      print(
          'DEBUG | Booking appointment for doctor ${doctor.value!.uuid} on $selectedDate');
  }

  double getAverageRating() {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold<double>(0, (sum, r) => sum + r.stars);
    return total / reviews.length;
  }

  int getReviewCount() => reviews.length;
}
