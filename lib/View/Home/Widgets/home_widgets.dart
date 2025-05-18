import 'package:ebookingdoc/Controller/Home/home_controller.dart';
import 'package:ebookingdoc/Global/app_color.dart';
import 'package:ebookingdoc/Global/app_text_style.dart';
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
                _buildCategoryButton('Tất cả', isSelected: true, onTap: () {}),
                _buildCategoryButton('Bác sĩ',
                    onTap: () => controller.viewAllDoctors()),
                _buildCategoryButton('Bệnh viện',
                    onTap: () => controller.viewAllHospitals()),
                _buildCategoryButton('Phòng khám',
                    onTap: () => controller.viewAllClinics()),
                _buildCategoryButton('Trung tâm tiêm chủng',
                    onTap: () => controller.viewAllVaccines()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
              _buildCategoryButton('Bác sĩ',
                  onTap: () => controller.viewAllDoctors()),
              _buildCategoryButton('Bệnh viện',
                  onTap: () => controller.viewAllHospitals()),
              _buildCategoryButton('Phòng khám',
                  onTap: () => controller.viewAllClinics()),
              _buildCategoryButton('Trung tâm tiêm chủng',
                  onTap: () => controller.viewAllVaccines()),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildCategoryButton(String title,
    {bool isSelected = false, void Function()? onTap}) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bác sĩ nổi bật',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => controller.viewAllDoctors(),
                  child: const Text(
                    'Xem thêm',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.featuredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = controller.featuredDoctors[index];
                return GestureDetector(
                  onTap: () => controller.viewDoctorDetails(doctor.id),
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage(doctor.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          doctor.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor.specialty,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class BuildRecommendedHospitals extends StatelessWidget {
  const BuildRecommendedHospitals({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bệnh viện đề xuất',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => controller.viewAllHospitals(),
                  child: const Text('Xem thêm',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 265, // Điều chỉnh chiều cao để cân đối hình ảnh và nội dung
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.recommendedHospitals.length,
              itemBuilder: (context, index) {
                final hospital = controller.recommendedHospitals[index];
                return GestureDetector(
                  onTap: () => controller.viewHospitalDetails(hospital.id),
                  child: Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.asset(
                            hospital.imageUrl,
                            width: double.infinity, // Hình ảnh phủ toàn bộ chiều ngang
                            height: 90, // Giảm chiều cao xuống 35% 
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14), // Tăng khoảng cách
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hospital.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      hospital.address,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColor.fourthMain.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${hospital.rating}★',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.fourthMain,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      controller.viewHospitalDetails(hospital.id),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.fourthMain,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10), // Tăng padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Đặt khám ngay',
                                    style: TextStyle(
                                      fontSize: 14, // Tăng kích thước chữ
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Dịch vụ toàn diện',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
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
              final service = controller.medicalServices[index];
              return GestureDetector(
                onTap: () => controller.selectService(service.id),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: service.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: service.icon,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          service.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Phòng khám đề xuất',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => controller.viewAllClinics(),
                  child: const Text('Xem thêm',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 265, // Điều chỉnh chiều cao để cân đối nội dung
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.nearestClinics.length,
              itemBuilder: (context, index) {
                final clinic = controller.nearestClinics[index];
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          clinic.imageUrl,
                          width: double.infinity, // Hình ảnh phủ toàn bộ chiều ngang
                          height: 90, // Giảm chiều cao xuống 35%
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clinic.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    clinic.address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Thêm phần đánh giá sao
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColor.fourthMain.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${clinic.rating}★', // Hiển thị số sao
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.fourthMain,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>
                                    controller.viewClinicDetails(clinic.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.fourthMain,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10), // Tăng padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Đặt khám',
                                  style: TextStyle(
                                    fontSize: 14, // Tăng kích thước chữ
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class BuildHealthArticles extends StatelessWidget {
  const BuildHealthArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sống khỏe mỗi ngày',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => controller.viewAllArticles(),
                  child: const Text('Xem thêm',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.healthArticles.length,
              itemBuilder: (context, index) {
                final article = controller.healthArticles[index];
                return GestureDetector(
                  onTap: () => controller.viewArticleDetails(article.id),
                  child: Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.asset(
                            article.imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColor.fourthMain.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      article.category,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColor.fourthMain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    article.publishDate,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lịch hẹn sắp tới',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => controller.viewAllAppointments(),
                  child: const Text('Tất cả',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
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
                    final appointment = controller.upcomingAppointments[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage(appointment.doctorImageUrl),
                          radius: 24,
                        ),
                        title: Text(
                          appointment.doctorName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(appointment.specialtyName),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  appointment.dateTime,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () =>
                              controller.viewAppointmentDetails(appointment.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.fourthMain,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(60, 36),
                          ),
                          child: const Text(
                            'Chi tiết',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
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
