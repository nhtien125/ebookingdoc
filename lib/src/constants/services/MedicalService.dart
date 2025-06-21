import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/data/model/medical_service_model.dart';

class MedicalServiceService {
  Future<List<MedicalServiceModel>> getAllMedicalServices() async {
    try {
      final response =
          await APICaller.getInstance().get('api/medical_service/getAll');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => MedicalServiceModel.fromJson(e)).toList();
      }
    } catch (e) {}
    return [];
  }
}