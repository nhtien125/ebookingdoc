import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:ebookingdoc/src/widgets/custom_component/facility_card.dart';
import 'package:ebookingdoc/src/widgets/custom_component/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildRecommendedHospitals extends StatelessWidget {
  const BuildRecommendedHospitals({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Bệnh viện đề xuất',
            onViewMore: () => controller.viewAllHospitals(),
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.hospitals.isEmpty) {
              return const Center(child: Text('Không có dữ liệu'));
            }
            return SizedBox(
              height: 265,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.hospitals.length,
                itemBuilder: (context, index) {
                  final hospital = controller.hospitals[index];
                  return FacilityCard(
                    facility: hospital,
                    onTap: () {
                      Get.toNamed(
                        Routes.appointmentScreen,
                        arguments: {
                          'hospital': hospital.toJson(),
                          'selectedPlaceType': 'hospital',
                        },
                      );
                    },
                    buttonText: 'Đặt khám',
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
