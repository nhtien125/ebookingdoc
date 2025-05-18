import 'package:ebookingdoc/src/screen/Appointment/AppointmentScreen/appointment_screen.dart';
import 'package:ebookingdoc/src/screen/Appointment/appointment.dart';
import 'package:ebookingdoc/src/screen/Home/DetailDoctor/detail_doctor.dart';
import 'package:ebookingdoc/src/screen/Home/Excellent_doctor/excellent_doctor.dart';
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
import 'package:ebookingdoc/src/screen/error_404.dart';
import 'package:go_router/go_router.dart';

class MyAppRouter {
  GoRouter router = GoRouter(
    initialLocation: "/dashboard",
    routes: [
      GoRoute(
        name: "Dashboard",
        path: '/dashboard',
        builder: (context, state) => Dashboard(),
      ),
      GoRoute(
        name: "Home",
        path: '/home',
        builder: (context, state) => Home(),
      ),
      GoRoute(
        name: "Profile",
        path: '/profile',
        builder: (context, state) => Profile(),
      ),
      GoRoute(
        name: "Login",
        path: '/login',
        builder: (context, state) => Login(),
      ),
      GoRoute(
        name: "Personal",
        path: '/personal',
        builder: (context, state) => Personal(),
      ),
      GoRoute(
        name: "Family",
        path: '/family',
        builder: (context, state) => Family(),
      ),
      GoRoute(
        name: "AppointmentHistory",
        path: '/appointmentHistory',
        builder: (context, state) => AppointmentHistory(),
      ),
      GoRoute(
        name: "MedicalRecord",
        path: '/medical-record',
        builder: (context, state) => MedicalRecord(),
      ),
      GoRoute(
        name: "Notification",
        path: '/mynotification',
        builder: (context, state) => MyNotification(),
      ),
      GoRoute(
        name: "Appointment",
        path: '/appointment',
        builder: (context, state) => Appointment(),
      ),
      GoRoute(
        name: "News",
        path: '/news',
        builder: (context, state) => const News(),
      ),
      GoRoute(
        name: "ExcellentDoctor",
        path: '/excellent-doctor',
        builder: (context, state) => ExcellentDoctor(),
      ),
      GoRoute(
        name: "DetailDoctor",
        path: '/detail-doctor',
        builder: (context, state) => DetailDoctor(),
      ),
      GoRoute(
        name: "AppointmentScreen",
        path: '/appointment-screen',
        builder: (context, state) => AppointmentScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      return const NotFoundScreen();
    },
  );
}

class Routes {
  static const dashboard = '/dashboard';
  static const home = '/home';
  static const profile = '/profile';
  static const login = '/login';
  static const personal = '/personal';
  static const family = '/family';
  static const appointmentHistory = '/appointmentHistory';
  static const medicalRecord = '/medical-record';
  static const notification = '/mynotification';
  static const appointment = '/appointment';
  static const news = '/news';
  static const excellentDoctor = '/excellent-doctor';
  static const detailDoctor = '/detail-doctor';
  static const appointmentScreen = '/appointment-screen';
}