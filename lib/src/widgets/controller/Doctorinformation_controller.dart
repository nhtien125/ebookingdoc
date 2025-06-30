import 'dart:convert';
import 'dart:io';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorinformationController extends GetxController {
  // Các trường dạng Rx cho dropdown/select
  final doctorType = 1.obs;
  final specializationId = ''.obs;
  final hospitalId = ''.obs;
  final clinicId = ''.obs;

  // Các trường nhập liệu
  final licenseController = TextEditingController();
  final introduceController = TextEditingController();
  final experienceController = TextEditingController();

  // Ảnh
  final image = ''.obs; // URL ảnh từ server (nếu có)
  final localImage = Rxn<File>();

  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  late String uuid;
  late String? userId;

  // Dữ liệu dropdown mẫu (nếu chưa có API)
  final List<Map<String, String>> specializations = [
    {'id': 'spec0001uuid00000000000000000001', 'name': 'Tim mạch'},
    {'id': 'spec0002uuid00000000000000000002', 'name': 'Ngoại khoa'},
    {'id': 'spec0003uuid00000000000000000003', 'name': 'Da liễu'},
    {'id': 'spec0004uuid00000000000000000004', 'name': 'Thần kinh'},
    {'id': 'spec0005uuid00000000000000000005', 'name': 'Ngoại tổng quát'},
    {'id': 'spec0006uuid00000000000000000006', 'name': 'Sản phụ khoa'},
    {'id': 'spec0007uuid00000000000000000007', 'name': 'Răng hàm mặt'},
  ];

  final List<Map<String, String>> hospitals = [
    {'id': 'hosp0001uuid00000000000000000001', 'name': 'Bệnh viện Chợ Rẫy'},
    {'id': 'hosp0003uuid00000000000000000003', 'name': 'Bệnh viện Da liễu TW'},
    {'id': 'hosp0005uuid00000000000000000005', 'name': 'Bệnh viện Ngoại TW'},
    {'id': 'hosp0007uuid00000000000000000007', 'name': 'Bệnh viện RHM VN'},
  ];
  final List<Map<String, String>> clinics = [
    {'id': 'cli0002uuid00000000000000000002', 'name': 'PK Nhi Đồng'},
    {'id': 'cli0004uuid00000000000000000004', 'name': 'PK Thần Kinh SG'},
    {'id': 'cli0006uuid00000000000000000006', 'name': 'PK Sản Phụ Khoa'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadDoctorFromPrefs();
  }

  Future<void> loadDoctorFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final doctorJson = prefs.getString('doctor_data');
    if (doctorJson != null) {
      print("Thông tin bác sĩ đã có trong SharedPreferences, đang giải mã...");
      final doctor = Doctor.fromJson(jsonDecode(doctorJson));
      uuid = doctor.uuid;
      userId = doctor.userId;
      doctorType.value = doctor.doctorType ?? 1;
      specializationId.value = doctor.specializationId ?? '';
      hospitalId.value = doctor.hospitalId ?? '';
      clinicId.value = doctor.clinicId ?? '';
      licenseController.text = doctor.license ?? '';
      introduceController.text = doctor.introduce ?? '';
      experienceController.text =
          doctor.experience != null ? doctor.experience.toString() : '';
      image.value = doctor.image ?? '';
      print("Thông tin bác sĩ: ${doctor.toString()}");
    } else {
      print("Không có thông tin bác sĩ trong SharedPreferences.");
    }
  }

  // Lưu thông tin bác sĩ vào SharedPreferences
  Future<void> saveDoctorToPrefs(Doctor doctor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('doctor_data', jsonEncode(doctor.toJson()));
  }

  Future<void> pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked != null) {
        localImage.value = File(picked.path);
        image.value = picked.path;
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể chọn ảnh: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    licenseController.dispose();
    introduceController.dispose();
    experienceController.dispose();
    super.onClose();
  }
}
