import 'package:ebookingdoc/src/widgets/controller/appointment_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'step3_components.dart';
import 'continue_button_component.dart';

class Step4Content extends StatelessWidget {
  final AppointmentScreenController controller;

  const Step4Content({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          const Text(
            'ĐẶT LỊCH THÀNH CÔNG',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mã đặt lịch: ${DateTime.now().millisecondsSinceEpoch}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ConfirmCard(
            title: 'Thông tin đặt lịch',
            icon: Icons.info,
            child: Obx(() {
              final patient = controller.selectedPatient.value;
              final hospital = controller.selectedDoctor.value;
              final service = controller.selectedService.value;

              return Column(
                children: [
                  if (patient != null) ConfirmItem(label: 'Bệnh nhân', value: patient.name),
                  if (hospital != null) ConfirmItem(label: 'Bệnh viện', value: hospital.name),
                  if (service != null) ConfirmItem(label: 'Dịch vụ', value: service.name),
                  if (controller.selectedDate.value != null)
                    ConfirmItem(
                      label: 'Ngày khám',
                      value: DateFormat('dd/MM/yyyy').format(controller.selectedDate.value!),
                    ),
                  if (controller.selectedTimeSlot.value != null)
                    ConfirmItem(label: 'Giờ khám', value: controller.selectedTimeSlot.value!),
                  const SizedBox(height: 12),
                  PriceItem(label: 'Tổng thanh toán', amount: service?.price ?? 0, isTotal: true),
                ],
              );
            }),
          ),
          const ConfirmCard(
            title: 'Hình thức thanh toán',
            icon: Icons.payment,
            child: Column(
              children: [
                PaymentMethod(
                  icon: Icons.credit_card,
                  title: 'Thanh toán online',
                  subtitle: 'Thẻ ATM/VISA/Mastercard',
                  isSelected: true,
                ),
                Divider(height: 24),
                PaymentMethod(
                  icon: Icons.money,
                  title: 'Thanh toán tại bệnh viện',
                  subtitle: 'Khi đến khám',
                ),
              ],
            ),
          ),
          ContinueButtonComponent(
            text: 'HOÀN TẤT',
            onPressed: () {
              controller.completePayment();
              Get.until((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;

  const PaymentMethod({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
      onTap: () {
      },
    );
  }
}