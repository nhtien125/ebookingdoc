part of 'app_page.dart';

abstract class Routes {
  Routes._();
  static const dashboard = _Paths.dashboard;
  static const home = _Paths.home;
  static const profile = _Paths.profile;
  static const login = _Paths.login;
  static const personal = _Paths.personal;
  static const family = _Paths.family;
  static const appointmentHistory = _Paths.appointmentHistory;
  static const medicalRecord = _Paths.medicalRecord;
  static const notification = _Paths.notification;
  static const appointment = _Paths.appointment;
  static const news = _Paths.news;
  static const category = _Paths.category;
  static const excellentDoctor = _Paths.excellentDoctor;
  static const detaildoctor = _Paths.detaildoctor;
}

abstract class _Paths {
  _Paths._();
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String personal = '/personal';
  static const String family = '/family';
  static const String appointmentHistory = '/appointmentHistory';
  static const String medicalRecord = '/medical-record';
  static const String notification = '/notification';
  static const String appointment = '/appointment';
  static const String news = '/news';
  static const String category = '/category';
  static const String excellentDoctor = '/excellent-doctor';
  static const String detaildoctor = '/detail-doctor';
}
