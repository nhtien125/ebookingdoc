import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:get/get.dart';

class DetailDoctorController extends GetxController {
  String id = '';

  // Reactive variables
  final Rx<Doctor?> doctor = Rx<Doctor?>(null);
  final RxInt selectedDateIndex = 0.obs;
  final RxInt selectedTimeIndex =
      (-1).obs; // Tránh lỗi 'Null' khi truy cập giá trị
  final RxList<DateTime> availableDates = <DateTime>[].obs;
  final RxMap<DateTime, List<String>> availableSlotsPerDate =
      <DateTime, List<String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments;
    fetchDoctorDetails();
    generateAvailableDates(); // Tự động tạo danh sách ngày khám kèm giờ khám mặc định
  }

  void fetchDoctorDetails() {
    doctor.value = Doctor(
      id: id,
      name: "Dr. Nguyễn Thanh Hà",
      specialization: "Bác sĩ Tim mạch",
      hospital: "Bệnh viện Đa khoa Hà Nội",
      imageUrl: "assets/images/doctor.jpg",
      rating: 4.8,
      reviewCount: 127,
      experience: 10,
      patientCount: 1500,
      about:
          "Tiến sĩ, Bác sĩ chuyên khoa Tim mạch với hơn 10 năm kinh nghiệm...",
      availableDays: ["Monday", "Wednesday", "Friday"],
      availableSlots: [
        "08:00 - 09:00",
        "09:00 - 10:00",
        "10:00 - 11:00",
        "14:00 - 15:00",
        "15:00 - 16:00"
      ],
      reviews: [
        Review(
          patientName: "Nguyễn Văn A",
          patientAvatar: "assets/images/patient1.jpg",
          rating: 5,
          comment:
              "Bác sĩ rất tận tâm, chu đáo. Tôi rất hài lòng với quá trình điều trị.",
          date: DateTime.now().subtract(const Duration(days: 10)),
        ),
        Review(
          patientName: "Trần Thị B",
          patientAvatar: "assets/images/patient2.jpg",
          rating: 4.5,
          comment:
              "Bác sĩ chẩn đoán chính xác và điều trị hiệu quả. Phòng khám sạch sẽ.",
          date: DateTime.now().subtract(const Duration(days: 25)),
        ),
        Review(
          patientName: "Lê Văn C",
          patientAvatar: "assets/images/patient3.jpg",
          rating: 4,
          comment: "Thời gian chờ hơi lâu nhưng bác sĩ rất giỏi và nhiệt tình.",
          date: DateTime.now().subtract(const Duration(days: 40)),
        ),
      ],
    );
  }

  void generateAvailableDates() {
    final now = DateTime.now();
    availableDates.value =
        List.generate(7, (index) => now.add(Duration(days: index)));

    // Gán giờ khám mặc định cho từng ngày
    for (var date in availableDates) {
      availableSlotsPerDate[date] = doctor.value?.availableSlots ?? [];
    }
  }

  bool isDoctorAvailableOnDate(DateTime date) {
    return true;
  }

  void selectDate(int index) {
    selectedDateIndex.value = index;
    selectedTimeIndex.value = -1; // Tránh lỗi 'Null' khi truy cập giá trị
  }

  void selectTime(int index) {
    selectedTimeIndex.value = index;
  }

  void bookAppointment() {
    Get.toNamed(Routes.appointmentScreen);
  }
}
