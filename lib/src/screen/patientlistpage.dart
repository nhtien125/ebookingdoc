import 'package:ebookingdoc/src/widgets/controller/patient_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PatientListPage extends StatelessWidget {
  PatientListPage({super.key});
  final controller = Get.put(PatientListController());

  String _formatDate(String dob) {
    try {
      final date = DateTime.parse(dob);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return dob;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          "Danh sách bệnh nhân",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.patients.isEmpty) {
          return const Center(
            child: Text(
              "Chưa có bệnh nhân nào.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 15),
          itemCount: controller.patients.length,
          itemBuilder: (_, i) {
            final patient = controller.patients[i];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(patient.avatarUrl),
                ),
                title: Text(
                  patient.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.cake, size: 15, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(patient.dob),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 15, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          patient.phone,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 15, color: Colors.red),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            patient.mainDisease,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.blueAccent),
                  tooltip: "Xem chi tiết",
                  onPressed: () {
                    // Show chi tiết hoặc chuyển trang khác nếu cần
                    Get.snackbar("Thông tin", 
                      "${patient.name}\n"
                      "Ngày sinh: ${_formatDate(patient.dob)}\n"
                      "SĐT: ${patient.phone}\n"
                      "Bệnh chính: ${patient.mainDisease}",
                      backgroundColor: Colors.white,
                      colorText: Colors.black87,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
