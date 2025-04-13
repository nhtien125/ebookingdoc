import 'package:ebookingdoc/Models/appointment_model.dart';
import 'package:ebookingdoc/Models/article_model.dart';
import 'package:ebookingdoc/Models/carousel_item_model.dart';
import 'package:ebookingdoc/Models/clinic_model.dart';
import 'package:ebookingdoc/Models/doctor_model.dart';
import 'package:ebookingdoc/Models/hospital_model.dart';
import 'package:ebookingdoc/Models/medical_service_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // State variables
  final RxInt selectedIndex = 0.obs;
  final RxInt currentCarouselIndex = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasUpcomingAppointment = false.obs;

  // Mock data lists
  final List<CarouselItem> carouselItems = [
    CarouselItem(
      id: '1',
      imageUrl: 'assets/images/carousel7.jpg',
      title: 'Ưu đãi khám tổng quát 50%',
    ),
    CarouselItem(
      id: '2',
      imageUrl: 'assets/images/carousel8.jpg',
      title: 'Tư vấn sức khỏe miễn phí',
    ),
    CarouselItem(
      id: '3',
      imageUrl: 'assets/images/carousel6.jpg',
      title: 'Gói khám gia đình ưu đãi',
    ),
  ];

  final List<Doctor> featuredDoctors = [
    Doctor(
      id: '1',
      name: 'BS. Trần Văn B',
      specialty: 'Tim mạch',
      imageUrl: 'assets/images/doctor1.jpg',
      rating: 4.9,
    ),
    Doctor(
      id: '2',
      name: 'BS. Nguyễn Thị C',
      specialty: 'Nhi khoa',
      imageUrl: 'assets/images/doctor2.jpg',
      rating: 4.8,
    ),
    Doctor(
      id: '3',
      name: 'BS. Lê Văn D',
      specialty: 'Da liễu',
      imageUrl: 'assets/images/doctor3.jpg',
      rating: 4.7,
    ),
    Doctor(
      id: '4',
      name: 'BS. Phạm Thị E',
      specialty: 'Sản phụ khoa',
      imageUrl: 'assets/images/doctor4.jpg',
      rating: 4.9,
    ),
  ];

  final List<Hospital> recommendedHospitals = [
    Hospital(
      id: '1',
      name: 'Bệnh viện Đa khoa Quốc tế Vinmec',
      address: '458 Minh Khai, Hai Bà Trưng, Hà Nội',
      imageUrl: 'assets/images/carosel7.jpg',
      rating: 4.8,
      distance: 2.5,
    ),
    Hospital(
      id: '2',
      name: 'Bệnh viện Hữu nghị Việt Đức',
      address: '40 Tràng Thi, Hoàn Kiếm, Hà Nội',
      imageUrl: 'assets/images/carosel8.jpg',
      rating: 4.7,
      distance: 3.2,
    ),
    Hospital(
      id: '3',
      name: 'Bệnh viện Bạch Mai',
      address: '78 Giải Phóng, Đống Đa, Hà Nội',
      imageUrl: 'assets/images/carosel6.jpg',
      rating: 4.6,
      distance: 4.1,
    ),
  ];

  final List<Clinic> nearestClinics = [
    Clinic(
      id: '1',
      name: 'Phòng khám Đa khoa Medlatec',
      address: '42-44 Nghĩa Dũng, Ba Đình, Hà Nội',
      imageUrl: 'assets/images/vitaminD.jpg',
      isOpen: true,
      distance: 1.2,
    ),
    Clinic(
      id: '2',
      name: 'Phòng khám Chuyên khoa Nội Hồng Ngọc',
      address: '55 Yên Ninh, Ba Đình, Hà Nội',
      imageUrl: 'assets/images/carosel1.jpg',
      isOpen: false,
      distance: 0.8,
    ),
    Clinic(
      id: '3',
      name: 'Phòng khám Đa khoa Quốc tế Thu Cúc',
      address: '286 Thụy Khuê, Tây Hồ, Hà Nội',
      imageUrl: 'assets/images/carosel2.jpg',
      isOpen: true,
      distance: 2.1,
    ),
  ];

  final List<MedicalService> medicalServices = [
    MedicalService(
      id: '1',
      name: 'Khám tổng quát',
      icon: Icons.medical_services,
      color: Colors.blue,
    ),
    MedicalService(
      id: '2',
      name: 'Khám chuyên khoa',
      icon: Icons.science,
      color: Colors.green,
    ),
    MedicalService(
      id: '3',
      name: 'Xét nghiệm y học',
      icon: Icons.science,
      color: Colors.green,
    ),
    MedicalService(
      id: '4',
      name: 'khám nha khoa',
      icon: Icons.vaccines,
      color: Colors.green,
    ),
    MedicalService(
      id: '5',
      name: 'Tiêm chủng',
      icon: Icons.vaccines,
      color: Colors.purple,
    ),
    MedicalService(
      id: '6',
      name: 'Gói phẫu thuật',
      icon: Icons.fastfood,
      color: Colors.teal,
    ),
    MedicalService(
      id: '7',
      name: 'Vật lý trị liệu',
      icon: Icons.accessible,
      color: Colors.red,
    ),
    MedicalService(
      id: '8',
      name: 'Tư vấn dinh dưỡng',
      icon: Icons.fastfood,
      color: Colors.teal,
    ),
    MedicalService(
      id: '9',
      name: 'Sống khoẻ tiểu đường',
      icon: Icons.fastfood,
      color: Colors.teal,
    ),
  ];

  final List<Article> healthArticles = [
    Article(
      id: '1',
      title: '10 cách tăng cường hệ miễn dịch mùa dịch',
      imageUrl: 'assets/images/carosel4.jpg',
      category: 'Sức khỏe',
      publishDate: '20/04/2023',
    ),
    Article(
      id: '2',
      title: 'Dấu hiệu nhận biết sớm bệnh tim mạch',
      imageUrl: 'assets/images/carosel5.jpg',
      category: 'Tim mạch',
      publishDate: '18/04/2023',
    ),
    Article(
      id: '3',
      title: 'Chế độ dinh dưỡng cho người tiểu đường',
      imageUrl: 'assets/images/10cpntm.jpg',
      category: 'Dinh dưỡng',
      publishDate: '15/04/2023',
    ),
  ];

  final List<Appointment> upcomingAppointments = [
    Appointment(
      id: '1',
      doctorName: 'BS. Nguyễn Thị Nguyệt',
      specialtyName: 'Tim mạch',
      doctorImageUrl: 'assets/images/doctor1.jpg',
      dateTime: '10:00, 25/04/2025',
    ),
    Appointment(
      id: '2',
      doctorName: 'BS. Trần Thanh Long',
      specialtyName: 'Nhi khoa',
      doctorImageUrl: 'assets/images/doctor2.jpg',
      dateTime: '14:30, 25/04/2025',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Simulate loading data
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      hasUpcomingAppointment.value = upcomingAppointments.isNotEmpty;
    });
  }

  // Navigation methods
  void changeTabIndex(int index) {
    selectedIndex.value = index;
    // You can add navigation logic here if needed
  }

  void openBookingFlow() {
    // Get.toNamed(Routes.BOOKING);
  }

  void viewHistory() {
    // Get.toNamed(Routes.APPOINTMENT_HISTORY);
  }

  void viewMedications() {
    // Get.toNamed(Routes.MEDICATIONS);
  }

  void openConsultation() {
    // Get.toNamed(Routes.CONSULTATION);
  }

  void onNotificationPressed() {
    // Get.toNamed(Routes.NOTIFICATIONS);
  }

  void onSearchPressed() {
    // Get.toNamed(Routes.SEARCH);
  }

  // Data methods
  Future<void> refreshData() async {
    isLoading.value = true;
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  void updateCarouselIndex(int index) {
    currentCarouselIndex.value = index;
  }

  void selectCategory(String category) {
    // Implement category selection logic
    Get.snackbar('Đã chọn', category,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1));
  }

  // Detail view methods
  void viewDoctorDetails(String doctorId) {
    // Get.toNamed(Routes.DOCTOR_DETAIL, arguments: doctorId);
  }

  void viewHospitalDetails(String hospitalId) {
    // Get.toNamed(Routes.HOSPITAL_DETAIL, arguments: hospitalId);
  }

  void viewClinicDetails(String clinicId) {
    // Get.toNamed(Routes.CLINIC_DETAIL, arguments: clinicId);
  }

  void viewArticleDetails(String articleId) {
    // Get.toNamed(Routes.ARTICLE_DETAIL, arguments: articleId);
  }

  void viewAppointmentDetails(String appointmentId) {
    // Get.toNamed(Routes.APPOINTMENT_DETAIL, arguments: appointmentId);
  }

  // View all methods
  void viewAllDoctors() {
    // Get.toNamed(Routes.DOCTORS);
  }

  void viewAllHospitals() {
    // Get.toNamed(Routes.HOSPITALS);
  }

  void viewAllClinics() {
    // Get.toNamed(Routes.CLINICS);
  }

  void viewAllArticles() {
    // Get.toNamed(Routes.ARTICLES);
  }

  void viewAllAppointments() {
    // Get.toNamed(Routes.APPOINTMENTS);
  }

  // Service selection
  void selectService(String serviceId) {}
}
