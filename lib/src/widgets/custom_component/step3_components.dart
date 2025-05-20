import 'package:ebookingdoc/src/widgets/controller/appointment_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'continue_button_component.dart';

class Step3Content extends StatelessWidget {
  final AppointmentScreenController controller;

  const Step3Content({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ConfirmCard(
            title: 'Thông tin bệnh nhân',
            icon: Icons.person,
            child: Obx(() {
              final patient = controller.selectedPatient.value;
              if (patient == null) return const Center(child: Text("Chưa chọn bệnh nhân"));
              return Column(
                children: [
                  ConfirmItem(label: 'Họ tên', value: patient.name),
                  ConfirmItem(label: 'SĐT', value: patient.phone ?? 'Chưa có'),
                  ConfirmItem(label: 'Ngày sinh', value: patient.dob),
                  ConfirmItem(label: 'Địa chỉ', value: patient.address ?? 'Chưa có'),
                ],
              );
            }),
          ),
          ConfirmCard(
            title: 'Thông tin bác sĩ',
            icon: Icons.local_hospital,
            child: Obx(() {
              final doctor = controller.selectedDoctor.value;
              if (doctor == null) return const Center(child: Text("Chưa chọn bác sĩ"));
              return Column(
                children: [
                  ConfirmItem(label: 'Bác sĩ', value: doctor.name),
                  ConfirmItem(label: 'Địa chỉ', value: doctor.address),
                  if (doctor.phone != null) ConfirmItem(label: 'Điện thoại', value: doctor.phone!),
                ],
              );
            }),
          ),
          ConfirmCard(
            title: 'Thông tin lịch hẹn',
            icon: Icons.calendar_today,
            child: Obx(() {
              return Column(
                children: [
                  if (controller.selectedDepartment.value != null)
                    ConfirmItem(label: 'Chuyên khoa', value: controller.selectedDepartment.value!.name),
                  if (controller.selectedService.value != null)
                    ConfirmItem(label: 'Dịch vụ', value: controller.selectedService.value!.name),
                  if (controller.selectedDate.value != null)
                    ConfirmItem(
                      label: 'Ngày khám',
                      value: DateFormat('dd/MM/yyyy').format(controller.selectedDate.value!),
                    ),
                  if (controller.selectedTimeSlot.value != null)
                    ConfirmItem(label: 'Giờ khám', value: controller.selectedTimeSlot.value!),
                ],
              );
            }),
          ),
          ConfirmCard(
            title: 'Tổng thanh toán',
            icon: Icons.payment,
            child: Obx(() {
              final service = controller.selectedService.value;
              if (service == null) return const Center(child: Text("Chưa chọn dịch vụ"));
              return Column(
                children: [
                  PriceItem(label: 'Phí khám bệnh', amount: service.price),
                  PriceItem(label: 'Phí dịch vụ', amount: 0),
                  const Divider(height: 24),
                  PriceItem(label: 'Tổng cộng', amount: service.price, isTotal: true),
                ],
              );
            }),
          ),
          ContinueButtonComponent(
            text: 'XÁC NHẬN ĐẶT LỊCH',
            onPressed: () => controller.confirmAppointment(),
          ),
        ],
      ),
    );
  }
}

class ConfirmCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const ConfirmCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class ConfirmItem extends StatelessWidget {
  final String label;
  final String value;

  const ConfirmItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class PriceItem extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const PriceItem({
    super.key,
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(0)} VNĐ',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue : null,
            ),
          ),
        ],
      ),
    );
  }
}