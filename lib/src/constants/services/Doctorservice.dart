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

  featuredDoctors() {}
}