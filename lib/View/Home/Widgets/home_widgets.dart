import 'package:ebookingdoc/Controller/Home/home_controller.dart';
import 'package:ebookingdoc/Global/app_color.dart';
import 'package:ebookingdoc/Global/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


  final controller = Get.put(HomeController());
Widget _buildCategories() {
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
                _buildCategoryButton('Tất cả', isSelected: true, onTap: () {}),
                _buildCategoryButton('Bác sĩ', onTap: () => controller.viewAllDoctors()),
                _buildCategoryButton('Bệnh viện', onTap: () => controller.viewAllHospitals()),
                _buildCategoryButton('Phòng khám', onTap: () => controller.viewAllClinics()),
                _buildCategoryButton('Trung tâm tiêm chủng',  onTap: () => controller.viewAllVaccines()),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryButton(String title, {bool isSelected = false, void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColor.fourthMain : Colors.white,
          foregroundColor: isSelected ? Colors.white : AppColor.fourthMain,
          elevation: isSelected ? 2 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColor.fourthMain),
          ),
        ),
        child: Text(title),
      ),
    );
  }
