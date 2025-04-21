import 'package:ebookingdoc/Controller/Home/DetailDoctor/detail_doctor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Detaildoctor extends StatelessWidget {
  Detaildoctor({super.key});

  final controller = Get.put(DetailDoctorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Mã định danh của bác sĩ: ${controller.id}"),
        ),
      ),
    );
  }
}
