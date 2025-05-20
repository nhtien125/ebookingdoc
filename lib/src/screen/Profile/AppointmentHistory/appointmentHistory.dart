import 'package:ebookingdoc/src/widgets/controller/appointmentHistory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentHistory extends StatelessWidget {
   AppointmentHistory({super.key});

  final controller = Get.put(AppointmentHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow,
      ),
    );
  }
}
