import 'package:ebookingdoc/src/constants/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // Controllers cho input
  final account = TextEditingController(); // Đổi tên biến cho rõ ràng!
  final password = TextEditingController();

  // State observable
  final hidePassword = true.obs;
  final isLoading = false.obs;
  final accountError = ''.obs;  // Đổi tên luôn!
  final passwordError = ''.obs;
  final rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedCredentials();
  }

  // Load thông tin đã lưu (ghi nhớ)
  void loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAccount = prefs.getString('account') ?? '';
    final savedPassword = prefs.getString('password') ?? '';
    final savedRememberMe = prefs.getBool('rememberMe') ?? false;

    if (savedRememberMe && savedAccount.isNotEmpty) {
      account.text = savedAccount;
      password.text = savedPassword;
      rememberMe.value = true;
    }
  }

  // Lưu thông tin đăng nhập (ghi nhớ)
  void saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe.value) {
      await prefs.setString('account', account.text.trim());
      await prefs.setString('password', password.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('account');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  // Validate email cơ bản
  bool isValidEmail(String text) => RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"
    ).hasMatch(text);

  // Validate username: chỉ cần không rỗng hoặc tối thiểu 4 ký tự, bạn tự custom thêm nếu muốn
  bool isValidUsername(String text) => text.length >= 4;

  // Validate mật khẩu
  bool isValidPassword(String pwd) => pwd.length >= 6 && pwd.length <= 20;

  // Kiểm tra form trước khi login
  bool validateForm() {
    bool valid = true;
    final acc = account.text.trim();

    if (acc.isEmpty) {
      accountError.value = 'Vui lòng nhập email hoặc tên đăng nhập';
      valid = false;
    } else if (acc.contains('@')) {
      if (!isValidEmail(acc)) {
        accountError.value = 'Email không hợp lệ';
        valid = false;
      } else {
        accountError.value = '';
      }
    } else {
      if (!isValidUsername(acc)) {
        accountError.value = 'Tên đăng nhập phải từ 4 ký tự';
        valid = false;
      } else {
        accountError.value = '';
      }
    }

    if (password.text.isEmpty) {
      passwordError.value = 'Vui lòng nhập mật khẩu';
      valid = false;
    } else if (!isValidPassword(password.text)) {
      passwordError.value = 'Mật khẩu phải từ 6-20 ký tự';
      valid = false;
    } else {
      passwordError.value = '';
    }
    return valid;
  }

  // Hàm đăng nhập
  Future<void> login() async {
    if (!validateForm()) return;

    isLoading.value = true;
    try {
      final result = await Auth.login(
        account: account.text.trim(), // truyền email hoặc username
        password: password.text.trim(),
      );
      if (result == true) {
        saveCredentials();
        // Đã tự chuyển màn ở Auth.login
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

  // Điều hướng sang đăng ký
  void register() {
    accountError.value = '';
    passwordError.value = '';
    Get.toNamed('/register');
  }

  // Điều hướng sang quên mật khẩu
  void forgotPassword() {
    accountError.value = '';
    passwordError.value = '';
    // Get.toNamed('/forgotPassword');
  }

  @override
  void onClose() {
    account.dispose();
    password.dispose();
    super.onClose();
  }
}
