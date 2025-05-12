import 'package:ebookingdoc/Controller/Appointment/AppointmentScreen/appointment_screen_controller.dart';
import 'package:ebookingdoc/Models/AppointmentScreen_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatelessWidget {
  final AppointmentScreenController controller =
      Get.put(AppointmentScreenController());

  AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header with stepper
          _buildHeader(),

          // Main content area
          Expanded(
            child: Obx(() {
              switch (controller.currentStep.value) {
                case 1:
                  return _buildStep1Content();
                case 2:
                  return _buildStep2Content();
                case 3:
                  return _buildStep3Content();
                case 4:
                  return _buildStep4Content();
                default:
                  return _buildStep1Content();
              }
            }),
          ),
        ],
      ),
    );
  }

  // ==================== Common Widgets ====================
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(Get.context!).padding.top),
      color: Colors.blue,
      child: Column(
        children: [
          // Title with back button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (controller.currentStep.value > 1)
                  GestureDetector(
                    onTap: () => controller.previousStep(),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  )
                else
                  const SizedBox(width: 40),
                const SizedBox(width: 16),
                const Text(
                  'Đặt lịch khám bệnh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Stepper indicator
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                _buildStepCircle(1, Icons.local_hospital),
                _buildStepLine(1),
                _buildStepCircle(2, Icons.person),
                _buildStepLine(2),
                _buildStepCircle(3, Icons.check_circle),
                _buildStepLine(3),
                _buildStepCircle(4, Icons.payment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, IconData icon) {
    final isActive = controller.currentStep.value >= step;
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

  Widget _buildStepLine(int step) {
    final isActive = controller.currentStep.value > step;
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.white : Colors.blue.shade300,
      ),
    );
  }

  Widget _buildContinueButton(String text, VoidCallback onPressed,
      {bool enabled = true}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.grey.shade500,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==================== Step 1: Select Hospital Info ====================
  Widget _buildStep1Content() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hospital selection - Không cần Obx vì không có observable trực tiếp
          _buildSectionTitle('Chọn bệnh viện'),
          _buildHospitalSelection(),

          // Department selection - Cần Obx vì phụ thuộc vào selectedHospital
          const SizedBox(height: 20),
          _buildSectionTitle('Chuyên khoa'),
          _buildDepartmentSelection(),

          // Service selection - Cần Obx vì phụ thuộc vào selectedDepartment
          const SizedBox(height: 20),
          _buildSectionTitle('Dịch vụ khám'),
          _buildServiceSelection(),

          // Room selection - Cần Obx vì phụ thuộc vào selectedDepartment
          const SizedBox(height: 20),
          _buildSectionTitle('Phòng khám'),
          _buildRoomSelection(),

          // Date selection - Cần Obx nếu có selectedDate thay đổi
          const SizedBox(height: 20),
          _buildSectionTitle('Ngày khám'),
          _buildDateSelection(),

          // Time slot selection - Cần Obx nếu có selectedTimeSlot thay đổi
          const SizedBox(height: 20),
          _buildSectionTitle('Giờ khám'),
          _buildTimeSlotSelection(),

          // Continue button - Cần Obx vì phụ thuộc vào isStep1Complete()
          _buildContinueButton(
            'TIẾP TỤC',
            () => controller.nextStep(),
            enabled: controller.isStep1Complete(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHospitalSelection() {
    return Obx(() {
      if (controller.hospitals.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return DropdownButtonFormField<Hospital>(
        value: controller.selectedHospital.value,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: controller.hospitals.map((hospital) {
          return DropdownMenuItem<Hospital>(
            value: hospital,
            child: Text(hospital.name),
          );
        }).toList(),
        onChanged: (hospital) {
          if (hospital != null) {
            controller.selectHospital(hospital);
          }
        },
      );
    });
  }

  Widget _buildDepartmentSelection() {
    return Obx(() {
      if (controller.selectedHospital.value == null) {
        return const Text('Vui lòng chọn bệnh viện trước');
      }
      return DropdownButtonFormField<Department>(
        value: controller.selectedDepartment.value,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        hint: const Text('Chọn chuyên khoa'),
        items: controller.selectedHospital.value!.departments.map((dept) {
          return DropdownMenuItem<Department>(
            value: dept,
            child: Text(dept.name),
          );
        }).toList(),
        onChanged: (dept) {
          if (dept != null) {
            controller.selectDepartment(dept);
          }
        },
      );
    });
  }

  Widget _buildServiceSelection() {
    return Obx(() {
      if (controller.selectedDepartment.value == null) {
        return const Text('Vui lòng chọn chuyên khoa trước');
      }
      return DropdownButtonFormField<MedicalService>(
        value: controller.selectedService.value,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        hint: const Text('Chọn dịch vụ khám'),
        items: controller.selectedDepartment.value!.services.map((service) {
          return DropdownMenuItem<MedicalService>(
            value: service,
            child: Text(
                '${service.name} - ${service.price.toStringAsFixed(0)} VNĐ'),
          );
        }).toList(),
        onChanged: (service) {
          if (service != null) {
            controller.selectService(service);
          }
        },
      );
    });
  }

  Widget _buildRoomSelection() {
    return Obx(() {
      if (controller.selectedDepartment.value == null) {
        return const Text('Vui lòng chọn chuyên khoa trước');
      }
      return DropdownButtonFormField<ClinicRoom>(
        value: controller.selectedRoom.value,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        hint: const Text('Chọn phòng khám'),
        items: controller.selectedDepartment.value!.rooms.map((room) {
          return DropdownMenuItem<ClinicRoom>(
            value: room,
            child: Text(
                '${room.name} ${room.floor != null ? '(${room.floor})' : ''}'),
          );
        }).toList(),
        onChanged: (room) {
          if (room != null) {
            controller.selectRoom(room);
          }
        },
      );
    });
  }

  Widget _buildDateSelection() {
    final now = DateTime.now();
    final next7Days = List.generate(7, (i) => now.add(Duration(days: i + 1)));

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: next7Days.length,
        itemBuilder: (context, index) {
          final date = next7Days[index];
          final isSelected = controller.selectedDate.value?.day == date.day;
          final dayName = DateFormat('EEEE', 'vi_VN').format(date);
          final dayNumber = DateFormat('dd').format(date);
          final month = DateFormat('MM').format(date);

          return GestureDetector(
            onTap: () => controller.selectDate(date),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    dayNumber,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Thg $month',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlotSelection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.timeSlots.map((time) {
        final isSelected = controller.selectedTimeSlot.value == time;
        return ChoiceChip(
          label: Text(time),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              controller.selectTimeSlot(time);
            }
          },
          selectedColor: Colors.blue,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
          backgroundColor: Colors.grey[200],
        );
      }).toList(),
    );
  }

  // ==================== Step 2: Select Patient Profile ====================
  Widget _buildStep2Content() {
    return Column(
      children: [
        Expanded(
          child: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.patients.length,
                itemBuilder: (context, index) {
                  final patient = controller.patients[index];
                  final isSelected =
                      controller.selectedPatient.value?.id == patient.id;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        patient.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SĐT: ${patient.phone ?? 'Chưa có'}'),
                          Text('Ngày sinh: ${patient.dob}'),
                          Text('Địa chỉ: ${patient.address ?? 'Chưa có'}'),
                        ],
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.blue)
                          : null,
                      onTap: () => controller.selectPatient(patient),
                    ),
                  );
                },
              )),
        ),
        // Add new profile button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Thêm hồ sơ mới'),
            onPressed: () {
              // Navigate to add profile screen
              // Get.to(() => AddProfileScreen());
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
        // Continue button
        Obx(() => _buildContinueButton(
              'TIẾP TỤC',
              () => controller.nextStep(),
              enabled: controller.isStep2Complete(),
            )),
      ],
    );
  }

  // ==================== Step 3: Confirm Appointment ====================
  Widget _buildStep3Content() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Patient info
          _buildConfirmCard(
            title: 'Thông tin bệnh nhân',
            icon: Icons.person,
            child: Obx(() {
              final patient = controller.selectedPatient.value;
              if (patient == null) return const SizedBox();
              return Column(
                children: [
                  _buildConfirmItem('Họ tên', patient.name),
                  _buildConfirmItem('SĐT', patient.phone ?? 'Chưa có'),
                  _buildConfirmItem('Ngày sinh', patient.dob),
                  _buildConfirmItem('Địa chỉ', patient.address ?? 'Chưa có'),
                ],
              );
            }),
          ),

          // Hospital info
          _buildConfirmCard(
            title: 'Thông tin bệnh viện',
            icon: Icons.local_hospital,
            child: Obx(() {
              final hospital = controller.selectedHospital.value;
              if (hospital == null) return const SizedBox();
              return Column(
                children: [
                  _buildConfirmItem('Bệnh viện', hospital.name),
                  _buildConfirmItem('Địa chỉ', hospital.address),
                  if (hospital.phone != null)
                    _buildConfirmItem('Điện thoại', hospital.phone!),
                ],
              );
            }),
          ),

          // Appointment details
          _buildConfirmCard(
            title: 'Thông tin lịch hẹn',
            icon: Icons.calendar_today,
            child: Obx(() {
              return Column(
                children: [
                  if (controller.selectedDepartment.value != null)
                    _buildConfirmItem('Chuyên khoa',
                        controller.selectedDepartment.value!.name),
                  if (controller.selectedService.value != null)
                    _buildConfirmItem(
                        'Dịch vụ', controller.selectedService.value!.name),
                  if (controller.selectedRoom.value != null)
                    _buildConfirmItem(
                        'Phòng khám', controller.selectedRoom.value!.name),
                  if (controller.selectedDate.value != null)
                    _buildConfirmItem(
                        'Ngày khám',
                        DateFormat('dd/MM/yyyy')
                            .format(controller.selectedDate.value!)),
                  if (controller.selectedTimeSlot.value != null)
                    _buildConfirmItem(
                        'Giờ khám', controller.selectedTimeSlot.value!),
                ],
              );
            }),
          ),

          // Payment summary
          _buildConfirmCard(
            title: 'Tổng thanh toán',
            icon: Icons.payment,
            child: Obx(() {
              final service = controller.selectedService.value;
              if (service == null) return const SizedBox();
              return Column(
                children: [
                  _buildPriceItem('Phí khám bệnh', service.price),
                  _buildPriceItem('Phí dịch vụ', 0),
                  const Divider(height: 24),
                  _buildPriceItem('Tổng cộng', service.price, isTotal: true),
                ],
              );
            }),
          ),

          // Confirm button
          _buildContinueButton(
            'XÁC NHẬN ĐẶT LỊCH',
            () => controller.confirmAppointment(),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceItem(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(0)} VNĐ',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue : null,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Step 4: Payment ====================
  Widget _buildStep4Content() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          const Text(
            'ĐẶT LỊCH THÀNH CÔNG',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mã đặt lịch: ${DateTime.now().millisecondsSinceEpoch}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),

          // Appointment summary
          _buildConfirmCard(
            title: 'Thông tin đặt lịch',
            icon: Icons.info,
            child: Obx(() {
              final patient = controller.selectedPatient.value;
              final hospital = controller.selectedHospital.value;
              final service = controller.selectedService.value;

              return Column(
                children: [
                  if (patient != null)
                    _buildConfirmItem('Bệnh nhân', patient.name),
                  if (hospital != null)
                    _buildConfirmItem('Bệnh viện', hospital.name),
                  if (service != null)
                    _buildConfirmItem('Dịch vụ', service.name),
                  if (controller.selectedDate.value != null)
                    _buildConfirmItem(
                        'Ngày khám',
                        DateFormat('dd/MM/yyyy')
                            .format(controller.selectedDate.value!)),
                  if (controller.selectedTimeSlot.value != null)
                    _buildConfirmItem(
                        'Giờ khám', controller.selectedTimeSlot.value!),
                  const SizedBox(height: 12),
                  _buildPriceItem('Tổng thanh toán', service?.price ?? 0,
                      isTotal: true),
                ],
              );
            }),
          ),

          // Payment methods
          _buildConfirmCard(
            title: 'Hình thức thanh toán',
            icon: Icons.payment,
            child: Column(
              children: [
                _buildPaymentMethod(
                  icon: Icons.credit_card,
                  title: 'Thanh toán online',
                  subtitle: 'Thẻ ATM/VISA/Mastercard',
                  isSelected: true,
                ),
                const Divider(height: 24),
                _buildPaymentMethod(
                  icon: Icons.money,
                  title: 'Thanh toán tại bệnh viện',
                  subtitle: 'Khi đến khám',
                ),
              ],
            ),
          ),

          // Complete button
          _buildContinueButton(
            'HOÀN TẤT',
            () {
              controller.completePayment();
              Get.until((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          )),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.blue)
          : null,
      onTap: () {
        // Handle payment method selection
      },
    );
  }
}
