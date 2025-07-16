import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/data/model/payment_model.dart';

class PaymentService {
  Future<List<Payment>> addPayment(Map<String, dynamic> data) async {
    try {
      final response = await APICaller.getInstance().post('api/payment/add', body: data);

      if (response != null && (response['code'] == 200 || response['code'] == 201)) {
        final resData = response['data'];
        if (resData is List) {
          return resData.map((e) => Payment.fromJson(e)).toList();
        } else if (resData is Map) {
          return [Payment.fromJson(resData.cast<String, dynamic>())];
        }
      }
    } catch (e) {
      print('Lỗi khi gọi API: $e');
    }
    return [];
  }

  Future<List<Payment>> getPaymentsByUserId(String uuid) async {
    try {
      final response = await APICaller.getInstance().get('api/payment/getByUserId/$uuid');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Payment.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error: $e');
    }
    return [];
  }

  Future<List<Payment>> getByAppointmentId(String appointmentId) async {
    try {
      final response = await APICaller.getInstance().get('api/payment/getByAppointmentId/$appointmentId');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Payment.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error: $e');
    }
    return [];
  }
}
