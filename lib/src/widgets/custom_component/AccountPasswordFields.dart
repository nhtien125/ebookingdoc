import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPasswordFields extends StatelessWidget {
  final TextEditingController accountController;
  final TextEditingController passwordController;
  final RxString accountError;
  final RxString passwordError;
  final RxBool hidePassword;
  final String accountLabel;
  final String accountHint;
  final bool showConfirmPassword;
  final TextEditingController? confirmPasswordController;
  final RxString? confirmPasswordError;
  final RxBool? hideConfirmPassword;

  const AccountPasswordFields({
    super.key,
    required this.accountController,
    required this.passwordController,
    required this.accountError,
    required this.passwordError,
    required this.hidePassword,
    this.accountLabel = 'Email hoặc tên đăng nhập',
    this.accountHint = 'Nhập email hoặc username',
    this.showConfirmPassword = false,
    this.confirmPasswordController,
    this.confirmPasswordError,
    this.hideConfirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            accountLabel,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 15),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextField(
              controller: accountController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: accountHint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                errorText: accountError.value.isEmpty ? null : accountError.value,
              ),
            )),
        const SizedBox(height: 18),

        Align(
          alignment: Alignment.centerLeft,
          child: Text("Mật khẩu", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 15)),
        ),
        const SizedBox(height: 8),
        Obx(() => TextField(
              controller: passwordController,
              obscureText: hidePassword.value,
              decoration: InputDecoration(
                hintText: "Nhập mật khẩu",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                errorText: passwordError.value.isEmpty ? null : passwordError.value,
                suffixIcon: IconButton(
                  icon: Icon(hidePassword.value ? Icons.visibility_off : Icons.visibility, color: Colors.grey[600]),
                  onPressed: () => hidePassword.value = !hidePassword.value,
                ),
              ),
            )),
        if (showConfirmPassword && confirmPasswordController != null && confirmPasswordError != null && hideConfirmPassword != null) ...[
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Nhập lại mật khẩu", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 15)),
          ),
          const SizedBox(height: 8),
          Obx(() => TextField(
                controller: confirmPasswordController,
                obscureText: hideConfirmPassword!.value,
                decoration: InputDecoration(
                  hintText: "Nhập lại mật khẩu",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  errorText: confirmPasswordError!.value.isEmpty ? null : confirmPasswordError!.value,
                  suffixIcon: IconButton(
                    icon: Icon(hideConfirmPassword!.value ? Icons.visibility_off : Icons.visibility, color: Colors.grey[600]),
                    onPressed: () => hideConfirmPassword!.value = !hideConfirmPassword!.value,
                  ),
                ),
              )),
        ]
      ],
    );
  }
}
