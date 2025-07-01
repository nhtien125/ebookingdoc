import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';

class HospitalService {
  Future<List<Hospital>> getAllHospital() async {
    try {
      final response = await APICaller.getInstance().get('api/hospital/getAll');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Hospital.fromJson(e)).toList();
      }
    } catch (e) {}
    return [];
  }

  Future<Hospital?> getHospitalById(String uuid) async {
    try {
      final response =
          await APICaller.getInstance().get('api/hospital/getById/$uuid');
      if (response != null && response['code'] == 200) {
        final data = response['data'];
        if (data != null) {
          return Hospital.fromJson(data);
        }
      }
    } catch (e) {}
    return null;
  }
}
