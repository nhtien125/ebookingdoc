import 'package:ebookingdoc/src/constants/services/PaymentService.dart';
import 'package:ebookingdoc/src/data/model/payment_model.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PaymentHistoryController extends GetxController {
  final isLoading = false.obs;
  final PaymentService paymentService = PaymentService();
  final RxList<Payment> payment = <Payment>[].obs;
  final Rxn<Payment> selectedPayemt = Rxn<Payment>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchPayemtFromApi();
  }

  // Lấy userId từ SharedPreferences
  Future<String?> getUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    print("User data from SharedPreferences: $userJson");
    if (userJson != null) {
      try {
        final user = User.fromJson(jsonDecode(userJson));
        print("User UUID: ${user.uuid}");
        return user.uuid; // Trả về chuỗi uuid
      } catch (e) {
        print("Error parsing user data: $e");
        return null;
      }
    } else {
      print("No user data found in SharedPreferences.");
    }
    return null;
  }

  Future<void> fetchPayemtFromApi() async {
    try {
      isLoading.value = true;
      print('[fetchPayemtFromApi] Bắt đầu lấy dữ liệu thanh toán...');
      final userId =
          await getUserIdFromPrefs(); // Lấy userId từ SharedPreferences
      print('[fetchPayemtFromApi] userId lấy được: $userId');
      if (userId != null) {
        final result =
            await paymentService.getPaymentsByUserId(userId.toString());
        print('[fetchPayemtFromApi] Kết quả từ API: $result');

        if (result.isEmpty) {
          print('[fetchPayemtFromApi] Không có dữ liệu thanh toán');
          Get.snackbar(
              'Không có dữ liệu', 'Không tìm thấy bất kỳ thanh toán nào',
              snackPosition: SnackPosition.BOTTOM);
        }

        payment.assignAll(result.cast<Payment>());
        print('[fetchPayemtFromApi] Đã gán payment: ${payment.length} bản ghi');

        if (payment.isNotEmpty && selectedPayemt.value == null) {
          selectedPayemt.value = payment.first;
          print(
              '[fetchPayemtFromApi] Đã chọn payment đầu tiên: ${selectedPayemt.value}');
        }
      } else {
        print('[fetchPayemtFromApi] Không thể lấy userId từ SharedPreferences');
        Get.snackbar('Lỗi', 'Không thể lấy thông tin người dùng',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e, stack) {
      print('[fetchPayemtFromApi] Lỗi khi lấy danh sách thanh toán: $e');
      print(stack);
      payment.clear();
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi khi tải dữ liệu thanh toán',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
      print('[fetchPayemtFromApi] Kết thúc lấy dữ liệu, isLoading=false');
    }
  }

  List<Payment> getCompletedPayments(List<Payment> payments) {
    return payments.where((payment) => payment.status == 2).toList();
  }

  List<Payment> getCancelledPayments(List<Payment> payments) {
    return payments.where((payment) => payment.status == 3).toList();
  }

  String getStatusDescription(int status) {
    switch (status) {
      case 0:
        return 'Đã thanh toán';
      case 2:
        return 'Đã hủy';
      default:
        return 'Chờ thanh toán';
    }
  }

  String getPaymentMethodText(String? method) {
    switch (method) {
      case 'cash':
        return 'Thanh toán tiền mặt';
      case 'online':
        return 'Chuyển khoản ngân hàng';
      default:
        return 'Không xác định';
    }
  }

  List<Payment> getPaymentByMethod(List<Payment> payments, String method) {
    return payments
        .where((payment) => payment.paymentMethod == method)
        .toList();
  }
}
