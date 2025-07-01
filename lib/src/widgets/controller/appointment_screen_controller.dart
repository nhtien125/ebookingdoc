import 'dart:convert';
import 'dart:math';

import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/PayOSService.dart';
import 'package:ebookingdoc/src/constants/services/PaymentService.dart';
import 'package:ebookingdoc/src/constants/services/appointmentService.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/constants/services/patient_service.dart';
import 'package:ebookingdoc/src/constants/services/vaccination_center_service.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/vaccination_center_model.dart';
import 'package:ebookingdoc/src/screen/PayOSWebViewScreen.dart';
import 'package:ebookingdoc/src/shared_preferences.dart';
import 'package:get/get.dart';
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
import 'package:ebookingdoc/src/data/model/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentScreenController extends GetxController {
  // Stepper
  final currentStep = 1.obs;
  final PaymentService paymentService = PaymentService();

  // Hospital
  final HospitalService hospitalService = HospitalService();
  final RxList<Hospital> hospitals = <Hospital>[].obs;
  final Rxn<Hospital> selectedHospital = Rxn<Hospital>();
  final RxString selectedPlaceType = 'hospital'.obs;

  // Clinic
  final ClinicService clinicService = ClinicService();
  final RxList<Clinic> clinics = <Clinic>[].obs;
  final Rxn<Clinic> selectedClinic = Rxn<Clinic>();

  // Vaccination Center
  final VaccinationCenterService vaccinationCenterService =
      VaccinationCenterService();
  final RxList<VaccinationCenter> vaccinationCenters =
      <VaccinationCenter>[].obs;
  final Rxn<VaccinationCenter> selectedVaccinationCenter =
      Rxn<VaccinationCenter>();

  //
  final healthStatus = ''.obs;
  final healthStatusController = TextEditingController();

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
  final AppointmentService _appointmentService = AppointmentService();
  final RxList<Schedule> schedules = <Schedule>[].obs;
  final Rxn<Schedule> selectedSchedule = Rxn<Schedule>();
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rxn<String> selectedTimeSlot = Rxn<String>();
  final RxInt selectedDateIndex = 0.obs;
  final RxInt selectedTimeIndex = (-1).obs;
  final isLoading = false.obs;
  final UserService _userService = UserService();
  final RxList<Specialization> specializations = <Specialization>[].obs;

  // Patient
  final PatientService _patientService = PatientService();
  final RxList<Patient> patients = <Patient>[].obs;
  final RxBool isLoadingPatients = false.obs;
  final Rxn<Patient> selectedPatient = Rxn<Patient>();

  List<MedicalServiceModel> get servicesForSelectedDepartment =>
      medical.toList();

  final appointmentConfirmed = false.obs;
  final paymentCompleted = false.obs;
  final selectedPaymentMethod = 'cash'.obs;
  final Rxn<Specialization> selectedDepartment = Rxn<Specialization>();
  final Rxn<MedicalServiceModel> selectedService = Rxn<MedicalServiceModel>();
  final PayOSService _payosService = PayOSService();

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
    final userId = args['userId'] ?? args['user_id'];
    print('DEBUG | Nhận userId: $userId');
    healthStatusController.text = healthStatus.value;
    healthStatusController.addListener(() {
      healthStatus.value = healthStatusController.text;
    });
    await fetchHospitalFromApi();
    await fetchDoctors();
    await fetchMedicalService();
    await fetchSpecializations();
    await loadFamilyMembers();
    await fetchClinicFromApi();
    await fetchVaccinationCenterFromApi();

    if (args != null) {
      if (args['selectedPlaceType'] != null) {
        selectedPlaceType.value = args['selectedPlaceType'];
        print('DEBUG | Nhận selectedPlaceType: ${selectedPlaceType.value}');
      }
      if (args['doctor'] != null) {
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
        print('DEBUG | Nhận hospital: ${args['hospital']}');
        selectedHospital.value = Hospital.fromJson(args['hospital']);
        print('DEBUG | selectedHospital: ${selectedHospital.value?.name}');
      } else if (args['doctor'] != null) {
        if (hospitals.isNotEmpty) {
          final doctorHospitalId = Doctor.fromJson(args['doctor']).hospitalId;
          final found =
              hospitals.firstWhereOrNull((h) => h.uuid == doctorHospitalId);
          if (found != null) selectedHospital.value = found;
        }
      }
      if (args['clinic'] != null) {
        print('DEBUG | Nhận clinic: ${args['clinic']}');
        selectedClinic.value = Clinic.fromJson(args['clinic']);
        print('DEBUG | selectedClinic: ${selectedClinic.value?.name}');
      } else if (args['doctor'] != null) {
        if (hospitals.isNotEmpty) {
          final doctorHospitalId = Doctor.fromJson(args['doctor']).hospitalId;
          final found =
              hospitals.firstWhereOrNull((h) => h.uuid == doctorHospitalId);
          if (found != null) selectedHospital.value = found;
        }
      }
      if (args['vaccination_center'] != null) {
        selectedVaccinationCenter.value =
            VaccinationCenter.fromJson(args['vaccination_center']);
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
      if (args['schedule'] != null) {
        if (args['schedule'] is Schedule) {
          selectedSchedule.value = args['schedule'] as Schedule;
        } else if (args['schedule'] is Map<String, dynamic>) {
          selectedSchedule.value = Schedule.fromJson(args['schedule']);
        }
        if (selectedSchedule.value != null) {
          final start =
              selectedSchedule.value!.startTime?.substring(0, 5) ?? '';
          final end = selectedSchedule.value!.endTime?.substring(0, 5) ?? '';
          selectedTimeSlot.value = '$start - $end';
        }
      } else if (args['slot'] != null) {
        selectedTimeSlot.value = args['slot'];
      }
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

  Future<void> fetchClinicFromApi() async {
    try {
      isLoading.value = true;
      final result = await clinicService.getAllClinic();
      clinics.assignAll(result.cast<Clinic>());
      if (clinics.isNotEmpty && selectedClinic.value == null) {
        selectedClinic.value = clinics.first;
      }
    } catch (e) {
      print('Lỗi khi lấy danh sách bệnh viện: $e');
      clinics.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchVaccinationCenterFromApi() async {
    try {
      isLoading.value = true;
      final result = await vaccinationCenterService.getAllVaccinationCenters();
      vaccinationCenters.assignAll(result.cast<VaccinationCenter>());
      if (vaccinationCenters.isNotEmpty &&
          selectedVaccinationCenter.value == null) {
        selectedVaccinationCenter.value = vaccinationCenters.first;
      }
    } catch (e) {
      print('Lỗi khi lấy danh sách bệnh viện: $e');
      vaccinationCenters.clear();
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

  void selectClinic(Clinic? clinic) {
    selectedClinic.value = clinic;
    selectedDepartment.value = null;
    selectedDoctor.value = null;
    selectedService.value = null;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    selectedSchedule.value = null;
  }

  void selectVaccinationCenter(VaccinationCenter? center) {
    selectedVaccinationCenter.value = center;
    selectedDate.value = null;
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
    print('Fetching schedules for doctorId: $doctorId');
    try {
      isLoading.value = true;
      final result = await _scheduleService.getSchedulesByDoctorId(doctorId);
      schedules.assignAll(result);
      print('Fetched schedules: $schedules');
      _updateAvailableDatesAndSlots();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFamilyMembers() async {
    try {
      isLoadingPatients.value = true;
      final userId = await getUserIdFromPrefs();
      if (userId != null) {
        final list = await _patientService.getPatientsByUserId(userId);
        patients.assignAll(list); // Cập nhật danh sách phản ứng
      } else {
        patients.clear();
      }
    } catch (e) {
      patients.clear();
      Get.snackbar('Lỗi', 'Không thể tải danh sách bệnh nhân: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingPatients.value = false;
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
      selectedDateIndex.value = idx >= 0 ? idx : 0;
    }
    updateTimeSlotsForSelectedDate();
    selectedTimeSlot.value = null;
    selectedSchedule.value = null;
  }

  void updateTimeSlotsForSelectedDate() {
    if (selectedDate.value == null) {
      timeSlots.clear();
      return;
    }
    final selectedDateStr = _dateToString(selectedDate.value!);
    print('Selected date string: $selectedDateStr');
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
    print('Updated time slots: $timeSlots');
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
          (s.startTime?.substring(0, 5) ?? '') == start &&
          (s.endTime?.substring(0, 5) ?? '') == end);
      selectedSchedule.value = found;
    } else {
      selectedSchedule.value = null;
    }
  }

  String _dateToString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  // ========================== PATIENT ==========================
  Future<void> loadPatients() async {
    try {
      isLoadingPatients.value = true;
      final userId = await getUserIdFromPrefs();
      if (userId != null) {
        final list = await _patientService.getPatientsByUserId(userId);
        patients.assignAll(list);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách bệnh nhân: $e');
    } finally {
      isLoadingPatients.value = false;
    }
  }

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
    if (selectedPlaceType.value == 'vaccination') {
      return selectedVaccinationCenter.value != null &&
          selectedService.value != null &&
          selectedDate.value != null;
    } else {
      return selectedHospital.value != null &&
          selectedDepartment.value != null &&
          selectedDoctor.value != null &&
          selectedService.value != null &&
          selectedDate.value != null &&
          selectedTimeSlot.value != null;
    }
  }

  void resetData() {
    selectedPlaceType.value = 'hospital'; // Reset to default place type
    selectedHospital.value = null;
    selectedClinic.value = null;
    selectedVaccinationCenter.value = null;
    selectedDepartment.value = null;
    selectedDoctor.value = null;
    selectedService.value = null;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    selectedSchedule.value = null;
    selectedPatient.value = null;
    healthStatus.value = '';
    healthStatusController.clear();
    selectedPaymentMethod.value = 'cash'; // Reset to default
    currentStep.value = 1; // Return to first step
    selectedDateIndex.value = 0;
    selectedTimeIndex.value = -1;
    timeSlots.clear(); // Clear time slots as they depend on selections
  }

  bool isStep2Complete() {
    return selectedPatient.value != null;
  }

  // ========================== APPOINTMENT CONFIRM, PAYMENT ==========================
  void confirmAppointment() {
    appointmentConfirmed.value = true;
    nextStep();
  }

  Future<void> deletePatient(Patient patient) async {
    try {
      if (!patients.contains(patient)) return;
      if (patients.length <= 1) {
        Get.snackbar('Không thể xoá', 'Cần ít nhất một hồ sơ bệnh nhân',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      patients.remove(patient);
      if (selectedPatient.value == patient) {
        selectedPatient.value = patients.firstOrNull;
      }
      Get.snackbar('Đã xoá', 'Đã xoá hồ sơ ${patient.name}',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể xoá bệnh nhân');
    }
  }

  void selectPatient(Patient? patient) {
    selectedPatient.value = patient;
  }

  void completePayment() {
    if (selectedPaymentMethod.value == 'online') {
    } else {
      Get.toNamed(Routes.dashboard);
    }
  }

  Future<String?> addAppointment() async {
    String? dateStr;
    if (selectedDate.value != null && selectedSchedule.value != null) {
      final date = selectedDate.value!;
      final startTime = selectedSchedule.value?.startTime ?? '09:00:00';
      dateStr =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} $startTime';
    } else if (selectedDate.value != null) {
      dateStr =
          '${selectedDate.value!.year.toString().padLeft(4, '0')}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')} 09:00:00';
    }
    Map<String, dynamic> data = {};
    if (selectedPlaceType.value == 'vaccination') {
      data = {
        "doctor_id": null,
        "patient_id": selectedPatient.value?.uuid,
        "clinic_id": null,
        "hospital_id": null,
        "schedule_id": null,
        "vaccination_center_id": selectedVaccinationCenter.value?.uuid,
        "medical_service_id": selectedService.value?.uuid,
        "date": dateStr,
        "status": 1,
        "health_status": healthStatusController.text.isNotEmpty
            ? healthStatusController.text
            : null,
        "user_id": await getUserIdFromPrefs(),
      };
    } else if (selectedPlaceType.value == 'clinic') {
      data = {
        "doctor_id": selectedDoctor.value?.doctor.uuid,
        "patient_id": selectedPatient.value?.uuid,
        "clinic_id": selectedClinic.value?.uuid,
        "hospital_id": null,
        "schedule_id": selectedSchedule.value?.uuid,
        "vaccination_center_id": null,
        "medical_service_id": selectedService.value?.uuid,
        "date": dateStr,
        "status": 1,
        "health_status": healthStatusController.text.isNotEmpty
            ? healthStatusController.text
            : null,
        "user_id": await getUserIdFromPrefs(),
      };
    } else if (selectedPlaceType.value == 'hospital') {
      data = {
        "doctor_id": selectedDoctor.value?.doctor.uuid,
        "patient_id": selectedPatient.value?.uuid,
        "clinic_id": null,
        "hospital_id": selectedHospital.value?.uuid,
        "schedule_id": selectedSchedule.value?.uuid,
        "vaccination_center_id": null,
        "medical_service_id": selectedService.value?.uuid,
        "date": dateStr,
        "status": 1,
        "health_status": healthStatusController.text.isNotEmpty
            ? healthStatusController.text
            : null,
        "user_id": await getUserIdFromPrefs(),
      };
    }
    print('[AppointmentScreenController] Data gửi API: $data');
    final result = await _appointmentService.addAppointment(data);
    if (result.isNotEmpty) {
      final appointment = result.first;
      print('Appointment ID: ${appointment.uuid}');
      return appointment.uuid;
    } else {
      Get.snackbar('Lỗi', 'Đặt lịch thất bại!');
      return null;
    }
  }

  Future<void> handlePayOS() async {
    final appointmentId = await addAppointment();
    if (appointmentId == null) {
      Get.snackbar('Lỗi', 'Đặt lịch thất bại!');
      return;
    }
    final userId = await getUserIdFromPrefs();
    final paymentResult = await paymentService.addPayment({
      "user_id": userId,
      "appointment_id": appointmentId,
      "amount": selectedService.value?.price?.toInt() ?? 0,
      "payment_method": selectedPaymentMethod.value,
      "status": 1,
      "payment_time": DateTime.now().toIso8601String(),
    });
    if (paymentResult.isNotEmpty && paymentResult.first.uuid != null) {
      final paymentId = paymentResult.first.uuid;
      final patient = selectedPatient.value;
      final amount = selectedService.value?.price?.toInt() ?? 0;
      final random = Random();
      final orderId = 100000 + random.nextInt(900000);
      final prefs = await SharedPreferences.getInstance();
      String? email;
      final userJson = prefs.getString('user_data');
      if (userJson != null) {
        final user = User.fromJson(jsonDecode(userJson));
        email = user.email;
      }
      final paymentLinkResult = await _payosService.createPaymentLink(
        amount: amount,
        orderId: orderId.toString(),
        description: 'Thanh toán lịch hẹn',
        fullname: patient?.name,
        phone: patient?.phone,
        email: email ?? 'no-reply@example.com',
        payment_id: paymentId,
      );
      if (paymentLinkResult != null) {
        final paymentLink =
            paymentLinkResult['paymentLink'] ?? paymentLinkResult;
        Get.to(() => PayOSWebViewScreen(
              url: paymentLink,
              paymentId: paymentId,
              payOSService: _payosService,
            ));
      } else {
        Get.snackbar('Lỗi', 'Không lấy được link thanh toán!');
      }
    } else {
      Get.snackbar('Lỗi', 'Không lưu được payment!');
    }
  }

  Future<String?> getUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      final user = User.fromJson(jsonDecode(userJson));
      return user.uuid;
    }
    return null;
  }

  Future<bool> savePayment(String appointmentId) async {
    final userId = await getUserIdFromPrefs();
    final result = await paymentService.addPayment({
      "user_id": userId,
      "appointment_id": appointmentId,
      "amount": selectedService.value?.price?.toInt() ?? 0,
      "payment_method": selectedPaymentMethod.value,
      "status": 1,
      "payment_time": DateTime.now().toIso8601String(),
    });
    return result.isNotEmpty;
  }
}
