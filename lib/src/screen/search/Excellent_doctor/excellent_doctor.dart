import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/controller/excellent_doctor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExcellentDoctor extends StatelessWidget {
  final controller = Get.put(ExcellentDoctorController());
  final TextEditingController searchController = TextEditingController();

  ExcellentDoctor({super.key});

  @override
  Widget build(BuildContext context) {
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
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_rounded,
                  color: Colors.white, size: 28),
              onPressed: () => _showFilterModal(context),
            ),
          ],
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
                      color: isSelected ? AppColor.grey : AppColor.main,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.fourthMain),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: AppColor.fourthMain,
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
    if (controller.vaccinas.isEmpty) {
      return _buildEmptyState('Không tìm thấy trung tâm tiêm chủng nào');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: controller.vaccinas.length,
      itemBuilder: (context, index) {
        return _buildHospitalCard(controller.vaccinas[index]);
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

  Widget _buildDoctorCard(dynamic doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.viewDoctorDetails(doctor.id),
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
                      child: Image.asset(
                        doctor.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[100],
                            child: Icon(Icons.person,
                                size: 36, color: Colors.grey[400]),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                doctor.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1A2E55),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Chuyên khoa
                        Text(
                          doctor.specialty,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Kinh nghiệm
                        Text(
                          doctor.experience,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Đánh giá và trạng thái (giống card phòng khám)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColor.fourthMain.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${doctor.rating ?? 5} ★',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.fourthMain,
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
              const SizedBox(height: 12),

              // Nút bấm "Xem chi tiết" và "Đặt lịch hẹn"
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      onPressed: () => controller.viewDoctorDetails(doctor.id),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: AppColor.fourthMain),
                      ),
                      child: GestureDetector(
                        onTap: () => controller.viewDoctorDetails(doctor.id),
                        child: Text(
                          "Xem chi tiết",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.fourthMain,
                          ),
                        ),
                      )),
                  const SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: () {
                        Get.snackbar(
                          'Đặt lịch hẹn',
                          'Bạn đã chọn bác sĩ ${doctor.name}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Color(0xFF3366FF),
                          colorText: Colors.white,
                          borderRadius: 12,
                          margin: const EdgeInsets.all(16),
                        );
                        controller.bookAppointment(doctor, 'doctor');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.fourthMain,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () => controller.viewAllDoctors(),
                        child: Text(
                          'Đặt lịch ngay',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.main,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalCard(Map<String, dynamic> hospital) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => controller.viewClinicDetails(hospital['id']),
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
                      child: Image.asset(
                        hospital['imageUrl'],
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
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Thông tin clinic
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tên phòng khám
                          Text(
                            hospital['name'],
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
                                  hospital['address'],
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

                          // Đánh giá và trạng thái
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColor.fourthMain.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${hospital['rating']} ★',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.fourthMain,
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
                const SizedBox(height: 12),

                // Nút bấm
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () =>
                          controller.viewClinicDetails(hospital['id']),
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
                      onPressed: () =>
                          controller.bookAppointment(hospital['id'], 'clinic'),
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

  Widget _buildClinicCard(Map<String, dynamic> clinic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => controller.viewClinicDetails(clinic['id']),
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
                      child: Image.asset(
                        clinic['imageUrl'],
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
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Thông tin clinic
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tên phòng khám
                          Text(
                            clinic['name'],
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
                                  clinic['address'],
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

                          // Đánh giá và trạng thái
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColor.fourthMain.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${clinic['rating']} ★',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.fourthMain,
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
                const SizedBox(height: 12),

                // Nút bấm
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () =>
                          controller.viewClinicDetails(clinic['id']),
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
                      onPressed: () =>
                          controller.bookAppointment(clinic['id'], 'clinic'),
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


  void _showFilterModal(BuildContext context) {
    final List<String> cities = [
      'Hồ Chí Minh',
      'Hà Nội',
      'Đà Nẵng',
      'Cần Thơ',
      'Hải Phòng'
    ];
    final List<String> serviceTypes = [
      'Bác sĩ',
      'Bệnh viện',
      'Phòng khám',
      'Trung tâm tiêm chủng'
    ];

    RxList<String> selectedCities = <String>[].obs;
    RxList<String> selectedServiceTypes = <String>[].obs;
    RxString selectedSortOption = 'Phổ biến'.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bộ lọc',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),

              // Lọc theo thành phố
              ExpansionTile(
                title: const Text('Thành phố',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  Obx(() => Wrap(
                        spacing: 8,
                        children: cities.map((city) {
                          final isSelected = selectedCities.contains(city);
                          return FilterChip(
                            label: Text(city),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                selectedCities.add(city);
                              } else {
                                selectedCities.remove(city);
                              }
                            },
                            selectedColor: AppColor.main.withOpacity(0.2),
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: isSelected ? AppColor.main : Colors.black,
                            ),
                          );
                        }).toList(),
                      )),
                ],
              ),

              // Lọc theo loại dịch vụ
              ExpansionTile(
                title: const Text('Loại dịch vụ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  Obx(() => Wrap(
                        spacing: 8,
                        children: serviceTypes.map((type) {
                          final isSelected =
                              selectedServiceTypes.contains(type);
                          return FilterChip(
                            label: Text(type),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                selectedServiceTypes.add(type);
                              } else {
                                selectedServiceTypes.remove(type);
                              }
                            },
                            selectedColor: AppColor.main.withOpacity(0.2),
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: isSelected ? AppColor.main : Colors.black,
                            ),
                          );
                        }).toList(),
                      )),
                ],
              ),

              // Sắp xếp
              ExpansionTile(
                title: const Text('Sắp xếp theo',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  Obx(() => Column(
                        children: [
                          RadioListTile(
                            title: const Text('Phổ biến'),
                            value: 'Phổ biến',
                            groupValue: selectedSortOption.value,
                            onChanged: (value) =>
                                selectedSortOption.value = value.toString(),
                          ),
                          RadioListTile(
                            title: const Text('Đánh giá cao'),
                            value: 'Đánh giá cao',
                            groupValue: selectedSortOption.value,
                            onChanged: (value) =>
                                selectedSortOption.value = value.toString(),
                          ),
                          RadioListTile(
                            title: const Text('Gần tôi'),
                            value: 'Gần tôi',
                            groupValue: selectedSortOption.value,
                            onChanged: (value) =>
                                selectedSortOption.value = value.toString(),
                          ),
                        ],
                      )),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        selectedCities.clear();
                        selectedServiceTypes.clear();
                        selectedSortOption.value = 'Phổ biến';
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: AppColor.main),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Đặt lại',
                        style: TextStyle(color: AppColor.main),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Áp dụng bộ lọc
                        controller.filterOption.value =
                            selectedServiceTypes.join(', ');
                        controller.applyFilter();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.main,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Áp dụng',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
