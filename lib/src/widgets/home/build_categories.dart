import 'package:ebookingdoc/src/Global/app_text_style.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:ebookingdoc/src/widgets/custom_component/category_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final controller = Get.put(HomeController());

class BuildCategories extends StatelessWidget {
  const BuildCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Danh mục',
              style: AppTextStyle.sectionTitle,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const CategoryButton(title: 'Tất cả', isSelected: true),
                CategoryButton(
                  title: 'Bác sĩ',
                  onTap: () => controller.viewAllDoctors(),
                ),
                CategoryButton(
                  title: 'Bệnh viện',
                  onTap: () => controller.viewAllHospitals(),
                ),
                CategoryButton(
                  title: 'Phòng khám',
                  onTap: () => controller.viewAllClinics(),
                ),
                CategoryButton(
                  title: 'Trung tâm tiêm chủng',
                  onTap: () => controller.viewAllVaccines(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}