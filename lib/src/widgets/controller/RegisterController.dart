import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/constants/services/auth.dart';

class RegisterController extends GetxController {
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  var usernameError = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  var isLoading = false.obs;
  var hidePassword = true.obs;
  var hideConfirmPassword = true.obs;

  // Initialize with null to show hint text initially
  final Rx<int?> selectedRole = Rx<int?>(null);

  @override
  void onClose() {
    username.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }

  void clearErrors() {
    usernameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
  }

  bool validateForm() {
    // Kiểm tra nếu controller đã bị dispose
    if (!Get.isRegistered<RegisterController>()) return false;
    
    clearErrors();
    bool isValid = true;

    // Lưu giá trị để tránh lỗi disposed
    final usernameValue = username.text.trim();
    final emailValue = email.text.trim();
    final passwordValue = password.text;
    final confirmPasswordValue = confirmPassword.text;

    // Username validation
    if (usernameValue.isEmpty) {
      usernameError.value = 'Vui lòng nhập tên tài khoản';
      isValid = false;
    } else if (usernameValue.length < 6) {
      usernameError.value = 'Tên tài khoản phải tối thiểu 6 ký tự';
      isValid = false;
    }

    // Email validation
    if (emailValue.isEmpty) {
      emailError.value = 'Vui lòng nhập email';
      isValid = false;
    } else if (!GetUtils.isEmail(emailValue)) {
      emailError.value = 'Email không hợp lệ';
      isValid = false;
    }

    // Password validation
    if (passwordValue.isEmpty) {
      passwordError.value = 'Vui lòng nhập mật khẩu';
      isValid = false;
    } else if (passwordValue.length < 6) {
      passwordError.value = 'Mật khẩu tối thiểu 6 ký tự';
      isValid = false;
    }

    // Confirm password validation
    if (confirmPasswordValue.isEmpty) {
      confirmPasswordError.value = 'Vui lòng nhập lại mật khẩu';
      isValid = false;
    } else if (confirmPasswordValue != passwordValue) {
      confirmPasswordError.value = 'Mật khẩu nhập lại không khớp';
      isValid = false;
    }

    // Role validation
    if (selectedRole.value == null) {
      Get.snackbar(
        "Lỗi",
        "Vui lòng chọn vai trò của bạn",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      isValid = false;
    }

    return isValid;
  }

  void register() async {
    if (!validateForm()) return;

    isLoading.value = true;
    
    try {
      // Lưu giá trị trước khi gọi API để tránh lỗi disposed
      final usernameValue = username.text.trim();
      final emailValue = email.text.trim();
      final passwordValue = password.text.trim();
      final roleValue = selectedRole.value!;
      
      // Debug: In ra giá trị role được chọn
      print('Selected role value: $roleValue');
      print('Role meaning: ${roleValue == 2 ? "Bác sĩ" : "Người dùng"}');
      
      final result = await Auth.register(
        username: usernameValue,
        email: emailValue,
        password: passwordValue,
        premissionId: roleValue,
      );
      
      // Kiểm tra nếu controller vẫn còn tồn tại trước khi sử dụng
      if (!Get.isRegistered<RegisterController>()) return;
      
      if (result is String && result.length > 10) { // Kiểm tra nếu là uuid
        if (roleValue == 2) { // Bác sĩ
          // Nếu là bác sĩ, chuyển sang màn hình đăng ký bác sĩ với uuid
          Get.snackbar(
            "Thành công", 
            "Tạo tài khoản bác sĩ thành công! Vui lòng hoàn tất thông tin bác sĩ.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            duration: const Duration(seconds: 3),
          );
          
          Get.toNamed('/doctor-registration', arguments: {
            'uuid': result,
          });
        } else if (roleValue == 3) { // Người dùng thông thường
          // Nếu là người dùng thông thường, đăng ký thành công
          Get.snackbar(
            "Thành công", 
            "Đăng ký tài khoản người dùng thành công! Vui lòng đăng nhập.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            duration: const Duration(seconds: 3),
          );
          
          Get.toNamed('/login');
        } else {
          // Vai trò không hợp lệ
          Get.snackbar(
            "Lỗi", 
            "Vai trò không hợp lệ: $roleValue",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        // Xử lý lỗi từ server
        String errorMessage = result.toString();
        if (errorMessage.contains('email')) {
          if (Get.isRegistered<RegisterController>()) {
            emailError.value = 'Email đã được sử dụng';
          }
        } else if (errorMessage.contains('username')) {
          if (Get.isRegistered<RegisterController>()) {
            usernameError.value = 'Tên tài khoản đã tồn tại';
          }
        } else {
          Get.snackbar(
            "Lỗi", 
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Lỗi", 
        "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } finally {
      // Chỉ set isLoading nếu controller vẫn còn tồn tại
      if (Get.isRegistered<RegisterController>()) {
        isLoading.value = false;
      }
    }
  }

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }
}