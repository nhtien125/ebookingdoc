import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/controller/appointment_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Step1Content extends StatelessWidget {
  final AppointmentScreenController controller;

  const Step1Content({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                HospitalInfoCard(controller: controller),
                const SizedBox(height: 10),
                _buildSectionTitle('Chọn bác sĩ'),
                DoctorSelection(controller: controller),
                const SizedBox(height: 20),
                _buildSectionTitle('Chuyên khoa'),
                DepartmentSelection(controller: controller),
                const SizedBox(height: 20),
                _buildSectionTitle('Dịch vụ khám'),
                ServiceSelection(controller: controller),
                const SizedBox(height: 20),
                _buildSectionTitle('Ngày khám'),
                DateSelection(controller: controller),
                const SizedBox(height: 20),
                _buildSectionTitle('Giờ khám'),
                TimeSlotSelection(controller: controller),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        Obx(() {
          final isComplete = controller.isStep1Complete();
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isComplete ? () => controller.nextStep() : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isComplete ? AppColor.fourthMain : Colors.grey[400],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'TIẾP TỤC',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
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
}

class HospitalInfoCard extends StatelessWidget {
  final AppointmentScreenController controller;

  const HospitalInfoCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hospital = controller.selectedHospital.value;
      if (hospital == null) {
        return const SizedBox();
      }

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.fourthMain),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hospital.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hospital.address,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class DoctorSelection extends StatelessWidget {
  final AppointmentScreenController controller;

  const DoctorSelection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Obx(() {
      final selected = controller.selectedDoctor.value;
      return GestureDetector(
        onTap: () {
          searchController.clear();
          showModalBottomSheet(
            context: Get.context!,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) {
              return Container(
                height: MediaQuery.of(Get.context!).size.height * 0.7,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Chọn bác sĩ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm bác sĩ...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (_) => controller.doctors.refresh(),
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: Obx(() {
                        final filteredDoctors = controller.doctors
                            .where((doctor) => doctor.name
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase()))
                            .toList();

                        if (filteredDoctors.isEmpty) {
                          return const Center(child: Text('Không tìm thấy bác sĩ nào'));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: filteredDoctors.length,
                          itemBuilder: (_, index) {
                            final doctor = filteredDoctors[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectDoctor(doctor);
                                  Get.back();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          doctor.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected != null ? AppColor.fourthMain : Colors.grey.shade400,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selected?.name ?? 'Chọn bác sĩ',
                style: TextStyle(
                  color: selected != null ? Colors.black : Colors.grey,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );
    });
  }
}

class DepartmentSelection extends StatelessWidget {
  final AppointmentScreenController controller;

  const DepartmentSelection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDept = controller.selectedDepartment.value;
      final departments = controller.selectedDoctor.value?.departments ?? [];

      return GestureDetector(
        onTap: () {
          if (controller.selectedDoctor.value == null) {
            Get.snackbar("Thông báo", "Vui lòng chọn bác sĩ trước");
            return;
          }

          showModalBottomSheet(
            context: Get.context!,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Chuyên khoa',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Divider(thickness: 1),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: departments.map((dept) {
                          final isSelected = dept == selectedDept;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: GestureDetector(
                              onTap: () {
                                controller.selectDepartment(dept);
                                Get.back();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? AppColor.fourthMain : Colors.grey.shade300,
                                    width: 1.2,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dept.name,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    if (isSelected) const Icon(Icons.check, color: Colors.blue),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selectedDept != null ? AppColor.fourthMain : Colors.grey.shade400,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDept?.name ?? 'Chọn chuyên khoa',
                style: TextStyle(
                  color: selectedDept != null ? Colors.black : Colors.grey,
                  fontSize: 16,
                  fontWeight: selectedDept != null ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );
    });
  }
}

class ServiceSelection extends StatelessWidget {
  final AppointmentScreenController controller;

  const ServiceSelection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedService = controller.selectedService.value;
      final selectedDept = controller.selectedDepartment.value;
      final services = selectedDept?.services ?? [];

      return GestureDetector(
        onTap: () {
          if (controller.selectedDoctor.value == null) {
            Get.snackbar("Thông báo", "Vui lòng chọn bác sĩ trước");
            return;
          }
          if (selectedDept == null) {
            Get.snackbar("Thông báo", "Vui lòng chọn chuyên khoa trước");
            return;
          }

          showModalBottomSheet(
            context: Get.context!,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              if (services.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      "Chuyên khoa này chưa có dịch vụ nào",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }

              return SizedBox(
                 height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Dịch vụ khám',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Divider(thickness: 1),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: services.map((service) {
                          final isSelected = service == selectedService;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: GestureDetector(
                              onTap: () {
                                controller.selectService(service);
                                Get.back();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? AppColor.fourthMain : Colors.grey.shade300,
                                    width: 1.2,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            service.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '${service.price.toStringAsFixed(0)} VNĐ',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected) const Icon(Icons.check, color: Colors.blue),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: selectedService != null ? AppColor.fourthMain : Colors.grey.shade400,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selectedService?.name ?? 'Chọn dịch vụ khám',
                  style: TextStyle(
                    color: selectedService != null ? Colors.black : Colors.grey,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );
    });
  }
}

class DateSelection extends StatelessWidget {
  final AppointmentScreenController controller;

  const DateSelection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDate = controller.selectedDate.value;

      return GestureDetector(
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: Get.context!,
            initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 1)),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 60)),
            helpText: 'Chọn ngày khám',
            locale: const Locale('vi', 'VN'),
          );
          if (picked != null) {
            controller.selectDate(picked);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selectedDate != null ? AppColor.fourthMain : Colors.grey.shade400,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate != null
                    ? DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(selectedDate)
                    : 'Chọn ngày khám',
                style: TextStyle(
                  color: selectedDate != null ? Colors.black : Colors.grey,
                  fontSize: 16,
                  fontWeight: selectedDate != null ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      );
    });
  }
}

class TimeSlotSelection extends StatelessWidget {
  final AppointmentScreenController controller;

  const TimeSlotSelection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedTimeSlot.value;

      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: controller.timeSlots.map((time) {
          final isSelected = time == selected;

          return GestureDetector(
            onTap: () => controller.selectTimeSlot(time),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.fourthMain : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                time,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}