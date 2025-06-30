import 'package:ebookingdoc/src/data/model/vaccination_center_model.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';

class VaccinationCenterService {
  Future<List<VaccinationCenter>> getAllVaccinationCenters() async {
    try {
      final response =
          await APICaller.getInstance().get('api/vaccination-center/getAll');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => VaccinationCenter.fromJson(e)).toList();
      }
    } catch (e) {}
    return [];
  }

  Future<VaccinationCenter?> getById(String id) async {
    try {
      final response = await APICaller.getInstance()
          .get('api/vaccination-center/getById/$id');
      if (response != null &&
          response['code'] == 200 &&
          response['data'] != null) {
        return VaccinationCenter.fromJson(response['data']);
      }
    } catch (e) {
      print('[VaccinationCenterService] Lỗi khi gọi API: $e');
    }
    return null;
  }
}
