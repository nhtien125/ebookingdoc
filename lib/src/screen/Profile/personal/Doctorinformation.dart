import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/controller/Doctorinformation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Doctorinformation extends StatelessWidget {
  Doctorinformation({super.key});
  final controller = Get.put(DoctorinformationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.fourthMain,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Thông tin bác sĩ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadDoctorFromAPI(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Status Card
                _buildStatusCard(controller),
                const SizedBox(height: 16),

                // Chuyên ngành
                _buildSpecializationDropdown(controller),
                const SizedBox(height: 16),


                // Số giấy phép hành nghề
                TextFormField(
                  controller: controller.licenseController,
                  decoration: const InputDecoration(
                    labelText: 'Số giấy phép hành nghề',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.assignment),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Nhập giấy phép' : null,
                ),
                const SizedBox(height: 16),

                // Kinh nghiệm
                TextFormField(
                  controller: controller.experienceController,
                  decoration: const InputDecoration(
                    labelText: 'Kinh nghiệm (năm)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Nhập số năm kinh nghiệm';
                    if (int.tryParse(value) == null) return 'Nhập số hợp lệ';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Giới thiệu bản thân
                TextFormField(
                  controller: controller.introduceController,
                  decoration: InputDecoration(
                    labelText: 'Giới thiệu bản thân',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: null,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 24),

                // Nút lưu thông tin
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.fourthMain,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.saveProfile,
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'LƯU THÔNG TIN',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(DoctorinformationController controller) {
    return Obx(() => Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  controller.getStatusColor().withOpacity(0.1),
                  controller.getStatusColor().withOpacity(0.05),
                ],
              ),
            ),
            child: Row(
              children: [
                Icon(
                  controller.getStatusIcon(),
                  color: controller.getStatusColor(),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trạng thái hồ sơ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.getStatusText(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: controller.getStatusColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  

  Widget _buildSpecializationDropdown(DoctorinformationController controller) {
    return Obx(() => DropdownButtonFormField<String>(
          value: controller.specializationId.value.isEmpty
              ? null
              : controller.specializationId.value,
          decoration: const InputDecoration(
            labelText: 'Chuyên ngành',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.medical_services),
          ),
          items: controller.isLoadingSpecializations.value
              ? [const DropdownMenuItem(value: null, child: Text('Đang tải...'))]
              : controller.specializations
                  .map((e) => DropdownMenuItem(
                        value: e.uuid,
                        child: Text(e.name ?? 'Không có tên'),
                      ))
                  .toList(),
          onChanged: controller.isLoadingSpecializations.value
              ? null
              : (value) {
                  if (value != null) controller.specializationId.value = value;
                },
          validator: (value) =>
              value == null || value.isEmpty ? 'Chọn chuyên ngành' : null,
        ));
  }

  Widget _buildHospitalDropdown(DoctorinformationController controller) {
    return Obx(() => DropdownButtonFormField<String>(
          value: controller.hospitalId.value.isEmpty
              ? null
              : controller.hospitalId.value,
          decoration: const InputDecoration(
            labelText: 'Bệnh viện',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.local_hospital),
          ),
          items: controller.isLoadingHospitals.value
              ? [const DropdownMenuItem(value: null, child: Text('Đang tải...'))]
              : controller.hospitals
                  .map((e) => DropdownMenuItem(
                        value: e.uuid,
                        child: Text(e.name ?? 'Không có tên'),
                      ))
                  .toList(),
          onChanged: controller.isLoadingHospitals.value
              ? null
              : (value) {
                  if (value != null) {
                    controller.hospitalId.value = value;
                    controller.clinicId.value = '';
                  }
                },
          validator: (value) =>
              controller.doctorType.value == 1 && (value == null || value.isEmpty)
                  ? 'Chọn bệnh viện'
                  : null,
        ));
  }

  Widget _buildClinicDropdown(DoctorinformationController controller) {
    return Obx(() => DropdownButtonFormField<String>(
          value: controller.clinicId.value.isEmpty
              ? null
              : controller.clinicId.value,
          decoration: const InputDecoration(
            labelText: 'Phòng khám',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business),
          ),
          items: controller.isLoadingClinics.value
              ? [const DropdownMenuItem(value: null, child: Text('Đang tải...'))]
              : controller.clinics
                  .map((e) => DropdownMenuItem(
                        value: e.uuid,
                        child: Text(e.name ?? 'Không có tên'),
                      ))
                  .toList(),
          onChanged: controller.isLoadingClinics.value
              ? null
              : (value) {
                  if (value != null) {
                    controller.clinicId.value = value;
                    controller.hospitalId.value = '';
                  }
                },
          validator: (value) =>
              controller.doctorType.value == 2 && (value == null || value.isEmpty)
                  ? 'Chọn phòng khám'
                  : null,
        ));
  }
}