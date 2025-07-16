import 'dart:convert';
import 'package:ebookingdoc/src/constants/services/HospitalService.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/constants/services/specialization_service.dart';
import 'package:ebookingdoc/src/constants/services/DoctorService.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/specialization_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorinformationController extends GetxController {
  // Services
  final HospitalService _hospitalService = HospitalService();
  final ClinicService _clinicService = ClinicService();
  final SpecializationService _specializationService = SpecializationService();
  final DoctorService _doctorService = DoctorService();

  // Controllers
  final licenseController = TextEditingController();
  final introduceController = TextEditingController();
  final experienceController = TextEditingController();

  // Dropdown data
  final specializations = <Specialization>[].obs;
  final hospitals = <Hospital>[].obs;
  final clinics = <Clinic>[].obs;

  // Selected values
  final RxString specializationId = ''.obs;
  final RxString hospitalId = ''.obs;
  final RxString clinicId = ''.obs;
  final RxInt doctorType = 1.obs; // 1: Chính quy, 2: Cộng tác viên

  // Loading states
  final isLoading = false.obs;
  final isLoadingSpecializations = false.obs;
  final isLoadingHospitals = false.obs;
  final isLoadingClinics = false.obs;

  // Doctor info
  final RxInt doctorStatus = 1.obs; // 0: Đã duyệt, 1: Chờ duyệt, 2: Từ chối
  final Rx<Doctor?> doctorInfo = Rx<Doctor?>(null);

  final formKey = GlobalKey<FormState>();

  String? uuid;
  String? userId;

  @override
  void onInit() {
    super.onInit();
    loadDoctorFromPrefs();
    loadInitialData();
  }

  @override
  void onClose() {
    licenseController.dispose();
    introduceController.dispose();
    experienceController.dispose();
    super.onClose();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      getSpecializations(),
      fetchHospitals(),
      fetchClinics(),
    ]);
  }

  Future<void> loadDoctorFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final doctorJson = prefs.getString('doctor_data');
    if (doctorJson != null) {
      print("Thông tin bác sĩ đã có trong SharedPreferences, đang giải mã...");
      final doctor = Doctor.fromJson(jsonDecode(doctorJson));
      uuid = doctor.uuid;
      userId = doctor.userId;
      doctorInfo.value = doctor;
      doctorStatus.value = doctor.status ?? 1;
      specializationId.value = doctor.specializationId ?? '';
      hospitalId.value = doctor.hospitalId ?? '';
      clinicId.value = doctor.clinicId ?? '';
      licenseController.text = doctor.license ?? '';
      introduceController.text = doctor.introduce ?? '';
      experienceController.text = doctor.experience?.toString() ?? '';
      print("Thông tin bác sĩ: ${doctor.toString()}");
      print("Status: ${doctorStatus.value}");
      await loadDoctorFromAPI();
    } else {
      print("Không có thông tin bác sĩ trong SharedPreferences.");
    }
  }

  Future<void> loadDoctorFromAPI() async {
    if (userId == null) {
      print("userId is null, skipping API load.");
      return;
    }

    isLoading.value = true;
    try {
      final doctors = await _doctorService.getDoctorsByUserId(userId!);
      if (doctors.isNotEmpty) {
        final doctor = doctors.firstWhere((d) => d.uuid == uuid, orElse: () => doctors.first);
        doctorInfo.value = doctor;
        doctorStatus.value = doctor.status ?? 1;
        specializationId.value = doctor.specializationId ?? '';
        hospitalId.value = doctor.hospitalId ?? '';
        clinicId.value = doctor.clinicId ?? '';
        licenseController.text = doctor.license ?? '';
        introduceController.text = doctor.introduce ?? '';
        experienceController.text = doctor.experience?.toString() ?? '';
        await saveDoctorToPrefs(doctor);
        print("Đã cập nhật thông tin bác sĩ từ API");
      } else {
        print("No doctors found for userId: $userId");
      }
    } catch (e) {
      print("Lỗi khi load thông tin bác sĩ từ API: $e");
      Get.snackbar('Lỗi', 'Không thể tải thông tin bác sĩ: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSpecializations() async {
    isLoadingSpecializations.value = true;
    try {
      final list = await _specializationService.getAllSpecialization();
      specializations.value = list;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách chuyên ngành: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingSpecializations.value = false;
    }
  }

  Future<void> fetchHospitals() async {
    isLoadingHospitals.value = true;
    try {
      final list = await _hospitalService.getAllHospital();
      hospitals.value = list;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách bệnh viện: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingHospitals.value = false;
    }
  }

  Future<void> fetchClinics() async {
    isLoadingClinics.value = true;
    try {
      final list = await _clinicService.getAllClinic();
      clinics.value = list;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách phòng khám: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingClinics.value = false;
    }
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      // Validate hospital and clinic exclusivity
      if (hospitalId.value.isNotEmpty && clinicId.value.isNotEmpty) {
        Get.snackbar('Lỗi', 'Chỉ có thể chọn bệnh viện hoặc phòng khám, không cả hai.', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Prepare data for API
      final doctorData = {
        'user_id': userId,
        'specialization_id': specializationId.value.isEmpty ? null : specializationId.value,
        'hospital_id': hospitalId.value.isEmpty ? null : hospitalId.value,
        'clinic_id': clinicId.value.isEmpty ? null : clinicId.value,
        'license': licenseController.text.trim(),
        'introduce': introduceController.text.trim(),
        'experience': int.tryParse(experienceController.text.trim()),
      };

      // Remove null values
      doctorData.removeWhere((key, value) => value == null);

      bool success;
      if (uuid != null) {
        // Update existing doctor
        success = await _doctorService.updateDoctor(uuid!, doctorData);
      } else {
        // This should not happen in this screen, but handle it as a fallback
        Get.snackbar('Lỗi', 'Không tìm thấy UUID bác sĩ. Vui lòng tải lại thông tin.', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (success) {
        final updatedDoctor = Doctor(
          uuid: uuid!, // Safe to use ! here since we checked uuid != null
          userId: userId,
          specializationId: specializationId.value,
          hospitalId: hospitalId.value,
          clinicId: clinicId.value,
          license: licenseController.text.trim(),
          introduce: introduceController.text.trim(),
          experience: int.tryParse(experienceController.text.trim()),
          status: doctorStatus.value,
        );
        doctorInfo.value = updatedDoctor;
        await saveDoctorToPrefs(updatedDoctor);
        Get.snackbar('Thành công', 'Đã lưu thông tin bác sĩ thành công!', backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Lỗi', 'Không thể lưu thông tin. Vui lòng thử lại.', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi: ${e.toString()}', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveDoctorToPrefs(Doctor doctor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('doctor_data', jsonEncode(doctor.toJson()));
  }

  String getStatusText() {
    switch (doctorStatus.value) {
      case 0:
        return 'Hồ sơ đã được duyệt';
      case 1:
        return 'Hồ sơ đang chờ duyệt';
      case 2:
        return 'Hồ sơ bị từ chối';
      default:
        return 'Trạng thái không xác định';
    }
  }

  Color getStatusColor() {
    switch (doctorStatus.value) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon() {
    switch (doctorStatus.value) {
      case 0:
        return Icons.check_circle;
      case 1:
        return Icons.access_time;
      case 2:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}