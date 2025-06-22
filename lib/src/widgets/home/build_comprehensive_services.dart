import 'dart:math';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:ebookingdoc/src/widgets/custom_component/section_header.dart';
import 'package:ebookingdoc/src/widgets/custom_component/service_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildComprehensiveServices extends StatelessWidget {
  const BuildComprehensiveServices({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Dịch vụ toàn diện'),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.medicalserviceModel.isEmpty) {
              return const Center(child: Text('Không có dịch vụ nào'));
            }
            // Random & lấy tối đa 6 dịch vụ
            final services = List.of(controller.medicalserviceModel)..shuffle(Random());
            final displayedServices = services.take(6).toList();

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.9,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: displayedServices.length,
              itemBuilder: (context, index) {
                return ServiceCard(service: displayedServices[index]);
              },
            );
          }),
        ],
      ),
    );
  }
}
