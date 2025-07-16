import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/DoctorService.dart';
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
  final RxBool hasError = false.obs;

  // Data lists
  final RxList<Doctor> doctors = <Doctor>[].obs;
  final RxList<Hospital> hospitals = <Hospital>[].obs;
  final RxList<Clinic> clinics = <Clinic>[].obs;
  final RxList<VaccinationCenter> vaccinationCenters = <VaccinationCenter>[].obs;
  final RxList<Doctor> allDoctors = <Doctor>[].obs;
  final RxList<Hospital> allHospitals = <Hospital>[].obs;
  final RxList<Clinic> allClinics = <Clinic>[].obs;
  final RxList<VaccinationCenter> allVaccinationCenters = <VaccinationCenter>[].obs;

  // Pagination variables
  final RxMap<int, int> currentPage = <int, int>{0: 1, 1: 1, 2: 1, 3: 1}.obs;
  final RxMap<int, int> totalPages = <int, int>{0: 1, 1: 1, 2: 1, 3: 1}.obs;
  final int itemsPerPage = 10;

  // Additional info for search and display
  final Map<String, String> doctorNames = {};
  final Map<String, String> doctorSpecialties = {};
  final Map<String, String> doctorClinics = {};
  final Map<String, String> imageDoctor = {};

  // Services
  final DoctorService doctorService = DoctorService();
  final UserService userService = UserService();
  final SpecializationService specializationService = SpecializationService();
  final HospitalService hospitalService = HospitalService();
  final ClinicService clinicService = ClinicService();
  final VaccinationCenterService vaccinationCenterService = VaccinationCenterService();

  // Debounce timer for search
  Timer? _debounce;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      await Future.wait([
        fetchDoctorsFromApi(),
        fetchHospitalFromApi(),
        fetchClinicFromApi(),
        fetchVaccinationCenterFromApi(),
      ]);
      updatePaginatedList();
    } catch (e) {
      if (kDebugMode) print('DEBUG | Error fetching data: $e');
      hasError.value = true;
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu. Vui lòng thử lại.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDoctorsFromApi() async {
    try {
      final cachedDoctors = _storage.read('doctors');
      if (cachedDoctors != null && searchQuery.value.isEmpty) {
        allDoctors.value = (cachedDoctors as List).map((e) => Doctor.fromJson(e)).toList();
        doctorNames.addAll(_storage.read('doctorNames') ?? {});
        imageDoctor.addAll(_storage.read('imageDoctor') ?? {});
        doctorSpecialties.addAll(_storage.read('doctorSpecialties') ?? {});
        doctorClinics.addAll(_storage.read('doctorClinics') ?? {});
        totalPages[0] = (allDoctors.length / itemsPerPage).ceil();
        if (kDebugMode) print('DEBUG | Loaded ${allDoctors.length} doctors from cache');
        return;
      }

      final doctorList = await doctorService.getAllDoctors();
      if (doctorList.isEmpty) {
        if (kDebugMode) print('DEBUG | No doctors found from getAllDoctors');
        allDoctors.clear();
        doctors.clear();
        doctorNames.clear();
        doctorSpecialties.clear();
        doctorClinics.clear();
        imageDoctor.clear();
        totalPages[0] = 1;
        return;
      }

      final List<Doctor> updatedDoctors = [];
      doctorNames.clear();
      doctorSpecialties.clear();
      doctorClinics.clear();
      imageDoctor.clear();

      for (var doctor in doctorList) {
        final key = doctor.userId ?? doctor.uuid ?? '';
        String userName = 'Bác sĩ không xác định';
        String specialtyName = 'Chưa có chuyên khoa';
        String clinicName = 'Không có phòng khám';
        String? image = 'assets/images/default_doctor.jpg';

        try {
          if (doctor.userId?.isNotEmpty ?? false) {
            final userData = await userService.getUserById(doctor.userId!);
            userName = userData?.name ?? userName;
            image = userData?.image ?? image;
          }
          if (doctor.specializationId?.isNotEmpty ?? false) {
            final specialtyData = await specializationService.getById(doctor.specializationId!);
            specialtyName = specialtyData?.name ?? specialtyName;
          }
          if (doctor.clinicId?.isNotEmpty ?? false) {
            final clinicData = await clinicService.getById(doctor.clinicId!);
            clinicName = clinicData?.name ?? clinicName;
          }
        } catch (e) {
          if (kDebugMode) print('DEBUG | Error fetching doctor metadata for ${doctor.uuid}: $e');
        }

        doctorNames[key] = userName;
        doctorSpecialties[key] = specialtyName;
        doctorClinics[key] = clinicName;
        imageDoctor[key] = image ?? '';
        updatedDoctors.add(doctor);
      }

      allDoctors.value = updatedDoctors;
      totalPages[0] = (allDoctors.length / itemsPerPage).ceil();
      if (searchQuery.value.isEmpty) {
        _storage.write('doctors', updatedDoctors.map((e) => e.toJson()).toList());
        _storage.write('doctorNames', doctorNames);
        _storage.write('imageDoctor', imageDoctor);
        _storage.write('doctorSpecialties', doctorSpecialties);
        _storage.write('doctorClinics', doctorClinics);
      }
      if (kDebugMode) print('DEBUG | Loaded ${allDoctors.length} doctors');
    } catch (e) {
      if (kDebugMode) print('DEBUG | Error fetching doctors: $e');
      allDoctors.clear();
      doctors.clear();
      doctorNames.clear();
      doctorSpecialties.clear();
      doctorClinics.clear();
      imageDoctor.clear();
      hasError.value = true;
      Get.snackbar('Lỗi', 'Không thể tải danh sách bác sĩ: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchHospitalFromApi() async {
    try {
      final cachedHospitals = _storage.read('hospitals');
      if (cachedHospitals != null && searchQuery.value.isEmpty) {
        allHospitals.value = (cachedHospitals as List).map((e) => Hospital.fromJson(e)).toList();
        totalPages[1] = (allHospitals.length / itemsPerPage).ceil();
        if (kDebugMode) print('DEBUG | Loaded ${allHospitals.length} hospitals from cache');
        return;
      }

      final hospitalList = await hospitalService.getAllHospital();
      allHospitals.value = hospitalList;
      totalPages[1] = (hospitalList.length / itemsPerPage).ceil();
      if (searchQuery.value.isEmpty) {
        _storage.write('hospitals', hospitalList.map((e) => e.toJson()).toList());
      }
      if (kDebugMode) print('DEBUG | Loaded ${hospitalList.length} hospitals');
    } catch (e) {
      if (kDebugMode) print('DEBUG | Error fetching hospitals: $e');
      allHospitals.clear();
      hospitals.clear();
      hasError.value = true;
      Get.snackbar('Lỗi', 'Không thể tải danh sách bệnh viện: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchClinicFromApi() async {
    try {
      final cachedClinics = _storage.read('clinics');
      if (cachedClinics != null && searchQuery.value.isEmpty) {
        allClinics.value = (cachedClinics as List).map((e) => Clinic.fromJson(e)).toList();
        totalPages[2] = (allClinics.length / itemsPerPage).ceil();
        if (kDebugMode) print('DEBUG | Loaded ${allClinics.length} clinics from cache');
        return;
      }

      final clinicList = await clinicService.getAllClinic();
      allClinics.value = clinicList;
      totalPages[2] = (clinicList.length / itemsPerPage).ceil();
      if (searchQuery.value.isEmpty) {
        _storage.write('clinics', clinicList.map((e) => e.toJson()).toList());
      }
      if (kDebugMode) print('DEBUG | Loaded ${clinicList.length} clinics');
    } catch (e) {
      if (kDebugMode) print('DEBUG | Error fetching clinics: $e');
      allClinics.clear();
      clinics.clear();
      hasError.value = true;
      Get.snackbar('Lỗi', 'Không thể tải danh sách phòng khám: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchVaccinationCenterFromApi() async {
    try {
      final cachedVaccinationCenters = _storage.read('vaccinationCenters');
      if (cachedVaccinationCenters != null && searchQuery.value.isEmpty) {
        allVaccinationCenters.value = (cachedVaccinationCenters as List)
            .map((e) => VaccinationCenter.fromJson(e))
            .toList();
        totalPages[3] = (allVaccinationCenters.length / itemsPerPage).ceil();
        if (kDebugMode) print('DEBUG | Loaded ${allVaccinationCenters.length} vaccination centers from cache');
        return;
      }

      final vaccinationList = await vaccinationCenterService.getAllVaccinationCenters();
      allVaccinationCenters.value = vaccinationList;
      totalPages[3] = (vaccinationList.length / itemsPerPage).ceil();
      if (searchQuery.value.isEmpty) {
        _storage.write('vaccinationCenters', vaccinationList.map((e) => e.toJson()).toList());
      }
      if (kDebugMode) print('DEBUG | Loaded ${vaccinationList.length} vaccination centers');
    } catch (e) {
      if (kDebugMode) print('DEBUG | Error fetching vaccination centers: $e');
      allVaccinationCenters.clear();
      vaccinationCenters.clear();
      hasError.value = true;
      Get.snackbar('Lỗi', 'Không thể tải danh sách trung tâm tiêm chủng: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void updatePaginatedList() {
    switch (topTabIndex.value) {
      case 0:
        final filteredDoctors = searchQuery.value.isEmpty
            ? allDoctors
            : allDoctors.where((doctor) {
                final key = doctor.userId ?? doctor.uuid ?? '';
                final name = doctorNames[key]?.toLowerCase() ?? '';
                final specialty = doctorSpecialties[key]?.toLowerCase() ?? '';
                final clinic = doctorClinics[key]?.toLowerCase() ?? '';
                final introduce = doctor.introduce?.toLowerCase() ?? '';
                return name.contains(searchQuery.value) ||
                    specialty.contains(searchQuery.value) ||
                    clinic.contains(searchQuery.value) ||
                    introduce.contains(searchQuery.value);
              }).toList();
        totalPages[0] = (filteredDoctors.length / itemsPerPage).ceil();
        doctors.value = _getPaginatedList(filteredDoctors);
        if (kDebugMode) print('DEBUG | Updated paginated doctors: ${doctors.length} items on page ${currentPage[0]}');
        break;
      case 1:
        final filteredHospitals = searchQuery.value.isEmpty
            ? allHospitals
            : allHospitals.where((hospital) {
                return (hospital.name?.toLowerCase().contains(searchQuery.value) ?? false) ||
                    (hospital.address?.toLowerCase().contains(searchQuery.value) ?? false);
              }).toList();
        totalPages[1] = (filteredHospitals.length / itemsPerPage).ceil();
        hospitals.value = _getPaginatedList(filteredHospitals);
        if (kDebugMode) print('DEBUG | Updated paginated hospitals: ${hospitals.length} items on page ${currentPage[1]}');
        break;
      case 2:
        final filteredClinics = searchQuery.value.isEmpty
            ? allClinics
            : allClinics.where((clinic) {
                return (clinic.name?.toLowerCase().contains(searchQuery.value) ?? false) ||
                    (clinic.address?.toLowerCase().contains(searchQuery.value) ?? false);
              }).toList();
        totalPages[2] = (filteredClinics.length / itemsPerPage).ceil();
        clinics.value = _getPaginatedList(filteredClinics);
        if (kDebugMode) print('DEBUG | Updated paginated clinics: ${clinics.length} items on page ${currentPage[2]}');
        break;
      case 3:
        final filteredVaccinationCenters = searchQuery.value.isEmpty
            ? allVaccinationCenters
            : allVaccinationCenters.where((v) {
                return (v.name?.toLowerCase().contains(searchQuery.value) ?? false) ||
                    (v.address?.toLowerCase().contains(searchQuery.value) ?? false);
              }).toList();
        totalPages[3] = (filteredVaccinationCenters.length / itemsPerPage).ceil();
        vaccinationCenters.value = _getPaginatedList(filteredVaccinationCenters);
        if (kDebugMode) print('DEBUG | Updated paginated vaccination centers: ${vaccinationCenters.length} items on page ${currentPage[3]}');
        break;
    }
  }

  List<T> _getPaginatedList<T>(List<T> items) {
    final page = currentPage[topTabIndex.value]!;
    final startIndex = (page - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return items.sublist(startIndex, endIndex.clamp(0, items.length));
  }

  void changeTab(int index) {
    topTabIndex.value = index;
    searchQuery.value = '';
    currentPage[index] = 1;
    if (kDebugMode) print('DEBUG | Changed to tab $index, reset to page 1');
    updatePaginatedList();
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchQuery.value = query.trim().toLowerCase();
      currentPage[topTabIndex.value] = 1;
      if (kDebugMode) print('DEBUG | Search query: "${searchQuery.value}", Tab: ${topTabIndex.value}, Page: 1');
      updatePaginatedList();
    });
  }

  void nextPage() {
    final tabIndex = topTabIndex.value;
    if (currentPage[tabIndex]! < totalPages[tabIndex]!) {
      currentPage[tabIndex] = currentPage[tabIndex]! + 1;
      if (kDebugMode) print('DEBUG | Moved to page ${currentPage[tabIndex]} for tab $tabIndex');
      updatePaginatedList();
    }
  }

  void previousPage() {
    final tabIndex = topTabIndex.value;
    if (currentPage[tabIndex]! > 1) {
      currentPage[tabIndex] = currentPage[tabIndex]! - 1;
      if (kDebugMode) print('DEBUG | Moved to page ${currentPage[tabIndex]} for tab $tabIndex');
      updatePaginatedList();
    }
  }

  void bookDoctorAppointment(Doctor doctor, String type) {
    if (doctor.uuid?.isEmpty ?? true) {
      Get.snackbar('Lỗi', 'Không thể đặt lịch: ID bác sĩ không hợp lệ', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (kDebugMode) print('DEBUG | Booking doctor appointment: ${doctor.toJson()}');
    Get.toNamed(Routes.appointmentScreen, arguments: {'doctor': doctor.toJson(), 'selectedPlaceType': 'doctor'});
  }

  void bookHospitalAppointment(Hospital hospital, String type) {
    if (hospital.uuid?.isEmpty ?? true) {
      Get.snackbar('Lỗi', 'Không thể đặt lịch: ID bệnh viện không hợp lệ', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (kDebugMode) print('DEBUG | Booking hospital appointment: ${hospital.toJson()}');
    Get.toNamed(Routes.appointmentScreen, arguments: {
      'hospital': hospital.toJson(),
      'selectedPlaceType': 'hospital',
    });
  }

  void bookClinicAppointment(Clinic clinic, String type) {
    if (clinic.uuid?.isEmpty ?? true) {
      Get.snackbar('Lỗi', 'Không thể đặt lịch: ID phòng khám không hợp lệ', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (kDebugMode) print('DEBUG | Booking clinic appointment: ${clinic.toJson()}');
    Get.toNamed(Routes.appointmentScreen, arguments: {
      'clinic': clinic.toJson(),
      'selectedPlaceType': 'clinic',
    });
  }

  void bookVaccinationAppointment(VaccinationCenter vaccination, String type) {
    if (vaccination.uuid?.isEmpty ?? true) {
      Get.snackbar('Lỗi', 'Không thể đặt lịch: ID trung tâm tiêm chủng không hợp lệ', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (kDebugMode) print('DEBUG | Booking vaccination appointment: ${vaccination.toJson()}');
    Get.toNamed(Routes.appointmentScreen, arguments: {
      'vaccination_center': vaccination.toJson(),
      'selectedPlaceType': 'vaccination',
    });
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

    if (uuid.isEmpty) {
      Get.snackbar('Lỗi', 'Không thể đặt lịch: ID không hợp lệ', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (kDebugMode) print('DEBUG | bookAppointment: uuid = $uuid, userId = $userId, doctorId = $doctorId, type = $type');
    Get.toNamed(Routes.appointmentScreen, arguments: {
      'uuid': uuid,
      'userId': userId,
      'doctorId': doctorId,
      'type': type,
    });
  }

  void viewDoctorDetails(String id) {
    if (id.isEmpty) {
      Get.snackbar('Lỗi', 'ID bác sĩ không hợp lệ', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (kDebugMode) print('DEBUG | Viewing doctor details for ID: $id');
    Get.toNamed(Routes.detaildoctor, arguments: id);
  }

  void viewHospitalDetails(Hospital hospital) {
    if (hospital.uuid?.isEmpty ?? true) {
      Get.snackbar('Lỗi', 'ID bệnh viện không hợp lệ', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (kDebugMode) print('DEBUG | Viewing hospital details: ${hospital.toJson()}');
    Get.toNamed(Routes.detailhospital, arguments: hospital.toJson());
  }

  void viewClinicDetails(Clinic clinic) {
    if (clinic.uuid?.isEmpty ?? true) {
      Get.snackbar('Lỗi', 'ID phòng khám không hợp lệ', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (kDebugMode) print('DEBUG | Viewing clinic details: ${clinic.toJson()}');
    Get.toNamed(Routes.detailhospital, arguments: clinic.toJson());
  }

  void viewVaccinaDetails(VaccinationCenter vaccinationcenter) {
    if (vaccinationcenter.uuid?.isEmpty ?? true) {
      Get.snackbar('Lỗi', 'ID trung tâm tiêm chủng không hợp lệ', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (kDebugMode) print('DEBUG | Viewing vaccination center details: ${vaccinationcenter.toJson()}');
    Get.toNamed(Routes.detailhospital, arguments: vaccinationcenter.toJson());
  }

  void applyFilter() {
    Get.snackbar('Đã áp dụng bộ lọc', 'Lọc theo: Tất cả', snackPosition: SnackPosition.BOTTOM);
  }

  void resetFilter() {
    searchQuery.value = '';
    fetchData();
  }

  void viewAllDoctors() {
    Get.toNamed(Routes.appointmentScreen);
  }

  void viewAllHospitals() {
    Get.toNamed(Routes.appointmentScreen);
  }

  void viewAllClinics() {
    Get.toNamed(Routes.appointmentScreen);
  }
}