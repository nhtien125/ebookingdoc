import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';

final controller = Get.put(HomeController());

class AppointmentCard extends StatelessWidget {
  final dynamic appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundImage: AssetImage(appointment.doctorImageUrl),
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
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
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
          onPressed: () => controller.viewAppointmentDetails(appointment.id),
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
  }
}