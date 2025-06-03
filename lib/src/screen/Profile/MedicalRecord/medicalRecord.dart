import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/data/model/medica_record_model.dart';
import 'package:ebookingdoc/src/widgets/Profile/MedicalRecord/medical_record_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicalRecord extends StatelessWidget {
  MedicalRecord({super.key});

  final MedicalRecordController controller = Get.put(MedicalRecordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hồ Sơ Bệnh Án',
          style: TextStyle(color: AppColor.main),
        ),
        centerTitle: true,
        backgroundColor: AppColor.fourthMain,
        iconTheme: IconThemeData(color: AppColor.main),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColor.main),
            onPressed: controller.editRecord,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 24),
                _buildHealthInfoSection(),
                const SizedBox(height: 24),
                _buildMedicalHistorySection(),
                const SizedBox(height: 24),
                _buildAppointmentHistory(),
              ],
            )),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                controller.record.value.gender == 'Nam'
                    ? Icons.male
                    : Icons.female,
                size: 40,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.record.value.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ngày sinh: ${controller.record.value.formattedDob}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nhóm máu: ${controller.record.value.bloodType}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthInfoSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'THÔNG TIN SỨC KHỎE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow('Chiều cao', '${controller.record.value.height} cm'),
            _buildInfoRow('Cân nặng', '${controller.record.value.weight} kg'),
            _buildInfoRow(
                'BMI', controller.record.value.bmi.toStringAsFixed(1)),
            _buildInfoRow(
                'Dị ứng', controller.record.value.allergies ?? 'Không có'),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalHistorySection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TIỀN SỬ BỆNH',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow('Bệnh mãn tính',
                controller.record.value.chronicDiseases ?? 'Không có'),
            _buildInfoRow(
                'Phẫu thuật', controller.record.value.surgeries ?? 'Không có'),
            _buildInfoRow('Thuốc đang dùng',
                controller.record.value.currentMedications ?? 'Không có'),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentHistory() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'LỊCH SỬ KHÁM BỆNH',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(height: 24),
            if (controller.appointments.isEmpty)
              const Center(child: Text('Chưa có lịch sử khám bệnh')),
            ...controller.appointments
                .map((appointment) => _buildAppointmentItem(appointment))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentItem(MedicalAppointment appointment) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.medical_services, color: Colors.blue),
          title: Text(appointment.serviceName),
          subtitle: Text(
            '${appointment.formattedDate} - ${appointment.hospitalName}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => controller.viewAppointmentDetails(appointment),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade700),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
