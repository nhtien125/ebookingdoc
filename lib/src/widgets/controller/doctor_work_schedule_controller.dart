import 'package:get/get.dart';

class DoctorWorkSchedule {
  final String uuid;
  final String doctorId;
  final String clinicId;
  final String workDate;
  final String startTime;
  final String endTime;
  final String clinicName;

  DoctorWorkSchedule({
    required this.uuid,
    required this.doctorId,
    required this.clinicId,
    required this.workDate,
    required this.startTime,
    required this.endTime,
    required this.clinicName,
  });
}

class DoctorWorkScheduleController extends GetxController {
  final schedules = <DoctorWorkSchedule>[
    // ... như mẫu cũ ...
    DoctorWorkSchedule(
      uuid: 'sch0001uuid010101',
      doctorId: 'doc0001uuid00000000000000000001',
      clinicId: 'cli0001uuid00000000000000000001',
      workDate: '2025-06-23',
      startTime: '08:00:00',
      endTime: '12:00:00',
      clinicName: 'Phòng khám Y Khoa Việt Mỹ',
    ),
    DoctorWorkSchedule(
      uuid: 'sch0002uuid010102',
      doctorId: 'doc0001uuid00000000000000000001',
      clinicId: 'cli0001uuid00000000000000000001',
      workDate: '2025-06-23',
      startTime: '13:00:00',
      endTime: '17:00:00',
      clinicName: 'Phòng khám Y Khoa Việt Mỹ',
    ),
    DoctorWorkSchedule(
      uuid: 'sch0003uuid010201',
      doctorId: 'doc0001uuid00000000000000000001',
      clinicId: 'cli0001uuid00000000000000000001',
      workDate: '2025-06-24',
      startTime: '07:00:00',
      endTime: '10:00:00',
      clinicName: 'Phòng khám Y Khoa Việt Mỹ',
    ),
  ].obs;

  // --- Filter ngày ---
  final selectedDate = Rxn<DateTime>();

  List<DoctorWorkSchedule> get filteredSchedules {
    if (selectedDate.value == null) return schedules;
    final d = selectedDate.value!;
    final dStr =
        "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
    return schedules.where((s) => s.workDate == dStr).toList();
  }

  // Chọn ngày
  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void addSchedule(DoctorWorkSchedule schedule) {
    schedules.add(schedule);
  }

  // Sửa lịch theo uuid
  void updateSchedule(String uuid, DoctorWorkSchedule newSchedule) {
    final index = schedules.indexWhere((s) => s.uuid == uuid);
    if (index != -1) {
      schedules[index] = newSchedule;
      schedules.refresh();
    }
  }

  // Xóa lịch theo uuid
  void deleteSchedule(String uuid) {
    schedules.removeWhere((s) => s.uuid == uuid);
  }

  @override
  void onInit() {
    super.onInit();
    // Mặc định chọn hôm nay nếu có lịch, không thì không chọn gì
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    if (schedules.any((s) => s.workDate == todayStr)) {
      selectedDate.value = DateTime.now();
    } else if (schedules.isNotEmpty) {
      selectedDate.value = DateTime.parse(schedules[0].workDate);
    }
  }
}
