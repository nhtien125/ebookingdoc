import 'package:ebookingdoc/src/constants/services/auth.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:ebookingdoc/src/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginController extends GetxController {
  final account = TextEditingController();
  final password = TextEditingController();

  final hidePassword = true.obs;
  final isLoading = false.obs;
  final accountError = ''.obs;
  final passwordError = ''.obs;
  final rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedCredentials();
  }

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


  Future<void> saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user_data', userJson);
  }


  Future<User?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  bool isValidEmail(String text) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
      .hasMatch(text);

  bool isValidUsername(String text) => text.length >= 4;
  bool isValidPassword(String pwd) => pwd.length >= 6 && pwd.length <= 20;

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
      final user = await Auth.login(
        account: account.text.trim(),
        password: password.text.trim(),
      );
      print("Kết quả Auth.login trả về: $user (${user.runtimeType})");
      if (user != null) {
        saveCredentials();
        await saveUserToPrefs(user);
        final prefs = await SharedPreferences.getInstance();
        print("user_data sau khi lưu: ${prefs.getString('user_data')}");
       Get.offAllNamed('/dashboard');
      } else {
        print("User NULL, không lưu được");
        Get.snackbar(
          "Lỗi",
          "Tài khoản hoặc mật khẩu không đúng",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[300],
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      print("Lỗi login: $e\n$stack");
    } finally {
      isLoading.value = false;
    }
  }

  void register() {
    accountError.value = '';
    passwordError.value = '';
    Get.toNamed('/register');
  }

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
