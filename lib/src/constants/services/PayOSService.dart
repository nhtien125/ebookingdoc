import 'package:http/http.dart' as http;
import 'dart:convert';

class PayOSService {
  static const String baseUrl = 'http://192.168.1.16:3210';

  Future<Map<String, dynamic>?> createPaymentLink({
    required int amount,
    required String orderId,
    required String description,
    String? fullname,
    String? phone,
    String? email,
    String? payment_id,
  }) async {
    final url = Uri.parse('$baseUrl/api/payment/create-payment-link');
    final body = {
      "amount": amount,
      "orderId": orderId,
      "description": description,
      "fullname": fullname,
      "phone": phone,
      "email": email,
      "payment_id": payment_id,
    };
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        "paymentLink": data['paymentLink'],
        "paymentId": data['paymentId'], // backend cần trả về
      };
    }
    print('PayOS error: ${response.body}');
    return null;
  }

  Future<bool> updatePaymentStatus(String paymentId, int status) async {
    final url = Uri.parse('$baseUrl/api/payment/update-status/$paymentId');
    final body = {
      "status": status, // Truyền số (1 = pending, 0 = success, 2 = cancel)
    };
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return true;
    }
    print('Update payment status error: ${response.body}');
    return false;
  }
}
