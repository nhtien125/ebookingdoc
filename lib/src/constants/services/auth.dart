import 'dart:convert';
import 'package:ebookingdoc/src/Global/constant.dart';
import 'package:ebookingdoc/src/Global/global_value.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/Utils/utils.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
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

  static Future<User?> login({
    required String account,
    required String password,
  }) async {
    Map<String, String> param;
    if (account.contains('@')) {
      param = {"email": account.trim(), "password": password.trim()};
    } else {
      param = {"username": account.trim(), "password": password.trim()};
    }

    try {
      var response =
          await APICaller.getInstance().post('api/auth/login', body: param);

      print('Raw response: $response');
      if (response is String) {
        if (response.trim().startsWith('<!DOCTYPE html>')) {
          Utils.showSnackBar(
              title: 'Thông báo',
              message:
                  'Lỗi server: API trả về HTML, hãy kiểm tra lại backend, URL hoặc mạng!');
          return null;
        } else {
          print("Unexpected string response: $response");
          return null;
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

        return User.fromJson(response['data']);
      } else {
        final msg = (response is Map)
            ? (response['message'] ?? "Đăng nhập thất bại")
            : "Đăng nhập thất bại";
        print("Login failed with message: $msg");
        Utils.showSnackBar(title: 'Thông báo', message: msg);
        return null;
      }
    } catch (e) {
      print("Auth.login error: $e");
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
      return null;
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

  static Future<Map<String, dynamic>?> updateUser({
    required String uuid,
    required String name,
    required int gender,
    required String birthDay, // yyyy-MM-dd
    required String phone,
    required String email,
    required int premissionId,
    String? accessToken,
  }) async {
    final param = {
      'name': name,
      'gender': gender,
      'birth_day': birthDay,
      'phone': phone,
      'email': email,
      'premission_id': premissionId,
    };

    try {
      final response = await APICaller.getInstance().put(
        'api/auth/update/$uuid',
        body: param,
        headers: accessToken != null
            ? {'Authorization': 'Bearer $accessToken'}
            : null,
      );

      print('Update user response: $response');

      if (response != null && response is Map && response['code'] == 200) {
        return response['data'];
      } else {
        final msg = (response is Map)
            ? (response['message'] ?? "Cập nhật thất bại")
            : "Cập nhật thất bại";
        Utils.showSnackBar(title: 'Thông báo', message: msg);
        return null;
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
      return null;
    }
  }
}
