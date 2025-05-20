import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/controller/excellent_doctor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final controller = Get.put(ExcellentDoctorController());

// ignore: camel_case_types
class buildDoctorCard extends StatelessWidget {
  const buildDoctorCard({super.key});

  @override
  Widget build(dynamic doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.viewDoctorDetails(doctor.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF3366FF).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        doctor.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[100],
                            child: Icon(Icons.person,
                                size: 36, color: Colors.grey[400]),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hàng đầu: chức danh và tên bác sĩ
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F0FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                doctor.title ?? 'BS',
                                style: const TextStyle(
                                  color: Color(0xFF3366FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                doctor.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1A2E55),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Chuyên khoa
                        Text(
                          doctor.specialty,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Kinh nghiệm
                        Text(
                          doctor.experience,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Đánh giá và trạng thái (giống card phòng khám)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColor.fourthMain.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${doctor.rating ?? 5} ★',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.fourthMain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Nút bấm - giống card phòng khám
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      onPressed: () => controller.viewDoctorDetails(doctor.id),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: AppColor.fourthMain),
                      ),
                      child: GestureDetector(
                        onTap: () => controller.viewDoctorDetails(doctor.id),
                        child: Text(
                          "Xem chi tiết",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.fourthMain,
                          ),
                        ),
                      )),
                  const SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: () {
                        controller.bookAppointment(doctor, 'doctor');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.fourthMain,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () => controller.viewAllDoctors(),
                        child: Text(
                          'Đặt lịch ngay',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.main,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
