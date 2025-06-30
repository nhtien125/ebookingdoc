import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/data/model/patient_model.dart';
import 'package:ebookingdoc/src/widgets/controller/appointment_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatelessWidget {
  final AppointmentScreenController controller =
      Get.put(AppointmentScreenController());

  AppointmentScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.main,
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

  String getStepTitle(int step) {
    switch (step) {
      case 1:
        return 'Chọn thông tin khám';
      case 2:
        return 'Chọn hồ sơ';
      case 3:
        return 'Xác nhận thông tin khám';
      case 4:
        return 'Thông tin thanh toán';
      default:
        return 'Đặt lịch khám bệnh';
    }
  }

  // ==================== Common Widgets ====================
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(Get.context!).padding.top),
      color: AppColor.fourthMain,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.currentStep.value > 1) {
                      controller.previousStep();
                    } else {
                      Get.back();
                    }
                  },
                  child: Icon(Icons.arrow_back, color: AppColor.main, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.2, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutQuart,
                            )),
                            child: child,
                          ),
                        ),
                        child: Text(
                          getStepTitle(controller.currentStep.value),
                          key: ValueKey(controller.currentStep.value),
                          style: TextStyle(
                            color: AppColor.main,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),

          // Interactive Stepper
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Obx(() => Row(
                  children: [
                    _buildInteractiveStepCircle(1, Icons.local_hospital),
                    _buildStepLine(1),
                    _buildInteractiveStepCircle(2, Icons.person),
                    _buildStepLine(2),
                    _buildInteractiveStepCircle(3, Icons.check_circle),
                    _buildStepLine(3),
                    _buildInteractiveStepCircle(4, Icons.payment),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveStepCircle(int step, IconData icon) {
    final isActive = controller.currentStep.value >= step;
    final isCompleted = controller.currentStep.value > step;

    return GestureDetector(
      onTap: () {
        if (step < controller.currentStep.value) {
          controller.goToStep(step);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? AppColor.main : AppColor.fourthMain,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColor.main,
            width: isCompleted ? 2 : 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColor.fourthMain,
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: Icon(
              icon,
              key: ValueKey('${isActive}_$step'),
              color: isActive ? AppColor.fourthMain : AppColor.main,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCircle(int step, IconData icon) {
    final isActive = controller.currentStep.value >= step;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isActive ? AppColor.main : AppColor.fourthMain,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.main, width: 2),
      ),
      child: Icon(
        icon,
        color: isActive ? AppColor.fourthMain : AppColor.main,
        size: 18,
      ),
    );
  }

  Widget _buildStepLine(int step) {
    final isActive = controller.currentStep.value > step;
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.blue.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
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
          backgroundColor: AppColor.fourthMain,
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
    final healthStatusController = TextEditingController(
      text: controller.healthStatus.value,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedPlaceType.value,
                decoration: const InputDecoration(
                  labelText: 'Bạn muốn khám ở',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'hospital', child: Text('Bệnh viện')),
                  DropdownMenuItem(value: 'clinic', child: Text('Phòng khám')),
                  DropdownMenuItem(
                      value: 'vaccination',
                      child: Text('Trung tâm tiêm chủng')),
                ],
                onChanged: (val) {
                  if (val != null) controller.selectedPlaceType.value = val;
                },
              )),
        ),
        // Thêm trường nhập tình trạng sức khỏe

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildHospitalInfoCard(),
                const SizedBox(height: 10),
                if (controller.selectedPlaceType.value != 'vaccination') ...[
                  _buildSectionTitle('Chuyên khoa'),
                  _buildDepartmentSelection(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Chọn bác sĩ'),
                  _buildDoctorSelection(),
                  const SizedBox(height: 20),
                ],
                _buildSectionTitle('Dịch vụ khám'),
                _buildServiceSelection(),
                const SizedBox(height: 20),
                if (controller.selectedPlaceType.value != 'vaccination') ...[
                  _buildSectionTitle('Ngày khám'),
                  _buildDateSelection(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Giờ khám'),
                  _buildTimeSlotSelection(),
                ],
                if (controller.selectedPlaceType.value == 'vaccination') ...[
                  _buildSectionTitle('Ngày tiêm'),
                  _buildDateSelection(),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: controller.healthStatusController,
                    decoration: const InputDecoration(
                      labelText: 'Tình trạng sức khỏe',
                      border: OutlineInputBorder(),
                      hintText: 'Nhập tình trạng sức khỏe hiện tại',
                    ),
                    maxLines: 2,
                  ),
                ),
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
                onPressed: isComplete
                    ? () async {
                        controller.nextStep();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isComplete ? AppColor.fourthMain : Colors.grey[400],
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

  Widget _buildHospitalInfoCard() {
    return Obx(() {
      final placeType = controller.selectedPlaceType.value;

      // Lấy object và danh sách tương ứng
      dynamic selectedPlace;
      List<dynamic> placeList = [];
      IconData icon = Icons.local_hospital;

      if (placeType == 'hospital') {
        selectedPlace = controller.selectedHospital.value;
        placeList = controller.hospitals;
        icon = Icons.local_hospital;
      } else if (placeType == 'clinic') {
        selectedPlace = controller.selectedClinic.value;
        placeList = controller.clinics;
        icon = Icons.local_hospital_outlined;
      } else if (placeType == 'vaccination') {
        selectedPlace = controller.selectedVaccinationCenter.value;
        placeList = controller.vaccinationCenters;
        icon = Icons.vaccines;
      }

      if (selectedPlace == null) {
        return const SizedBox();
      }

      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: Get.context!,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return ListView.builder(
                itemCount: placeList.length,
                itemBuilder: (context, index) {
                  final item = placeList[index];
                  return ListTile(
                    leading: item.image != null && item.image.isNotEmpty
                        ? Image.network(item.image,
                            width: 40, height: 40, fit: BoxFit.cover)
                        : Icon(icon),
                    title: Text(item.name),
                    subtitle: Text(item.address),
                    onTap: () {
                      if (placeType == 'hospital') {
                        controller.selectHospital(item);
                      } else if (placeType == 'clinic') {
                        controller.selectClinic(item);
                      } else if (placeType == 'vaccination') {
                        controller.selectVaccinationCenter(item);
                      }
                      Get.back();
                    },
                    selected: item.uuid == selectedPlace.uuid,
                    selectedTileColor: Colors.blue[50],
                  );
                },
              );
            },
          );
        },
        child: Container(
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedPlace.image != null && selectedPlace.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: selectedPlace.image.startsWith('http')
                      ? Image.network(
                          selectedPlace.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          selectedPlace.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                )
              else
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 36, color: Colors.blue),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedPlace.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedPlace.address,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDepartmentSelection() {
    return Obx(() {
      final selectedSpecialization = controller.selectedDepartment.value;
      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: Get.context!,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) {
              final specializations = controller.specializations;
              if (specializations.isEmpty) {
                return const Center(child: Text('Không có chuyên khoa nào!'));
              }
              return Container(
                height: MediaQuery.of(Get.context!).size.height * 0.6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView.builder(
                  itemCount: specializations.length,
                  itemBuilder: (_, index) {
                    final sp = specializations[index];
                    return ListTile(
                      title: Text(sp.name ?? ''),
                      onTap: () {
                        controller.selectDepartment(sp);
                        controller.selectedDoctor.value = null;
                        Navigator.pop(Get.context!);
                      },
                    );
                  },
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
              color: selectedSpecialization != null
                  ? AppColor.fourthMain
                  : Colors.grey.shade400,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedSpecialization?.name ?? 'Chọn chuyên khoa',
                style: TextStyle(
                  color: selectedSpecialization != null
                      ? Colors.black
                      : Colors.grey,
                  fontSize: 16,
                  fontWeight: selectedSpecialization != null
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDoctorSelection() {
    final RxString keyword = ''.obs;
    final searchController = TextEditingController();

    return Obx(() {
      final selectedDoctor = controller.selectedDoctor.value;
      final selectedSpecialization = controller.selectedDepartment.value;
      final selectedHospital = controller.selectedHospital.value;

      if (selectedSpecialization == null || selectedHospital == null) {
        return GestureDetector(
          onTap: () {
            Get.snackbar(
                "Thông báo", "Vui lòng chọn chuyên khoa và bệnh viện trước!");
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Chọn bác sĩ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        );
      }

      final doctorsBySpecializationAndHospital = controller.featuredDoctors
          .where((doctorDisplay) =>
              doctorDisplay.specialization.uuid ==
                  selectedSpecialization.uuid &&
              doctorDisplay.doctor.hospitalId == selectedHospital.uuid)
          .toList();

      return GestureDetector(
        onTap: () {
          searchController.clear();
          keyword.value = '';
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        onChanged: (val) => keyword.value = val,
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: Obx(() {
                        final filter = keyword.value.toLowerCase();
                        final filteredDoctors =
                            doctorsBySpecializationAndHospital
                                .where((doctorDisplay) {
                          return (doctorDisplay.user.name ?? '')
                                  .toLowerCase()
                                  .contains(filter) ||
                              (doctorDisplay.specialization.name
                                      ?.toLowerCase()
                                      .contains(filter) ??
                                  false);
                        }).toList();

                        if (filteredDoctors.isEmpty) {
                          return const Center(
                              child: Text('Không tìm thấy bác sĩ nào'));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: filteredDoctors.length,
                          itemBuilder: (_, index) {
                            final doctor = filteredDoctors[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectDoctor(doctor);
                                  Get.back();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      if ((doctor.doctor.image ?? '')
                                          .isNotEmpty)
                                        ClipOval(
                                          child: Image.network(
                                            doctor.doctor.image!,
                                            width: 36,
                                            height: 36,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      else
                                        const CircleAvatar(
                                          radius: 18,
                                          child: Icon(Icons.person),
                                        ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doctor.user.name ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              doctor.specialization.name ?? '',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
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
              color: selectedDoctor != null
                  ? AppColor.fourthMain
                  : Colors.grey.shade400,
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
              Expanded(
                child: Text(
                  selectedDoctor?.user.name ?? 'Chọn bác sĩ',
                  style: TextStyle(
                    color: selectedDoctor != null ? Colors.black : Colors.grey,
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

  Widget _buildServiceSelection() {
    return Obx(() {
      final selectedService = controller.selectedService.value;
      final selectedDepartment = controller.selectedDepartment.value;
      final services = selectedDepartment == null
          ? []
          : controller.medical
              .where((service) =>
                  service.specializationId == selectedDepartment.uuid)
              .toList();

      return GestureDetector(
        onTap: () {
          if (selectedDepartment == null) {
            Get.snackbar("Thông báo", "Vui lòng chọn chuyên khoa trước");
            return;
          }

          if (services.isEmpty) {
            Get.snackbar(
                "Thông báo", "Không có dịch vụ nào cho chuyên khoa này");
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
                      'Dịch vụ khám',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                                controller.selectedService.value = service;
                                Get.back();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColor.fourthMain
                                        : Colors.grey.shade300,
                                    width: 1.2,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            service.name ?? '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '${service.price?.toStringAsFixed(0) ?? '0'} VNĐ',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(Icons.check,
                                          color: Colors.blue),
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
              color: selectedService != null
                  ? AppColor.fourthMain
                  : Colors.grey.shade400,
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

  Widget _buildDateSelection() {
    return Obx(() {
      final selectedDate = controller.selectedDate.value;

      return GestureDetector(
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: Get.context!,
            initialDate:
                selectedDate ?? DateTime.now().add(const Duration(days: 1)),
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
              color: selectedDate != null
                  ? AppColor.fourthMain
                  : Colors.grey.shade400,
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
                    ? DateFormat('EEEE, dd/MM/yyyy', 'vi_VN')
                        .format(selectedDate)
                    : 'Chọn ngày khám',
                style: TextStyle(
                  color: selectedDate != null ? Colors.black : Colors.grey,
                  fontSize: 16,
                  fontWeight: selectedDate != null
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTimeSlotSelection() {
    return Obx(() {
      final selectedTimeSlot = controller.selectedTimeSlot.value;
      final timeSlots = controller.timeSlots;

      if (controller.selectedDate.value == null) {
        return const Center(child: Text('Vui lòng chọn ngày'));
      }
      if (timeSlots.isEmpty) {
        return const Center(child: Text('Không có khung giờ trống'));
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
        ),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final slot = timeSlots[index];
          final isSelected = selectedTimeSlot == slot;
          return GestureDetector(
            onTap: () => controller.selectTimeSlot(slot),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[700] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.13),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  slot,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  //==================== Step 2: Select Patient Profile ====================Widget _buildStep2Content() {
  Widget _buildStep2Content() {
    return Column(
      children: [
        // PHẦN TIÊU ĐỀ
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Chọn hồ sơ bệnh nhân cho lịch khám',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // DANH SÁCH BỆNH NHÂN
        Expanded(
          child: Obx(
            () {
              // Loading indicator
              if (controller.isLoadingPatients.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // Debug: show raw data for test
              print('Patients length: ${controller.patients.length}');
              // Nếu rỗng
              if (controller.patients.isEmpty) {
                return _buildEmptyPatientList();
              }
              // Nếu có data
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.patients.length,
                itemBuilder: (context, index) {
                  final patient = controller.patients[index];
                  return Obx(() {
                    final isSelected =
                        controller.selectedPatient.value?.uuid == patient.uuid;
                    return GestureDetector(
                      onTap: () => controller.selectPatient(patient),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColor.fourthMain
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? AppColor.fourthMain.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Avatar giới tính
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColor.fourthMain.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        patient.gender == 'Nam'
                                            ? Icons.man
                                            : Icons.woman,
                                        color: AppColor.fourthMain,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Thông tin bệnh nhân
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          patient.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        _buildInfoRow(Icons.cake,
                                            'Ngày sinh: ${patient.dob}'),
                                        const SizedBox(height: 4),
                                        _buildInfoRow(
                                          Icons.phone,
                                          patient.phone != null &&
                                                  patient.phone!.isNotEmpty
                                              ? 'SĐT: ${patient.phone}'
                                              : 'Chưa có SĐT',
                                        ),
                                        const SizedBox(height: 4),
                                        _buildInfoRow(
                                          Icons.home,
                                          patient.address != null &&
                                                  patient.address!.isNotEmpty
                                              ? 'Địa chỉ: ${patient.address}'
                                              : 'Chưa có địa chỉ',
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Nút tuỳ chọn (sửa/xoá)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(Icons.settings,
                                    size: 20, color: Colors.grey),
                                onPressed: () {
                                  _showPatientOptionsBottomSheet(
                                      context, patient as Patient);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              );
            },
          ),
        ),

        // NÚT THÊM VÀ TIẾP TỤC
        Container(
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
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Get.toNamed(Routes.personal),
                  icon: const Icon(Icons.add),
                  label: const Text('THÊM HỒ SƠ BỆNH NHÂN'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(color: AppColor.fourthMain),
                    foregroundColor: AppColor.fourthMain,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => _buildContinueButton(
                    'TIẾP TỤC',
                    () {
                      controller.nextStep();
                    },
                    enabled: controller.selectedPatient.value != null,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  void _showPatientOptionsBottomSheet(BuildContext context, Patient patient) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Chỉnh sửa hồ sơ'),
              onTap: () {
                Get.back();
                // Navigate to edit screen
                Get.toNamed(Routes.personal, arguments: patient);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Xoá hồ sơ'),
              onTap: () {
                Get.back();
                _showDeleteConfirmationDialog(patient);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                child: const Text('HỦY'),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Patient patient) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text('Bạn có chắc chắn muốn xoá hồ sơ ${patient.name}?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('HỦY'),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deletePatient(patient);
            },
            child: const Text('XOÁ', style: TextStyle(color: Colors.red)),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPatientList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có hồ sơ bệnh nhân nào',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(Routes.personal),
            icon: const Icon(Icons.add),
            label: const Text('THÊM HỒ SƠ BỆNH NHÂN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.fourthMain,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Step 3: Confirm Appointment ====================
  Widget _buildStep3Content() {
    final patient = controller.selectedPatient.value;
    final doctor = controller.selectedDoctor.value;
    final department = controller.selectedDepartment.value;
    final service = controller.selectedService.value;
    final date = controller.selectedDate.value;
    final timeSlot = controller.selectedTimeSlot.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Patient info
          _buildConfirmCard(
            title: 'Thông tin bệnh nhân',
            icon: Icons.person,
            child: Column(
              children: [
                _buildConfirmItem('Họ tên', patient?.name ?? ''),
                _buildConfirmItem('SĐT', patient?.phone ?? ''),
                _buildConfirmItem('Ngày sinh', patient?.dob ?? ''),
                _buildConfirmItem('Địa chỉ', patient?.address ?? ''),
              ],
            ),
          ),

          // Doctor info
          _buildConfirmCard(
            title: 'Thông tin bác sĩ',
            icon: Icons.local_hospital,
            child: Column(
              children: [
                _buildConfirmItem('Bác sĩ', doctor?.user.name ?? ''),
                _buildConfirmItem('Chuyên khoa', department?.name ?? ''),
                _buildConfirmItem('Điện thoại', doctor?.user.phone ?? ''),
              ],
            ),
          ),

          // Appointment details
          _buildConfirmCard(
            title: 'Thông tin lịch hẹn',
            icon: Icons.calendar_today,
            child: Column(
              children: [
                _buildConfirmItem('Dịch vụ', service?.name ?? ''),
                _buildConfirmItem('Ngày khám',
                    date != null ? DateFormat('dd/MM/yyyy').format(date) : ''),
                _buildConfirmItem('Giờ khám', timeSlot ?? ''),
              ],
            ),
          ),

          // Payment summary
          _buildConfirmCard(
            title: 'Tổng thanh toán',
            icon: Icons.payment,
            child: Column(
              children: [
                _buildPriceItem(
                    'Phí khám bệnh', service?.price?.toDouble() ?? 0),
                _buildPriceItem('Phí dịch vụ', 0),
                const Divider(height: 24),
                _buildPriceItem('Tổng cộng', service?.price?.toDouble() ?? 0,
                    isTotal: true),
              ],
            ),
          ),

          // Confirm button
          _buildContinueButton(
            'Tiếp Tục',
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
    final patient = controller.selectedPatient.value;
    final hospital = controller.selectedHospital.value;
    final clinic = controller.selectedClinic.value;
    final vaccinationCenter = controller.selectedVaccinationCenter.value;
    final service = controller.selectedService.value;
    final date = controller.selectedDate.value;
    final timeSlot = controller.selectedTimeSlot.value;

    // Lấy tên nơi khám phù hợp
    String placeName = '';
    if (controller.selectedPlaceType.value == 'hospital') {
      placeName = hospital?.name ?? '';
    } else if (controller.selectedPlaceType.value == 'clinic') {
      placeName = clinic?.name ?? '';
    } else if (controller.selectedPlaceType.value == 'vaccination') {
      placeName = vaccinationCenter?.name ?? '';
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Appointment summary
                  _buildConfirmCard(
                    title: 'Thông tin đặt lịch',
                    icon: Icons.info,
                    child: Column(
                      children: [
                        _buildConfirmItem('Bệnh nhân', patient?.name ?? ''),
                        _buildConfirmItem('Nơi khám', placeName),
                        _buildConfirmItem('Dịch vụ', service?.name ?? ''),
                        _buildConfirmItem(
                          'Ngày khám',
                          date != null
                              ? DateFormat('dd/MM/yyyy').format(date)
                              : '',
                        ),
                        _buildConfirmItem('Giờ khám', timeSlot ?? ''),
                        const SizedBox(height: 12),
                        _buildPriceItem(
                          'Tổng thanh toán',
                          service?.price?.toDouble() ?? 0,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  // Payment method selector
                  _buildConfirmCard(
                    title: 'Hình thức thanh toán',
                    icon: Icons.payment,
                    child: Obx(() => ListTile(
                          leading: Icon(
                            controller.selectedPaymentMethod.value == 'online'
                                ? Icons.credit_card
                                : Icons.money,
                            color: Colors.blue,
                          ),
                          title: Text(
                            controller.selectedPaymentMethod.value == 'online'
                                ? 'Thanh toán PayOS'
                                : 'Thanh toán tại bệnh viện',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            controller.selectedPaymentMethod.value == 'online'
                                ? 'Thẻ ATM/VISA/Mastercard'
                                : 'Khi đến khám',
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            _showPaymentMethodBottomSheet();
                          },
                        )),
                  ),

                  // Thêm khoảng trống phía dưới
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: _buildContinueButton(
            'THANH TOÁN',
            () async {
              if (controller.selectedPaymentMethod.value == 'online') {
                // Thanh toán online (PayOS): Tự lo hết
                await controller.handlePayOS();
              } else {
                // Tiền mặt: làm thủ công từng bước
                final appointmentId = await controller.addAppointment();
                print('AppointmentId: $appointmentId');
                if (appointmentId != null) {
                  final paymentSaved =
                      await controller.savePayment(appointmentId);
                  print('paymentSaved: $paymentSaved');
                  if (paymentSaved) {
                    controller
                        .completePayment(); // show thông báo hoặc chuyển màn hình
                  } else {
                    Get.snackbar('Lỗi', 'Không thể lưu thông tin thanh toán!');
                  }
                }
              }
            },
          )),
    );
  }

  void _showPaymentMethodBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Chọn hình thức thanh toán',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() => _buildPaymentMethodOption(
                  icon: Icons.credit_card,
                  title: 'Thanh toán online',
                  subtitle: 'Thẻ ATM/VISA/Mastercard',
                  isSelected:
                      controller.selectedPaymentMethod.value == 'online',
                  onTap: () {
                    controller.selectedPaymentMethod.value = 'online';
                    Get.back();
                  },
                )),
            const Divider(height: 1),
            Obx(() => _buildPaymentMethodOption(
                  icon: Icons.money,
                  title: 'Thanh toán tại bệnh viện',
                  subtitle: 'Khi đến khám',
                  isSelected: controller.selectedPaymentMethod.value == 'cash',
                  onTap: () {
                    controller.selectedPaymentMethod.value = 'cash';
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.black,
          )),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.blue)
          : null,
    );
  }
}
