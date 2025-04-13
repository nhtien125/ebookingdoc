import 'package:ebookingdoc/Controller/Appointment/appointment_controller.dart';
import 'package:ebookingdoc/Global/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Appointment extends StatelessWidget {
  Appointment({super.key});
  final controller = Get.put(AppointmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch hẹn của tôi' ),
        centerTitle: true,
        backgroundColor: AppColor.main ,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    } else if (controller.appointments.isEmpty) {
      return const Center(
        child: Text(
          'Bạn chưa có lịch hẹn nào',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: controller.appointments.length,
        itemBuilder: (context, index) {
          final appointment = controller.appointments[index];
          return AppointmentCard(
            appointment: appointment,
            onCancel: () => controller.cancelAppointment(appointment['id']),
            onReschedule: () =>
                controller.rescheduleAppointment(appointment['id']),
          );
        },
      );
    }
  }
}

class AppointmentCard extends StatelessWidget {
  final dynamic appointment;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;

  const AppointmentCard({
    required this.appointment,
    required this.onCancel,
    required this.onReschedule,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildDetails(),
            const SizedBox(height: 12),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          appointment['hospitalName'] ?? 'Phòng khám XYZ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(appointment['status']),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            appointment['status'] ?? 'Đang chờ',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
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

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hủy lịch', style: TextStyle(color: Colors.red)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onReschedule,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.fourthMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Đổi lịch',
              style: TextStyle(color: Colors.white),
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
      default:
        return Colors.orange; // Mặc định cho trạng thái chờ
    }
  }
}
