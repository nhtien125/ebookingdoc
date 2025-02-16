import 'package:ebookingdoc/View/Home/MyTest/my_test.dart';
import 'package:ebookingdoc/View/Home/home.dart';
import 'package:ebookingdoc/View/dashboard.dart';
import 'package:get/get.dart';

part 'app_route.dart';

class AppPage {
  AppPage._();

  static const String initialRoute = Routes.dashboard;

  static final List<GetPage<dynamic>> routes = [
    GetPage(name: Routes.dashboard, page: () => Dashboard()),
    GetPage(name: Routes.home, page: () => Home()),
    GetPage(name: Routes.myTest, page: () => MyTest()),
  ];
}
