import 'package:ebookingdoc/Models/doctor_model.dart';
import 'package:get/get.dart';

class ExcellentDoctorController extends GetxController {
  var doctorList = <Doctor>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDoctors(); // Load dữ liệu bác sĩ khi controller được khởi tạo
  }

  void loadDoctors() {
    doctorList.value = [
      Doctor(
        id: '1',
        name: 'Bác sĩ Nguyễn Văn A',
        specialty: 'Tim mạch',
        imageUrl: 'assets/images/carosel4.jpg',
        rating: 4.8,
        experience: '15 năm kinh nghiệm',
        hospital: 'Bệnh viện Bạch Mai',
        address: '78 Giải Phóng, Hà Nội',
      ),
      Doctor(
        id: '2',
        name: 'Bác sĩ Trần Thị B',
        specialty: 'Nội tiết',
        imageUrl: 'assets/images/carosel4.jpg',
        rating: 4.5,
        experience: '10 năm kinh nghiệm',
        hospital: 'Bệnh viện Nội tiết TW',
        address: 'Ngõ 215 Ngọc Hồi, Hà Nội',
      ),
    ];
  }

  void bookAppointment(Doctor doctor) {
    // Xử lý đặt lịch - bạn có thể mở dialog hoặc chuyển sang màn đặt lịch
    Get.snackbar("Đặt lịch hẹn", "Bạn đã chọn ${doctor.name}");
  }
}
