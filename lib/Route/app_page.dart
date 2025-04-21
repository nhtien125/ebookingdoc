import 'package:ebookingdoc/Controller/Home/DetailDoctor/detail_doctor_controller.dart';
import 'package:ebookingdoc/View/Appointment/appointment.dart';
import 'package:ebookingdoc/View/Home/Category/category.dart';
import 'package:ebookingdoc/View/Home/DetailDoctor/detail_doctor.dart';
import 'package:ebookingdoc/View/Home/Excellent_doctor/excellent_doctor.dart';
import 'package:ebookingdoc/View/Home/home.dart';
import 'package:ebookingdoc/View/Login/login.dart';
import 'package:ebookingdoc/View/News/new.dart';
import 'package:ebookingdoc/View/Notification/notification.dart';
import 'package:ebookingdoc/View/Profile/AppointmentHistory/appointmentHistory.dart';
import 'package:ebookingdoc/View/Profile/Family/family.dart';
import 'package:ebookingdoc/View/Profile/MedicalRecord/MedicalRecord.dart';
import 'package:ebookingdoc/View/Profile/personal.dart';
import 'package:ebookingdoc/View/Profile/profile.dart';
import 'package:ebookingdoc/View/dashboard.dart';
import 'package:get/get.dart';

part 'app_route.dart';

class AppPage {
  AppPage._();

  static const String initialRoute = Routes.dashboard;

  static final List<GetPage<dynamic>> routes = [
    GetPage(name: Routes.dashboard, page: () => Dashboard()),
    GetPage(name: Routes.home, page: () => Home()),
    GetPage(name: Routes.profile, page: () => Profile()),
    GetPage(name: Routes.login, page: () => Login()),
    GetPage(name: Routes.personal, page: () => Personal()),
    GetPage(name: Routes.family, page: () => Family()),
    GetPage(name: Routes.appointmentHistory, page: () => AppointmentHistory()),
    GetPage(name: Routes.medicalRecord, page: () => MedicalRecord()),
    GetPage(name: Routes.notification, page: () => MyNotification()),
    GetPage(name: Routes.appointment, page: () => Appointment()),
    GetPage(name: Routes.news, page: () => News()),
    GetPage(name: Routes.category, page: () => Category()),
    GetPage(name: Routes.excellentDoctor, page: () => ExcellentDoctor()),
    GetPage(name: Routes.detaildoctor, page: () => Detaildoctor()),
  ];
}
