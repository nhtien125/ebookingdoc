import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:ebookingdoc/src/widgets/custom_component/section_header.dart';
import 'package:ebookingdoc/src/widgets/custom_component/service_card.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';

final controller = Get.put(HomeController());

class BuildComprehensiveServices extends StatelessWidget {
  const BuildComprehensiveServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Dịch vụ toàn diện'),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: controller.medicalServices.length,
            itemBuilder: (context, index) {
              return ServiceCard(service: controller.medicalServices[index]);
            },
          ),
        ],
      ),
    );
  }
}