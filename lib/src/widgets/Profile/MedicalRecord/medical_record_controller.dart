import 'package:ebookingdoc/src/data/model/medica_record_model.dart';
import 'package:ebookingdoc/src/screen/Profile/MedicalRecord/edit_medical_record.dart';
import 'package:get/get.dart';

class MedicalRecordController extends GetxController {
  final record = MedicalRecord(
    name: 'Nguyễn Văn A',
    dob: DateTime(1990, 5, 15),
    gender: 'Nam',
    bloodType: 'A+',
    height: 170,
    weight: 65,
  
    allergies: 'Không có',
    chronicDiseases: 'Không có',
    surgeries: 'Không có',
    currentMedications: 'Không có',
  ).obs;

  final appointments = <MedicalAppointment>[
    MedicalAppointment(
      date: DateTime(2023, 10, 15),
      hospitalName: 'Bệnh viện Đa khoa X',
      serviceName: 'Khám tổng quát',
      doctorName: 'BS. Trần Văn B',
    ),
    MedicalAppointment(
      date: DateTime(2023, 8, 22),
      hospitalName: 'Bệnh viện Chuyên khoa Y',
      serviceName: 'Kiểm tra huyết áp',
      doctorName: 'BS. Lê Thị C',
    ),
  ].obs;

  void editRecord() {
      Get.to(() => EditMedicalRecord());

  }

  void viewAppointmentDetails(MedicalAppointment appointment) {
    // Get.toNamed('/appointment-details', arguments: appointment);
  }
  void updateRecord(MedicalRecord updatedRecord) {
    record.value = updatedRecord;
    Get.back();  
}

}