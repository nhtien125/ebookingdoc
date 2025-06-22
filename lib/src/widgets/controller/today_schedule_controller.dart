import 'package:get/get.dart';

class TodayScheduleController extends GetxController {
  // Danh sách lịch khám (tất cả đều đã xác nhận, cùng khoa, cùng bệnh viện)
  final schedules = <Schedule>[
    Schedule(
      scheduleId: "#000101",
      patientName: "Nguyễn Văn A",
      hospital: "Bệnh viện Đại học Y Hà Nội",
      specialization: "Nội tim mạch",
      time: "15/06/2025 - 08:00",
      note: "Tái khám định kỳ",
    ),
    Schedule(
      scheduleId: "#000102",
      patientName: "Nguyễn Văn B",
      hospital: "Bệnh viện Đại học Y Hà Nội",
      specialization: "Nội tim mạch",
      time: "15/06/2025 - 09:30",
      note: "Khám tổng quát tim",
    ),
    Schedule(
      scheduleId: "#000103",
      patientName: "Nguyễn Văn C",
      hospital: "Bệnh viện Đại học Y Hà Nội",
      specialization: "Nội tim mạch",
      time: "15/06/2025 - 10:15",
      note: "Tư vấn điều trị cao huyết áp",
    ),
  ].obs;

  final isLoading = false.obs;

  Future<void> fetchData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    // Gọi API ở đây, rồi set schedules.value = ...
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
}

class Schedule {
  final String scheduleId;
  final String patientName;
  final String hospital;
  final String specialization;
  final String time;
  final String note;

  Schedule({
    required this.scheduleId,
    required this.patientName,
    required this.hospital,
    required this.specialization,
    required this.time,
    required this.note,
  });
}
