import 'package:ebookingdoc/Controller/Appointment/AppointmentScreen/appointment_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AppointmentScreen extends StatelessWidget {
  final AppointmentScreenController controller = Get.put(AppointmentScreenController());
  
  AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header với tiêu đề và stepper
          _buildHeader(),
          
          // Nội dung chính
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thông tin bệnh viện
                    _buildHospitalCard(),
                    
                    // Các mục chọn
                    _buildSelectionItem(
                      title: 'Chuyên khoa',
                      icon: Icons.medical_services_outlined,
                      onTap: () => _showDepartmentSelection(context),
                      valueBuilder: () => controller.selectedDepartment.value,
                    ),
                    
                    _buildSelectionItem(
                      title: 'Dịch vụ',
                      icon: Icons.miscellaneous_services_outlined,
                      onTap: () => _showServiceSelection(context),
                      valueBuilder: () => controller.selectedService.value,
                    ),
                    
                    _buildSelectionItem(
                      title: 'Phòng khám',
                      icon: Icons.home_outlined,
                      onTap: () => _showRoomSelection(context),
                      valueBuilder: () => controller.selectedRoom.value,
                    ),
                    
                    _buildSelectionItem(
                      title: 'Ngày khám',
                      icon: Icons.calendar_today_outlined,
                      onTap: () => _showDateSelection(context),
                      valueBuilder: () => controller.selectedDate.value != null 
                        ? '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}'
                        : null,
                    ),
                    
                    _buildSelectionItem(
                      title: 'Giờ khám',
                      icon: Icons.access_time_outlined,
                      onTap: () => _showTimeSelection(context),
                      valueBuilder: () => controller.selectedTime.value,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Nút tiếp tục
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() => Container(
      padding: EdgeInsets.only(top: MediaQuery.of(Get.context!).padding.top),
      color: Colors.blue,
      child: Column(
        children: [
          // Phần tiêu đề với nút back
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Chọn thông tin khám',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Indicator các bước đặt lịch
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                _buildStepCircle(isActive: true, icon: Icons.local_hospital),
                _buildStepLine(isActive: controller.currentStep.value > 0),
                _buildStepCircle(isActive: controller.currentStep.value >= 1, icon: Icons.person),
                _buildStepLine(isActive: controller.currentStep.value > 1),
                _buildStepCircle(isActive: controller.currentStep.value >= 2, icon: Icons.check_circle),
                _buildStepLine(isActive: controller.currentStep.value > 2),
                _buildStepCircle(isActive: controller.currentStep.value >= 3, icon: Icons.description),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildStepCircle({required bool isActive, required IconData icon}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.blue.shade300,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.blue : Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.white : Colors.blue.shade300,
      ),
    );
  }

  Widget _buildHospitalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.hospital.value.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.hospital.value.address,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required String? Function() valueBuilder,
  }) {
    return Obx(() {
      String? value = valueBuilder();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value ?? 'Chọn ${title.toLowerCase()}',
                      style: TextStyle(
                        color: value != null ? Colors.black87 : Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Obx(() => ElevatedButton(
        onPressed: controller.canProceed() ? () {
          controller.incrementStep();
          controller.proceedToNextStep();
          // Trong thực tế, tại đây sẽ chuyển sang màn hình tiếp theo
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade50,
          foregroundColor: Colors.blue,
          disabledBackgroundColor: Colors.grey.shade200,
          disabledForegroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'TIẾP TỤC',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      )),
    );
  }

  // Các phương thức hiển thị dialog chọn thông tin
  void _showDepartmentSelection(BuildContext context) {
    final departments = ['Nội khoa', 'Ngoại khoa', 'Sản khoa', 'Nhi khoa', 'Tim mạch', 'Thần kinh'];
    _showSelectionBottomSheet(context, 'Chọn chuyên khoa', departments, (value) {
      controller.selectedDepartment.value = value;
    });
  }

  void _showServiceSelection(BuildContext context) {
    final services = ['Khám thông thường', 'Khám yêu cầu', 'Tái khám', 'Khám bảo hiểm'];
    _showSelectionBottomSheet(context, 'Chọn dịch vụ', services, (value) {
      controller.selectedService.value = value;
    });
  }

  void _showRoomSelection(BuildContext context) {
    final rooms = ['Phòng 101', 'Phòng 102', 'Phòng 103', 'Phòng 201', 'Phòng 202'];
    _showSelectionBottomSheet(context, 'Chọn phòng khám', rooms, (value) {
      controller.selectedRoom.value = value;
    });
  }

  void _showDateSelection(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.blue),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      controller.selectedDate.value = selected;
    }
  }

  void _showTimeSelection(BuildContext context) {
    final times = ['8:00 - 8:30', '8:30 - 9:00', '9:00 - 9:30', '9:30 - 10:00', '10:00 - 10:30'];
    _showSelectionBottomSheet(context, 'Chọn giờ khám', times, (value) {
      controller.selectedTime.value = value;
    });
  }

  void _showSelectionBottomSheet(BuildContext context, String title, List<String> items, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search box
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            // List items
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      onSelected(items[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}