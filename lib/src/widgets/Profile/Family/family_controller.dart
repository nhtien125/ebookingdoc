import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FamilyController extends GetxController {
  var familyMembers = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    familyMembers.add('Lò Thị Tươi'); 
  }

  void addMember() {
    Get.toNamed(Routes.personal);
  }

  void confirmDeleteMember(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Xoá thành viên',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Bạn có chắc muốn xoá hay không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy bỏ'),
          ),
          ElevatedButton(
            onPressed: () {
              familyMembers.removeAt(index);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryDark, 
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}
