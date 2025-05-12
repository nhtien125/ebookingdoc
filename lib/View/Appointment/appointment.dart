import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/Controller/Appointment/appointment_controller.dart';
import 'package:ebookingdoc/Global/app_color.dart';

class Appointment extends StatelessWidget {
  final controller = Get.put(AppointmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch hẹn của tôi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.fourthMain,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.appointments.isEmpty) {
              return const Center(
                child: Text(
                  'Bạn chưa có lịch hẹn nào',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            } else {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: controller.appointments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final appointment = controller.appointments.values.toList()[index];
                  return _buildAppointmentCard(appointment);
                },
              );
            }
          }),
          Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.showNewAppointmentDialog(context),
        backgroundColor: AppColor.fourthMain,
        label: const Text(
          'Đặt lịch',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
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
            const SizedBox(height: 8),
            _buildDetails(appointment),
            const SizedBox(height: 16),
            _buildActions(appointment['id']),
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
          child: Text(
            appointment['hospitalName'] ?? 'Phòng khám chưa xác định',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
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
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(Map<String, dynamic> appointment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bác sĩ: ${appointment['doctorName'] ?? 'Chưa xác định'}',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
        ),
        const SizedBox(height: 8),
        Text(
          'Khoa: ${appointment['department'] ?? 'Nội tổng quát'}',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
        ),
        const SizedBox(height: 8),
        Text(
          'Thời gian: ${appointment['date'] ?? '--/--/----'} - ${appointment['time'] ?? '--:--'}',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
        ),
      ],
    );
  }

  Widget _buildActions(int id) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => controller.cancelAppointment(id),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Hủy lịch',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () =>
                controller.rescheduleAppointment(id, '10/04/2025', '09:00'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.fourthMain,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Đổi lịch',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
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
}
