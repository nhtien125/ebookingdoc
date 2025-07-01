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
          backgroundColor: isSelected ? AppColor.fourthMain : AppColor.fivethMain,
          foregroundColor: isSelected ? AppColor.main : AppColor.text1,
          elevation: isSelected ? 2 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Đảm bảo padding đủ
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: isSelected ? AppColor.fourthMain : Colors.transparent),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColor.main : AppColor.text1,
            fontSize: 14, // Đảm bảo kích thước chữ không bị lỗi
          ),
        ),
      ),
    );
  }
}