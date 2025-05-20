import 'package:ebookingdoc/src/constants/services/auth.dart';
import 'package:ebookingdoc/src/widgets/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[700]!, Colors.blue[500]!, Colors.blue[300]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                ),

                // Doctor image
                Positioned(
                  top: size.height * 0.08,
                  right: 0,
                  child: Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      'assets/images/doctor.png',
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

                // Login card
                Positioned(
                  top: size.height * 0.25,
                  left: 20,
                  right: 20,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
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
                                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                
                          _buildTextField(
                            label: "Số điện thoại",
                            controller: controller.username,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            hintText: "Nhập số điện thoại của bạn",
                            icon: Icons.phone_android,
                            errorText: controller.usernameError,
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          _buildTextField(
                            label: "Mật khẩu",
                            controller: controller.password,
                            keyboardType: controller.numericPassword.value
                                ? TextInputType.number
                                : TextInputType.text,
                            inputFormatters: controller.numericPassword.value
                                ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(20)]
                                : [LengthLimitingTextInputFormatter(20)],
                            hintText: "Nhập mật khẩu của bạn",
                            icon: Icons.lock_rounded,
                            errorText: controller.passwordError,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.hidePassword.value ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey[600],
                                size: 22,
                              ),
                              onPressed: () => controller.hidePassword.toggle(),
                            ),
                          ),

                          // Remember me and forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => Checkbox(
                                    value: controller.rememberMe.value,
                                    onChanged: (value) => controller.rememberMe.value = value!,
                                    activeColor: Colors.blue[800],
                                  )),
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
                          const SizedBox(height: 24),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 2,
                              ),
                              child: Obx(() => controller.isLoading.value
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                    )
                                  : const Text(
                                      "ĐĂNG NHẬP",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                    )),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Register option
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Chưa có tài khoản? ", style: TextStyle(color: Colors.grey[600], fontSize: 15)),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    RxString? errorText,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 15)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Obx(() => TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                  errorText: errorText?.value.isEmpty ?? true ? null : errorText?.value,
                  prefixIcon: Icon(icon, color: Colors.blue[800]),
                  suffixIcon: suffixIcon,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  counterText: "",
                ),
              )),
        ),
      ],
    );
  }
}