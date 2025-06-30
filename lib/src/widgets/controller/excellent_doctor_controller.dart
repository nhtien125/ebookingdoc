import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/Doctorservice.dart';
import 'package:ebookingdoc/src/constants/services/HospitalService.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/constants/services/vaccination_center_service.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/vaccination_center_model.dart';
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
  final RxList<VaccinationCenter> vaccinationCenters =
      <VaccinationCenter>[].obs;

  // Filter option
  final RxString filterOption = 'Tất cả'.obs;

  final DoctorService doctorService = DoctorService();
  final HospitalService hospitalService = HospitalService();
  final ClinicService clinicService = ClinicService();
  final VaccinationCenterService vaccinationCenterService =
      VaccinationCenterService();

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
    await fetchVaccinationCenterFromApi();
    isLoading(false);
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

  Future<void> fetchVaccinationCenterFromApi() async {
    try {
      vaccinationCenters.value =
          await vaccinationCenterService.getAllVaccinationCenters();
    } catch (e) {
      print('Lỗi khi lấy danh sách trung tâm tiêm chủng: $e');
      vaccinationCenters.clear();
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
    final filteredVaccinas = vaccinationCenters.where((v) {
      return v.name.toLowerCase().contains(query) ||
          v.address.toLowerCase().contains(query);
    }).toList();

    vaccinationCenters.value = filteredVaccinas;
  }

  void bookDoctorAppointment(Doctor doctor, String type) {
    Get.toNamed(
      Routes.appointmentScreen,
      arguments: {
        'doctor': doctor.toJson(),
      },
    );
  }

  void bookHospitalAppointment(Hospital hospital, String type) {
    print('DEBUG | Truyền hospital: ${hospital.toJson()}');
    Get.toNamed(
      Routes.appointmentScreen,
      arguments: {
        'hospital': hospital.toJson(),
        'selectedPlaceType': 'hospital', // Thêm type vào arguments
      },
    );
  }

  void bookClinicAppointment(Clinic clinic, String type) {
    print('DEBUG | Truyền clinic: ${clinic.toJson()}');
    Get.toNamed(
      Routes.appointmentScreen,
      arguments: {
        'clinic': clinic.toJson(),
        'selectedPlaceType': 'clinic', // Thêm type vào arguments
      },
    );
  }

  void bookVaccinationAppointment(VaccinationCenter vaccination, String type) {
    print('DEBUG | Truyền vaccination: ${vaccination.toJson()}');
    Get.toNamed(
      Routes.appointmentScreen,
      arguments: {
        'vaccination_center]': vaccination.toJson(),
        'selectedPlaceType': 'vaccination', // Thêm type vào arguments
      },
    );
  }

  void bookAppointment(dynamic item, String type) {
    String uuid = '';
    String? userId;
    String? doctorId;

    if (item is Map) {
      uuid = item['uuid'] ?? '';
      userId = item['user_id'];
      doctorId = item['uuid']; // Nếu là doctor thì uuid chính là doctorId
    } else {
      uuid = item.uuid ?? '';
      userId = item.userId;
      doctorId = item.uuid; // Nếu là doctor thì uuid chính là doctorId
    }

    print(
        'DEBUG | bookAppointment: uuid = $uuid, userId = $userId, doctorId = $doctorId, type = $type');

    Get.toNamed(
      Routes.appointmentScreen,
      arguments: {
        'uuid': uuid,
        'userId': userId,
        'doctorId': doctorId,
        'type': type,
      },
    );
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

  void viewHospitalDetails(Hospital hospital) {
    print('DEBUG | Truyền hospital sang chi tiết: ${hospital.toJson()}');
    Get.toNamed(Routes.detailhospital, arguments: hospital.toJson());
  }

  void viewClinicDetails(Clinic clinic) {
    print('DEBUG | Truyền clinic sang chi tiết: ${clinic.toJson()}');
    Get.toNamed(Routes.detailhospital, arguments: clinic.toJson());
  }

  void viewVaccinaDetails(VaccinationCenter vaccinationcenter) {
    Get.toNamed(Routes.detailhospital, arguments: vaccinationcenter.toJson());
  }
}
