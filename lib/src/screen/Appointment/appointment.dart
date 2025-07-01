import 'package:ebookingdoc/src/data/model/specialization_model.dart';
import 'package:ebookingdoc/src/widgets/controller/appointment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/data/model/appointment_model.dart';

class AppointmentPage extends StatelessWidget {
  final controller = Get.put(AppointmentController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Lịch hẹn khám bệnh',
            style: TextStyle(
              color: AppColor.main,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColor.fourthMain,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Sắp tới'),
              Tab(text: 'Lịch sử'),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                _buildAppointmentList([1, 2]), // Pending, Confirmed
                _buildAppointmentList([3, 4]), // Rejected, Cancelled
              ],
            ),
            Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  // Build appointment list based on status filter
  Widget _buildAppointmentList(List<int> statusFilter) {
    return Obx(() {
      final filteredAppointments = controller.appointments
          .where((appointment) =>
              statusFilter.contains(appointment.status.value.index + 1))
          .toList();

      if (filteredAppointments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getEmptyIcon(statusFilter.first),
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                _getEmptyMessage(statusFilter.first),
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: filteredAppointments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final appointment = filteredAppointments[index];
          return _buildAppointmentCard(appointment);
        },
      );
    });
  }

  // Get icon for empty state
  IconData _getEmptyIcon(int status) {
    switch (status) {
      case 1:
      case 2:
        return Icons.event_available;
      case 3:
      case 4:
        return Icons.history;
      default:
        return Icons.event_note;
    }
  }

  // Get message for empty state
  String _getEmptyMessage(int status) {
    switch (status) {
      case 1:
      case 2:
        return 'Bạn chưa có lịch hẹn nào sắp tới\nHãy đặt lịch khám bệnh mới!';
      case 3:
      case 4:
        return 'Bạn chưa có lịch sử khám bệnh nào\nSau khi khám hoặc huỷ lịch, thông tin sẽ hiển thị tại đây';
      default:
        return 'Không có dữ liệu';
    }
  }

  // Build appointment card
  Widget _buildAppointmentCard(Appointment appointment) {
    final status = appointment.status.value.index + 1;
    final isCompleted = status == 3;
    final isCancelled = status == 4;
    final isActive = status == 1 || status == 2;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(appointment),
            const SizedBox(height: 12),
            _buildDetails(appointment),
            if (isCompleted) ...[
              const SizedBox(height: 12),
              _buildCompletedInfo(appointment),
            ],
            const SizedBox(height: 16),
            _buildActions(appointment),
          ],
        ),
      ),
    );
  }

  // Build header with pre-loaded hospital/clinic/vaccination center name
  Widget _buildHeader(Appointment appointment) {
    String placeName = appointment.hospitalName ??
        appointment.clinicName ??
        appointment.vaccinationCenterName ??
        'Chưa có thông tin';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                placeName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(appointment.status.value),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _getStatusText(appointment.status.value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Get status text
  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Đang chờ';
      case AppointmentStatus.confirmed:
        return 'Đã xác nhận';
      case AppointmentStatus.rejected:
        return 'Đã từ chối';
      case AppointmentStatus.cancelled:
        return 'Đã hủy';
      default:
        return 'Chưa xác định';
    }
  }

  // Get status color
  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.rejected:
        return Colors.red;
      case AppointmentStatus.cancelled:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Build details section with pre-loaded doctor name and specialization
  Widget _buildDetails(Appointment appointment) {
    // Lấy ngày hiện tại làm mặc định nếu không có
    DateTime now = DateTime.now();
    String defaultDay =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Tách và định dạng dateTime một cách linh hoạt
    String? date = appointment.dateTime;
    String? dayPart = defaultDay; // Mặc định là ngày hiện tại
    String? timePart = 'Chưa xác định giờ';

    if (date != null) {
      // Kiểm tra nếu có ngày và giờ (ví dụ: "2025-07-01 8:30" hoặc "2025-07-01 8h30")
      if (date.contains(' ')) {
        final parts = date.split(' ');
        dayPart = parts[0]; // Ví dụ: "2025-07-01"
        String? timeRaw = parts[1]; // Ví dụ: "8:30" hoặc "8h30"
        if (timeRaw != null) {
          timePart = _formatTime(timeRaw); // Định dạng giờ
        }
      } else {
        // Nếu chỉ có giờ (ví dụ: "8:30" hoặc "8h30")
        timePart = _formatTime(date);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị ngày khám
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              'Ngày khám: $dayPart',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Hiển thị giờ khám
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              'Giờ khám: $timePart',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Hiển thị chuyên khoa
        Row(
          children: [
            Icon(Icons.medical_services, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              'Chuyên khoa: ${appointment.specializationName ?? 'Chưa xác định chuyên khoa'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Hiển thị tên bác sĩ
        Row(
          children: [
            Icon(Icons.person, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              'Bác sĩ: ${appointment.doctorName ?? 'Chưa xác định bác sĩ'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(String timeRaw) {
    String timePart = 'Chưa xác định giờ';

    timeRaw = timeRaw.replaceAll('h', ':');
    if (timeRaw.contains(':')) {
      final timeComponents = timeRaw.split(':');
      int hour = int.tryParse(timeComponents[0]) ?? 0;
      int minute = int.tryParse(timeComponents[1]) ?? 0;
      if (hour >= 0 && minute >= 0 && minute < 60) {
        String period = hour >= 12 ? 'PM' : 'AM';
        hour = hour > 12 ? hour - 12 : hour;
        hour = hour == 0 ? 12 : hour; // Đảm bảo 0h là 12AM
        timePart = '$hour:${minute.toString().padLeft(2, '0')} $period';
      }
    }
    return timePart;
  }

  // Build completed info
  Widget _buildCompletedInfo(Appointment appointment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 8),
          Text(
            'Đã hoàn thành khám bệnh',
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Build action buttons
  Widget _buildActions(Appointment appointment) {
    final status = appointment.status.value.index + 1;
    final canCancel = status == 1 || status == 2; // Pending or Confirmed
    final canView = true;

    return Row(
      children: [
        if (canView) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                final index = controller.appointments.indexOf(appointment);
                controller.viewAppointmentDetail(index);
              },
              icon: const Icon(Icons.visibility, size: 16),
              label: const Text('Xem chi tiết'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: BorderSide(color: Colors.blue.shade300),
                foregroundColor: Colors.blue.shade700,
              ),
            ),
          ),
        ],
        if (canCancel) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                final index = controller.appointments.indexOf(appointment);
                controller.cancelAppointment(index);
              },
              icon: const Icon(Icons.cancel, size: 16),
              label: const Text('Hủy lịch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
