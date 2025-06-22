import 'package:ebookingdoc/src/widgets/controller/today_schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodaySchedulePage extends StatelessWidget {
  TodaySchedulePage({super.key});
  final controller = Get.put(TodayScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        title: const Text(
          'Lịch khám hôm nay',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.schedules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.event_busy, color: Colors.grey, size: 66),
                SizedBox(height: 12),
                Text('Không có lịch khám hôm nay.',
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(18),
          itemCount: controller.schedules.length,
          separatorBuilder: (_, __) => const SizedBox(height: 18),
          itemBuilder: (_, i) {
            final s = controller.schedules[i];
            return _ScheduleCard(schedule: s);
          },
        );
      }),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  const _ScheduleCard({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.07),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.green.shade400,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  schedule.hospital,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Text(
                    "Đã xác nhận",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "Mã lịch: ${schedule.scheduleId}",
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 5),
            // *** Tên bệnh nhân ***
            Text(
              "Bệnh nhân: ${schedule.patientName}",
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            // Info
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FA),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rowIconText(Icons.local_hospital, "Chuyên khoa: ${schedule.specialization}"),
                  const SizedBox(height: 4),
                  _rowIconText(Icons.access_time, "Thời gian: ${schedule.time}"),
                  const SizedBox(height: 4),
                  _rowIconText(Icons.note, "Ghi chú: ${schedule.note}"),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Button
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.blue.shade800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.info_outline),
                    label: const Text("Chi tiết", style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Get.snackbar(
                        "Chi tiết lịch khám",
                        "Bệnh nhân: ${schedule.patientName}\n"
                        "${schedule.specialization}\n${schedule.time}\n${schedule.note}");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowIconText(IconData icon, String text) => Row(
        children: [
          Icon(icon, color: Colors.blue.shade800, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      );
}
