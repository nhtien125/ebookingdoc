import 'package:ebookingdoc/Controller/Profile/Family/family_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Family extends StatelessWidget {
   Family({super.key});

  final controller = Get.put(FamilyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
      ),
    );
  }
}