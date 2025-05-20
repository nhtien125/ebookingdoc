import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/widgets/controller/appointment_screen_controller.dart';
import 'package:ebookingdoc/src/widgets/custom_component/header_component.dart';
import 'package:ebookingdoc/src/widgets/custom_component/step1_components.dart';
import 'package:ebookingdoc/src/widgets/custom_component/step2_components.dart';
import 'package:ebookingdoc/src/widgets/custom_component/step3_components.dart';
import 'package:ebookingdoc/src/widgets/custom_component/step4_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentScreen extends StatelessWidget {
  final AppointmentScreenController controller = Get.put(AppointmentScreenController());

  AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.main,
      body: Column(
        children: [
          // Header with stepper
          HeaderComponent(controller: controller),

          // Main content area
          Expanded(
            child: Obx(() {
              switch (controller.currentStep.value) {
                case 1:
                  return Step1Content(controller: controller);
                case 2:
                  return Step2Content(controller: controller);
                case 3:
                  return Step3Content(controller: controller);
                case 4:
                  return Step4Content(controller: controller);
                default:
                  return Step1Content(controller: controller);
              }
            }),
          ),
        ],
      ),
    );
  }
}