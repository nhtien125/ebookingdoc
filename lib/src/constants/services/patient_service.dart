import 'package:ebookingdoc/src/data/model/patient_model.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';

class PatientService {
  Future<List<Patient>> getAllPatients() async {
    try {
      final response = await APICaller.getInstance().get('api/patient/getAll');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Patient.fromJson(e)).toList();
      }
    } catch (e) {}
    return [];
  }

  Future<bool> createPatient(Patient patient) async {
    try {
      final response = await APICaller.getInstance().post(
        'api/patient/create',
        body: patient.toJson(),
      );
      return response != null &&
          (response['code'] == 201 || response['code'] == 200);
    } catch (e) {}
    return false;
  }

  Future<List<Patient>> getPatientsByUserId(String uuid) async {
    try {
      final response =
          await APICaller.getInstance().get('api/patient/byUser/$uuid');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Patient.fromJson(e)).toList();
      }
    } catch (e) {}
    return [];
  }

  Future<List<Patient>> getPatientsById(String uuid) async {
    try {
      final response =
          await APICaller.getInstance().get('api/patient/getById/$uuid');
  
      if (response != null &&
          response['code'] == 200 &&
          response['data'] != null) {
        return [Patient.fromJson(response['data'])];
      }
    } catch (e) {}
    return [];
  }

  Future<bool> deletePatient(String uuid) async {
    try {
      final response =
          await APICaller.getInstance().delete('api/patient/delete/$uuid');
      return response != null && response['code'] == 200;
    } catch (e) {}
    return false;
  }
}
