import 'dart:convert';
import 'package:ebookingdoc/src/constants/services/HospitalService.dart';
import 'package:ebookingdoc/src/constants/services/MedicalService.dart';
import 'package:ebookingdoc/src/constants/services/ScheduleService.dart';
import 'package:ebookingdoc/src/constants/services/appointmentService.dart';
import 'package:ebookingdoc/src/constants/services/patient_service.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/constants/services/specialization_service.dart';
import 'package:ebookingdoc/src/constants/services/vaccination_center_service.dart';
import 'package:ebookingdoc/src/data/model/appointment_model.dart';
import 'package:ebookingdoc/src/data/model/patient_model.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/vaccination_center_model.dart';
import 'package:ebookingdoc/src/data/model/schedule_model.dart';
import 'package:ebookingdoc/src/data/model/medical_service_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodayScheduleController extends GetxController {
  final isLoading = false.obs;
  final RxList<Appointment> appointments = <Appointment>[].obs;

  final RxList<Patient> patients = <Patient>[].obs;
  final RxList<Clinic> clinics = <Clinic>[].obs;
  final RxList<Hospital> hospitals = <Hospital>[].obs;
  final RxList<VaccinationCenter> vaccinationCenters = <VaccinationCenter>[].obs;
  final RxList<Schedule> schedules = <Schedule>[].obs;
  final RxList<MedicalServiceModel> medicalServices = <MedicalServiceModel>[].obs;

  final RxString specializationName = ''.obs;
  final SpecializationService _specializationService = SpecializationService();

  final AppointmentService _appointmentService = AppointmentService();
  final PatientService _patientService = PatientService();
  final ClinicService _clinicService = ClinicService();
  final HospitalService _hospitalService = HospitalService();
  final VaccinationCenterService _vaccinationCenterService = VaccinationCenterService();
  final ScheduleService _scheduleService = ScheduleService();
  final MedicalServiceService _medicalServiceService = MedicalServiceService();

  String? doctorId;

  @override
  void onInit() {
    super.onInit();
    loadDoctorIdAndFetch();
    loadDoctorSpecialization();
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

  Future<void> loadDoctorSpecialization() async {
    final prefs = await SharedPreferences.getInstance();
    final doctorJson = prefs.getString('doctor_data');
    if (doctorJson != null) {
      final doctor = jsonDecode(doctorJson);
      final specId = doctor['specialization_id'];
      if (specId != null) {
        await fetchSpecialization(specId);
      }
    }
  }

  Future<void> fetchSchedulesByDoctorId(String doctorId) async {
    isLoading.value = true;
    try {
      // Lấy toàn bộ appointments của bác sĩ
      final result = await _appointmentService.getByDoctorId(doctorId);
      appointments.assignAll(result);

      // Các ID để fetch detail entity
      final patientIds = appointments.map((a) => a.patientId).where((id) => id != null).toSet();
      final Set<String> hospitalIds = {};
      final Set<String> clinicIds = {};
      final Set<String> vaccinationCenterIds = {};

      for (final a in appointments) {
        if (a.hospitalId != null) {
          hospitalIds.add(a.hospitalId!);
        } else if (a.clinicId != null) {
          clinicIds.add(a.clinicId!);
        } else if (a.vaccinationCenterId != null) {
          vaccinationCenterIds.add(a.vaccinationCenterId!);
        }
      }

      final scheduleIds = appointments.map((a) => a.scheduleId).where((id) => id != null).toSet();
      final medicalServiceIds = appointments.map((a) => a.medicalServiceId).where((id) => id != null).toSet();

      // Fetch chi tiết từng loại entity
      patients.clear();
      for (final id in patientIds) {
        if (id != null) {
          final result = await _patientService.getPatientsById(id);
          if (result.isNotEmpty) patients.addAll(result);
        }
      }

      clinics.clear();
      for (final id in clinicIds) {
        if (id != null) {
          final clinic = await _clinicService.getById(id);
          if (clinic != null) clinics.add(clinic);
        }
      }

      hospitals.clear();
      for (final id in hospitalIds) {
        if (id != null) {
          final hospital = await _hospitalService.getHospitalById(id);
          if (hospital != null) hospitals.add(hospital);
        }
      }

      vaccinationCenters.clear();
      for (final id in vaccinationCenterIds) {
        if (id != null) {
          final vc = await _vaccinationCenterService.getById(id);
          if (vc != null) vaccinationCenters.add(vc);
        }
      }

      schedules.clear();
      for (final id in scheduleIds) {
        if (id != null) {
          final schedule = await _scheduleService.getScheduleById(id);
          if (schedule != null) schedules.add(schedule);
        }
      }

      medicalServices.clear();
      for (final id in medicalServiceIds) {
        if (id != null) {
          final ms = await _medicalServiceService.getById(id);
          if (ms != null) medicalServices.add(ms);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSpecialization(String specializationId) async {
    final result = await _specializationService.getById(specializationId);
    if (result != null) {
      specializationName.value = result.name;
    } else {
      specializationName.value = "Không xác định";
    }
  }

  /// Lấy list lịch khám lọc theo NGÀY HÔM NAY và CÒN GIỜ CHƯA QUA
  List<TodayScheduleItemVM> get todaySchedules {
    // Lấy ngày hiện tại (yyyy-MM-dd)
    final now = DateTime.now();
    final todayStr = "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final List<TodayScheduleItemVM> list = [];
    for (int i = 0; i < appointments.length; i++) {
      final appt = appointments[i];
      Schedule? schedule;
      if (appt.scheduleId != null) {
        schedule = schedules.firstWhereOrNull((s) => s.uuid == appt.scheduleId);
      }

      // So sánh ngày
      String? workDate;
      String? startTime;
      String? endTime;
      if (schedule != null) {
        workDate = schedule.workDate?.split('T').first; // lấy phần yyyy-MM-dd
        startTime = schedule.startTime;
        endTime = schedule.endTime;
      } else if (appt.dateTime != null) {
        final dt = DateTime.tryParse(appt.dateTime!);
        if (dt != null) {
          workDate = "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
          startTime = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:00";
        }
      }

      // Nếu không phải ngày hôm nay thì bỏ qua
      if (workDate != todayStr) continue;

      // Nếu đã qua giờ kết thúc thì bỏ qua
      if (endTime != null) {
        final nowTime = TimeOfDay.now();
        final end = TimeOfDay(
            hour: int.tryParse(endTime.split(':')[0]) ?? 0,
            minute: int.tryParse(endTime.split(':')[1]) ?? 0);
        // Nếu giờ hiện tại > giờ kết thúc ca khám, bỏ qua
        if (nowTime.hour > end.hour || (nowTime.hour == end.hour && nowTime.minute >= end.minute)) {
          continue;
        }
      }

      final patient = patients.firstWhereOrNull((p) => p.uuid == appt.patientId);
      final specialization = specializationName.value;
      String? locationName;
      if (appt.hospitalId != null) {
        locationName = hospitals.firstWhereOrNull((h) => h.uuid == appt.hospitalId)?.name;
      } else if (appt.clinicId != null) {
        locationName = clinics.firstWhereOrNull((c) => c.uuid == appt.clinicId)?.name;
      } else if (appt.vaccinationCenterId != null) {
        locationName = vaccinationCenters.firstWhereOrNull((v) => v.uuid == appt.vaccinationCenterId)?.name;
      }

      // Format ngày và giờ hiển thị
      String displayDate = '';
      String displayTime = '';
      if (schedule != null) {
        displayDate = _formatDate(schedule.workDate);
        displayTime = '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}';
      } else if (appt.dateTime != null) {
        displayDate = _formatDate(appt.dateTime);
        displayTime = _formatTime(appt.dateTime);
      }

      list.add(
        TodayScheduleItemVM(
          scheduleId: appt.scheduleId ?? '',
          location: locationName ?? "Không xác định",
          patientName: patient?.name ?? "Không rõ",
          specialization: specialization,
          date: displayDate,
          timeRange: displayTime,
          note: appt.healthStatus ?? '',
        ),
      );
    }
    return list;
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final dt = DateTime.tryParse(iso.split('T').first);
    if (dt == null) return iso;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _formatTime(String? t) {
    if (t == null || t.isEmpty) return '';
    if (t.length == 8 && t.contains(':')) {
      return t.substring(0, 5); // "HH:mm"
    }
    final dt = DateTime.tryParse(t);
    if (dt != null) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return t;
  }
}

class TodayScheduleItemVM {
  final String scheduleId;
  final String location;
  final String patientName;
  final String specialization;
  final String date;
  final String timeRange;
  final String note;

  TodayScheduleItemVM({
    required this.scheduleId,
    required this.location,
    required this.patientName,
    required this.specialization,
    required this.date,
    required this.timeRange,
    required this.note,
  });
}
