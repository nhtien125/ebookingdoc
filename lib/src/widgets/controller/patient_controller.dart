import 'dart:convert';

import 'package:ebookingdoc/src/constants/services/patient_service.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final gender = 0.obs; // 0: Nam, 1: Nữ, 2: Khác
  final relationship = ''.obs;
  final isLoading = false.obs;
  final PatientService _patientService = PatientService();

  @override
  void onClose() {
    nameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập họ và tên';
    if (value.length < 2) return 'Họ và tên phải có ít nhất 2 ký tự';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập số điện thoại';
    if (!RegExp(r'^\+?\d{9,15}$').hasMatch(value))
      return 'Số điện thoại không hợp lệ';
    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng chọn ngày sinh';
    try {
      final date = DateFormat('dd/MM/yyyy').parseStrict(value);
      final age = DateTime.now().year - date.year;
      if (age < 1 || age > 120) return 'Tuổi phải từ 1 đến 120';
      return null;
    } catch (e) {
      return 'Ngày sinh không hợp lệ';
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(picked);
    } else {
      Get.snackbar('Cảnh báo', 'Vui lòng chọn ngày sinh',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<User?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> saveProfile() async {
    if (formKey.currentState!.validate() &&
        gender.value != null &&
        relationship.value.isNotEmpty) {
      isLoading.value = true;
      try {
        // Fetch user_id from SharedPreferences
        User? currentUser = await getUserFromPrefs();
        if (currentUser == null) {
          Get.snackbar('Lỗi', 'Không tìm thấy thông tin người dùng',
              snackPosition: SnackPosition.BOTTOM);
          return;
        }

        // Convert dob to YYYY-MM-DD format
        String? formattedDob;
        if (dobController.text.isNotEmpty) {
          final date = DateFormat('dd/MM/yyyy').parse(dobController.text);
          formattedDob = DateFormat('yyyy-MM-dd').format(date);
        } else {
          Get.snackbar('Lỗi', 'Vui lòng chọn ngày sinh',
              snackPosition: SnackPosition.BOTTOM);
          isLoading.value = false;
          return;
        }

        // Prepare the patient data
        final patientData = {
          'user_id': currentUser.uuid,
          'name': nameController.text,
          'dob': formattedDob, // Use formatted date
          'gender': gender.value,
          'phone': phoneController.text,
          'relationship': relationship.value,
          'address': addressController.text,
        };

        print('Sending patient data: $patientData'); // Debug log

        // Call the createPatient method
        bool result = await _patientService.createPatient(patientData);
        if (result) {
          Get.snackbar('Thành công', 'Thông tin đã được lưu',
              snackPosition: SnackPosition.BOTTOM);
          formKey.currentState!.reset();
          gender.value = 0;
          relationship.value = '';
          nameController.clear();
          dobController.clear();
          phoneController.clear();
          addressController.clear();
        } else {
          Get.snackbar('Lỗi', 'Không thể lưu thông tin',
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar('Lỗi', 'Không thể lưu thông tin: ${e.toString()}',
            snackPosition: SnackPosition.BOTTOM);
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Lỗi', 'Vui lòng điền đầy đủ thông tin bắt buộc',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}