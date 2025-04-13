import 'package:ebookingdoc/Controller/Profile/personal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Personal extends StatelessWidget {
  Personal({super.key});

    final controller = Get.put(PersonalController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
      ),
    );
  }
}