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

  Future<List<Doctor>> getDoctorsByStatus(int status) async {
    try {
      final response =
          await APICaller.getInstance().get('api/doctor/getStatus/$status');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Doctor.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error getting doctors by status: $e');
    }
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

  Future<bool> registerDoctor(Map<String, dynamic> doctorData) async {
    try {
      print('Calling API with data: $doctorData');

      getDoctorsByStatus(int i) {}
      final response = await APICaller.getInstance().post(
        'api/doctor/add',
        body: doctorData,
      );

      print('API Response: $response');

      if (response != null && response['code'] == 201) {
        // API trả về 'msg' thay vì 'message'
        print(
            "Đăng ký bác sĩ thành công: ${response['msg'] ?? response['message'] ?? 'Success'}");
        return true;
      } else {
        // Handle error response
        String errorMessage = 'Unknown error';
        if (response != null) {
          errorMessage = response['msg'] ??
              response['message'] ??
              response['error'] ??
              'Unknown error';
        }
        print("Đăng ký bác sĩ thất bại: $errorMessage");
        return false;
      }
    } catch (e) {
      print("Lỗi khi đăng ký bác sĩ: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateDoctor(
      String uuid, Map<String, dynamic> doctorData) async {
    try {
      final response = await APICaller.getInstance().put(
        'api/doctor/update/$uuid',
        body: doctorData,
      );

      if (response != null && response['code'] == 200) {
        print("Cập nhật bác sĩ thành công");
        return true;
      } else {
        String errorMessage =
            response?['msg'] ?? response?['message'] ?? 'Unknown error';
        print("Cập nhật bác sĩ thất bại: $errorMessage");
        return false;
      }
    } catch (e) {
      print("Lỗi khi cập nhật bác sĩ: ${e.toString()}");
      return false;
    }
  }

  featuredDoctors() {}
}
