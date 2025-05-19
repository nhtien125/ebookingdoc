import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:ebookingdoc/src/widgets/custom_component/appointment_card.dart';
import 'package:ebookingdoc/src/widgets/custom_component/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BuildUpcomingAppointments extends StatelessWidget {
  const BuildUpcomingAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Lịch hẹn sắp tới',
            onViewMore: () => controller.viewAllAppointments(),
            viewMoreText: 'Tất cả',
          ),
          const SizedBox(height: 12),
          Obx(() => controller.hasUpcomingAppointment.value
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.upcomingAppointments.length > 2
                      ? 2
                      : controller.upcomingAppointments.length,
                  itemBuilder: (context, index) {
                    return AppointmentCard(
                        appointment: controller.upcomingAppointments[index]);
                  },
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Bạn không có lịch hẹn sắp tới',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                )),
        ],
      ),
    );
  }
}