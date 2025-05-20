import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:ebookingdoc/src/widgets/controller/detail_doctor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorBottomActionBar extends StatelessWidget {
  final DetailDoctorController controller;

  const DoctorBottomActionBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() {
        final isEnabled = controller.selectedTimeIndex.value != -1;
        final entity = controller.entity.value;

        return Row(
          children: [
            if (entity != null && entity.type == MedicalType.doctor) ...[
              _buildIconActionButton(
                icon: Icons.message,
                color: Colors.blue[100]!,
                iconColor: Colors.blue,
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              _buildIconActionButton(
                icon: Icons.call,
                color: Colors.green[100]!,
                iconColor: Colors.green,
                onPressed: () {},
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: isEnabled ? controller.bookAppointment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEnabled
                      ? controller.entity.value?.type.color ?? Colors.blue
                      : Colors.grey[300],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(entity?.type.icon ?? Icons.calendar_today, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      entity?.type == MedicalType.doctor
                          ? 'ĐẶT LỊCH KHÁM'
                          : 'ĐẶT HẸN NGAY',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildIconActionButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor),
        onPressed: onPressed,
      ),
    );
  }
}