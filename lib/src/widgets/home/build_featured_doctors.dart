// lib/widgets/home/build_featured_doctors.dart
import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:ebookingdoc/src/widgets/custom_component/doctor_card.dart';
import 'package:ebookingdoc/src/widgets/custom_component/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final controller = Get.put(HomeController());

class BuildFeaturedDoctors extends StatelessWidget {
  const BuildFeaturedDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.main,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Bác sĩ nổi bật',
            onViewMore: () => controller.viewAllDoctors(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.featuredDoctors.length,
              itemBuilder: (context, index) {
                return DoctorCard(doctor: controller.featuredDoctors[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}