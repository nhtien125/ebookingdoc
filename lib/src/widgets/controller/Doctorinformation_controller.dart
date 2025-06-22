import 'dart:convert';
import 'dart:io';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorinformationController extends GetxController {
  final doctorType = 1.obs;
  final specializationId = ''.obs;
  final licenseController = TextEditingController();
  final introduceController = TextEditingController();
  final image = ''.obs;
  final localImage = Rxn<File>();

  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  late String uuid;
  late String? userId;

  // Data mẫu
  final Doctor sampleDoctor = Doctor(
    uuid: 'doc0001uuid00000000000000000001',
    userId: 'user0001uuid00000000000000000001',
    doctorType: 1,
    specializationId: 'spec0001uuid00000000000000000001',
    license: 'BS12345',
    introduce: 'Tôi là bác sĩ chuyên khoa Tim mạch với hơn 10 năm kinh nghiệm trong lĩnh vực chẩn đoán, điều trị các bệnh lý tim mạch và chăm sóc sức khỏe tim cho cộng đồng. Trong quá trình công tác tại các bệnh viện lớn, tôi đã trực tiếp điều trị thành công nhiều ca bệnh phức tạp như tăng huyết áp, bệnh động mạch vành, suy tim và rối loạn nhịp tim. Ngoài công việc chuyên môn, tôi thường xuyên tham gia các chương trình tư vấn, nâng cao nhận thức về phòng ngừa bệnh tim mạch. Phương châm làm việc của tôi là “Tận tâm – Chính xác – Hiệu quả” để mang lại sức khỏe bền vững cho từng bệnh nhân.',
    image: 'https://chienthanky.vn/wp-content/uploads/2024/01/top-100-anh-gai-2k7-cuc-xinh-ngay-tho-thuan-khiet-2169-31.jpg',
  );

  @override
  void onInit() {
    super.onInit();
    loadDoctorFromPrefs();
  }

  Future<void> loadDoctorFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final doctorJson = prefs.getString('doctor_data');
    Doctor doctor;
    if (doctorJson != null) {
      doctor = Doctor.fromJson(jsonDecode(doctorJson));
    } else {
      doctor = sampleDoctor;
      await prefs.setString('doctor_data', jsonEncode(doctor.toJson()));
    }
    uuid = doctor.uuid;
    userId = doctor.userId;
    doctorType.value = doctor.doctorType ?? 1;
    specializationId.value = doctor.specializationId ?? '';
    licenseController.text = doctor.license ?? '';
    introduceController.text = doctor.introduce ?? '';
    image.value = doctor.image ?? '';
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {

      final updatedDoctor = Doctor(
        uuid: uuid,
        userId: userId,
        doctorType: doctorType.value,
        specializationId: specializationId.value,
        license: licenseController.text,
        introduce: introduceController.text,
        image: image.value,
      );
      await saveDoctorToPrefs(updatedDoctor);
      Get.snackbar('Thành công', 'Đã lưu thông tin bác sĩ!');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lưu: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

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
    super.onClose();
  }
}
