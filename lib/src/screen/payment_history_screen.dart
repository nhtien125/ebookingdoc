import 'package:flutter/material.dart';
import 'package:ebookingdoc/src/data/model/payment_model.dart';
import 'package:ebookingdoc/src/widgets/controller/payment_history_controller.dart';
import 'package:get/get.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final PaymentHistoryController controller =
      Get.put(PaymentHistoryController(), permanent: false);

  @override
  void initState() {
    super.initState();
    controller.fetchPayemtFromApi(); // Luôn fetch lại khi vào màn
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lịch sử Thanh toán"),
          backgroundColor: Colors.blueAccent,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tiền mặt'),
              Tab(text: 'Chuyển khoản'),
              Tab(text: 'Đã hủy'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.payment.isEmpty) {
            return const Center(child: Text("Không có dữ liệu thanh toán."));
          }
          return TabBarView(
            children: [
              _buildPaymentList(controller.getPaymentByMethod(controller.payment, 'cash')),
              _buildPaymentList(controller.getPaymentByMethod(controller.payment, 'online')),
              _buildPaymentList(controller.getCancelledPayments(controller.payment)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPaymentList(List<Payment> payments) {
    if (payments.isEmpty) {
      return const Center(child: Text("Không có dữ liệu."));
    }
    return ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return _buildPaymentCard(payment);
      },
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    final Color statusColor = payment.status == 0
        ? Colors.green
        : payment.status == 2
            ? Colors.red
            : Colors.orange;

    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.15),
          child: Icon(
            payment.status == 2 ? Icons.cancel : Icons.check,
            color: statusColor,
            size: 30,
          ),
          radius: 30,
        ),
        title: Text(
          'Số tiền: ${payment.amount} VNĐ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Phương thức: ${controller.getPaymentMethodText(payment.paymentMethod)}',
              style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
            const SizedBox(height: 4),
            Text(
              'Trạng thái: ${controller.getStatusDescription(payment.status ?? 0)}',
              style: TextStyle(
                color: statusColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (payment.paymentTime != null) ...[
              const SizedBox(height: 4),
              Text(
                'Ngày thanh toán: ${payment.paymentTime?.toLocal()}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue),
        onTap: () {
          // Xử lý khi bấm vào từng item (nếu cần)
        },
      ),
    );
  }
}
