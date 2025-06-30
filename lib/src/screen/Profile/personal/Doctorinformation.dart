import 'dart:io';
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
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Ảnh bác sĩ
              Obx(() {
                Widget avatarWidget;
                if (controller.localImage.value != null) {
                  avatarWidget = CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(controller.localImage.value!),
                  );
                } else if (controller.image.value.isNotEmpty) {
                  avatarWidget = CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(controller.image.value),
                  );
                } else {
                  avatarWidget = const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  );
                }
                return GestureDetector(
                  onTap: controller.pickImage,
                  child: avatarWidget,
                );
              }),
              const SizedBox(height: 16),

              // Loại bác sĩ
              _buildDoctorTypeDropdown(controller),

              const SizedBox(height: 16),

              // Chuyên ngành
              _buildSpecializationDropdown(controller),

              const SizedBox(height: 16),

              // Bệnh viện (chỉ hiện với loại "Chính quy")
              Obx(() => controller.doctorType.value == 1
                  ? _buildHospitalDropdown(controller)
                  : const SizedBox()),

              // Phòng khám (chỉ hiện với loại "Cộng tác viên")
              Obx(() => controller.doctorType.value == 2
                  ? _buildClinicDropdown(controller)
                  : const SizedBox()),

              const SizedBox(height: 16),

              // Số giấy phép hành nghề
              TextFormField(
                controller: controller.licenseController,
                decoration: const InputDecoration(
                  labelText: 'Số giấy phép hành nghề',
                  border: OutlineInputBorder(),
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
                        backgroundColor: AppColor.fourthMain, // Nền nút màu xanh
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              if (controller.formKey.currentState!.validate()) {
                                // Gọi hàm saveProfile trong controller
                                // controller.saveProfile();
                              }
                            },
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'LƯU THÔNG TIN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Chữ màu trắng
                              ),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorTypeDropdown(DoctorinformationController controller) {
    return Obx(() => DropdownButtonFormField<int>(
          value: controller.doctorType.value,
          decoration: const InputDecoration(
            labelText: 'Loại bác sĩ',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 1, child: Text('Chính quy')),
            DropdownMenuItem(value: 2, child: Text('Cộng tác viên')),
          ],
          onChanged: (value) {
            if (value != null) {
              controller.doctorType.value = value;
              controller.hospitalId.value = '';
              controller.clinicId.value = '';
            }
          },
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
          ),
          items: controller.specializations
              .map((e) => DropdownMenuItem(
                    value: e['id'],
                    child: Text(e['name']!),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) controller.specializationId.value = value;
          },
          validator: (value) =>
              value == null || value.isEmpty ? 'Chọn chuyên ngành' : null,
        ));
  }

  Widget _buildHospitalDropdown(DoctorinformationController controller) {
    return DropdownButtonFormField<String>(
      value: controller.hospitalId.value.isEmpty
          ? null
          : controller.hospitalId.value,
      decoration: const InputDecoration(
        labelText: 'Bệnh viện',
        border: OutlineInputBorder(),
      ),
      items: controller.hospitals
          .map((e) => DropdownMenuItem(
                value: e['id'],
                child: Text(e['name']!),
              ))
          .toList(),
      onChanged: (value) {
        controller.hospitalId.value = value ?? '';
        controller.clinicId.value = '';
      },
      validator: (value) =>
          value == null || value.isEmpty ? 'Chọn bệnh viện' : null,
    );
  }

  Widget _buildClinicDropdown(DoctorinformationController controller) {
    return DropdownButtonFormField<String>(
      value:
          controller.clinicId.value.isEmpty ? null : controller.clinicId.value,
      decoration: const InputDecoration(
        labelText: 'Phòng khám',
        border: OutlineInputBorder(),
      ),
      items: controller.clinics
          .map((e) => DropdownMenuItem(
                value: e['id'],
                child: Text(e['name']!),
              ))
          .toList(),
      onChanged: (value) {
        controller.clinicId.value = value ?? '';
        controller.hospitalId.value = '';
      },
      validator: (value) =>
          value == null || value.isEmpty ? 'Chọn phòng khám' : null,
    );
  }
}
