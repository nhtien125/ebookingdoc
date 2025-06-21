import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/widgets/controller/RegisterController.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final controller = Get.put(RegisterController());

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
                Positioned(
                  top: size.height * 0.18,
                  left: 20,
                  right: 20,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "ĐĂNG KÝ TÀI KHOẢN",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Obx(() => Column(
                            children: [
                              TextField(
                                controller: controller.username,
                                decoration: InputDecoration(
                                  labelText: "Tên tài khoản",
                                  errorText: controller.usernameError.value.isEmpty
                                      ? null
                                      : controller.usernameError.value,
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: controller.email,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  errorText: controller.emailError.value.isEmpty
                                      ? null
                                      : controller.emailError.value,
                                  prefixIcon: Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: controller.password,
                                obscureText: controller.hidePassword.value,
                                decoration: InputDecoration(
                                  labelText: "Mật khẩu",
                                  errorText: controller.passwordError.value.isEmpty
                                      ? null
                                      : controller.passwordError.value,
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(controller.hidePassword.value
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      controller.hidePassword.value =
                                          !controller.hidePassword.value;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: controller.confirmPassword,
                                obscureText: controller.hideConfirmPassword.value,
                                decoration: InputDecoration(
                                  labelText: "Nhập lại mật khẩu",
                                  errorText:
                                      controller.confirmPasswordError.value.isEmpty
                                          ? null
                                          : controller.confirmPasswordError.value,
                                  prefixIcon: Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(controller.hideConfirmPassword.value
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      controller.hideConfirmPassword.value =
                                          !controller.hideConfirmPassword.value;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Obx(() => ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          "ĐĂNG KÝ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                )),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Đã có tài khoản? ",
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 15)),
                                TextButton(
                                  onPressed: () => Get.toNamed('/login'),
                                  child: Text(
                                    "Đăng nhập ngay",
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
