
import 'package:ebookingdoc/src/screen/Appointment/AppointmentScreen/appointment_screen.dart';
import 'package:ebookingdoc/src/screen/Appointment/appointment.dart';
import 'package:ebookingdoc/src/screen/detail/detail_doctor.dart';
import 'package:ebookingdoc/src/screen/ExcellentDoctor/excellent_doctor.dart';
import 'package:ebookingdoc/src/screen/Home/home.dart';
import 'package:ebookingdoc/src/screen/Login/login.dart';
import 'package:ebookingdoc/src/screen/News/new.dart';
import 'package:ebookingdoc/src/screen/Notification/notification.dart';
import 'package:ebookingdoc/src/screen/Profile/AppointmentHistory/appointmentHistory.dart';
import 'package:ebookingdoc/src/screen/Profile/Family/family.dart';
import 'package:ebookingdoc/src/screen/Profile/MedicalRecord/medicalRecord.dart';
import 'package:ebookingdoc/src/screen/Profile/personal/personal.dart';
import 'package:ebookingdoc/src/screen/Profile/profile.dart';
import 'package:ebookingdoc/src/screen/dashboard.dart';
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
    GetPage(name: Routes.news, page: () => const News()),
    GetPage(name: Routes.excellentDoctor, page: () => ExcellentDoctor()),
    GetPage(name: Routes.detaildoctor, page: () => DetailDoctor()),
    GetPage(name: Routes.appointmentScreen, page: () => AppointmentScreen()),

  ];
  
 
}
