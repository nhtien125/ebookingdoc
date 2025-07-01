import 'dart:io';
import 'package:ebookingdoc/src/constants/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart'; // Thêm để kiểm tra debug mode

class PersonalController extends GetxController {
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final addressController = TextEditingController();

  final gender = 0.obs;
  final avatar = Rxn<File>();
  final avatarUrl = ''.obs;
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadUserFromPrefs();
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (kDebugMode) {
      print('Loaded userJson from SharedPreferences: $userJson');
    }
    if (userJson != null) {
      try {
        final user = User.fromJson(jsonDecode(userJson));
        nameController.text = user.name ?? '';
        phoneController.text = user.phone ?? '';
        emailController.text = user.email ?? '';
        addressController.text = user.address ?? '';
        gender.value = user.gender ?? 0;
        avatarUrl.value = user.image ?? '';
        if (user.birthDay != null && user.birthDay!.isNotEmpty) {
          try {
            final date = DateFormat('yyyy-MM-dd').parse(user.birthDay!);
            dobController.text =
                "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
            if (kDebugMode) {
              print('Loaded birthDay: ${user.birthDay}');
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error parsing birthDay: $e');
            }
          }
        } else {
          if (kDebugMode) {
            print('No birthDay found in user data');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error decoding userJson: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('No user data found in SharedPreferences');
      }
    }
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) {
      if (kDebugMode) {
        print('Form validation failed');
      }
      return;
    }

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
      User? oldUser;
      if (userJson != null) {
        oldUser = User.fromJson(jsonDecode(userJson));
      }

      // In dữ liệu đầu vào
      if (kDebugMode) {
        print('[saveProfile] Input Data:');
        print('Name: ${nameController.text}');
        print('Email: ${emailController.text}');
        print('Phone: ${phoneController.text}');
        print('Gender: ${gender.value}');
        print('BirthDay: ${dobController.text}');
        print('Address: ${addressController.text}');
      }

      // Chuyển đổi ngày sinh
      String? birthDay;
      if (dobController.text.isNotEmpty) {
        try {
          final date = DateFormat('dd/MM/yyyy').parse(dobController.text);
          birthDay = DateFormat('yyyy-MM-dd').format(date);
          if (kDebugMode) {
            print('Converted birthDay: $birthDay');
          }
        } catch (e) {
          Get.snackbar('Lỗi', 'Định dạng ngày sinh không hợp lệ: ${e.toString()}',
              backgroundColor: Colors.red, colorText: Colors.white);
          isLoading.value = false;
          return;
        }
      }

      // Gọi API
      final apiResult = await Auth.updateUser(
        uuid: oldUser?.uuid ?? '',
        name: nameController.text,
        gender: gender.value,
        birthDay: birthDay ?? '',
        phone: phoneController.text,
        email: emailController.text,
        premissionId: oldUser?.premissionId ?? 3,
        accessToken: null,
      );

      if (kDebugMode) {
        print('[saveProfile] API Result: $apiResult');
      }

      if (apiResult != null) {
        final updatedUser = User(
          uuid: oldUser?.uuid ?? '',
          premissionId: oldUser?.premissionId ?? 3,
          name: apiResult['name'] ?? nameController.text.isNotEmpty ? nameController.text : oldUser?.name,
          email: apiResult['email'] ?? emailController.text.isNotEmpty ? emailController.text : oldUser?.email,
          phone: apiResult['phone'] ?? phoneController.text.isNotEmpty ? phoneController.text : oldUser?.phone,
          gender: apiResult['gender'] ?? gender.value,
          address: apiResult['address'] ?? addressController.text.isNotEmpty ? addressController.text : oldUser?.address,
          username: oldUser?.username ?? '',
          password: oldUser?.password,
          status: oldUser?.status ?? 0,
          image: apiResult['image'] ?? avatarUrl.value,
          birthDay: apiResult['birth_day'] ?? birthDay ?? oldUser?.birthDay ?? '',
          createdAt: apiResult['created_at'] ?? oldUser?.createdAt ?? '',
          updatedAt: apiResult['updated_at'] ?? DateTime.now().toIso8601String(),
        );
        await saveUserToPrefs(updatedUser);

        Get.snackbar(
          'Thành công',
          'Thông tin đã được lưu',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Lỗi',
          'Phản hồi từ API không hợp lệ',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
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

  void printUserDetails(User user) {
    if (kDebugMode) {
      print('[User Details]');
      print('UUID: ${user.uuid ?? 'N/A'}');
      print('Name: ${user.name ?? 'N/A'}');
      print('Email: ${user.email ?? 'N/A'}');
      print('Phone: ${user.phone ?? 'N/A'}');
      print('Gender: ${user.gender ?? 'N/A'}');
      print('Address: ${user.address ?? 'N/A'}');
      print('BirthDay: ${user.birthDay ?? 'N/A'}');
      print('Permission ID: ${user.premissionId ?? 'N/A'}');
      print('Username: ${user.username ?? 'N/A'}');
      print('Status: ${user.status ?? 'N/A'}');
      print('Image: ${user.image ?? 'N/A'}');
      print('Created At: ${user.createdAt ?? 'N/A'}');
      print('Updated At: ${user.updatedAt ?? 'N/A'}');
    }
  }

  Future<void> saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    if (kDebugMode) {
      print('[saveUserToPrefs] Saved userJson: $userJson');
    }
    printUserDetails(user);
    await prefs.setString('user_data', userJson);
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
        avatarUrl.value = picked.path;
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể chọn ảnh: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
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
        dobController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể chọn ngày: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

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
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    if (!regex.hasMatch(value)) {
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
}