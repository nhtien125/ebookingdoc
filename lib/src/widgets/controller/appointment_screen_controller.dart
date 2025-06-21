import 'package:get/get.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/Doctorservice.dart';
import 'package:ebookingdoc/src/constants/services/HospitalService.dart';
import 'package:ebookingdoc/src/constants/services/ScheduleService.dart';
import 'package:ebookingdoc/src/constants/services/user_service.dart';
import 'package:ebookingdoc/src/constants/services/specialization_service.dart';
import 'package:ebookingdoc/src/constants/services/MedicalService.dart';
import 'package:ebookingdoc/src/data/model/DoctorDisplayModel.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/medical_service_model.dart';
import 'package:ebookingdoc/src/data/model/schedule_model.dart';
import 'package:ebookingdoc/src/data/model/specialization_model.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:ebookingdoc/src/data/model/select_profile.dart';
import 'package:flutter/material.dart';

class AppointmentScreenController extends GetxController {
  // Stepper
  final currentStep = 1.obs;

  // Hospital
  final HospitalService hospitalService = HospitalService();
  final RxList<Hospital> hospitals = <Hospital>[].obs;
  final Rxn<Hospital> selectedHospital = Rxn<Hospital>();

  // Doctor
  final DoctorService _doctorService = DoctorService();
  final RxList<Doctor> doctors = <Doctor>[].obs;
  final Rx<DoctorDisplay?> selectedDoctor = Rx<DoctorDisplay?>(null);
  final RxList<DoctorDisplay> featuredDoctors = <DoctorDisplay>[].obs;
  final SpecializationService _specService = SpecializationService();

  // Medical Service
  final MedicalServiceService _medicalServiceService = MedicalServiceService();
  final RxList<MedicalServiceModel> medical = <MedicalServiceModel>[].obs;

  // Schedule
  final ScheduleService _scheduleService = ScheduleService();
  final RxList<Schedule> schedules = <Schedule>[].obs;
  final Rxn<Schedule> selectedSchedule = Rxn<Schedule>();
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rxn<String> selectedTimeSlot = Rxn<String>();
  final RxInt selectedDateIndex = 0.obs;
  final RxInt selectedTimeIndex = (-1).obs;
  final isLoading = false.obs;
  final UserService _userService = UserService();
  final RxList<Specialization> specializations = <Specialization>[].obs;


  List<MedicalServiceModel> get servicesForSelectedDepartment =>
      medical.toList();


  final patients = <Patient>[].obs;
  final selectedPatient = Rxn<Patient>();
  final isLoadingPatients = false.obs;


  final appointmentConfirmed = false.obs;
  final paymentCompleted = false.obs;
  final selectedPaymentMethod = 'online'.obs;
  final Rxn<Specialization> selectedDepartment = Rxn<Specialization>();
  final Rxn<MedicalServiceModel> selectedService = Rxn<MedicalServiceModel>();


  final timeSlots = <String>[].obs;

  void selectDepartment(Specialization specialization) {
    selectedDepartment.value = specialization;

    selectedDoctor.value = null;
    selectedService.value = null;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    selectedSchedule.value = null;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments;
    await fetchHospitalFromApi();
    await fetchDoctors();
    await fetchMedicalService();
    await fetchSpecializations();

    if (args != null) {
      if (args != null && args['doctor'] != null) {
        final doc = Doctor.fromJson(args['doctor']);
        final user = await _userService.getUserById(doc.userId!);
        final specialization =
            await _specService.getById(doc.specializationId!);
        if (user != null && specialization != null) {
          var doctorDisplay = DoctorDisplay(
            doctor: doc,
            user: user,
            specialization: specialization,
          );
          selectedDoctor.value = doctorDisplay;
          await fetchSchedulesByDoctorId(doc.uuid); 
        }
      }
      if (args['hospital'] != null) {
        selectedHospital.value = Hospital.fromJson(args['hospital']);
      } else if (args['doctor'] != null) {
        if (hospitals.isNotEmpty) {
          final doctorHospitalId = Doctor.fromJson(args['doctor']).hospitalId;
          final found =
              hospitals.firstWhereOrNull((h) => h.uuid == doctorHospitalId);
          if (found != null) selectedHospital.value = found;
        }
      }
      if (args['specialization'] != null) {
        selectedDepartment.value =
            Specialization.fromJson(args['specialization']);
      } else if (args['doctor'] != null) {
        if (specializations.isNotEmpty) {
          final doctorSpecId = Doctor.fromJson(args['doctor']).specializationId;
          final found =
              specializations.firstWhereOrNull((s) => s.uuid == doctorSpecId);
          if (found != null) selectedDepartment.value = found;
        }
      }
      if (args['date'] != null) {
        selectedDate.value = args['date'] as DateTime?;
        _updateAvailableDatesAndSlots();
      }
      if (args['schedule'] != null)
        selectedSchedule.value = Schedule.fromJson(args['schedule']);
      if (args['slot'] != null)
        selectedTimeSlot.value = args['slot'] as String?;
    }
  }

  // ========================== HOSPITAL ==========================
  Future<void> fetchHospitalFromApi() async {
    try {
      isLoading.value = true;
      final result = await hospitalService.getAllHospital();
      hospitals.assignAll(result.cast<Hospital>());
      if (hospitals.isNotEmpty && selectedHospital.value == null) {
        selectedHospital.value = hospitals.first;
      }
    } catch (e) {
      print('Lỗi khi lấy danh sách bệnh viện: $e');
      hospitals.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void selectHospital(Hospital? hospital) {
    selectedHospital.value = hospital;
  
    selectedDepartment.value = null;
    selectedDoctor.value = null;
    selectedService.value = null;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    selectedSchedule.value = null;
  }

  // ========================== MEDICAL SERVICE ==========================
  Future<void> fetchMedicalService() async {
    isLoading.value = true;
    medical.clear();
    try {
      List<MedicalServiceModel> result =
          (await _medicalServiceService.getAllMedicalServices())
              .cast<MedicalServiceModel>();
      medical.addAll(result);
    } catch (e) {
      print('Lỗi khi lấy danh sách dịch vụ: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ========================== DOCTOR ==========================
  Future<void> fetchDoctors() async {
    isLoading.value = true;
    featuredDoctors.clear();
    try {
      List<Doctor> doctorsList = await _doctorService.getAllDoctors();
      for (var doc in doctorsList) {
        if ((doc.userId == null || doc.userId!.isEmpty) ||
            (doc.specializationId == null || doc.specializationId!.isEmpty))
          continue;
        final userFuture = _userService.getUserById(doc.userId!);
        final specFuture = _specService.getById(doc.specializationId!);
        final results = await Future.wait([userFuture, specFuture]);
        final user = results[0] as User?;
        final specialization = results[1] as Specialization?;
        if (user != null && specialization != null) {
          featuredDoctors.add(DoctorDisplay(
              doctor: doc, user: user, specialization: specialization));
        }
      }
    } catch (e) {
      print('Lỗi khi lấy danh sách bác sĩ: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSpecializations() async {
    isLoading.value = true;
    try {
      List<Specialization> result = await _specService.getAllSpecialization();
      specializations.assignAll(result);
    } catch (e) {
      print('Lỗi khi lấy danh sách chuyên khoa: $e');
      specializations.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDoctorById(String uuid) async {
    try {
      isLoading.value = true;
      final doctor = await _doctorService.getDoctorById(uuid);
      if (doctor != null) {
        selectedDoctor.value = doctor as DoctorDisplay?;
        if (doctors.indexWhere((d) => d.userId == doctor.uuid) == -1)
          doctors.add(doctor as Doctor);
        await fetchSchedulesByDoctorId(doctor.uuid);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void selectDoctor(DoctorDisplay doctorDisplay) {
    selectedDoctor.value = doctorDisplay;
    selectedDepartment.value = doctorDisplay.specialization;
    fetchSchedulesByDoctorId(doctorDisplay.doctor.uuid);
  }

  // ========================== SCHEDULE ==========================
  Future<void> fetchSchedulesByDoctorId(String doctorId) async {
    print('Fetching schedules for doctorId: $doctorId'); // Thêm log
    try {
      isLoading.value = true;
      final result = await _scheduleService.getSchedulesByDoctorId(doctorId);
      schedules.assignAll(result);
      print('Fetched schedules: $schedules'); // Kiểm tra dữ liệu
      _updateAvailableDatesAndSlots();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchScheduleById(String scheduleId) async {
    try {
      isLoading.value = true;
      final schedule = await _scheduleService.getScheduleById(scheduleId);
      if (schedule != null) selectedSchedule.value = schedule;
    } finally {
      isLoading.value = false;
    }
  }

  void _updateAvailableDatesAndSlots() {
    final dates = schedules
        .map((s) => DateTime.parse(s.workDate))
        .toSet()
        .toList()
      ..sort();
    if (dates.isEmpty) {
      selectedDate.value = null;
      timeSlots.clear();
      selectedDateIndex.value = 0;
      return;
    }
    if (selectedDate.value == null || !dates.contains(selectedDate.value)) {
      selectedDate.value = dates.first;
    }
    final idx = dates.indexWhere((d) => d == selectedDate.value);
    selectedDateIndex.value = idx >= 0 ? idx : 0;
    updateTimeSlotsForSelectedDate();
  }

  void selectDate(DateTime? date) {
    selectedDate.value = date;
    if (date != null) {
      final dates = schedules
          .map((s) => DateTime.parse(s.workDate))
          .toSet()
          .toList()
        ..sort();
      final idx = dates.indexWhere((d) =>
          d.year == date.year && d.month == date.month && d.day == date.day);
      selectedDateIndex.value = idx >= 0 ? idx : 0; // Đồng bộ selectedDateIndex
    }
    updateTimeSlotsForSelectedDate(); // Cập nhật timeSlots dựa trên ngày chọn
    selectedTimeSlot.value = null;
    selectedSchedule.value = null;
  }

  void updateTimeSlotsForSelectedDate() {
    if (selectedDate.value == null) {
      timeSlots.clear();
      return;
    }
    final selectedDateStr = _dateToString(selectedDate.value!);
    print('Selected date string: $selectedDateStr'); // Debug
    final slots = schedules
        .where((s) {
          final scheduleDate = DateTime.parse(s.workDate);
          final scheduleDateStr = _dateToString(scheduleDate);
          print('Schedule date: $scheduleDateStr');
          return scheduleDateStr == selectedDateStr;
        })
        .map((s) =>
            '${s.startTime?.substring(0, 5)} - ${s.endTime?.substring(0, 5)}')
        .toList();
    timeSlots.assignAll(slots);
    print('Updated time slots: $timeSlots'); // Debug
  }

  void selectTimeSlot(String? time) {
    selectedTimeSlot.value = time;
    if (selectedDate.value != null && time != null) {
      final slotParts = time.split(' - ');
      final start = slotParts.first;
      final end = slotParts.last;
      final found = schedules.firstWhereOrNull((s) =>
          _dateToString(DateTime.parse(s.workDate)) ==
              _dateToString(selectedDate.value!) &&
          s.startTime?.substring(0, 5) == start &&
          s.endTime?.substring(0, 5) == end);
      selectedSchedule.value = found;
    } else {
      selectedSchedule.value = null;
    }
  }

  String _dateToString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  // ========================== PATIENT ==========================
  // Thêm các hàm quản lý bệnh nhân nếu cần

  // ========================== STEPPER, VALIDATION ==========================
  void nextStep() {
    if (currentStep.value < 4) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 1) currentStep.value--;
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 4) currentStep.value = step;
  }

  bool isStep1Complete() {
    return selectedHospital.value != null &&
        selectedDoctor.value != null &&
        selectedDate.value != null &&
        selectedTimeSlot.value != null &&
        selectedSchedule.value != null;
  }

  bool isStep2Complete() {
    return selectedPatient.value != null;
  }

  // ========================== APPOINTMENT CONFIRM, PAYMENT ==========================
  void confirmAppointment() {
    appointmentConfirmed.value = true;
    nextStep();
  }

  void completePayment() {
    if (selectedPaymentMethod.value == 'online') {
      // Xử lý thanh toán online
    } else {
      // Xử lý thanh toán tại bệnh viện
    }
  }
}
