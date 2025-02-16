import 'package:ebookingdoc/Controller/Home/MyTest/my_test_controller.dart';
import 'package:ebookingdoc/Global/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTest extends StatelessWidget {
  MyTest({super.key});

  final controller = Get.put(MyTestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.subMain,
      appBar: AppBar(
        backgroundColor: AppColor.main,
        title: Obx(() => Text(controller.hehe.value)),
      ),
      body: Center(
        child: GestureDetector(
            onTap: () {
              controller.hehe.value = "Trang test";
            },
            child: Text("trang test")),
      ),
    );
  }
}
