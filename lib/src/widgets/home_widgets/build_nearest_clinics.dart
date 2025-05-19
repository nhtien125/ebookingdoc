// lib/widgets/home/build_nearest_clinics.dart
import 'package:ebookingdoc/src/widgets/custom_component/facility_card.dart';
import 'package:ebookingdoc/src/widgets/custom_component/section_header.dart';
import 'package:ebookingdoc/src/widgets/home_widgets/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


final controller = Get.put(HomeController());

class BuildNearestClinics extends StatelessWidget {
  const BuildNearestClinics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Phòng khám đề xuất',
            onViewMore: () => controller.viewAllClinics(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 265,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.nearestClinics.length,
              itemBuilder: (context, index) {
                final clinic = controller.nearestClinics[index];
                return FacilityCard(
                  facility: clinic,
                  onTap: () => controller.viewClinicDetails(clinic.id),
                  buttonText: 'Đặt khám',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}