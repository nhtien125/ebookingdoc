import 'package:ebookingdoc/src/data/model/schedule_model.dart';
import 'package:ebookingdoc/src/widgets/controller/doctor_work_schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

List<DateTime> get7NextDays() {
  final now = DateTime.now();
  final list = List.generate(7, (i) {
    final d = DateTime(now.year, now.month, now.day).add(Duration(days: i));
    return d;
  });
  return list;
}

class DoctorWorkSchedulePage extends StatelessWidget {
  DoctorWorkSchedulePage({super.key});
  final controller = Get.put(DoctorWorkScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        title: const Text(
          'Lịch làm việc của bác sĩ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
        ),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Obx(() {
            final weekDays = get7NextDays();
            final selected = controller.selectedDate.value;
            return Container(
              margin: const EdgeInsets.only(top: 12, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekDays.map((d) {
                  final isSelected = selected != null &&
                      d.year == selected.year &&
                      d.month == selected.month &&
                      d.day == selected.day;
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => controller.selectDate(d),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade700 : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat.E('vi').format(d), // CN, Th 2, ...
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${d.day}",
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          // Danh sách lịch làm việc ngày đã chọn
          Expanded(
            child: Obx(() {
              final filtered = controller.filteredSchedules;
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (filtered.isEmpty) {
                return const Center(
                  child: Text("Không có lịch làm việc.", style: TextStyle(color: Colors.grey)),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(18),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, i) {
                  final s = filtered[i];
                  return WorkScheduleCardV2(
                    schedule: s,
                    onEdit: () => _showEditScheduleDialog(context, s),
                    onDelete: () => controller.deleteSchedule(s.uuid),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddScheduleDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: "Thêm lịch làm việc",
      ),
    );
  }

  void _showAddScheduleDialog(BuildContext context) {
    final controller = Get.find<DoctorWorkScheduleController>();
    DateTime selectedDate = DateTime.now();
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text("Thêm lịch làm việc mới"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.blue),
                    title: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                    trailing: const Icon(Icons.edit_calendar),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.green),
                    title: Text(startTime == null ? "Chọn giờ bắt đầu" : startTime!.format(ctx)),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay(hour: 8, minute: 0),
                      );
                      if (picked != null) setState(() => startTime = picked);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.red),
                    title: Text(endTime == null ? "Chọn giờ kết thúc" : endTime!.format(ctx)),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay(hour: 17, minute: 0),
                      );
                      if (picked != null) setState(() => endTime = picked);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (startTime == null || endTime == null) return;
                    final workDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
                    final doctorId = controller.doctorId ?? "";
                    final newSchedule = Schedule(
                      uuid: '', // backend tự sinh
                      doctorId: doctorId,
                      workDate: workDateStr,
                      startTime: "${startTime?.hour.toString().padLeft(2, '0')}:${startTime?.minute.toString().padLeft(2, '0')}",
                      endTime: "${endTime?.hour.toString().padLeft(2, '0')}:${endTime?.minute.toString().padLeft(2, '0')}",
                    );
                    await controller.addSchedule(newSchedule);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("Lưu"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditScheduleDialog(BuildContext context, Schedule oldSchedule) {
    final controller = Get.find<DoctorWorkScheduleController>();
    DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(oldSchedule.workDate);
    TimeOfDay? startTime = oldSchedule.startTime != null
        ? TimeOfDay(
            hour: int.parse(oldSchedule.startTime!.split(':')[0]),
            minute: int.parse(oldSchedule.startTime!.split(':')[1]),
          )
        : null;
    TimeOfDay? endTime = oldSchedule.endTime != null
        ? TimeOfDay(
            hour: int.parse(oldSchedule.endTime!.split(':')[0]),
            minute: int.parse(oldSchedule.endTime!.split(':')[1]),
          )
        : null;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text("Sửa lịch làm việc"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.blue),
                    title: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.green),
                    title: Text(startTime == null ? "Chọn giờ bắt đầu" : startTime!.format(ctx)),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: ctx,
                        initialTime: startTime ?? TimeOfDay(hour: 8, minute: 0),
                      );
                      if (picked != null) setState(() => startTime = picked);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.red),
                    title: Text(endTime == null ? "Chọn giờ kết thúc" : endTime!.format(ctx)),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: ctx,
                        initialTime: endTime ?? TimeOfDay(hour: 17, minute: 0),
                      );
                      if (picked != null) setState(() => endTime = picked);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (startTime == null || endTime == null) return;
                    final workDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
                    final doctorId = controller.doctorId ?? "";
                    final newSchedule = Schedule(
                      uuid: oldSchedule.uuid,
                      doctorId: doctorId,
                      workDate: workDateStr,
                      startTime: "${startTime?.hour.toString().padLeft(2, '0')}:${startTime?.minute.toString().padLeft(2, '0')}",
                      endTime: "${endTime?.hour.toString().padLeft(2, '0')}:${endTime?.minute.toString().padLeft(2, '0')}",
                    );
                    await controller.updateSchedule(oldSchedule.uuid, newSchedule);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("Lưu"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class WorkScheduleCardV2 extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WorkScheduleCardV2({
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final workDate = schedule.workDate.length > 10
        ? schedule.workDate.substring(0, 10).split('-').reversed.join('/')
        : schedule.workDate;
    final start = schedule.startTime?.substring(0, 5) ?? "";
    final end = schedule.endTime?.substring(0, 5) ?? "";

    return Card(
      elevation: 6,
      shadowColor: Colors.blue.withOpacity(0.10),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  workDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, color: Colors.blue, size: 20),
                  tooltip: "Sửa lịch",
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  tooltip: "Xóa lịch",
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time_filled, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  "Từ $start đến $end",
                  style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
