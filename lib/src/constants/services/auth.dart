import 'dart:convert';
import 'package:ebookingdoc/src/Global/constant.dart';
import 'package:ebookingdoc/src/Global/global_value.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/Utils/utils.dart';
import 'package:get/get.dart';

class Auth {
  static backLogin(bool isRun) async {
    if (!isRun) {
      return null;
    }
    await Utils.saveStringWithKey(Constant.ACCESS_TOKEN, '');
    await Utils.saveStringWithKey(Constant.REFRESH_TOKEN, '');
    await Utils.saveStringWithKey(Constant.USERNAME, '');
    await Utils.saveStringWithKey(Constant.PASSWORD, '');
    if (Get.currentRoute != Routes.login) {
      Get.offAllNamed(Routes.login);
    }
  }

static Future<dynamic> login({
  required String account,
  required String password,
}) async {
  // Xác định nên gửi key username hay email
  Map<String, String> param;
  if (account.contains('@')) {
    param = {"email": account, "password": password};
  } else {
    param = {"username": account, "password": password};
  }

  try {
    var response = await APICaller.getInstance().post('api/auth/login', body: param);

    print('Raw response: $response');
    if (response is String) {
      if (response.trim().startsWith('<!DOCTYPE html>')) {
        Utils.showSnackBar(
            title: 'Thông báo',
            message: 'Lỗi server: API trả về HTML, hãy kiểm tra lại backend, URL hoặc mạng!');
        return "Lỗi server: API trả về HTML";
      } else {
        Utils.showSnackBar(
            title: 'Thông báo', message: 'Lỗi không xác định: $response');
        return "Lỗi không xác định: $response";
      }
    }

    if (response != null &&
        response is Map &&
        response['code'] == 200 &&
        response['data'] != null) {
      GlobalValue.getInstance()
          .setToken('Bearer ${response['data']['access_token']}');
      Utils.saveStringWithKey(
          Constant.ACCESS_TOKEN, response['data']['access_token']);
      Utils.saveStringWithKey(
          Constant.REFRESH_TOKEN, response['data']['refresh_token']);
      Utils.saveStringWithKey(Constant.NAME, response['data']['name'] ?? '');
      Utils.saveStringWithKey(
          Constant.AVATAR, response['data']['avatar'] ?? '');
      Utils.saveStringWithKey(Constant.USERNAME, account);
      Utils.saveStringWithKey(Constant.PASSWORD, password);
      Get.offAllNamed(Routes.dashboard);
      return true;
    } else {
      final msg = (response is Map)
          ? (response['message'] ?? "Đăng nhập thất bại")
          : "Đăng nhập thất bại";
      Utils.showSnackBar(title: 'Thông báo', message: msg);
      return msg;
    }
  } catch (e) {
    Utils.showSnackBar(title: 'Thông báo', message: '$e');
    return e.toString();
  }
}


  static Future<dynamic> register({
    required String username,
    required String email,
    required String password,
    required int premissionId,
  }) async {
    Map<String, dynamic> param = {
      "username": username,
      "email": email,
      "password": password,
      "premission_id": premissionId,
    };

    try {
      var response =
          await APICaller.getInstance().post('api/auth/register', body: param);
      if (response != null && response['code'] == 200) {
        return true;
      }
      return response?['message'] ?? "Đăng ký thất bại";
    } catch (e) {
      return e.toString();
    }
  }
}
