import 'dart:io';  
import 'package:flutter/material.dart';  
import 'package:get/get.dart';  
import 'package:image_picker/image_picker.dart';  

class PersonalController extends GetxController {  
  // Form controllers  
  final nameController = TextEditingController();  
  final dobController = TextEditingController();  
  final phoneController = TextEditingController();  
  final emailController = TextEditingController();  
  final cityController = TextEditingController();  
  final districtController = TextEditingController();  
  final addressController = TextEditingController();  

  // Observables  
  final gender = 0.obs;  
  final avatar = Rxn<File>();  
  final isLoading = false.obs;  
  final formKey = GlobalKey<FormState>();  

  // Dispose controllers when no longer needed  
  @override  
  void onClose() {  
    nameController.dispose();  
    dobController.dispose();  
    phoneController.dispose();  
    emailController.dispose();  
    cityController.dispose();  
    districtController.dispose();  
    addressController.dispose();  
    super.onClose();  
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
        avatar.value = File(picked.path);  
      }  
    } catch (e) {  
      Get.snackbar('Lỗi', 'Không thể chọn ảnh: ${e.toString()}');  
    }  
  }  

  Future<void> selectDate(BuildContext context) async {  
    try {  
      final DateTime? pickedDate = await showDatePicker(  
        context: context,  
        initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),  
        firstDate: DateTime(1900),  
        lastDate: DateTime.now(),  
        locale: const Locale('vi', 'VN'),  
      );  

      if (pickedDate != null) {  
        dobController.text = "${pickedDate.day.toString().padLeft(2, '0')}/"  
            "${pickedDate.month.toString().padLeft(2, '0')}/"  
            "${pickedDate.year}";  
      }  
    } catch (e) {  
      Get.snackbar('Lỗi', 'Không thể chọn ngày: ${e.toString()}');  
    }  
  }  

  Future<void> saveProfile() async {  
    if (!formKey.currentState!.validate()) return;  

    isLoading.value = true;  
    
    try {  
      // Simulate API call  
      await Future.delayed(const Duration(seconds: 2));  
      
      Get.snackbar(  
        'Thành công',  
        'Thông tin đã được lưu',  
        backgroundColor: Colors.green,  
        colorText: Colors.white,  
      );  
    } catch (e) {  
      Get.snackbar(  
        'Lỗi',  
        'Không thể lưu thông tin: ${e.toString()}',  
        backgroundColor: Colors.red,  
        colorText: Colors.white,  
      );  
    } finally {  
      isLoading.value = false;  
    }  
  }  

  // Validation methods  
  String? validateName(String? value) {  
    if (value == null || value.isEmpty) {  
      return 'Vui lòng nhập họ tên';  
    }  
    return null;  
  }  

  String? validatePhone(String? value) {  
    if (value == null || value.isEmpty) {  
      return 'Vui lòng nhập số điện thoại';  
    }  
    if (!RegExp(r'^(0|\+84)[0-9]{9,10}$').hasMatch(value)) {  
      return 'Số điện thoại không hợp lệ';  
    }  
    return null;  
  }  
  
String? validateGmail(String? value) {
  final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
  
  if (!regex.hasMatch(value ?? '')) {
    return 'Email phải là Gmail hợp lệ';
  }
  return null;
}


  String? validateDate(String? value) {  
    if (value == null || value.isEmpty) {  
      return 'Vui lòng chọn ngày sinh';  
    }  
    return null;  
  }  
}  