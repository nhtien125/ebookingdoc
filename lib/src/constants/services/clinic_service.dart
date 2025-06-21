import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';

class ClinicService {
  Future<List<Clinic>> getAllClinic() async {
    try {
      final response = await APICaller.getInstance().get('api/clinic/getAll');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Clinic.fromJson(e)).toList();
      } else {
        if (response != null && response['message'] != null) {
          print('[ClinicService] Lý do: ${response['message']}');
        }
      }
    } catch (e) {
      print('[ClinicService] Lỗi khi gọi API: $e');
    }
    return [];
  }
}
