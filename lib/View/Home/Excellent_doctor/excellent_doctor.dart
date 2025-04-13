import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/Home/Excellent_doctor/excellent_doctor_controller.dart';

class ExcellentDoctor extends StatelessWidget {
  final controller = Get.put(ExcellentDoctorController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Color(0xFF3366FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
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
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm bác sĩ, chuyên khoa...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Color(0xFF3366FF)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: controller.searchDoctors,
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3366FF)),
            ),
          );
        }

        if (controller.doctorList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 16),
                Text(
                  'Không tìm thấy bác sĩ nào',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.doctorList.length,
          itemBuilder: (context, index) {
            final doctor = controller.doctorList[index];
            return _buildDoctorCard(doctor);
          },
        );
      }),
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
        onTap: () {},
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
                        color: Color(0xFF3366FF).withOpacity(0.2),
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
                        // Hàng đầu: chức danh và tên bác sĩ
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(0xFFE6F0FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                doctor.title ?? 'BS',
                                style: const TextStyle(
                                  color: Color(0xFF3366FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
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

                        // Ngôi sao đánh giá
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < (doctor.rating?.toInt() ?? 5)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(), // Placeholder
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
                      controller.bookAppointment(doctor);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3366FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Đặt lịch ngay',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bộ lọc',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2E55),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1),

              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    Obx(() => _buildFilterOption('Bác sĩ')),
                    Obx(() => _buildFilterOption('Bệnh viện')),
                    Obx(() => _buildFilterOption('Phòng khám')),
                    Obx(() => _buildFilterOption('Trung tâm tiêm chủng')),
                    Obx(() => _buildFilterOption('Tất cả')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Chỉ giữ lại nút "Áp dụng" và điều chỉnh để chiếm toàn bộ chiều rộng
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3366FF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(
                      double.infinity, 50), // Chiều cao 50 và chiều rộng tối đa
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  controller.applyFilter();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Áp dụng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String option) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          controller.filterOption.value = option;
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: controller.filterOption.value == option
                ? Color(0xFFE6F0FF)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: controller.filterOption.value == option
                  ? Color(0xFF3366FF)
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                controller.filterOption.value == option
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: controller.filterOption.value == option
                    ? Color(0xFF3366FF)
                    : Colors.grey,
              ),
              SizedBox(width: 12),
              Text(
                option,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1A2E55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
