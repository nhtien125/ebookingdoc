import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/data/model/appointment_model.dart';
import 'package:ebookingdoc/src/data/model/article_model.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/medical_service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // State variables
  final RxInt selectedIndex = 0.obs;
  final RxInt currentCarouselIndex = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasUpcomingAppointment = false.obs;

  final RxList<Doctor> featuredDoctors = <Doctor>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, String>> filteredResults =
      <Map<String, String>>[].obs;

  final List<Map<String, String>> allSearchableItems = [
    {'name': 'Bác sĩ Nguyễn Văn Chiến', 'type': 'Bác sĩ'},
    {'name': 'Bệnh viện Bạch Mai', 'type': 'Bệnh viện'},
    {'name': 'Phòng khám Đa khoa Medlatec', 'type': 'Phòng khám'},
    {'name': 'Trung tâm tiêm chủng Quốc gia', 'type': 'Trung tâm tiêm chủng'},
    // Có thể mở rộng thêm các mục từ các model sẵn có như recommendedHospitals, nearestClinics, featuredDoctors...
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
      rating: 4.7,
      distance: 1.2,
    ),
    Clinic(
      id: '2',
      name: 'Phòng khám Chuyên khoa Nội Hồng Ngọc',
      address: '55 Yên Ninh, Ba Đình, Hà Nội',
      imageUrl: 'assets/images/carosel1.jpg',
      rating: 5.0,
      distance: 0.8,
    ),
    Clinic(
      id: '3',
      name: 'Phòng khám Đa khoa Quốc tế Thu Cúc',
      address: '286 Thụy Khuê, Tây Hồ, Hà Nội',
      imageUrl: 'assets/images/carosel2.jpg',
      rating: 4.9,
      distance: 2.1,
    ),
  ];

  final List<MedicalService> medicalServices = [
    MedicalService(
      id: '1',
      name: 'Đặt khám tại cơ sở',
      icon: SvgPicture.asset(
        'assets/icons/tongquat.svg',
        height: 20,
        width: 20,
      ),
      color: AppColor.fourthMain,
    ),
    MedicalService(
      id: '2',
      name: 'Đặt khám tại nhà',
      icon: SvgPicture.asset(
        'assets/icons/chuyenkhoa.svg',
        height: 20,
        width: 20,
      ),
      color: AppColor.fourthMain,
    ),
    MedicalService(
      id: '3',
      name: 'Đặt lịch xét nghiệm',
      icon: SvgPicture.asset(
        'assets/icons/xetnghiem.svg',
        height: 20,
        width: 20,
      ),
      color: AppColor.fourthMain,
    ),
    MedicalService(
      id: '4',
      name: 'Đặt bác sĩ',
      icon: SvgPicture.asset(
        'assets/icons/nhakhoa.svg',
        height: 20,
        width: 20,
      ),
      color: AppColor.fourthMain,
    ),
    MedicalService(
      id: '5',
      name: 'Gói khám sức khoẻ',
      icon: SvgPicture.asset(
        'assets/icons/tiemchung.svg',
        height: 20,
        width: 20,
      ),
      color: AppColor.fourthMain,
    ),
    MedicalService(
      id: '6',
      name: 'Sống khoẻ tiểu đường',
      icon: SvgPicture.asset(
        'assets/icons/tieuduong.svg',
        height: 20,
        width: 20,
      ),
      color: AppColor.fourthMain,
    ),
  ];

  final List<Article> healthArticles = [
    Article(
      id: '1',
      title: '10 cách tăng cường hệ miễn dịch mùa dịch',
      imageUrl: 'assets/images/carosel4.jpg',
      publishDate: '20/04/2025',
    ),
    Article(
      id: '2',
      title: 'Dấu hiệu nhận biết sớm bệnh tim mạch',
      imageUrl: 'assets/images/carosel5.jpg',
      publishDate: '18/04/2025',
    ),
    Article(
      id: '3',
      title: 'Chế độ dinh dưỡng cho người tiểu đường',
      imageUrl: 'assets/images/10cpntm.jpg',
      publishDate: '15/04/2025',
    ),
  ];

  final List<Appointment> upcomingAppointments = [
    Appointment(
      id: '1',
      doctorName: 'BS. Nguyễn Thị Nguyệt',
      specialtyName: 'Tim mạch',
      doctorImageUrl: 'assets/images/bs4.jpg',
      dateTime: '10:00, 25/04/2025',
    ),
    Appointment(
      id: '2',
      doctorName: 'BS. Trần Thanh Long',
      specialtyName: 'Nhi khoa',
      doctorImageUrl: 'assets/images/bs5.jpg',
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

    featuredDoctors.value = [
      Doctor(
        id: '1',
        title: "TS. BS",
        name: 'BS. Nguyễn Văn Chiến',
        specialty: 'Tổng quát',
        imageUrl: 'assets/images/bs4.jpg',
        rating: 4.8,
        experience: '15 năm kinh nghiệm',
        hospital: 'Bệnh viện Bạch Mai',
      ),
      Doctor(
        id: '2',
        title: "PGS. TS. BS",
        name: 'BS. Phạm Ngọc Ánh',
        specialty: 'Tim mạch',
        imageUrl: 'assets/images/bs5.jpg',
        rating: 4.8,
        experience: '15 năm kinh nghiệm',
        hospital: 'Bệnh viện Bạch Mai',
      ),
      Doctor(
        id: '3',
        title: "GS. PGS. BS",
        name: 'BS. Ngô Diệu Linh',
        specialty: 'Nhi khoa',
        imageUrl: 'assets/images/bs6.jpg',
        rating: 4.8,
        experience: '15 năm kinh nghiệm',
        hospital: 'Bệnh viện Bạch Mai',
      ),
      Doctor(
        id: '4',
        title: "BS. CK2",
        name: 'BS. Đào Khánh Toàn',
        specialty: 'Nội tiết',
        imageUrl: 'assets/images/bs7.jpg',
        rating: 4.8,
        experience: '15 năm kinh nghiệm',
        hospital: 'Bệnh viện Bạch Mai',
      ),
    ];
  }

  void onSearchPressed() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      filteredResults.clear();
      return;
    }
    filteredResults.value = allSearchableItems
        .where((item) => item['name']!.toLowerCase().contains(query))
        .toList();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
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
    Get.toNamed(Routes.notification);
  }

  void updateCarouselIndex(int index) {
    currentCarouselIndex.value = index;
  }

  // Detail view methods
  void viewDoctorDetails(String doctorId) {
    Get.toNamed(Routes.detaildoctor, arguments: doctorId);
  }

  void viewHospitalDetails(String hospitalId) {
    Get.toNamed(Routes.appointmentScreen);
  }

  void viewClinicDetails(String clinicId) {
    Get.toNamed(Routes.appointmentScreen);
  }

  void viewArticleDetails(String articleId) {
    Get.toNamed(Routes.news);}

  void viewAppointmentDetails(String appointmentId) {
    // Get.toNamed(Routes.APPOINTMENT_DETAIL, arguments: appointmentId);
  }

  // View all methods
  void viewAllDoctors() {
    Get.toNamed(Routes.excellentDoctor);
  }

  void viewAllHospitals() {
    Get.toNamed(Routes.excellentDoctor, arguments: {'hospitals': true});
  }

  void viewAllClinics() {
    Get.toNamed(Routes.excellentDoctor, arguments: {'clinics': true});
  }

  void viewAllVaccines() {
    Get.toNamed(Routes.excellentDoctor, arguments: {'vaccines': true});
  }

  void viewAllArticles() {
    Get.toNamed(Routes.news);
  }

  void viewAllAppointments() {
    Get.toNamed(Routes.appointment);
  }

  // Service selection
  void selectService(String serviceId) {
    Get.toNamed(Routes.excellentDoctor);
  }
}
