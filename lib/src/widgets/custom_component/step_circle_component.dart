import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/controller/appointment_screen_controller.dart';
import 'package:flutter/material.dart';
class StepCircleComponent extends StatelessWidget {
  final int step;
  final IconData icon;
  final AppointmentScreenController controller;

  const StepCircleComponent({
    super.key,
    required this.step,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = controller.currentStep.value >= step;
    final isCompleted = controller.currentStep.value > step;

    return GestureDetector(
      onTap: () {
        if (step < controller.currentStep.value) {
          controller.goToStep(step);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? AppColor.main : AppColor.fourthMain,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColor.main,
            width: isCompleted ? 2 : 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColor.fourthMain,
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: Icon(
              icon,
              key: ValueKey('${isActive}_$step'),
              color: isActive ? AppColor.fourthMain : AppColor.main,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}