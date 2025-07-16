import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/widgets/controller/excellent_doctor_controller.dart';

const _kCardBorderRadius = 12.0;
const _kButtonPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
const _kCardPadding = EdgeInsets.all(12);
const _kImageSize = 80.0;

class BuildDoctorCard extends StatelessWidget {
  final Doctor doctor;

  const BuildDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExcellentDoctorController>();
    final name = controller.doctorNames[doctor.userId ?? doctor.uuid] ?? 'Bác sĩ không xác định';
    final specialty = controller.doctorSpecialties[doctor.userId ?? doctor.uuid] ?? 'Chưa có chuyên khoa';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kCardBorderRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(_kCardBorderRadius),
        onTap: () {
          if (doctor.uuid == null || doctor.uuid!.isEmpty) {
            Get.snackbar('Lỗi', 'ID bác sĩ không hợp lệ', snackPosition: SnackPosition.BOTTOM);
            return;
          }
          controller.viewDoctorDetails(doctor.uuid!);
        },
        child: Padding(
          padding: _kCardPadding,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                                name,
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
                        Text(
                          specialty,
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Kinh nghiệm: ${doctor.experience ?? 0} năm',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildActionButtons(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return Container(
      width: _kImageSize,
      height: _kImageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3366FF).withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[100],
                  child: Icon(Icons.person, size: 36, color: Colors.grey[400]),
                ),
              )
            : Container(
                color: Colors.grey[100],
                child: Icon(Icons.person, size: 36, color: Colors.grey[400]),
              ),
      ),
    );
  }

  Widget _buildActionButtons(ExcellentDoctorController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            if (doctor.uuid == null || doctor.uuid!.isEmpty) {
              Get.snackbar('Lỗi', 'ID bác sĩ không hợp lệ', snackPosition: SnackPosition.BOTTOM);
              return;
            }
            controller.viewDoctorDetails(doctor.uuid!);
          },
          style: OutlinedButton.styleFrom(
            padding: _kButtonPadding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: BorderSide(color: AppColor.fourthMain),
          ),
          child: Text(
            'Xem chi tiết',
            style: TextStyle(fontSize: 14, color: AppColor.fourthMain),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            if (doctor.uuid == null || doctor.uuid!.isEmpty) {
              Get.snackbar('Lỗi', 'ID bác sĩ không hợp lệ', snackPosition: SnackPosition.BOTTOM);
              return;
            }
            controller.bookDoctorAppointment(doctor, 'doctor');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.fourthMain,
            padding: _kButtonPadding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            'Đặt lịch ngay',
            style: TextStyle(fontSize: 14, color: AppColor.main),
          ),
        ),
      ],
    );
  }
}