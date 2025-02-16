import 'package:ebookingdoc/Controller/Home/home_controller.dart';
import 'package:ebookingdoc/Global/app_color.dart';
import 'package:ebookingdoc/Route/app_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.subMain,
      appBar: AppBar(
        backgroundColor: AppColor.main,
        title: const Text('Home'),
        actions: [
          GestureDetector(
              onTap: () {
                Get.toNamed(Routes.myTest);
              },
              child: Icon(Icons.abc))
        ],
      ),
      body: Center(
        child: Text("Trang chủ"),
      ),
    );
  }
}
