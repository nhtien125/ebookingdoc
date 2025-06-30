import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';

class DoctorService {
  Future<List<Doctor>> getAllDoctors() async {
    try {
      final response = await APICaller.getInstance().get('api/doctor/getAll');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Doctor.fromJson(e)).toList();
      }
    } catch (e) {}
    return [];
  }

  Future<Doctor?> getDoctorById(String uuid) async {
    try {
      final response =
          await APICaller.getInstance().get('api/doctor/getById/$uuid');
      if (response != null &&
          response['code'] == 200 &&
          response['data'] != null) {
        return Doctor.fromJson(response['data']);
      }
    } catch (e) {}
    return null;
  }

  Future<List<Doctor>> getDoctorsByUserId(String uuid) async {
    try {
      print("Gọi API để lấy thông tin bác sĩ với userId: $uuid");
      final response =
          await APICaller.getInstance().get('api/doctor/getByUserId/$uuid');
      print("API raw response: $response"); // Kiểm tra phản hồi API
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        print("API trả về ${list.length} bác sĩ.");
        return list.map((e) => Doctor.fromJson(e)).toList();
      } else {
        print("API không trả về dữ liệu hợp lệ.");
      }
    } catch (e) {
      print("Lỗi khi gọi API: ${e.toString()}");
    }
    return [];
  }

  featuredDoctors() {}
}
