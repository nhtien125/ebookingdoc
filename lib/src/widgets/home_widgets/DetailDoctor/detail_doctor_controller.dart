import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailDoctorController extends GetxController {
  String id = '';
  MedicalType facilityType = MedicalType.doctor;

  // Reactive variables
  final Rx<MedicalEntity?> entity = Rx<MedicalEntity?>(null);
  final RxInt selectedDateIndex = 0.obs;
  final RxInt selectedTimeIndex = (-1).obs;
  final RxList<DateTime> availableDates = <DateTime>[].obs;
  final RxMap<DateTime, List<String>> availableSlotsPerDate = <DateTime, List<String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    facilityType = Get.arguments['type'] ?? MedicalType.doctor;
    fetchEntityDetails();
    generateAvailableDates();
  }

  void fetchEntityDetails() {
    switch (facilityType) {
      case MedicalType.doctor:
        entity.value = Doctor(
          id: id,
          name: "Dr. Nguyễn Thanh Hà",
          specialization: "Bác sĩ Tim mạch",
          hospital: "Bệnh viện Đa khoa Hà Nội",
          imageUrl: "assets/images/doctor.jpg",
          rating: 4.8,
          reviewCount: 127,
          experience: 10,
          patientCount: 1500,
          about: "Tiến sĩ, Bác sĩ chuyên khoa Tim mạch với hơn 10 năm kinh nghiệm tại bệnh viện...",
          availableDays: ["Monday", "Wednesday", "Friday"],
          availableSlots: ["08:00 - 09:00", "09:00 - 10:00", "14:00 - 15:00"],
          reviews: [
            Review(
              patientName: "Nguyễn Văn A",
              patientAvatar: "assets/images/patient1.jpg",
              rating: 5,
              comment: "Bác sĩ rất tận tâm, chu đáo",
              date: DateTime.now().subtract(const Duration(days: 10)),
            ),
            Review(
              patientName: "Trần Thị B",
              patientAvatar: "assets/images/patient2.jpg",
              rating: 4.5,
              comment: "Bác sĩ chẩn đoán chính xác",
              date: DateTime.now().subtract(const Duration(days: 25)),
            ),
          ], consultationFee: 0,
        );
        break;
      case MedicalType.hospital:
        entity.value = Hospital(
          id: id,
          name: "Bệnh viện Đa khoa Hà Nội",
          imageUrl: "assets/images/hospital.jpg",
          rating: 4.5,
          reviewCount: 342,
          about: "Bệnh viện đa khoa hạng I với đầy đủ các chuyên khoa, trang thiết bị hiện đại...",
          availableDays: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
          availableSlots: ["08:00 - 11:30", "13:30 - 17:00"],
          reviews: [
            Review(
              patientName: "Nguyễn Văn C",
              patientAvatar: "assets/images/patient3.jpg",
              rating: 4,
              comment: "Cơ sở vật chất tốt, nhân viên nhiệt tình",
              date: DateTime.now().subtract(const Duration(days: 15)),
            ),
            Review(
              patientName: "Lê Thị D",
              patientAvatar: "assets/images/patient4.jpg",
              rating: 5,
              comment: "Khám chữa bệnh hiệu quả, bác sĩ giỏi",
              date: DateTime.now().subtract(const Duration(days: 30)),
            ),
          ],
          address: "123 Đường Lê Duẩn, Hà Nội",
          departmentCount: 15,
          doctorCount: 200,
        );
        break;
      case MedicalType.clinic:
        entity.value = Clinic(
          id: id,
          name: "Phòng khám Đa khoa Hồng Phúc",
          imageUrl: "assets/images/clinic.jpg",
          rating: 4.2,
          reviewCount: 87,
          about: "Phòng khám đa khoa với các dịch vụ khám chữa bệnh chất lượng cao...",
          availableDays: ["Tuesday", "Thursday", "Saturday"],
          availableSlots: ["08:00 - 12:00", "14:00 - 18:00"],
          reviews: [
            Review(
              patientName: "Phạm Văn E",
              patientAvatar: "assets/images/patient5.jpg",
              rating: 4.5,
              comment: "Phòng khám sạch sẽ, thủ tục nhanh gọn",
              date: DateTime.now().subtract(const Duration(days: 20)),
            ),
            Review(
              patientName: "Hoàng Thị F",
              patientAvatar: "assets/images/patient6.jpg",
              rating: 4,
              comment: "Bác sĩ tư vấn nhiệt tình",
              date: DateTime.now().subtract(const Duration(days: 45)),
            ),
          ],
          address: "456 Đường Giải Phóng, Hà Nội",
          director: "TS. Trần Văn Minh",
          phoneNumber: "0243.876.5432",
        );
        break;
      case MedicalType.vaccinationCenter:
        entity.value = VaccinationCenter(
          id: id,
          name: "Trung tâm Tiêm chủng VNVC",
          imageUrl: "assets/images/vaccine.jpg",
          rating: 4.7,
          reviewCount: 215,
          about: "Trung tâm tiêm chủng hàng đầu với đầy đủ các loại vắc xin...",
          availableDays: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
          availableSlots: ["07:30 - 17:00"],
          reviews: [
            Review(
              patientName: "Nguyễn Thị G",
              patientAvatar: "assets/images/patient7.jpg",
              rating: 5,
              comment: "Tiêm chủng nhanh chóng, không đau",
              date: DateTime.now().subtract(const Duration(days: 10)),
            ),
            Review(
              patientName: "Trần Văn H",
              patientAvatar: "assets/images/patient8.jpg",
              rating: 4.5,
              comment: "Nhân viên nhiệt tình, cơ sở vật chất tốt",
              date: DateTime.now().subtract(const Duration(days: 25)),
            ),
          ],
          address: "789 Đường Láng, Hà Nội",
          availableVaccines: ["Covid-19", "Cúm", "Viêm gan B", "Sởi", "Quai bị", "Rubella"],
          is24h: false,
        );
        break;
    }
  }

  void generateAvailableDates() {
    final now = DateTime.now();
    availableDates.value = List.generate(7, (index) => now.add(Duration(days: index)));

    for (var date in availableDates) {
      availableSlotsPerDate[date] = entity.value?.availableSlots ?? [];
    }
  }

  bool isEntityAvailableOnDate(DateTime date) {
    if (entity.value == null) return false;
    
    final dayName = DateFormat('EEEE').format(date);
    return entity.value!.availableDays.contains(dayName);
  }

void selectDate(int index) {
  if (index >= 0 && index < availableDates.length) {
    selectedDateIndex.value = index;
    selectedTimeIndex.value = -1;

    // Nếu bạn cần dùng selectedDate ngay sau khi chọn
    final selectedDate = availableDates[index];
    // Có thể dùng selectedDate ở đây nếu cần
  }
}


  void selectTime(int index) {
    if (entity.value != null && 
        index >= 0 && 
        index < entity.value!.availableSlots.length) {
      selectedTimeIndex.value = index;
    }
  }

  void bookAppointment() {
    if (selectedTimeIndex.value == -1 || 
        selectedDateIndex.value == -1 || 
        entity.value == null) {
      return;
    }

    final selectedDate = availableDates[selectedDateIndex.value];
    final selectedTime = entity.value!.availableSlots[selectedTimeIndex.value];

    Get.toNamed(Routes.appointmentScreen, arguments: {
      'entity': entity.value,
      'date': selectedDate,
      'time': selectedTime,
      'type': facilityType,
    });
  }
}