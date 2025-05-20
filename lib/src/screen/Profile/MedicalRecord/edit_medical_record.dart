import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/Profile/MedicalRecord/medical_record_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditMedicalRecord extends StatelessWidget {
  final MedicalRecordController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();

  EditMedicalRecord({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo bản sao của record để chỉnh sửa
    final record = controller.record.value.copyWith();
    _heightController.text = record.height.toString();
    _genderController.text = record.gender;
    _bloodTypeController.text = record.bloodType;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chỉnh sửa hồ sơ',
          style: TextStyle(color: AppColor.main),
        ),
        centerTitle: true,
        backgroundColor: AppColor.fourthMain,
        iconTheme: IconThemeData(color: AppColor.main),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'Họ và tên',
                initialValue: record.name,
                onChanged: (value) => record.name = value,
                validator: (value) =>
                    value!.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              _buildDatePicker(
                context,
                label: 'Ngày sinh',
                initialDate: record.dob,
                onChanged: (date) => record.dob = date,
              ),
              _buildSelectionField(
                context,
                label: 'Giới tính',
                controller: _genderController,
                options: const ['Nam', 'Nữ'],
                onSelected: (value) {
                  _genderController.text = value;
                  record.gender = value;
                },
              ),
              _buildTextField(
                label: 'Chiều cao (cm)',
                controller: _heightController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Vui lòng nhập chiều cao';
                  final height = int.tryParse(value) ?? 0;
                  if (height <= 0 || height > 250) {
                    return 'Chiều cao phải từ 1-250cm';
                  }
                  return null;
                },
                onChanged: (value) => record.height = int.tryParse(value) ?? 0,
              ),
              _buildTextField(
                label: 'Cân nặng (kg)',
                initialValue: record.weight.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) => record.weight = int.tryParse(value) ?? 0,
                validator: (value) =>
                    value!.isEmpty ? 'Vui lòng nhập cân nặng' : null,
              ),
              _buildSelectionField(
                context,
                label: 'Nhóm máu',
                controller: _bloodTypeController,
                options: const [
                  'A+',
                  'A-',
                  'B+',
                  'B-',
                  'AB+',
                  'AB-',
                  'O+',
                  'O-'
                ],
                onSelected: (value) {
                  _bloodTypeController.text = value;
                  record.bloodType = value;
                },
              ),
              _buildTextField(
                label: 'Dị ứng',
                initialValue: record.allergies ?? '',
                onChanged: (value) =>
                    record.allergies = value.isEmpty ? null : value,
                keyboardType: TextInputType.multiline,
              ),
              _buildTextField(
                label: 'Bệnh mãn tính',
                initialValue: record.chronicDiseases ?? '',
                onChanged: (value) =>
                    record.chronicDiseases = value.isEmpty ? null : value,
                keyboardType: TextInputType.multiline,
              ),
              _buildTextField(
                label: 'Thuốc đang sử dụng',
                initialValue: record.currentMedications ?? '',
                onChanged: (value) =>
                    record.currentMedications = value.isEmpty ? null : value,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColor.fourthMain, // Màu nền xanh
                    foregroundColor: AppColor.main,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      record.height =
                          int.tryParse(_heightController.text) ?? record.height;
                      record.gender = _genderController.text;
                      record.bloodType = _bloodTypeController.text;

                      controller.updateRecord(record);
                    }
                  },
                  child: const Text('LƯU THAY ĐỔI',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required String label,
    required DateTime initialDate,
    required ValueChanged<DateTime> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(1900), // Giới hạn ngày sinh hợp lệ
            lastDate: DateTime.now(), // Không cho chọn ngày trong tương lai
          );
          if (pickedDate != null) {
            onChanged(pickedDate);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('dd/MM/yyyy').format(initialDate)),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    TextEditingController? controller,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        controller: controller,
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType ?? TextInputType.multiline,
        maxLines: null, // Cho phép xuống dòng tự động
      ),
    );
  }

  void _showSelectionBottomSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(options[index]),
                          onTap: () {
                            onSelected(options[index]); // Cập nhật controller
                            Navigator.pop(context); // Đóng bottom sheet sau
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectionField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          _showSelectionBottomSheet(
            context: context,
            title: 'Chọn $label',
            options: options,
            onSelected: (value) {
              controller.text = value; // Set controller khi chọn
              onSelected(value); // Gọi hàm cập nhật vào biến record
            },
          );
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          child: Text(controller.text),
        ),
      ),
    );
  }
}
