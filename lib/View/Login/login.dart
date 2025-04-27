import 'package:ebookingdoc/Service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import để sử dụng InputFormatter
import 'package:get/get.dart';
import 'package:ebookingdoc/Controller/Login/login_controller.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để responsive
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                // Background gradient
                Container(
                  height: size.height * 0.4,
                  width: size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue[700]!,
                        Colors.blue[500]!,
                        Colors.blue[300]!,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),

                // Hình ảnh bệnh viện hoặc doctor
                Positioned(
                  top: size.height * 0.08,
                  right: 0,
                  child: Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      'assets/images/doctor.png', // Thay thế bằng hình ảnh của bạn
                      height: size.height * 0.2,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.medical_services,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Login Card
                Positioned(
                  top: size.height * 0.25,
                  left: 20,
                  right: 20,
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "EBOOKINGDOC",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Xin chào! Đăng nhập để tiếp tục",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Text Fields
                          Text(
                            "Số điện thoại",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: Obx(() => TextField(
                                  controller: controller.username,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue[800],
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Nhập số điện thoại của bạn",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    border: InputBorder.none,
                                    errorText:
                                        controller.usernameError.value.isEmpty
                                            ? null
                                            : controller.usernameError.value,
                                    prefixIcon: Icon(
                                      Icons.phone_android,
                                      color: Colors.blue[800],
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    counterText: "",
                                  ),
                                )),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            "Mật khẩu",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: Obx(() => TextField(
                                  controller: controller.password,
                                  obscureText: controller.hidePassword.value,
                                  keyboardType: controller.numericPassword.value
                                      ? TextInputType.number
                                      : TextInputType.text,
                                  inputFormatters: controller
                                          .numericPassword.value
                                      ? [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(20),
                                        ]
                                      : [
                                          LengthLimitingTextInputFormatter(20),
                                        ],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue[800],
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Nhập mật khẩu của bạn",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    border: InputBorder.none,
                                    errorText:
                                        controller.passwordError.value.isEmpty
                                            ? null
                                            : controller.passwordError.value,
                                    prefixIcon: Icon(
                                      Icons.lock_rounded,
                                      color: Colors.blue[800],
                                    ),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            controller.hidePassword.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey[600],
                                            size: 22,
                                          ),
                                          onPressed: () => controller
                                                  .hidePassword.value =
                                              !controller.hidePassword.value,
                                        ),
                                      ],
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    counterText: "",
                                  ),
                                )),
                          ),

                          // Remember Me and Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Obx(() => Checkbox(
                                        value: controller.rememberMe.value,
                                        onChanged: (value) => controller
                                            .rememberMe.value = value!,
                                        activeColor: Colors.blue[800],
                                      )),
                                ],
                              ),
                              TextButton(
                                onPressed: controller.forgotPassword,
                                child: Text(
                                  "Quên mật khẩu?",
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                await Auth.login(
                                  userName: controller.username.text.trim(),
                                  password: controller.password.text.trim(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                              ),
                              child: Obx(() => controller.isLoading.value
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      "ĐĂNG NHẬP",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    )),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Register Option
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Chưa có tài khoản? ",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 15,
                                  ),
                                ),
                                TextButton(
                                  onPressed: controller.register,
                                  child: Text(
                                    "Đăng ký ngay",
                                    style: TextStyle(
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
