import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppointmentController extends GetxController {
  var appointments = <int, Map<String, dynamic>>{}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  // Load danh sách lịch hẹn
  void loadAppointments() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      // Mock data với các trạng thái khác nhau
      appointments.value = {
        1: {
          'id': 1,
          'hospitalName': 'Bệnh viện Đại học Y Hà Nội',
          'doctorName': 'BS. Nguyễn Văn An',
          'department': 'Nội tim mạch',
          'date': '15/06/2025',
          'time': '09:00',
          'status': 'Đã xác nhận',
          'notes': 'Khám định kỳ huyết áp',
        },
        2: {
          'id': 2,
          'hospitalName': 'Phòng khám Đa khoa Medlatec',
          'doctorName': 'BS. Trần Thị Bình',
          'department': 'Da liễu',
          'date': '20/06/2025',
          'time': '14:30',
          'status': 'Đang chờ',
          'notes': 'Tái khám sau điều trị',
        },
        3: {
          'id': 3,
          'hospitalName': 'Bệnh viện Bach Mai',
          'doctorName': 'TS.BS Lê Văn Cường',
          'department': 'Nội tiêu hóa',
          'date': '25/05/2025',
          'time': '08:30',
          'status': 'Đã hoàn thành',
          'completedDate': '25/05/2025',
          'diagnosis': 'Viêm dạ dày mãn tính',
          'notes': 'Đã khám và kê đơn thuốc',
        },
        4: {
          'id': 4,
          'hospitalName': 'Phòng khám Đa khoa Thu Cúc',
          'doctorName': 'BS. Phạm Minh Đức',
          'department': 'Ngoại tổng quát',
          'date': '10/05/2025',
          'time': '16:00',
          'status': 'Đã hủy',
          'notes': 'Bệnh nhân hủy do có việc đột xuất',
          'cancelReason': 'Bận việc gia đình',
          'cancelDate': '08/05/2025',
        },
        5: {
          'id': 5,
          'hospitalName': 'Bệnh viện Việt Đức',
          'doctorName': 'PGS.TS Hoàng Văn Minh',
          'department': 'Ngoại thần kinh',
          'date': '20/04/2025',
          'time': '10:15',
          'status': 'Đã hoàn thành',
          'completedDate': '20/04/2025',
          'diagnosis': 'Thoát vị đĩa đệm L4-L5',
          'notes': 'Đã phẫu thuật thành công',
        },
      };
      isLoading.value = false;
    });
  }

  // Xem chi tiết lịch hẹn
  void viewAppointmentDetail(int appointmentId) {
    final appointment = appointments[appointmentId];
    if (appointment == null) return;

    Get.dialog(
      AlertDialog(
        title: Text(
            'Chi tiết lịch hẹn #${appointmentId.toString().padLeft(6, '0')}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Bệnh viện', appointment['hospitalName']),
              _buildDetailItem('Bác sĩ', appointment['doctorName']),
              _buildDetailItem('Khoa', appointment['department']),
              _buildDetailItem('Ngày khám', appointment['date']),
              _buildDetailItem('Giờ khám', appointment['time']),
              _buildDetailItem('Trạng thái', appointment['status']),
              if (appointment['notes'] != null)
                _buildDetailItem('Ghi chú', appointment['notes']),
              if (appointment['diagnosis'] != null)
                _buildDetailItem('Chẩn đoán', appointment['diagnosis']),
              if (appointment['cancelReason'] != null)
                _buildDetailItem('Lý do hủy', appointment['cancelReason']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // Hủy lịch hẹn
  void cancelAppointment(int appointmentId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận hủy lịch'),
        content: const Text('Bạn có chắc chắn muốn hủy lịch hẹn này không?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              // Cập nhật trạng thái thành đã hủy
              if (appointments.containsKey(appointmentId)) {
                appointments[appointmentId]!['status'] = 'Đã hủy';
                appointments[appointmentId]!['cancelDate'] =
                    DateTime.now().toString().substring(0, 10);
                appointments[appointmentId]!['cancelReason'] =
                    'Bệnh nhân hủy lịch';
                appointments.refresh();
              }
              Get.back();
              Get.snackbar(
                'Thành công',
                'Đã hủy lịch hẹn thành công',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Hủy lịch', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Xem hồ sơ bệnh án
  void viewMedicalRecord(int appointmentId) {
    final appointment = appointments[appointmentId];
    if (appointment == null || appointment['status'] != 'Đã hoàn thành') return;

    Get.dialog(
      AlertDialog(
        title: const Text('Hồ sơ bệnh án'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Ngày khám', appointment['completedDate']),
              _buildDetailItem('Bác sĩ khám', appointment['doctorName']),
              _buildDetailItem(
                  'Chẩn đoán', appointment['diagnosis'] ?? 'Chưa có'),
              const SizedBox(height: 12),
              const Text(
                'Đơn thuốc:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '1. Thuốc A - 2 viên/ngày\n'
                  '2. Thuốc B - 1 viên/ngày\n'
                  '3. Thuốc C - 3 lần/ngày',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Lời dặn của bác sĩ:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Uống thuốc đúng giờ, tái khám sau 2 tuần.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () {
              // In hoặc tải hồ sơ
              Get.snackbar(
                'Thông báo',
                'Chức năng tải hồ sơ đang được phát triển',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Tải về'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Chưa có thông tin',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
