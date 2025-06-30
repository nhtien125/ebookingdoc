import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/data/model/appointment_model.dart';

class AppointmentService {
  Future<List<Appointment>> addAppointment(Map<String, dynamic> data) async {
    try {
      final response = await APICaller.getInstance().post('api/appointment/add', body: data);

      if (response != null && (response['code'] == 200 || response['code'] == 201)) {
        final resData = response['data'];
        if (resData is List) {
          return resData.map((e) => Appointment.fromJson(e)).toList();
        } else if (resData is Map) {
          return [Appointment.fromJson(resData.cast<String, dynamic>())];
        }
      }
    } catch (e) {}
    return [];
  }

  Future<List<Appointment>> getByDoctorId(String doctorId) async {
    try {
      final response = await APICaller.getInstance()
          .get('api/appointment/getByDoctorId/$doctorId');

      if (response != null && (response['code'] == 200 || response['code'] == 201)) {
        final resData = response['data'];
        if (resData is List) {
          return resData.map((e) => Appointment.fromJson(e)).toList();
        } else if (resData is Map) {
          return [Appointment.fromJson(resData.cast<String, dynamic>())];
        }
      }
    } catch (e) {}
    return [];
  }

  Future<bool> updateStatus(String uuid, int status) async {
    try {
      final response = await APICaller.getInstance().put(
        'api/appointment/updateStatus/$uuid',
        body: {"status": status},
      );

      if (response != null && (response['code'] == 200 || response['code'] == 201)) {
        return true;
      }
    } catch (e) {}
    return false;
  }
}
