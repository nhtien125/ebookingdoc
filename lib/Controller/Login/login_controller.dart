import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/Route/app_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm package này nếu chưa có

class LoginController extends GetxController {
  // Text controllers
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  
  // Biến observable
  RxBool hidePassword = true.obs;
  RxBool isLoading = false.obs;
  RxString usernameError = ''.obs;
  RxString passwordError = ''.obs;
  RxBool rememberMe = false.obs;
  RxBool numericPassword = true.obs; // Mặc định sử dụng bàn phím số cho mật khẩu
  
  @override
  void onInit() {
    super.onInit();
    loadSavedCredentials();
  }
  
  // Hàm chuyển đổi giữa bàn phím số và bàn phím chữ cho mật khẩu
  void togglePasswordKeyboardType() {
    numericPassword.value = !numericPassword.value;
  }
  
  // Tải thông tin đăng nhập đã lưu
  void loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username') ?? '';
    final savedPassword = prefs.getString('password') ?? '';
    final savedRememberMe = prefs.getBool('rememberMe') ?? false;
    
    if (savedRememberMe && savedUsername.isNotEmpty) {
      username.text = savedUsername;
      if (savedPassword.isNotEmpty) {
        password.text = savedPassword;
      }
      rememberMe.value = true;
    }
  }
  
  // Lưu thông tin đăng nhập
  void saveCredentials() async {
    if (rememberMe.value) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username.text);
      await prefs.setString('password', password.text);
      await prefs.setBool('rememberMe', true);
    } else {
      // Xóa thông tin đã lưu nếu không chọn ghi nhớ
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  // Kiểm tra số điện thoại hợp lệ
  bool isValidPhoneNumber(String phone) {
    // Kiểm tra xem SĐT có đúng định dạng không
    return phone.length == 10 && phone.startsWith('0');
  }

  // Kiểm tra mật khẩu hợp lệ
  bool isValidPassword(String pwd) {
    return pwd.length >= 6 && pwd.length <= 20;
  }

  // Validate form
  bool validateForm() {
    bool isValid = true;
    
    // Kiểm tra username (SĐT)
    if (username.text.isEmpty) {
      usernameError.value = 'Vui lòng nhập số điện thoại';
      isValid = false;
    } else if (!isValidPhoneNumber(username.text)) {
      usernameError.value = 'Số điện thoại không hợp lệ';
      isValid = false;
    } else {
      usernameError.value = '';
    }
    
    // Kiểm tra password
    if (password.text.isEmpty) {
      passwordError.value = 'Vui lòng nhập mật khẩu';
      isValid = false;
    } else if (!isValidPassword(password.text)) {
      passwordError.value = 'Mật khẩu phải từ 6-20 ký tự';
      isValid = false;
    } else {
      passwordError.value = '';
    }
    
    return isValid;
  }

  // Logic đăng nhập
  void login() async {
    // Kiểm tra form trước
    if (!validateForm()) return;
    
    try {
      isLoading.value = true;
      
      // Mô phỏng gọi API đăng nhập
      await Future.delayed(Duration(seconds: 1));
      
      // TODO: Thay thế bằng logic gọi API thực tế
      // Đây chỉ là logic đăng nhập giả để kiểm tra giao diện
      bool loginSuccess = false;
      
      // Demo tài khoản (số điện thoại: 0123456789, mật khẩu: 123456)
      if (username.text == '0123456789' && password.text == '123456') {
        loginSuccess = true;
      }
      
      if (loginSuccess) {
        // Lưu thông tin đăng nhập nếu chọn "Ghi nhớ đăng nhập"
        saveCredentials();
        
        // Chuyển hướng đến trang chủ (dashboard)
        Get.offAllNamed(Routes.dashboard);
      } else {
        // Hiển thị thông báo lỗi đăng nhập
        Get.snackbar(
          'Đăng nhập thất bại',
          'Số điện thoại hoặc mật khẩu không chính xác',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.error_outline, color: Colors.red[800]),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra. Vui lòng thử lại sau.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        margin: EdgeInsets.all(16),
        icon: Icon(Icons.error_outline, color: Colors.red[800]),
      );
      print('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Logic đăng ký
  void register() {
    // Xóa các thông báo lỗi khi chuyển trang
    usernameError.value = '';
    passwordError.value = '';
    
    // Điều hướng tới trang đăng ký
    // Get.toNamed(Routes.register);
  }

  // Logic quên mật khẩu
  void forgotPassword() {
    // Xóa các thông báo lỗi khi chuyển trang
    usernameError.value = '';
    passwordError.value = '';
    
    // Get.toNamed(Routes.forgotPassword);
  }
  
  @override
  void onClose() {
    // Giải phóng bộ nhớ controllers khi không sử dụng
    username.dispose();
    password.dispose();
    super.onClose();
  }
}