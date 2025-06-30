import 'package:ebookingdoc/src/data/model/specialization_model.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';

class SpecializationService {
  Future<Specialization?> getById(String? id) async {
    if (id == null || id.isEmpty) {
      return null;
    }
    final response =
        await APICaller.getInstance().get('api/specialization/getById/$id');
    if (response != null &&
        response['code'] == 200 &&
        response['data'] != null) {
      return Specialization.fromJson(response['data']);
    }
    return null;
  }

  Future<List<Specialization>> getAllSpecialization() async {
    try {
      final response =
          await APICaller.getInstance().get('api/specialization/getAll');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Specialization.fromJson(e)).toList();
      }
    } catch (e) {}
    return [];
  }
}
