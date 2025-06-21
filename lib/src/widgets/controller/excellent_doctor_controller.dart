import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/Doctorservice.dart';
import 'package:ebookingdoc/src/constants/services/HospitalService.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';

class ExcellentDoctorController extends GetxController {
  // Tab navigation state
  final RxInt topTabIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  // Data lists
  final RxList<Doctor> doctors = <Doctor>[].obs;
  final RxList<Hospital> hospitals = <Hospital>[].obs;
  final RxList<Clinic> clinics = <Clinic>[].obs;
  final RxList<Map<String, dynamic>> specialties = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> vaccinas = <Map<String, dynamic>>[].obs;

  // Filter option
  final RxString filterOption = 'Tất cả'.obs;

  final DoctorService doctorService = DoctorService();
  final HospitalService hospitalService = HospitalService();
  final ClinicService clinicService = ClinicService();
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    isLoading(true);
    await fetchDoctorsFromApi();
    await fetchHospitalFromApi();
    await fetchClinicFromApi();
    try {
      await Future.wait([
        fetchDoctorsFromApi(),
        fetchHospitalFromApi(),
        fetchClinicFromApi(),
        Future.delayed(const Duration(milliseconds: 800)),
      ]);
  
      // Load vaccinas data
      vaccinas.value = [
        {
          'id': '1',
          'name': 'Trung tâm tiêm chủng Long châu',
          'imageUrl': 'assets/images/tcLongChau.jpg',
          'address': '216 P.Thái Hà, Trung Liệt, Đống Đa, Hà Nội',
          'rating': 4.5,
          'isOpen': true,
        },
        {
          'id': '2',
          'name': 'Trung tâm tiêm chủng VNVC',
          'imageUrl': 'assets/images/tcVNVC.jpg',
          'address': '35 P.Lê Văn Thiêm, Thanh Xuân Trung, Thanh Xuân, Hà Nội',
          'rating': 4.3,
          'isOpen': true,
        },
        {
          'id': '3',
          'name': 'Phòng tiêm chủng Vắc xin Safpo',
          'imageUrl': 'assets/images/tcSappo.jpg',
          'address':
              '135 P.Lò Đúc, Phạm Đình Hổ, Hai Bà Trưng, Hà Nội, Vietnam',
          'rating': 4.6,
          'isOpen': false,
        },
      ];

      // Load specialties data
      specialties.value = [
        {
          'id': '1',
          'name': 'Nha khoa',
          'imageUrl': 'assets/images/specialty1.jpg',
          'description': 'Khám và điều trị các bệnh về răng miệng',
          'doctorCount': 48,
        },
        {
          'id': '2',
          'name': 'Da liễu',
          'imageUrl': 'assets/images/specialty2.jpg',
          'description': 'Khám và điều trị các bệnh về da',
          'doctorCount': 36,
        },
        {
          'id': '3',
          'name': 'Tai mũi họng',
          'imageUrl': 'assets/images/specialty3.jpg',
          'description': 'Khám và điều trị các bệnh về tai, mũi, họng',
          'doctorCount': 42,
        },
      ];
    } catch (e) {
      print('Lỗi khi tải dữ liệu: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchDoctorsFromApi() async {
    try {
      doctors.value = await doctorService.getAllDoctors();
    } catch (e) {
      print('Lỗi khi lấy danh sách bác sĩ: $e');
      doctors.clear();
    }
  }

  Future<void> fetchHospitalFromApi() async {
    try {
      hospitals.value = await hospitalService.getAllHospital();
    } catch (e) {
      print('Lỗi khi lấy danh sách bệnh viện: $e');
      doctors.clear();
    }
  }
  Future<void> fetchClinicFromApi() async {
    try {
      clinics.value = await clinicService.getAllClinic();
    } catch (e) {
      print('Lỗi khi lấy danh sách phòng khám: $e');
      doctors.clear();
    }
  }

  void changeTab(int index) {
    topTabIndex.value = index;
  }

  void search(String query) {
    searchQuery.value = query;

   
    switch (topTabIndex.value) {
      case 0: // Tất cả - tìm kiếm tất cả
        break;
      case 1: // Tại nhà - tìm kiếm bác sĩ
        searchDoctors(query);
        break;
      case 2: // Tại viện - tìm kiếm bệnh viện
        searchHospitals(query);
        break;
      case 3: // Chuyên khoa - tìm kiếm phòng khám
        searchClinics(query);
        break;
      case 4:
        searchVaccinas(query);
        break;
    }
  }

  void searchDoctors(String query) {
    // if (query.isEmpty) {
    //   fetchDoctorsFromApi();
    //   return;
    // }

    // query = query.toLowerCase();
    // final List<Doctor> filteredDoctors = [];

    // for (var doctor in doctors) {
    //   if ((doctor.name?.toLowerCase().contains(query) ?? false) ||
    //       (doctor.introduce?.toLowerCase().contains(query) ?? false)) {
    //     filteredDoctors.add(doctor);
    //   }
    // }

    // doctors.value = filteredDoctors;
  }

  void searchHospitals(String query) {
    if (query.isEmpty) {
      fetchData();
      return;
    }

    query = query.toLowerCase();
    final filteredHospitals = hospitals.where((hospital) {
      return hospital.name.toLowerCase().contains(query) ||
          hospital.address.toLowerCase().contains(query);
    }).toList();

    hospitals.value = filteredHospitals;
  }

  void searchClinics(String query) {
    if (query.isEmpty) {
      fetchData();
      return;
    }

    query = query.toLowerCase();
    final filteredClinics = clinics.where((clinic) {
      return clinic.name.toLowerCase().contains(query) ||
          clinic.address.toLowerCase().contains(query);
    }).toList();

    clinics.value = filteredClinics;
  }

  void searchVaccinas(String query) {
    if (query.isEmpty) {
      fetchData();
      return;
    }

    query = query.toLowerCase();
    final filteredVaccinas = vaccinas.where((v) {
      return v['name'].toString().toLowerCase().contains(query) ||
          v['address'].toString().toLowerCase().contains(query);
    }).toList();

    vaccinas.value = filteredVaccinas;
  }

  void bookAppointment(dynamic item, String type) {
    String name = '';

    if (type == 'doctor') {
      name = item.name;
    } else {
      name = item['name'];
    }
    // Chuyển hướng đến màn hình đặt lịch
    // Get.to(() => BookingScreen(item: item, type: type));
  }

  void applyFilter() {
    Get.snackbar(
      'Đã áp dụng bộ lọc',
      'Lọc theo: ${filterOption.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void resetFilter() {
    filterOption.value = 'Tất cả';
    searchQuery.value = '';
    fetchData();
  }

  void viewAllDoctors() {
    Get.toNamed(Routes.appointmentScreen);
  }

  void viewAllHospitals() {}

  void viewAllClinics() {}

  void viewDoctorDetails(String id) {
    Get.toNamed(Routes.detaildoctor, arguments: '$id');
  }

  void viewHospitalDetails(String id) {}

  void viewClinicDetails(String id) {}

  void viewVaccinaDetails(String id) {}
}
