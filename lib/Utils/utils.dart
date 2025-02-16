import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future saveStringWithKey(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
  }

  static Future saveIntWithKey(String key, int value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(key, value);
  }

  static Future getStringValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  static Future getIntValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(key) ?? 0;
  }

  static Future getBoolValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(key) ?? false;
  }

  static Future saveBoolWithKey(String key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(key, value);
  }

  static String formatVndCurrency(int amount) {
    final formatter =
        NumberFormat.currency(locale: 'vi_VN', name: ' ', decimalDigits: 0);
    return formatter.format(amount);
  }

  static void showSnackBar(
      {required String title,
      required String message,
      Color? colorText = Colors.white,
      Widget? icon,
      bool isDismissible = true,
      Duration duration = const Duration(seconds: 2),
      Duration animationDuration = const Duration(milliseconds: 300),
      Color backgroundColor = Colors.black,
      double opacityBackground = 0.8,
      SnackPosition? direction = SnackPosition.TOP,
      Curve? animation}) {
    Get.snackbar(
      title,
      message,
      colorText: colorText,
      duration: duration,
      animationDuration: animationDuration,
      icon: icon,
      backgroundColor: backgroundColor.withOpacity(opacityBackground),
      snackPosition: direction,
      forwardAnimationCurve: animation,
      isDismissible: isDismissible,
    );
  }

  static showDateTimePicker(
      {required BuildContext context,
      DateTime? firstDate,
      DateTime? lastDate,
      Locale locale = const Locale('vi', 'VN'),
      required Function(DateTime?) onValue,
      Function? onError}) {
    firstDate ??= DateTime(2000);
    lastDate ??= DateTime.now();

    showDatePicker(
      context: context,
      locale: locale,
      firstDate: firstDate,
      lastDate: lastDate,
    ).then(onValue, onError: onError);
  }
}
