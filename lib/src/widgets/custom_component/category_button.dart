import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryButton({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? AppColor.fourthMain
              : AppColor.main, // Nền xanh khi được chọn
          foregroundColor: isSelected
              ? AppColor.main
              : AppColor.fourthMain, // Chữ trắng khi được chọn
          elevation: isSelected ? 2 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColor.fourthMain), // Viền xanh
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
