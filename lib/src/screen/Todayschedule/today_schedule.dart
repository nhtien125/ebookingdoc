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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final schedules = controller.todaySchedules;
        if (schedules.isEmpty) {
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
          itemCount: schedules.length,
          separatorBuilder: (_, __) => const SizedBox(height: 18),
          itemBuilder: (_, i) => _ScheduleCard(schedule: schedules[i]),
        );
      }),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final TodayScheduleItemVM schedule;
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
            // Header: Tên địa điểm & trạng thái
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    schedule.location,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Colors.blue.shade800, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        schedule.date,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Icon(Icons.access_time,
                          color: Colors.blue.shade800, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        schedule.timeRange,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _rowIconText(Icons.local_hospital,
                      "Chuyên khoa: ${schedule.specialization.isNotEmpty ? schedule.specialization : 'Không rõ'}"),
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
                    label: const Text("Chi tiết",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        isScrollControlled: true,
                        builder: (_) => Padding(
                          padding: EdgeInsets.only(
                            left: 18,
                            right: 18,
                            top: 18,
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 18,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              Text(
                                "Chi tiết lịch khám",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _detailRow("Bệnh nhân:", schedule.patientName),
                              _detailRow(
                                  "Chuyên khoa:",
                                  schedule.specialization.isNotEmpty
                                      ? schedule.specialization
                                      : 'Không rõ'),
                              _detailRow("Địa điểm:", schedule.location),
                              _detailRow("Ngày khám:", schedule.date),
                              _detailRow("Thời gian:", schedule.timeRange),
                              _detailRow("Ghi chú:", schedule.note),
                              const SizedBox(height: 18),
                              Center(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade800,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 12),
                                  ),
                                  icon: const Icon(Icons.check,
                                      color: Colors.white),
                                  label: const Text('Đóng',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () => Navigator.of(context).pop(),
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

  Widget _detailRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(color: Colors.black87),
                softWrap: true,
              ),
            ),
          ],
        ),
      );
}
