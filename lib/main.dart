import 'package:ebookingdoc/Global/app_color.dart';
import 'package:ebookingdoc/Route/app_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('vi', 'VN'),
        ],
        title: 'Thrift Flow',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.fourthMain),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            titleSpacing: 20,
            elevation: 0,
            foregroundColor: AppColor.text1,
            backgroundColor: AppColor.main,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: AppPage.initialRoute,
        getPages: AppPage.routes,
      ),
    );
  }
}
