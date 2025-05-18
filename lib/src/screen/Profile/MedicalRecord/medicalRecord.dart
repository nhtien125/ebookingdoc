import 'package:ebookingdoc/src/widgets/Profile/MedicalRecord/medical_record_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicalRecord extends StatelessWidget {
 MedicalRecord({super.key});

  final controller = Get.put(MedicalRecordController());

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Container(
        color: Colors.green,
      ),
    );
  }
}