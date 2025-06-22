import 'package:ebookingdoc/src/screen/Appointment/AppointmentScreen/appointment_screen.dart';
import 'package:ebookingdoc/src/screen/Appointment/appointment.dart';
import 'package:ebookingdoc/src/screen/ConfirmSchedulePage/confirmSchedulePage.dart';
import 'package:ebookingdoc/src/screen/Profile/MedicalRecord/edit_medical_record.dart';
import 'package:ebookingdoc/src/screen/Profile/MedicalRecord/medicalRecord.dart';
import 'package:ebookingdoc/src/screen/Profile/personal/Doctorinformation.dart';
import 'package:ebookingdoc/src/screen/Todayschedule/today_schedule.dart';
import 'package:ebookingdoc/src/screen/dashboardDoctor.dart';
import 'package:ebookingdoc/src/screen/detail/detail_doctor.dart';
import 'package:ebookingdoc/src/screen/ExcellentDoctor/excellent_doctor.dart';
import 'package:ebookingdoc/src/screen/Home/home.dart';
import 'package:ebookingdoc/src/screen/Login/login.dart';
import 'package:ebookingdoc/src/screen/News/new.dart';
import 'package:ebookingdoc/src/screen/Notification/notification.dart';
import 'package:ebookingdoc/src/screen/Profile/Family/family.dart';
import 'package:ebookingdoc/src/screen/Profile/personal/personal.dart';
import 'package:ebookingdoc/src/screen/Profile/profile.dart';
import 'package:ebookingdoc/src/screen/dashboard.dart';
import 'package:ebookingdoc/src/screen/Register/register.dart';
import 'package:ebookingdoc/src/screen/doctor_work_schedule_page.dart';
import 'package:ebookingdoc/src/screen/patientlistpage.dart';
import 'package:get/get.dart';

part 'app_route.dart';

class AppPage {
  AppPage._();

  static const String initialRoute = Routes.login;

  static final List<GetPage<dynamic>> routes = [
    GetPage(name: Routes.login, page: () => Login()),
    GetPage(name: Routes.dashboard, page: () => Dashboard()),
    GetPage(name: Routes.dashboarddoctor, page: () => DashboardDoctor()),
    GetPage(name: Routes.home, page: () => Home()),
    GetPage(name: Routes.profile, page: () => Profile()),
    GetPage(name: Routes.personal, page: () => Personal()),
    GetPage(name: Routes.doctorinformation, page: () => Doctorinformation()),
    GetPage(name: Routes.family, page: () => Family()),
    GetPage(name: Routes.medicalRecord, page: () => MedicalRecord()),
    GetPage(name: Routes.notification, page: () => MyNotification()),
    GetPage(name: Routes.appointment, page: () => Appointment()),
    GetPage(name: Routes.news, page: () => const News()),
    GetPage(name: Routes.excellentDoctor, page: () => ExcellentDoctor()),
    GetPage(name: Routes.detaildoctor, page: () => DetailDoctor()),
    GetPage(name: Routes.appointmentScreen, page: () => AppointmentScreen()),
    GetPage(name: Routes.editMedicalRecord, page: () => EditMedicalRecord()),
    GetPage(name: Routes.register, page: () => Register()),
    GetPage(name: Routes.todayschedule, page: () => TodaySchedulePage()),
    GetPage(name: Routes.confirmschedule, page: () => ConfirmSchedulePage()),
    GetPage(
        name: Routes.doctorworkschedulepage,
        page: () => DoctorWorkSchedulePage()),
    GetPage(
        name: Routes.patientlist,
        page: () => PatientListPage()),
  ];
}
