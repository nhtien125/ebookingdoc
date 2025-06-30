part of 'app_page.dart';

abstract class Routes {
  Routes._();
  static const login = _Paths.login;
  static const dashboard = _Paths.dashboard;
  static const dashboarddoctor = _Paths.dashboarddoctor;
  static const home = _Paths.home;
  static const profile = _Paths.profile;
  static const personal = _Paths.personal;
  static const doctorinformation = _Paths.doctorinformation;
  static const family = _Paths.family;
  static const medicalRecord = _Paths.medicalRecord;
  static const notification = _Paths.mynotification;
  static const appointment = _Paths.appointment;
  static const news = _Paths.news;
  static const excellentDoctor = _Paths.excellentDoctor;
  static const detaildoctor = _Paths.detaildoctor;
  static const detailhospital = _Paths.detailhospital;
  static var appointmentScreen = _Paths.appointmentScreen;
  static var editMedicalRecord = _Paths.editMedicalRecord;
  static var register = _Paths.register;
  static var todayschedule = _Paths.todayschedule;
  static var confirmschedule = _Paths.confirmschedule;
  static var doctorworkschedulepage = _Paths.doctorworkschedulepage;
   static var patientlist = _Paths.patientlist;
  static var paymentHistory = _Paths.paymentHistory;
}

abstract class _Paths {
  _Paths._();
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String dashboarddoctor = '/dashboard_doctor';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String personal = '/personal';
  static const String doctorinformation = '/doctorinformation';
  static const String family = '/family';
  static const String medicalRecord = '/medical-record';
  static const String mynotification = '/mynotification';
  static const String appointment = '/appointment';
  static const String news = '/news';
  static const String excellentDoctor = '/excellent-doctor';
  static const String detaildoctor = '/detail-doctor';
  static const String appointmentScreen = '/appointment-screen';
  static const String editMedicalRecord = '/edit-medical-record';
  static const String register = '/register';
  static const String todayschedule = '/todayschedule';
  static const String confirmschedule = '/confirmschedule';
  static const String doctorworkschedulepage = '/doctorworkschedulepage';
  static const String patientlist = '/patientlist';
  static const String detailhospital = '/detail-hospital';
  static const String paymentHistory = '/payment-history';
  
}
