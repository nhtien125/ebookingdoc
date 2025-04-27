import 'dart:convert';

import 'package:ebookingdoc/Global/constant.dart';
import 'package:ebookingdoc/Global/global_value.dart';
import 'package:ebookingdoc/Route/app_page.dart';
import 'package:ebookingdoc/Service/api_caller.dart';
import 'package:ebookingdoc/Utils/utils.dart';
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

  static login({String? userName, String? password}) async {
    String userNamePreferences =
        await Utils.getStringValueWithKey(Constant.USERNAME);
    String passwordPreferences =
        await Utils.getStringValueWithKey(Constant.PASSWORD);

    Map<String, String> param = {
      "username": userName ?? userNamePreferences,
      // "password":
      //     password != null ? Utils.generateMd5(password) : passwordPreferences,
      "password":
          password ?? passwordPreferences,
      // "fcmToken": await Utils.getStringValueWithKey(Constant.FCMTOKEN)
    };

    try {
      var response =
          await APICaller.getInstance().post('v1/user/login', body: param);
      print(jsonEncode(response));
      if (response != null) {
        GlobalValue.getInstance()
            .setToken('Bearer ${response['data']['access_token']}');
        Utils.saveStringWithKey(
            Constant.ACCESS_TOKEN, response['data']['access_token']);
        Utils.saveStringWithKey(
            Constant.REFRESH_TOKEN, response['data']['refresh_token']);
        Utils.saveStringWithKey(Constant.NAME, response['data']['name'] ?? '');
        Utils.saveStringWithKey(Constant.AVATAR, response['data']['avatar'] ?? '');
        Utils.saveStringWithKey(
            Constant.USERNAME, userName ?? userNamePreferences);
        Utils.saveStringWithKey(Constant.PASSWORD, param['password']!);
        Get.offAllNamed(Routes.dashboard);
      } else {
        backLogin(true);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }
}