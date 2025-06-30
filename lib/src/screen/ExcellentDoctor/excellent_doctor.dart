import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/vaccination_center_model.dart';
import 'package:ebookingdoc/src/widgets/controller/excellent_doctor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/doctor_model.dart';

class ExcellentDoctor extends StatelessWidget {
  final controller = Get.put(ExcellentDoctorController());
  final TextEditingController searchController = TextEditingController();

  ExcellentDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    if (args != null) {
      if (args['hospitals'] == true) {
        controller.topTabIndex.value = 1; // tab Bệnh viện
      } else if (args['clinics'] == true) {
        controller.topTabIndex.value = 2; // tab Phòng khám
      } else if (args['vaccines'] == true) {
        controller.topTabIndex.value = 3; // tab Tiêm chủng
      } else {
        controller.topTabIndex.value = 0; // tab Bác sĩ (mặc định)
      }
    }
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColor.fivethMain,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: AppColor.fourthMain,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          title: Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColor.main,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bác sĩ, chuyên khoa, bệnh viện...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: AppColor.fourthMain),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: controller.search,
            ),
          ),
        ),
        body: Column(
          children: [
            _buildTopTabs(),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabs() {
    final tabs = ['Bác sĩ', 'Bệnh viện', 'Phòng khám', 'Trung tâm tiêm chủng'];

    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = controller.topTabIndex.value == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => controller.changeTab(index),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.fourthMain
                          : AppColor.main, // Nền màu xanh khi chọn
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColor.fourthMain), // Viền màu xanh
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColor.fourthMain, // Chữ trắng khi chọn
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ));
  }

  Widget _buildTabContent() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      }

      switch (controller.topTabIndex.value) {
        case 0:
          return _buildDoctorsContent();
        case 1:
          return _buildHospitalsContent();
        case 2:
          return _buildClinicsContent();
        case 3:
          return _buildVaccinationContent();
        default:
          return Container();
      }
    });
  }

  Widget _buildDoctorsContent() {
    if (controller.doctors.isEmpty) {
      return _buildEmptyState('Không tìm thấy bác sĩ nào');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: controller.doctors.length,
      itemBuilder: (context, index) {
        return _buildDoctorCard(controller.doctors[index]);
      },
    );
  }

  Widget _buildHospitalsContent() {
    if (controller.hospitals.isEmpty) {
      return _buildEmptyState('Không tìm thấy bệnh viện nào');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: controller.hospitals.length,
      itemBuilder: (context, index) {
        return _buildHospitalCard(controller.hospitals[index]);
      },
    );
  }

  Widget _buildClinicsContent() {
    if (controller.clinics.isEmpty) {
      return _buildEmptyState('Không tìm thấy phòng khám nào');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: controller.clinics.length,
      itemBuilder: (context, index) {
        return _buildClinicCard(controller.clinics[index]);
      },
    );
  }

  Widget _buildVaccinationContent() {
    if (controller.vaccinationCenters.isEmpty) {
      return _buildEmptyState('Không tìm thấy trung tâm tiêm chủng nào');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: controller.vaccinationCenters.length,
      itemBuilder: (context, index) {
        return _buildVaccinationCard(controller.vaccinationCenters[index]);
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.viewDoctorDetails(doctor.uuid),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF3366FF).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        doctor.image ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.person,
                            size: 36, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.introduce ?? 'Chưa có thông tin',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1A2E55),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Kinh nghiệm: ${doctor.experience ?? 0} năm',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Đã chữa trị: ${doctor.patientCount ?? 0} bệnh nhân',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => controller.viewDoctorDetails(doctor.uuid),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(color: AppColor.fourthMain),
                    ),
                    child: Text("Xem chi tiết",
                        style: TextStyle(
                            fontSize: 14, color: AppColor.fourthMain)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () =>
                        controller.bookDoctorAppointment(doctor, 'doctor'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.fourthMain,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Đặt lịch ngay',
                        style: TextStyle(fontSize: 14, color: AppColor.main)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalCard(Hospital hospital) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => controller.viewHospitalDetails(hospital),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        hospital.image ?? '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.medical_services,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Thông tin bệnh viện
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hospital.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Địa chỉ
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  hospital.address,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Đánh giá
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Nút bấm
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => controller.viewHospitalDetails(hospital),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: AppColor.fourthMain),
                      ),
                      child: Text(
                        "Xem chi tiết",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.fourthMain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        print(
                            'DEBUG | Button pressed hospital: ${hospital.toJson()}');
                        controller.bookHospitalAppointment(
                            hospital, 'hospital');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.fourthMain,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Đặt lịch khám",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.main,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClinicCard(Clinic clinic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => controller.viewClinicDetails(clinic),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hình ảnh
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    clinic.image ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.medical_services,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Thông tin phòng khám và nút bấm
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinic.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              clinic.address,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () =>
                                controller.viewClinicDetails(clinic),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: AppColor.fourthMain),
                            ),
                            child: Text(
                              "Xem chi tiết",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColor.fourthMain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              print(
                                  'DEBUG | Button pressed hospital: ${clinic.toJson()}');
                              controller.bookClinicAppointment(
                                  clinic, 'hospital');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.fourthMain,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Đặt lịch khám",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColor.main,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVaccinationCard(VaccinationCenter vaccina) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => controller.viewVaccinaDetails(vaccina),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          (vaccina.image != null && vaccina.image!.isNotEmpty)
                              ? Image.network(
                                  vaccina.image!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.medical_services,
                                          color: Colors.white),
                                    );
                                  },
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.medical_services,
                                      color: Colors.white),
                                ),
                    ),
                    const SizedBox(width: 12),

                    // Thông tin trung tâm tiêm chủng
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tên trung tâm
                          Text(
                            vaccina.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Địa chỉ
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  vaccina.address,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Text(
                            (vaccina.status == "open") ? "Đang mở" : "Đã đóng",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: (vaccina.status == "open")
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => controller.viewVaccinaDetails(vaccina),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: AppColor.fourthMain),
                      ),
                      child: Text(
                        "Xem chi tiết",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.fourthMain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => controller.bookVaccinationAppointment(
                          vaccina, 'vaccination'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.fourthMain,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Đặt lịch tiêm",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.main,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
