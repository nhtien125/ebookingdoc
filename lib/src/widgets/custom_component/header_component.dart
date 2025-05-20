import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/controller/appointment_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'step_circle_component.dart';
import 'step_line_component.dart';

class HeaderComponent extends StatelessWidget {
  final AppointmentScreenController controller;

  const HeaderComponent({super.key, required this.controller});

  String getStepTitle(int step) {
    switch (step) {
      case 1:
        return 'Chọn thông tin khám';
      case 2:
        return 'Chọn hồ sơ';
      case 3:
        return 'Xác nhận thông tin khám';
      case 4:
        return 'Thông tin thanh toán';
      default:
        return 'Đặt lịch khám bệnh';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(Get.context!).padding.top),
      color: AppColor.fourthMain,
      child: Column(
        children: [
          // Title with back button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.currentStep.value > 1) {
                      controller.previousStep();
                    } else {
                      Get.back();
                    }
                  },
                  child: Icon(Icons.arrow_back, color: AppColor.main, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.2, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutQuart,
                            )),
                            child: child,
                          ),
                        ),
                        child: Text(
                          getStepTitle(controller.currentStep.value),
                          key: ValueKey(controller.currentStep.value),
                          style: TextStyle(
                            color: AppColor.main,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),

          // Interactive Stepper
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Obx(() => Row(
                  children: [
                    StepCircleComponent(
                      step: 1,
                      icon: Icons.local_hospital,
                      controller: controller,
                    ),
                    StepLineComponent(step: 1, controller: controller),
                    StepCircleComponent(
                      step: 2,
                      icon: Icons.person,
                      controller: controller,
                    ),
                    StepLineComponent(step: 2, controller: controller),
                    StepCircleComponent(
                      step: 3,
                      icon: Icons.check_circle,
                      controller: controller,
                    ),
                    StepLineComponent(step: 3, controller: controller),
                    StepCircleComponent(
                      step: 4,
                      icon: Icons.payment,
                      controller: controller,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}