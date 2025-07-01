import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/controller/patient_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Patient extends StatelessWidget {
  Patient({super.key});

  final PatientController controller = Get.put(PatientController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.fourthMain,
      title: const Text(
        'Thêm thành viên',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      elevation: 0,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNameField(),
            const SizedBox(height: 16),
            _buildDatePicker(context),
            const SizedBox(height: 16),
            _buildGenderPicker(),
            const SizedBox(height: 16),
            _buildPhoneField(),
            const SizedBox(height: 16),
            _buildAddressField(),
            const SizedBox(height: 16),
            _buildRelationshipField(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameController,
      decoration: InputDecoration(
        labelText: 'Họ và tên (*)',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.person),
      ),
      validator: controller.validateName,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: controller.phoneController,
      decoration: InputDecoration(
        labelText: 'Số điện thoại (*)',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      validator: controller.validatePhone,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: controller.addressController,
      decoration: InputDecoration(
        labelText: 'Địa chỉ',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.location_on),
      ),
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildRelationshipField() {
    return Obx(() => DropdownButtonFormField<String>(
          value: controller.relationship.value.isNotEmpty
              ? controller.relationship.value
              : null,
          decoration: InputDecoration(
            labelText: 'Quan hệ (*)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: const Icon(Icons.family_restroom),
          ),
          items: ['Bản thân', 'Vợ/Chồng', 'Con', 'Cha/Mẹ', 'Khác']
              .map((String relationship) => DropdownMenuItem<String>(
                    value: relationship,
                    child: Text(relationship),
                  ))
              .toList(),
          onChanged: (String? newValue) {
            if (newValue != null) controller.relationship.value = newValue;
          },
          validator: (value) =>
              value == null || value.isEmpty ? 'Vui lòng chọn quan hệ' : null,
          hint: const Text('Chọn quan hệ'),
        ));
  }

  Widget _buildGenderPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giới tính (*)',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGenderRadio('Nam', 0),
                _buildGenderRadio('Nữ', 1),
                _buildGenderRadio('Khác', 2),
              ],
            )),
      ],
    );
  }

  Widget _buildGenderRadio(String label, int value) {
    return Expanded(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Radio<int>(
          value: value,
          groupValue: controller.gender.value,
          onChanged: (int? newValue) {
            if (newValue != null) {
              controller.gender.value = newValue;
            }
          },
          activeColor: Colors.blue,
        ),
        title: Text(label),
        onTap: () => controller.gender.value = value,
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return TextFormField(
      controller: controller.dobController,
      decoration: InputDecoration(
        labelText: 'Ngày sinh (*)',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      readOnly: true,
      onTap: () => controller.selectDate(context),
      validator: controller.validateDate,
    );
  }

  Widget _buildActionButtons() {
    return Obx(() => Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    controller.isLoading.value ? null : controller.saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'LƯU THÔNG TIN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ));
  }
}