import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:ebookingdoc/src/widgets/custom_component/facility_card.dart';
import 'package:ebookingdoc/src/widgets/custom_component/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildNearestClinics extends StatelessWidget {
  const BuildNearestClinics({super.key});

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
            title: 'Phòng khám đề xuất',
            onViewMore: () => controller.viewAllClinics(),
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.clinics.isEmpty) {
              return const Center(child: Text('Không có dữ liệu'));
            }
            return SizedBox(
              height: 265,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.clinics.length,
                itemBuilder: (context, index) {
                  final clinic = controller.clinics[index];
                  return FacilityCard(
                    facility: clinic,
                    onTap: () {
                      Get.toNamed(
                        Routes.appointmentScreen,
                        arguments: {
                          'clinic': clinic.toJson(),
                          'selectedPlaceType': 'clinic',
                          'clinicId': clinic.uuid,
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
