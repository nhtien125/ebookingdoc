// lib/Controller/Home/Excellent_doctor/excellent_doctor_controller.dart

import 'package:ebookingdoc/Models/doctor_model.dart';
import 'package:get/get.dart';

class ExcellentDoctorController extends GetxController {
  var doctorList = <Doctor>[].obs;
  var filteredDoctorList = <Doctor>[].obs;
  var filterOption = 'Tất cả'.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  void fetchDoctors() async {
    isLoading(true);
    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 1));

      // Add dummy data
      doctorList.value = [
        Doctor(
          id: '1',
          title: 'TS. BS',
          name: 'Đào Bùi Quý Quyền',
          imageUrl: 'assets/images/bs1.jpg',
          specialty: 'Răng-hàm-mặt',
          hospital: '242 Nguyễn Chí Thanh, Phường 2, Quận 10, Hồ Chí Minh',
          experience: '22 năm kinh nghiệm',

          rating: 5,
          // reviewCount: 78,
        ),
        Doctor(
          id: '3',
          title: 'ThS. BS',
          name: 'Lê Anh Tuấn',
          imageUrl: 'assets/images/bs2.jpg',
          specialty: 'Sản khoa',
          hospital: '12 Trần Phú, Phường 8, Quận 5, Hồ Chí Minh',
          experience: '30 năm kinh nghiệm',

          rating: 5,
          // reviewCount: 8,
        ),
        Doctor(
          id: '3',
          title: 'ThS. BS',
          name: 'Lê Anh Tuấn',
          imageUrl: 'assets/images/bs3.jpg',
          specialty: 'Sản khoa',
          hospital: '12 Trần Phú, Phường 8, Quận 5, Hồ Chí Minh',
          experience: '30 năm kinh nghiệm',

          rating: 5,
          // reviewCount: 78,
        ),
      ];

      filteredDoctorList.value = doctorList;
    } catch (e) {
      print('Không tìm thấy bác sĩ $e');
    } finally {
      isLoading(false);
    }
  }

  void searchDoctors(String query) {
    if (query.isEmpty) {
      doctorList.value = filteredDoctorList;
      return;
    }

    query = query.toLowerCase();
    doctorList.value = filteredDoctorList.where((doctor) {
      return doctor.name.toLowerCase().contains(query) ||
          doctor.specialty.toLowerCase().contains(query);
    }).toList();
  }

  void applyFilter() {
    if (filterOption.value == 'Tất cả') {
      doctorList.value = filteredDoctorList;
      return;
    }

    // Here you would implement the actual filtering logic based on
    // filterOption.value ('Bác sĩ', 'Bệnh viện', 'Phòng khám', etc.)
    // This is just a simulated implementation
    doctorList.value = filteredDoctorList;
    Get.snackbar('Đã áp dụng bộ lọc', 'Lọc theo: ${filterOption.value}',
        snackPosition: SnackPosition.BOTTOM);
  }

  void bookAppointment(Doctor doctor) {
    // Handle appointment booking
    print('Đặt lịch hẹn với bác sĩ ${doctor.name}');
    // In a real app, you would navigate to booking screen or call API
  }

  void resetFilter() {
    filterOption.value = 'Tất cả'; // Đặt lại về giá trị mặc định
    searchDoctors('');
  }
}
