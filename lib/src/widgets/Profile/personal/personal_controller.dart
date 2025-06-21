import 'dart:io';
import 'package:ebookingdoc/src/constants/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ebookingdoc/src/data/model/userModel.dart';

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
  final avatarUrl = ''.obs;
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadUserFromPrefs();
  }

  // Load user info từ SharedPreferences
  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      final user = User.fromJson(jsonDecode(userJson));
      nameController.text = user.name ?? '';
      phoneController.text = user.phone ?? '';
      emailController.text = user.email ?? '';
      addressController.text = user.address ?? '';
      gender.value = user.gender ?? 0;
      avatarUrl.value = user.image ?? '';
      // Nếu có ngày sinh thì parse lại cho đúng định dạng dd/MM/yyyy
      if (user.createdAt != null && user.createdAt!.isNotEmpty) {
        try {
          final date = DateTime.parse(user.createdAt!);
          dobController.text = "${date.day.toString().padLeft(2, '0')}/"
              "${date.month.toString().padLeft(2, '0')}/"
              "${date.year}";
        } catch (_) {}
      }
    }
  }

  // Lưu lại thông tin user vào SharedPreferences
  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
      User? oldUser;
      if (userJson != null) {
        oldUser = User.fromJson(jsonDecode(userJson));
      }

      // Gọi API cập nhật thông tin người dùng
      final apiResult = await Auth.updateUser(
        uuid: oldUser?.uuid ?? '',
        name: nameController.text,
        gender: gender.value,
        birthDay: dobController
            .text, // Đảm bảo đúng định dạng yyyy-MM-dd nếu backend yêu cầu
        phone: phoneController.text,
        email: emailController.text,
        premissionId: oldUser?.premissionId ?? 3,
        accessToken: null, // hoặc truyền token nếu cần
      );

      if (apiResult != null) {
        // Cập nhật lại SharedPreferences với dữ liệu mới từ API
        final updatedUser = User(
          uuid: oldUser?.uuid ?? '',
          premissionId: oldUser?.premissionId,
          name: apiResult['name'],
          email: apiResult['email'],
          phone: apiResult['phone'],
          gender: apiResult['gender'],
          address: apiResult['address'],
          username: oldUser?.username,
          password: oldUser?.password,
          status: oldUser?.status,
          image: apiResult['image'] ?? avatarUrl.value,
          createdAt: apiResult['created_at'] ?? oldUser?.createdAt,
          updatedAt:
              apiResult['updated_at'] ?? DateTime.now().toIso8601String(),
        );
        await saveUserToPrefs(updatedUser);

        Get.snackbar(
          'Thành công',
          'Thông tin đã được lưu',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      // Nếu apiResult là null thì Auth.updateUser đã show lỗi rồi
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

  Future<void> saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    // Log ra màn hình (console) trước khi lưu
    print('[saveUserToPrefs] userJson: $userJson');
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
        // Nếu bạn muốn lưu đường dẫn ảnh vào SharedPreferences:
        avatarUrl.value = picked.path;
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
