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

final RxInt selectedRole = 2.obs; 


  void register() async {
    usernameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';

    if (username.text.trim().isEmpty) {
      usernameError.value = 'Vui lòng nhập tên tài khoản';
      return;
    }
    if (username.text.trim().length < 6) {
      usernameError.value = 'Tên tài khoản phải tối thiểu 6 ký tự';
      return;
    }
    if (email.text.trim().isEmpty) {
      emailError.value = 'Vui lòng nhập email';
      return;
    }
    if (!GetUtils.isEmail(email.text.trim())) {
      emailError.value = 'Email không hợp lệ';
      return;
    }
    if (password.text.isEmpty) {
      passwordError.value = 'Vui lòng nhập mật khẩu';
      return;
    }
    if (password.text.length < 6) {
      passwordError.value = 'Mật khẩu tối thiểu 6 ký tự';
      return;
    }
    if (confirmPassword.text != password.text) {
      confirmPasswordError.value = 'Mật khẩu nhập lại không khớp';
      return;
    }

    isLoading.value = true;
    try {
      final result = await Auth.register(
        username: username.text.trim(),
        email: email.text.trim(),
        password: password.text.trim(),
        premissionId: 2, 
      );
      if (result == true) {
        Get.snackbar("Thành công", "Đăng ký thành công, vui lòng đăng nhập!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green[300],
            colorText: Colors.white);
        Get.offAllNamed('/login');
      } else {
        Get.snackbar("Lỗi", result.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[300],
            colorText: Colors.white);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
