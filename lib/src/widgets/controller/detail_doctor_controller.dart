import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/ReviewService.dart';
import 'package:ebookingdoc/src/constants/services/ScheduleService.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/constants/services/specialization_service.dart';
import 'package:ebookingdoc/src/constants/services/user_service.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/data/model/schedule_model.dart';
import 'package:ebookingdoc/src/data/model/review_model.dart';
import 'package:ebookingdoc/src/constants/services/doctorservice.dart';

class DetailDoctorController extends GetxController {
String id = '';

  final Rx<Doctor?> doctor = Rx<Doctor?>(null); // Added missing property
  final RxInt selectedDateIndex = 0.obs;
  final RxInt selectedTimeIndex = (-1).obs;
  final RxList<DateTime> availableDates = <DateTime>[].obs;
  final RxMap<DateTime, List<String>> availableSlotsPerDate =
      <DateTime, List<String>>{}.obs;
  final RxBool isLoading = true.obs;
  final RxList<Doctor> doctors = <Doctor>[].obs;
  final RxList<Hospital> hospitals = <Hospital>[].obs;
  final RxList<Clinic> clinics = <Clinic>[].obs;
  final RxList<Schedule> schedules = <Schedule>[].obs;
  final RxList<Review> reviews = <Review>[].obs;
  final Map<String, String> doctorNames = {};
  final Map<String, String> doctorSpecialties = {};
  final Map<String, String> doctorClinics = {};

  final DoctorService doctorService = DoctorService();
  final UserService userService = UserService();
  final SpecializationService specializationService = SpecializationService();
  final ScheduleService _scheduleService = ScheduleService();
  final ReviewService _reviewService = ReviewService();
  final ClinicService clinicService = ClinicService();

  
  @override
  void onInit() {
    super.onInit();
    id = Get.arguments;
    fetchDoctorDetails(id);
    fetchSchedulesByDoctorId(id);
    fetchReviewsByDoctorId(id);
  }

  Future<void> fetchDoctorDetails(String id) async {
    try {
      isLoading.value = true;
      final doctorList = await doctorService.getAllDoctors();
      if (doctorList.isEmpty) {
        if (kDebugMode) print('DEBUG | No doctors found from getAllDoctors');
        doctors.clear();
        doctorNames.clear();
        doctorSpecialties.clear();
        doctorClinics.clear();
        return;
      }

      final List<Doctor> updatedDoctors = [];
      doctorNames.clear();
      doctorSpecialties.clear();
      doctorClinics.clear();

      for (var doctor in doctorList) {
        final key = doctor.userId ?? doctor.uuid ?? '';
        String userName = 'Bác sĩ không xác định';
        String specialtyName = 'Chưa có chuyên khoa';
        String clinicName = 'Không có phòng khám';

        if (doctor.userId?.isNotEmpty ?? false) {
          final userData = await userService.getUserById(doctor.userId!);
          userName = userData?.name ?? userName;
        }

        if (doctor.specializationId?.isNotEmpty ?? false) {
          final specialtyData =
              await specializationService.getById(doctor.specializationId!);
          specialtyName = specialtyData?.name ?? specialtyName;
        }

        if (doctor.clinicId?.isNotEmpty ?? false) {
          final clinicData = await clinicService.getById(doctor.clinicId!);
          clinicName = clinicData?.name ?? clinicName;
        }

        doctorNames[key] = userName;
        doctorSpecialties[key] = specialtyName;
        doctorClinics[key] = clinicName;

        updatedDoctors.add(doctor);
        if (doctor.uuid == id) {
          this.doctor.value = doctor; // Now works with the defined property
        }
      }

      doctors.value = updatedDoctors;
      if (kDebugMode) print('DEBUG | Loaded ${doctors.length} doctors');
    } catch (e) {
      if (kDebugMode) print('Lỗi khi lấy danh sách bác sĩ: $e');
      doctors.clear();
      doctorNames.clear();
      doctorSpecialties.clear();
      doctorClinics.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSchedulesByDoctorId(String doctorId) async {
    isLoading.value = true;
    schedules.clear();
    List<Schedule> result =
        await _scheduleService.getSchedulesByDoctorId(doctorId);
    if (result.isNotEmpty) {
      schedules.addAll(result);
    }
    isLoading.value = false;
    generateAvailableDates();
  }

  Future<void> fetchReviewsByDoctorId(String doctorId) async {
    reviews.value = await _reviewService.getReviewsByDoctorId(doctorId);
  }

  void generateAvailableDates() {
    final now = DateTime.now();
    availableDates.value =
        List.generate(7, (index) => now.add(Duration(days: index)));
    for (var date in availableDates) {
      String dateStr = date.toIso8601String().substring(0, 10); // yyyy-MM-dd
      List<Schedule> scheduleForDate =
          schedules.where((s) => s.workDate == dateStr).toList();

      List<String> slots = scheduleForDate
          .map((s) =>
              '${s.startTime?.substring(0, 5)} - ${s.endTime?.substring(0, 5)}')
          .toList();

      availableSlotsPerDate[date] = slots;
    }
  }

  bool isDoctorAvailableOnDate(DateTime date) {
    String dateStr = date.toIso8601String().substring(0, 10);
    return schedules.any((s) => s.workDate == dateStr);
  }

  List<String> getAvailableSlotsForSelectedDate() {
    if (availableDates.isEmpty) return [];
    final selectedDate = availableDates[selectedDateIndex.value];
    return availableSlotsPerDate[selectedDate] ?? [];
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
      Get.snackbar("Lỗi", "Bạn cần chọn ngày hợp lệ để đặt lịch!");
      return;
    }
    final selectedDate = dates[selectedDateIndex.value];

    final slots = schedules.where((s) {
      final d = DateTime.parse(s.workDate);
      return d.year == selectedDate.year &&
          d.month == selectedDate.month &&
          d.day == selectedDate.day;
    }).toList();

    if (selectedTimeIndex.value < 0 ||
        selectedTimeIndex.value >= slots.length) {
      Get.snackbar("Lỗi", "Bạn cần chọn khung giờ hợp lệ để đặt lịch!");
      return;
    }

    final Schedule selectedSchedule = slots[selectedTimeIndex.value];

    Get.offAllNamed(
      Routes.appointmentScreen,
      arguments: {
        'doctor': doctor.value?.toJson(),
        'date': selectedDate,
        'schedule': selectedSchedule,
        'slot': '${selectedSchedule.startTime} - ${selectedSchedule.endTime}',
      },
    );
  }

  double getAverageRating() {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold<int>(0, (sum, r) => sum + r.stars);
    return total / reviews.length;
  }

  int getReviewCount() => reviews.length;
}
