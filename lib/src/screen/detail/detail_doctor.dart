import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:ebookingdoc/src/widgets/controller/detail_doctor_controller.dart';
import 'package:ebookingdoc/src/widgets/custom_component/doctor_app_bar.dart';
import 'package:ebookingdoc/src/widgets/custom_component/doctor_bottom_action_bar.dart';
import 'package:ebookingdoc/src/widgets/custom_component/doctor_info_card.dart';
import 'package:ebookingdoc/src/widgets/detail/clinic_contact_section.dart';
import 'package:ebookingdoc/src/widgets/detail/doctor_about_section.dart';
import 'package:ebookingdoc/src/widgets/detail/doctor_specialization_section.dart';
import 'package:ebookingdoc/src/widgets/detail/hospital_address_section.dart';
import 'package:ebookingdoc/src/widgets/detail/reviews_section.dart';
import 'package:ebookingdoc/src/widgets/detail/schedule_section.dart';
import 'package:ebookingdoc/src/widgets/detail/vaccination_center_vaccines_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailDoctor extends StatelessWidget {
  DetailDoctor({super.key});
  final DetailDoctorController controller = Get.put(DetailDoctorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          DoctorAppBar(controller: controller),
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.entity.value == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final entity = controller.entity.value!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  DoctorInfoCard(entity: entity),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        DoctorAboutSection(entity: entity),
                        if (entity is Doctor) ...[
                          const SizedBox(height: 24),
                          DoctorSpecializationSection(doctor: entity),
                        ],
                        if (entity is Hospital) ...[
                          const SizedBox(height: 24),
                          HospitalAddressSection(hospital: entity),
                        ],
                        if (entity is Clinic) ...[
                          const SizedBox(height: 24),
                          ClinicContactSection(clinic: entity),
                        ],
                        if (entity is VaccinationCenter) ...[
                          const SizedBox(height: 24),
                          VaccinationCenterVaccinesSection(center: entity),
                        ],
                        const SizedBox(height: 24),
                        ScheduleSection(controller: controller),
                        const SizedBox(height: 24),
                        ReviewsSection(entity: entity),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: DoctorBottomActionBar(controller: controller),
    );
  }
}