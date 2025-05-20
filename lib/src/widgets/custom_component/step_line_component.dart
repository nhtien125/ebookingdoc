import 'package:ebookingdoc/src/widgets/controller/appointment_screen_controller.dart';
import 'package:flutter/material.dart';

class StepLineComponent extends StatelessWidget {
  final int step;
  final AppointmentScreenController controller;

  const StepLineComponent({
    super.key,
    required this.step,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = controller.currentStep.value > step;
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.blue.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}