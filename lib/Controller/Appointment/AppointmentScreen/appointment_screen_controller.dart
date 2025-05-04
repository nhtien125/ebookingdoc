
import 'package:ebookingdoc/Models/AppointmentScreen_model.dart';
import 'package:get/get.dart';



class AppointmentScreenController extends GetxController {
  // Observable state
  var currentStep = 0.obs;
  var hospital = Hospital(
    name: 'Bệnh viện Nhân Dân 115',
    address: '527 Sư Vạn Hạnh, Phường 12, Quận 10, Thành phố Hồ Chí Minh',
  ).obs;
  
  var selectedDepartment = RxnString(); // Chuyên khoa
  var selectedService = RxnString();    // Dịch vụ
  var selectedRoom = RxnString();       // Phòng khám
  var selectedDate = Rxn<DateTime>();   // Ngày khám
  var selectedTime = RxnString();       // Giờ khám

  bool canProceed() {
    // Kiểm tra xem đã chọn đủ thông tin bắt buộc chưa
    // Dịch vụ là tùy chọn (không bắt buộc)
    return selectedDepartment.value != null &&
           selectedRoom.value != null &&
           selectedDate.value != null &&
           selectedTime.value != null;
  }

  void incrementStep() {
    currentStep.value++;
  }

  void proceedToNextStep() {
    // Xử lý lưu thông tin và chuyển sang bước tiếp theo
    // Trong thực tế có thể gọi API để đặt lịch khám
    print('Proceeding to next step with data:');
    print('Hospital: ${hospital.value.name}');
    print('Department: ${selectedDepartment.value}');
    print('Service: ${selectedService.value ?? "Không có"}');
    print('Room: ${selectedRoom.value}');
    print('Date: ${selectedDate.value?.day}/${selectedDate.value?.month}/${selectedDate.value?.year}');
    print('Time: ${selectedTime.value}');
    
    // Trong thực tế, tại đây sẽ chuyển sang màn hình tiếp theo
    // Get.to(() => NextScreen());
  }
}