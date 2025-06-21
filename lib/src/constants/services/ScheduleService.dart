import 'package:ebookingdoc/src/data/model/schedule_model.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';

class ScheduleService {
  Future<List<Schedule>> getSchedulesByDoctorId(String doctorId) async {
    try {
      final response =
          await APICaller.getInstance().get('api/schedule/doctor/$doctorId');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Schedule.fromJson(e)).toList();
      }
    } catch (e) {}
    return [];
  }

  Future<Schedule?> getScheduleById(String scheduleId) async {
    try {
      final response =
          await APICaller.getInstance().get('api/schedule/getById/$scheduleId');
      if (response != null &&
          response['code'] == 200 &&
          response['data'] != null) {
        return Schedule.fromJson(response['data']);
      }
    } catch (e) {}
    return null;
  }
}
