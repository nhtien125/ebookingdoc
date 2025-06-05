import 'package:ebookingdoc/src/widgets/controller/appointment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/Global/app_color.dart';

class Appointment extends StatelessWidget {
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
                _buildAppointmentList(['Đang chờ', 'Đã xác nhận']),
                _buildAppointmentList(['Đã hoàn thành', 'Đã hủy']),
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

  Widget _buildAppointmentList(List<String> statusFilter) {
    return Obx(() {
      final filteredAppointments = controller.appointments.values
          .where((appointment) => statusFilter.contains(appointment['status']))
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

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final status = appointment['status'] ?? 'Không xác định';
    final isCompleted = status == 'Đã hoàn thành';
    final isCancelled = status == 'Đã hủy';
    final isActive = status == 'Đang chờ' || status == 'Đã xác nhận';

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

  Widget _buildHeader(Map<String, dynamic> appointment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment['hospitalName'] ?? 'Phòng khám chưa xác định',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Mã lịch: #${appointment['id']?.toString().padLeft(6, '0') ?? '000000'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(appointment['status']),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            appointment['status'] ?? 'Không xác định',
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

  Widget _buildDetails(Map<String, dynamic> appointment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.person, 'Bác sĩ',
              appointment['doctorName'] ?? 'Chưa xác định'),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.local_hospital, 'Khoa',
              appointment['department'] ?? 'Nội tổng quát'),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.access_time, 'Thời gian',
              '${appointment['date'] ?? '--/--/----'} - ${appointment['time'] ?? '--:--'}'),
          if (appointment['notes'] != null) ...[
            const SizedBox(height: 8),
            _buildDetailRow(Icons.note, 'Ghi chú', appointment['notes']),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedInfo(Map<String, dynamic> appointment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Text(
                'Đã khám xong',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          if (appointment['completedDate'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Ngày khám: ${appointment['completedDate']}',
              style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
            ),
          ],
          if (appointment['diagnosis'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Chẩn đoán: ${appointment['diagnosis']}',
              style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(Map<String, dynamic> appointment) {
    final status = appointment['status'] ?? 'Không xác định';
    final isCompleted = status == 'Đã hoàn thành';
    final isCancelled = status == 'Đã hủy';
    final isActive = status == 'Đang chờ' || status == 'Đã xác nhận';

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () =>
                controller.viewAppointmentDetail(appointment['id']),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColor.fourthMain, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon:
                Icon(Icons.info_outline, size: 16, color: AppColor.fourthMain),
            label: Text(
              'Chi tiết',
              style: TextStyle(
                color: AppColor.fourthMain,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (isActive) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => controller.cancelAppointment(appointment['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.fourthMain,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.cancel_outlined,
                  size: 16, color: Colors.white),
              label: const Text(
                'Hủy lịch',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ] else if (isCompleted) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => controller.viewMedicalRecord(appointment['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.fourthMain,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.assignment, size: 16, color: Colors.white),
              label: const Text(
                'Hồ sơ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Đã xác nhận':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      case 'Đã hoàn thành':
        return Colors.blue;
      case 'Đang chờ':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getEmptyIcon(String status) {
    switch (status) {
      case 'Đang chờ':
      case 'Đã xác nhận':
        return Icons.event_available;
      case 'Đã hoàn thành':
      case 'Đã hủy':
        return Icons.history;
      default:
        return Icons.event_note;
    }
  }

  String _getEmptyMessage(String status) {
    switch (status) {
      case 'Đang chờ':
      case 'Đã xác nhận':
        return 'Bạn chưa có lịch hẹn nào sắp tới\nHãy đặt lịch khám bệnh mới!';
      case 'Đã hoàn thành':
      case 'Đã hủy':
        return 'Bạn chưa có lịch sử khám bệnh nào\nSau khi khám hoặc huỷ lịch, thông tin sẽ hiển thị tại đây';
      default:
        return 'Không có dữ liệu';
    }
  }
}
