import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/constants/intl.dart';
import 'package:ebookingdoc/src/widgets/controller/doctor_work_schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DoctorWorkSchedulePage extends StatelessWidget {
  DoctorWorkSchedulePage({super.key});
  final controller = Get.put(DoctorWorkScheduleController());

  final clinicList = [
    "Phòng khám Y Khoa Việt Mỹ",
    "Phòng khám Bệnh viện Đại học Y Hà Nội",
    "Phòng khám Đa khoa Quốc tế"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        title: const Text(
          'Lịch làm việc của bác sĩ',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
        ),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showScheduleForm(context, controller, clinicList),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Thêm lịch", style: TextStyle(color: Colors.white)),
        backgroundColor:  AppColor.fourthMain,
      ),
      body: Column(
        children: [
          // --- Picker chọn ngày ---
          Obx(() {
            final today = DateTime.now();
            final weekDays = getWeekDays(today);
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.shade700
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            weekdayShort(d),
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.blueGrey,
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
          // --- Danh sách lịch làm việc ngày đã chọn ---
          Expanded(
            child: Obx(() {
              final filtered = controller.filteredSchedules;
              if (filtered.isEmpty) {
                return const Center(
                  child: Text("Không có lịch làm việc ngày này.",
                      style: TextStyle(color: Colors.grey)),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(18),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, i) {
                  final s = filtered[i];
                  return _WorkScheduleCard(
                    schedule: s,
                    onEdit: () => _showScheduleForm(
                        context, controller, clinicList,
                        schedule: s),
                    onDelete: () => controller.deleteSchedule(s.uuid),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Form tạo/sửa lịch làm việc
  void _showScheduleForm(BuildContext context,
      DoctorWorkScheduleController controller, List<String> clinics,
      {DoctorWorkSchedule? schedule}) {
    final formKey = GlobalKey<FormState>();
    final clinicCtrl =
        TextEditingController(text: schedule?.clinicName ?? clinics.first);
    final dateCtrl = TextEditingController(
        text: schedule?.workDate ??
            DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final startCtrl =
        TextEditingController(text: schedule?.startTime ?? "08:00:00");
    final endCtrl =
        TextEditingController(text: schedule?.endTime ?? "12:00:00");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title:
            Text(schedule == null ? "Thêm lịch làm việc" : "Sửa lịch làm việc"),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 350,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: clinicCtrl.text,
                    items: clinics
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    decoration: const InputDecoration(labelText: "Phòng khám"),
                    onChanged: (v) => clinicCtrl.text = v ?? clinics.first,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: dateCtrl,
                    decoration: const InputDecoration(
                      labelText: "Ngày làm việc",
                      prefixIcon: Icon(Icons.date_range),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.tryParse(dateCtrl.text) ?? DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        dateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
                      }
                    },
                    validator: (v) =>
                        v == null || v.isEmpty ? "Chọn ngày!" : null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: startCtrl,
                          decoration: const InputDecoration(
                              labelText: "Giờ bắt đầu (hh:mm)"),
                          readOnly: true,
                          onTap: () async {
                            final t = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: 8, minute: 0),
                            );
                            if (t != null) {
                              startCtrl.text =
                                  "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00";
                            }
                          },
                          validator: (v) =>
                              v == null || v.isEmpty ? "Chọn giờ!" : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: endCtrl,
                          decoration: const InputDecoration(
                              labelText: "Giờ kết thúc (hh:mm)"),
                          readOnly: true,
                          onTap: () async {
                            final t = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: 12, minute: 0),
                            );
                            if (t != null) {
                              endCtrl.text =
                                  "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00";
                            }
                          },
                          validator: (v) =>
                              v == null || v.isEmpty ? "Chọn giờ!" : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Hủy"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text(schedule == null ? "Thêm" : "Lưu"),
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final newSchedule = DoctorWorkSchedule(
                uuid: schedule?.uuid ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                doctorId: 'doc0001uuid00000000000000000001',
                clinicId: 'cli0001uuid00000000000000000001',
                workDate: dateCtrl.text,
                startTime: startCtrl.text,
                endTime: endCtrl.text,
                clinicName: clinicCtrl.text,
              );
              if (schedule == null) {
                controller.addSchedule(newSchedule);
              } else {
                controller.updateSchedule(schedule.uuid, newSchedule);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// Card hiển thị từng ca làm việc
class _WorkScheduleCard extends StatelessWidget {
  final DoctorWorkSchedule schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _WorkScheduleCard({
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.blue.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schedule.clinicName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.black54),
                const SizedBox(width: 7),
                Text(
                  "Từ ${schedule.startTime.substring(0, 5)} đến ${schedule.endTime.substring(0, 5)}",
                  style: const TextStyle(fontSize: 15),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  tooltip: "Sửa lịch",
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.red, size: 20),
                  tooltip: "Xóa lịch",
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Xác nhận",
                      middleText: "Bạn có chắc chắn muốn xóa lịch này?",
                      confirm: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          onDelete();
                          Get.back();
                        },
                        child: const Text("Xóa",
                            style: TextStyle(color: Colors.white)),
                      ),
                      cancel: TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Hủy")),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
