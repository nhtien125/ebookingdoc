import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/data/model/AppointmentScreen_model.dart';
import 'package:ebookingdoc/src/widgets/controller/appointment_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'continue_button_component.dart';

class Step2Content extends StatelessWidget {
  final AppointmentScreenController controller;

  const Step2Content({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Chọn hồ sơ bệnh nhân cho lịch khám',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => controller.patients.isEmpty
                ? EmptyPatientList()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.patients.length,
                    itemBuilder: (context, index) {
                      final patient = controller.patients[index];
                      final isSelected = controller.selectedPatient.value?.id == patient.id;

                      return GestureDetector(
                        onTap: () => controller.selectPatient(patient),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColor.fourthMain : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? AppColor.fourthMain.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: AppColor.fourthMain.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          patient.gender == 'Nam' ? Icons.man : Icons.woman,
                                          color: AppColor.fourthMain,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            patient.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          InfoRow(icon: Icons.cake, text: 'Ngày sinh: ${patient.dob}'),
                                          const SizedBox(height: 4),
                                          InfoRow(
                                            icon: Icons.phone,
                                            text: patient.phone != null
                                                ? 'SĐT: ${patient.phone}'
                                                : 'Chưa có SĐT',
                                          ),
                                          const SizedBox(height: 4),
                                          InfoRow(
                                            icon: Icons.home,
                                            text: patient.address != null
                                                ? 'Địa chỉ: ${patient.address}'
                                                : 'Chưa có địa chỉ',
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(Icons.settings, size: 20, color: Colors.grey),
                                  onPressed: () {
                                    _showPatientOptionsBottomSheet(context, patient);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              OutlinedButton.icon(
                onPressed: () => Get.toNamed(Routes.personal),
                icon: const Icon(Icons.add),
                label: const Text('THÊM HỒ SƠ BỆNH NHÂN MỚI'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: BorderSide(color: AppColor.fourthMain),
                  foregroundColor: AppColor.fourthMain,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => ContinueButtonComponent(
                    text: 'TIẾP TỤC',
                    onPressed: controller.nextStep,
                    enabled: controller.selectedPatient.value != null,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  void _showPatientOptionsBottomSheet(BuildContext context, Patient patient) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Chỉnh sửa hồ sơ'),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.personal, arguments: {'patient': patient});
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Xóa hồ sơ'),
              onTap: () {
                Get.back();
                _showDeleteConfirmationDialog(patient);
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('HỦY'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Patient patient) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xóa hồ sơ'),
        content: Text('Bạn có chắc muốn xóa hồ sơ bệnh nhân "${patient.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('HỦY'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deletePatient(patient);
            },
            child: const Text('XÓA', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class EmptyPatientList extends StatelessWidget {
  const EmptyPatientList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có hồ sơ bệnh nhân nào',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(Routes.personal),
            icon: const Icon(Icons.add),
            label: const Text('THÊM HỒ SƠ BỆNH NHÂN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.fourthMain,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}