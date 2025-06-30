import 'package:ebookingdoc/src/data/model/schedule_model.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';

class ScheduleService {
  Future<List<Schedule>> getSchedulesByDoctorId(String doctorId) async {
    try {
      final response = await APICaller.getInstance().get('api/schedule/doctor/$doctorId');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Schedule.fromJson(e)).toList();
      }
    } catch (e) {}
    return [];
  }

  Future<Schedule?> getScheduleById(String scheduleId) async {
    try {
      final response = await APICaller.getInstance().get('api/schedule/getById/$scheduleId');
      if (response != null && response['code'] == 200 && response['data'] != null) {
        return Schedule.fromJson(response['data']);
      }
    } catch (e) {}
    return null;
  }

  Future<bool> addSchedule(Schedule schedule) async {
    try {
      final response = await APICaller.getInstance().post(
        'api/schedule/add',
        body: schedule.toJson(),
      );
      if (response != null && response['code'] == 201) {
        return true;
      }
    } catch (e, stack) {}
    return false;
  }

  Future<bool> updateSchedule(String id, Schedule schedule) async {
    try {
      final response = await APICaller.getInstance().put(
        'api/schedule/update/$id',
        body: schedule.toJson(),
      );
      if (response != null && response['code'] == 200) {
        return true;
      }
    } catch (e, stack) {}
    return false;
  }

  Future<bool> deleteSchedule(String id) async {
    try {
      final response = await APICaller.getInstance().delete(
        'api/schedule/delete/$id',
      );
      if (response != null && response['code'] == 200) {
        return true;
      }
    } catch (e, stack) {}
    return false;
  }
}
