import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';

class ExcellentDoctorController extends GetxController {
  // Tab navigation state
  final RxInt topTabIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  // Data lists
  final RxList<Doctor> doctors = <Doctor>[].obs;
  final RxList<Map<String, dynamic>> hospitals = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> clinics = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> specialties = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> vaccinas = <Map<String, dynamic>>[].obs;

  // Filter option
  final RxString filterOption = 'Tất cả'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    isLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Load doctors data
      doctors.value = [
        Doctor(
          id: '1',
          title: 'TS. BS',
          name: 'Đào Bùi Quý Quyền',
          imageUrl: 'assets/images/bs1.jpg',
          specialty: 'Răng-hàm-mặt',
          hospital: '242 Nguyễn Chí Thanh, Phường 2, Quận 10, Hồ Chí Minh',
          experience: '22 năm kinh nghiệm',
          rating: 5,
        ),
        Doctor(
          id: '2',
          title: 'ThS. BS',
          name: 'Lê Anh Tuấn',
          imageUrl: 'assets/images/bs2.jpg',
          specialty: 'Sản khoa',
          hospital: '12 Trần Phú, Phường 8, Quận 5, Hồ Chí Minh',
          experience: '30 năm kinh nghiệm',
          rating: 5,
        ),
        Doctor(
          id: '3',
          title: 'PGS. TS',
          name: 'Nguyễn Văn Hùng',
          imageUrl: 'assets/images/bs3.jpg',
          specialty: 'Nội tổng quát',
          hospital: '15 Lê Lợi, Phường Bến Nghé, Quận 1, Hồ Chí Minh',
          experience: '25 năm kinh nghiệm',
          rating: 4,
        ),
      ];

      // Load hospitals data
      hospitals.value = [
        {
          'id': '3',
          'name': 'Bệnh viện Đại học Y Hà Nội',
          'imageUrl': 'assets/images/bvYhn.jpg',
          'address': '1 Phường Tôn Thất Tùng, Kim Liên, Đống Đa, Hà Nội',
          'rating': 4.7,
          'specialty': 'Đa khoa',
        },
        {
          'id': '1',
          'name': 'Bệnh viện Thu Cúc',
          'imageUrl': 'assets/images/bvThucuc.jpg',
          'address': '286 Thụy Khuê, Thuỵ Khuê, Ba Đình, Hà Nội',
          'rating': 4.8,
          'specialty': 'Đa khoa',
        },
        {
          'id': '2',
          'name': 'Bệnh viện Quân Đội 108',
          'imageUrl': 'assets/images/pk108.jpg',
          'address': '1 Trần Hưng Đạo, Hai Bà Trưng, Hà Nội',
          'rating': 4.5,
          'specialty': 'Đa khoa',
        },
        {
          'id': '3',
          'name': 'Bệnh viện Việt Đức',
          'imageUrl': 'assets/images/bvVietduc.jpg',
          'address': '40 P.Tràng Thi - Hoàn Kiếm - Hà Nội',
          'rating': 4.7,
          'specialty': 'Đa khoa',
        },
      ];

      // Load clinics data
      clinics.value = [
        {
          'id': '1',
          'name': 'Phòng khám đa khoa Thái Hà',
          'imageUrl': 'assets/images/pkThaiha.jpg',
          'address': '11 Thái Hà, Đống Đa, Hà Nội',
          'rating': 4.5,
          
        },
        {
          'id': '2',
          'name': 'Phòng khám đa khoa Hà Nội',
          'imageUrl': 'assets/images/pkHN.jpg',
          'address': '152 P.Xã Đàn, Phương Liên, Đống Đa, Hà Nội',
          'rating': 4.3,
          
        },
        {
          'id': '3',
          'name': 'Phòng khám đa khoa Hà Nội Bệnh viện 108',
          'imageUrl': 'assets/images/pk108.jpg',
          'address': '1 Trần Hưng Đạo, Hai Bà Trưng, Hà Nội',
          'rating': 4.6,
         
        },
      ];

      // Load vacancies data
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

  void changeTab(int index) {
    topTabIndex.value = index;
  }

  void search(String query) {
    searchQuery.value = query;

    // Implement search based on current tab
    switch (topTabIndex.value) {
      case 0: // Tất cả - tìm kiếm tất cả
        // Thực hiện tìm kiếm tất cả
        break;
      case 1: // Tại nhà - tìm kiếm bác sĩ
        searchDoctors(query);
        break;
      case 2: // Tại viện - tìm kiếm bệnh viện
        searchHospitals(query);
        break;
      case 3: // Chuyên khoa - tìm kiếm phòng khám
        searchClinics(query);
      case 4:
        searchVaccinas(query);
        break;
    }
  }

  void searchDoctors(String query) {
    if (query.isEmpty) {
      fetchData(); // Nạp lại dữ liệu ban đầu
      return;
    }

    query = query.toLowerCase();
    final List<Doctor> filteredDoctors = [];

    // Tìm trong tên bác sĩ hoặc chuyên khoa
    for (var doctor in doctors) {
      if (doctor.name.toLowerCase().contains(query) ||
          doctor.specialty.toLowerCase().contains(query)) {
        filteredDoctors.add(doctor);
      }
    }

    doctors.value = filteredDoctors;
  }

  void searchHospitals(String query) {
    if (query.isEmpty) {
      fetchData(); // Nạp lại dữ liệu ban đầu
      return;
    }

    query = query.toLowerCase();
    final filteredHospitals = hospitals.where((hospital) {
      return hospital['name'].toString().toLowerCase().contains(query) ||
          hospital['address'].toString().toLowerCase().contains(query) ||
          hospital['specialty'].toString().toLowerCase().contains(query);
    }).toList();

    hospitals.value = filteredHospitals;
  }

  void searchClinics(String query) {
    if (query.isEmpty) {
      fetchData(); // Nạp lại dữ liệu ban đầu
      return;
    }

    query = query.toLowerCase();
    final filteredClinics = clinics.where((clinic) {
      return clinic['name'].toString().toLowerCase().contains(query) ||
          clinic['address'].toString().toLowerCase().contains(query);
    }).toList();

    clinics.value = filteredClinics;
  }

  void bookAppointment(dynamic item, String type) {
    // ignore: unused_local_variable
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
    // Xử lý lọc dữ liệu theo filterOption
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

  void viewAllHospitals() {
    // Chuyển đến trang danh sách bệnh viện
   
  }

  void viewAllClinics() {
    // Chuyển đến trang danh sách phòng khám
  
  }

  void viewDoctorDetails(String id) {
    // Chuyển đến trang thông tin bác sĩ
    Get.toNamed(Routes.detaildoctor, arguments: '$id');
  }

  void viewHospitalDetails(String id) {
    // Chuyển đến trang thông tin bệnh viện
   
  }

  void viewClinicDetails(String id) {
    // Chuyển đến trang thông tin phòng khám
 
  }

  void viewVaccinaDetails(String id) {
    // Chuyển đến trang thông tin phòng khám
    
  }

  void searchVaccinas(String query) {
    if (query.isEmpty) {
      fetchData(); // load lại
      return;
    }

    query = query.toLowerCase();
    final filteredVaccinas = vaccinas.where((v) {
      return v['name'].toString().toLowerCase().contains(query) ||
          v['address'].toString().toLowerCase().contains(query);
    }).toList();

    vaccinas.value = filteredVaccinas;
  }
}
