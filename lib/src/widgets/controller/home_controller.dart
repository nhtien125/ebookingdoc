import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/ArticleService.dart';
import 'package:ebookingdoc/src/constants/services/Doctorservice.dart';
import 'package:ebookingdoc/src/constants/services/HospitalService.dart';
import 'package:ebookingdoc/src/constants/services/MedicalService.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/constants/services/user_service.dart';
import 'package:ebookingdoc/src/data/model/appointment_model.dart';
import 'package:ebookingdoc/src/data/model/article_model.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/medical_service_model.dart';
import 'package:ebookingdoc/src/data/model/specialization_model.dart';
import 'package:ebookingdoc/src/constants/services/specialization_service.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DoctorDisplay {
  final Doctor doctor;
  final User? user;
  final Specialization? specialization;

  DoctorDisplay({required this.doctor, this.user, this.specialization});
}

class HomeController extends GetxController {
  final RxList<Clinic> clinics = <Clinic>[].obs;
  final ClinicService _clinicService = ClinicService();
  final RxInt selectedIndex = 0.obs;
  final RxInt currentCarouselIndex = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasUpcomingAppointment = false.obs;
  final RxList<DoctorDisplay> featuredDoctors = <DoctorDisplay>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, String>> filteredResults =
      <Map<String, String>>[].obs;
  final HospitalService _hospitalService = HospitalService();
  final MedicalServiceService _medicalService = MedicalServiceService();
  final RxList<MedicalServiceModel> medicalserviceModel =
      <MedicalServiceModel>[].obs;
  final RxList<Hospital> hospitals = <Hospital>[].obs;
  final ArticleService _articleService = ArticleService();
  final RxList<Article> article = <Article>[].obs;
  final DoctorService _doctorService = DoctorService();
  final UserService _userService = UserService();
  final SpecializationService _specService = SpecializationService();

  final List<Map<String, String>> allSearchableItems = [
    {'name': 'Bác sĩ Nguyễn Văn Chiến', 'type': 'Bác sĩ'},
    {'name': 'Bệnh viện Bạch Mai', 'type': 'Bệnh viện'},
    {'name': 'Phòng khám Đa khoa Medlatec', 'type': 'Phòng khám'},
    {'name': 'Trung tâm tiêm chủng Quốc gia', 'type': 'Trung tâm tiêm chủng'},
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
    loadAllData();
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    await Future.wait([
      fetchDoctors(),
      fetchHospital(),
      fetchClinics(),
      fetchArticle(),
      fetchMedicalService()
    ]);
    isLoading.value = false;
  }

  Future<void> fetchDoctors() async {
    isLoading.value = true;
    featuredDoctors.clear();

    List<Doctor> doctors = await _doctorService.getAllDoctors();
    print('[DEBUG] Số lượng bác sĩ từ API: ${doctors.length}');

    for (var doc in doctors) {
      if ((doc.userId == null || doc.userId!.isEmpty) ||
          (doc.specializationId == null || doc.specializationId!.isEmpty)) {
        print('Bác sĩ ${doc.uuid} thiếu userId hoặc specializationId, bỏ qua!');
        continue; // bỏ qua bác sĩ này
      }

      final userFuture = _userService.getUserById(doc.userId!);
      final specFuture = _specService.getById(doc.specializationId!);

      final results = await Future.wait([userFuture, specFuture]);
      final user = results[0] as User?;
      final specialization = results[1] as Specialization?;

      featuredDoctors.add(
        DoctorDisplay(
          doctor: doc,
          user: user,
          specialization: specialization,
        ),
      );
      print('[DEBUG] Đã add bác sĩ: ${user?.name} - ${specialization?.name}');
    }

    print('[DEBUG] Tổng bác sĩ featured: ${featuredDoctors.length}');
    isLoading.value = false;
  }

  Future<void> fetchHospital() async {
    print('BẮT ĐẦU fetchHospital');
    isLoading.value = true;
    hospitals.clear();

    List<Hospital> result =
        (await _hospitalService.getAllHospital()).cast<Hospital>();
    hospitals.addAll(result);

    isLoading.value = false;
    print('KẾT THÚC fetchHospital');
  }

  Future<void> fetchMedicalService() async {
    print('BẮT ĐẦU MedicalService');
    isLoading.value = true;
    hospitals.clear();

    List<Hospital> result =
        (await _hospitalService.getAllHospital()).cast<Hospital>();
    hospitals.addAll(result);

    isLoading.value = false;
    print('KẾT THÚC fetchHospital');
  }

  Future<void> fetchClinics() async {
    clinics.clear();
    List<Clinic> result = await _clinicService.getAllClinic();
    clinics.addAll(result);
  }

  Future<void> fetchArticle() async {
    article.clear();
    List<Article> result = await _articleService.getAllArticles();
    article.addAll(result);
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

  Future<void> refreshData() => loadAllData();

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  void openBookingFlow() {}

  void viewHistory() {}

  void viewMedications() {}

  void openConsultation() {}

  void onNotificationPressed() {
    Get.toNamed(Routes.notification);
  }

  void updateCarouselIndex(int index) {
    currentCarouselIndex.value = index;
  }

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
    Get.toNamed(Routes.news);
  }

  void viewAppointmentDetails(String appointmentId) {}

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

  void selectService(String serviceId) {
    Get.toNamed(Routes.excellentDoctor);
  }
}
