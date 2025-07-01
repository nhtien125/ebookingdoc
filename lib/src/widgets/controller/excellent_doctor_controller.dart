import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/Doctorservice.dart';
import 'package:ebookingdoc/src/constants/services/HospitalService.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/constants/services/vaccination_center_service.dart';
import 'package:ebookingdoc/src/constants/services/specialization_service.dart';
import 'package:ebookingdoc/src/constants/services/user_service.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/vaccination_center_model.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:ebookingdoc/src/data/model/specialization_model.dart';

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

  // Lưu trữ thông tin bổ sung cho tìm kiếm và hiển thị
  final Map<String, String> doctorNames = {}; // Lưu userId -> name
  final Map<String, String> doctorSpecialties =
      {}; // Lưu userId -> specialty name
  final Map<String, String> doctorClinics = {}; // Lưu userId -> clinic name

  final DoctorService doctorService = DoctorService();
  final UserService userService = UserService();
  final SpecializationService specializationService = SpecializationService();
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
    isLoading.value = true;
    await Future.wait([
      fetchDoctorsFromApi(),
      fetchHospitalFromApi(),
      fetchClinicFromApi(),
      fetchVaccinationCenterFromApi(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchDoctorsFromApi() async {
    try {
      isLoading.value = true;
      final doctorList = await doctorService.getAllDoctors();
      if (doctorList.isEmpty) {
        if (kDebugMode) print('DEBUG | No doctors found from getAllDoctors');
        doctors.clear();
        doctorNames.clear();
        doctorSpecialties.clear();
        doctorClinics.clear();
        return;
      }

      final List<Doctor> updatedDoctors = [];
      doctorNames.clear();
      doctorSpecialties.clear();
      doctorClinics.clear();

      for (var doctor in doctorList) {
        final key = doctor.userId ?? doctor.uuid ?? '';
        String userName = 'Bác sĩ không xác định';
        String specialtyName = 'Chưa có chuyên khoa';
        String clinicName = 'Không có phòng khám';

        // Lấy tên bác sĩ
        if (doctor.userId?.isNotEmpty ?? false) {
          final userData = await userService.getUserById(doctor.userId!);
          userName = userData?.name ?? userName;
        }

        // Lấy tên chuyên khoa
        if (doctor.specializationId?.isNotEmpty ?? false) {
          final specialtyData =
              await specializationService.getById(doctor.specializationId!);
          specialtyName = specialtyData?.name ?? specialtyName;
        }

        // Lấy tên phòng khám
        if (doctor.clinicId?.isNotEmpty ?? false) {
          final clinicData = await clinicService.getById(doctor.clinicId!);
          clinicName = clinicData?.name ?? clinicName;
        }

        doctorNames[key] = userName;
        doctorSpecialties[key] = specialtyName;
        doctorClinics[key] = clinicName;

        updatedDoctors.add(doctor); // Sử dụng doctor gốc thay vì tạo mới
      }

      doctors.value = updatedDoctors;
      if (kDebugMode) print('DEBUG | Loaded ${doctors.length} doctors');
    } catch (e) {
      if (kDebugMode) print('Lỗi khi lấy danh sách bác sĩ: $e');
      doctors.clear();
      doctorNames.clear();
      doctorSpecialties.clear();
      doctorClinics.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHospitalFromApi() async {
    try {
      isLoading.value = true;
      final hospitalList = await hospitalService.getAllHospital();
      hospitals.value = hospitalList;
      if (kDebugMode) {
        print('DEBUG | Loaded ${hospitalList.length} hospitals');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi lấy danh sách bệnh viện: $e');
      }
      hospitals.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchClinicFromApi() async {
    try {
      isLoading.value = true;
      final clinicList = await clinicService.getAllClinic();
      clinics.value = clinicList;
      if (kDebugMode) {
        print('DEBUG | Loaded ${clinicList.length} clinics');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi lấy danh sách phòng khám: $e');
      }
      clinics.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchVaccinationCenterFromApi() async {
    try {
      isLoading.value = true;
      final vaccinationList =
          await vaccinationCenterService.getAllVaccinationCenters();
      vaccinationCenters.value = vaccinationList;
      if (kDebugMode) {
        print('DEBUG | Loaded ${vaccinationList.length} vaccination centers');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi lấy danh sách trung tâm tiêm chủng: $e');
      }
      vaccinationCenters.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    topTabIndex.value = index;
    searchQuery.value = ''; // Reset query khi đổi tab
    fetchData(); // Tải lại dữ liệu khi đổi tab
  }

  void search(String query) {
    searchQuery.value = query.trim();
    if (kDebugMode) {
      print('DEBUG | Search query: "$query", Tab index: ${topTabIndex.value}');
    }

    if (query.isEmpty) {
      fetchData();
      return;
    }

    switch (topTabIndex.value) {
      case 0: // Bác sĩ
        searchDoctors(query);
        break;
      case 1: // Bệnh viện
        searchHospitals(query);
        break;
      case 2: // Phòng khám
        searchClinics(query);
        break;
      case 3: // Trung tâm tiêm chủng
        searchVaccinas(query);
        break;
      default:
        fetchData();
        break;
    }
  }

  void searchDoctors(String query) {
    if (query.isEmpty) {
      fetchDoctorsFromApi();
      return;
    }

    query = query.toLowerCase();
    final filteredDoctors = doctors.where((doctor) {
      final key = doctor.userId ?? doctor.uuid;
      final name = doctorNames[key]?.toLowerCase() ?? '';
      final specialty = doctorSpecialties[key]?.toLowerCase() ?? '';
      final clinic = doctorClinics[key]?.toLowerCase() ?? '';
      final introduce = doctor.introduce?.toLowerCase() ?? '';
      return name.contains(query) ||
          specialty.contains(query) ||
          clinic.contains(query) ||
          introduce.contains(query);
    }).toList();

    if (kDebugMode) {
      print('DEBUG | Filtered doctors: ${filteredDoctors.length}');
    }
    doctors.value = filteredDoctors;
  }

  void searchHospitals(String query) {
    if (query.isEmpty) {
      fetchHospitalFromApi();
      return;
    }

    query = query.toLowerCase();
    final filteredHospitals = hospitals.where((hospital) {
      return (hospital.name?.toLowerCase().contains(query) ?? false) ||
          (hospital.address?.toLowerCase().contains(query) ?? false);
    }).toList();

    if (kDebugMode) {
      print('DEBUG | Filtered hospitals: ${filteredHospitals.length}');
    }
    hospitals.value = filteredHospitals;
  }

  void searchClinics(String query) {
    if (query.isEmpty) {
      fetchClinicFromApi();
      return;
    }

    query = query.toLowerCase();
    final filteredClinics = clinics.where((clinic) {
      return (clinic.name?.toLowerCase().contains(query) ?? false) ||
          (clinic.address?.toLowerCase().contains(query) ?? false);
    }).toList();

    if (kDebugMode) {
      print('DEBUG | Filtered clinics: ${filteredClinics.length}');
    }
    clinics.value = filteredClinics;
  }

  void searchVaccinas(String query) {
    if (query.isEmpty) {
      fetchVaccinationCenterFromApi();
      return;
    }

    query = query.toLowerCase();
    final filteredVaccinas = vaccinationCenters.where((v) {
      return (v.name?.toLowerCase().contains(query) ?? false) ||
          (v.address?.toLowerCase().contains(query) ?? false);
    }).toList();

    if (kDebugMode) {
      print('DEBUG | Filtered vaccination centers: ${filteredVaccinas.length}');
    }
    vaccinationCenters.value = filteredVaccinas;
  }

   void bookDoctorAppointment(Doctor doctor, String type) {
    Get.offAllNamed(
      Routes.appointmentScreen,
      arguments: {
        'doctor': doctor.toJson(),
      },
    );
  }

  void bookHospitalAppointment(Hospital hospital, String type) {
    if (kDebugMode) {
      print('DEBUG | Booking hospital appointment: ${hospital.toJson()}');
    }
    Get.offAllNamed(
      Routes.appointmentScreen,
      arguments: {
        'hospital': hospital.toJson(),
        'selectedPlaceType': 'hospital',
      },
    );
  }

  void bookClinicAppointment(Clinic clinic, String type) {
    if (kDebugMode) {
      print('DEBUG | Booking clinic appointment: ${clinic.toJson()}');
    }
    Get.offAllNamed(
      Routes.appointmentScreen,
      arguments: {
        'clinic': clinic.toJson(),
        'selectedPlaceType': 'clinic',
      },
    );
  }

  void bookVaccinationAppointment(VaccinationCenter vaccination, String type) {
    if (kDebugMode) {
      print('DEBUG | Booking vaccination appointment: ${vaccination.toJson()}');
    }
    Get.offAllNamed(
      Routes.appointmentScreen,
      arguments: {
        'vaccination_center': vaccination.toJson(),
        'selectedPlaceType': 'vaccination',
      },
    );
  }

  void bookAppointment(dynamic item, String type) {
    String uuid = '';
    String? userId;
    String? doctorId;

    if (item is Map) {
      uuid = item['uuid'] ?? '';
      userId = item['userId'];
      doctorId = item['uuid'];
    } else {
      uuid = item.uuid ?? '';
      userId = item.userId;
      doctorId = item.uuid;
    }

    if (kDebugMode) {
      print(
          'DEBUG | bookAppointment: uuid = $uuid, userId = $userId, doctorId = $doctorId, type = $type');
    }

    Get.offAllNamed(
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
    Get.offAllNamed(Routes.appointmentScreen);
  }

  void viewAllHospitals() {
    Get.offAllNamed(Routes.appointmentScreen);
  }

  void viewAllClinics() {
    Get.offAllNamed(Routes.appointmentScreen);
  }

  void viewDoctorDetails(String id) {
    if (kDebugMode) {
      print('DEBUG | Viewing doctor details for ID: $id');
    }
    Get.toNamed(Routes.detaildoctor, arguments: id);
  }

  void viewHospitalDetails(Hospital hospital) {
    if (kDebugMode) {
      print('DEBUG | Viewing hospital details: ${hospital.toJson()}');
    }
    Get.toNamed(Routes.detailhospital, arguments: hospital.toJson());
  }

  void viewClinicDetails(Clinic clinic) {
    if (kDebugMode) {
      print('DEBUG | Viewing clinic details: ${clinic.toJson()}');
    }
    Get.toNamed(Routes.detailhospital, arguments: clinic.toJson());
  }

  void viewVaccinaDetails(VaccinationCenter vaccinationcenter) {
    if (kDebugMode) {
      print(
          'DEBUG | Viewing vaccination center details: ${vaccinationcenter.toJson()}');
    }
    Get.toNamed(Routes.detailhospital, arguments: vaccinationcenter.toJson());
  }
}
