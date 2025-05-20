import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:flutter/material.dart';

class ContinueButtonComponent extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;

  const ContinueButtonComponent({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.fourthMain,
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.grey.shade500,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}