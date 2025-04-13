import 'package:get/get.dart';

class AppointmentController extends GetxController {
  // Observable variables
  var isLoading = false.obs; // Trạng thái đang tải
  var appointments = <Map<String, dynamic>>[].obs; // Danh sách lịch hẹn

  @override
  void onInit() {
    super.onInit();
    fetchAppointments(); // Gọi để tải danh sách lịch hẹn ban đầu
  }

  // Hàm tải dữ liệu lịch hẹn
  void fetchAppointments() async {
    isLoading.value = true;
    try {
      // Giả lập dữ liệu từ API hoặc database
      await Future.delayed(const Duration(seconds: 2)); // Mô phỏng thời gian tải
      appointments.value = [
        {
          'id': 1,
          'hospitalName': 'Phòng khám XYZ',
          'doctorName': 'Bác sĩ A',
          'department': 'Nội tổng quát',
          'date': '05/04/2025',
          'time': '10:00',
          'status': 'Đã xác nhận',
        },
        {
          'id': 2,
          'hospitalName': 'Phòng khám ABC',
          'doctorName': 'Bác sĩ B',
          'department': 'Da liễu',
          'date': '06/04/2025',
          'time': '14:30',
          'status': 'Đang chờ',
        },
      ];
    } catch (e) {
      print('Error fetching appointments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm hủy lịch hẹn
  void cancelAppointment(int id) {
    appointments.value = appointments.where((appointment) {
      if (appointment['id'] == id) {
        appointment['status'] = 'Đã hủy'; // Cập nhật trạng thái
      }
      return true;
    }).toList();
  }

  // Hàm đổi lịch hẹn
  void rescheduleAppointment(int id) {
    // Logic đổi lịch hẹn (giả lập)
    appointments.value = appointments.where((appointment) {
      if (appointment['id'] == id) {
        appointment['date'] = '10/04/2025'; // Cập nhật ngày mới
        appointment['time'] = '09:00'; // Cập nhật giờ mới
        appointment['status'] = 'Đã xác nhận';
      }
      return true;
    }).toList();
  }
}

