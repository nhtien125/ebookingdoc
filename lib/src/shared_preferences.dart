import 'package:shared_preferences/shared_preferences.dart';

Future<void> logAllPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  print('[SharedPreferences] All keys/values:');
  prefs.getKeys().forEach((key) {
    print('$key: ${prefs.get(key)}');
  });
}