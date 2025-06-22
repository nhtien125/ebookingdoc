import 'dart:io';
import 'package:ebookingdoc/src/widgets/controller/Doctorinformation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Doctorinformation extends StatelessWidget {
  Doctorinformation({super.key});
  final controller = Get.put(DoctorinformationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin bác sĩ'), centerTitle: true),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
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
              _buildDoctorTypeDropdown(),
              const SizedBox(height: 16),
              _buildSpecializationDropdown(),
              const SizedBox(height: 16),
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
              TextFormField(
                controller: controller.introduceController,
                decoration: InputDecoration(
                  labelText: 'Giới thiệu bản thân',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignLabelWithHint:
                      true, // Đảm bảo label nằm đúng vị trí khi nhiều dòng
                ),
                maxLines:
                    null, // hoặc null nếu muốn tự động cao theo nội dung (nhưng thường đặt 5 là đẹp)
                minLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 24),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.saveProfile,
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('LƯU THÔNG TIN',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorTypeDropdown() {
    final controller = Get.find<DoctorinformationController>();
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
            if (value != null) controller.doctorType.value = value;
          },
        ));
  }

  Widget _buildSpecializationDropdown() {
    final controller = Get.find<DoctorinformationController>();
    final List<Map<String, String>> specializations = [
      {'id': 'spec0001uuid00000000000000000001', 'name': 'Tim mạch'},
      {'id': 'spec0002uuid00000000000000000001', 'name': 'Ngoại khoa'},
    ];
    return Obx(() => DropdownButtonFormField<String>(
          value: controller.specializationId.value.isEmpty
              ? null
              : controller.specializationId.value,
          decoration: const InputDecoration(
            labelText: 'Chuyên ngành',
            border: OutlineInputBorder(),
          ),
          items: specializations
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
}
