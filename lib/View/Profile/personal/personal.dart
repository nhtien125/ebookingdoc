import 'package:ebookingdoc/Controller/Profile/personal/personal_controller.dart';
import 'package:ebookingdoc/Global/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Personal extends StatelessWidget {
  Personal({super.key});

  final controller = Get.put(PersonalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Thông tin cá nhân',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
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
            _buildAvatarSection(),
            const SizedBox(height: 24),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildDatePicker(context),
            const SizedBox(height: 16),
            _buildGenderPicker(),
            const SizedBox(height: 16),
            _buildPhoneField(),
            const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildAddressField(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        Obx(() {
          return GestureDetector(
            onTap: controller.pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColor.fivethMain,
                  backgroundImage: controller.avatar.value != null
                      ? FileImage(controller.avatar.value!)
                      : null,
                  child: controller.avatar.value == null
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        Text(
          'Thay đổi ảnh đại diện',
          style: TextStyle(
            color: Colors.blue.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameController,
      decoration: InputDecoration(
        labelText: 'Họ và tên (*)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone, // Bàn phím số
      validator: controller.validatePhone,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: controller.validateGmail,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: controller.addressController,
      decoration: InputDecoration(
        labelText: 'Địa chỉ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.location_on),
      ),
      textInputAction: TextInputAction.done,
    );
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
              children: [
                Expanded(
                  child: _buildGenderRadio('Nam', 0),
                ),
                Expanded(
                  child: _buildGenderRadio('Nữ', 1),
                ),
                Expanded(
                  child: _buildGenderRadio('Khác', 2),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildGenderRadio(String label, int value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Radio<int>(
        value: value,
        groupValue: controller.gender.value,
        onChanged: (int? value) {
          controller.gender.value = value!;
        },
        activeColor: Colors.blue,
      ),
      title: Text(label),
      onTap: () {
        controller.gender.value = value;
      },
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return TextFormField(
      controller: controller.dobController,
      decoration: InputDecoration(
        labelText: 'Ngày sinh (*)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      readOnly: true,
      onTap: () => controller.selectDate(context),
      validator: controller.validateDate,
    );
  }

  Widget _buildActionButtons() {
    return Obx(() {
      return Column(
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
      );
    });
  }
}
