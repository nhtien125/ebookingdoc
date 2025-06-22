import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> logAllPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  print('[SharedPreferences] All keys/values:');
  prefs.getKeys().forEach((key) {
    print('$key: ${prefs.get(key)}');
  });
}

Future<String?> getUserIdFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final userData = prefs.getString('user_data');
  if (userData != null) {
    final user = User.fromJson(jsonDecode(userData));
    return user.uuid; 
  }
  return null;
}
