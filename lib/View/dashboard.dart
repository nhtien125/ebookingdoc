import 'dart:io';

import 'package:ebookingdoc/Controller/dashboard_controller.dart';
import 'package:ebookingdoc/Global/app_color.dart';
import 'package:ebookingdoc/Service/device_helper.dart';
import 'package:ebookingdoc/Utils/custom_dialog.dart';
import 'package:ebookingdoc/View/Appointment/appointment.dart';
import 'package:ebookingdoc/View/Home/home.dart';
import 'package:ebookingdoc/View/News/new.dart';
import 'package:ebookingdoc/View/Notification/notification.dart';
import 'package:ebookingdoc/View/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        CustomDialog.showCustomDialog(
          context: context,
          title: 'Đóng ứng dụng',
          content: 'Ứng dụng sẽ được đóng lại ?',
          onPressed: () {
            Get.back();
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
        );
      },
      child: Scaffold(
        backgroundColor: AppColor.subMain,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Obx(() {
          switch (controller.currentIndex.value) {
            case 0:
              return Home();
            case 1:
              return MyNotification();
            case 2:
              return Appointment();
            case 3:
              return const News();
            case 4:
              return Profile();
            default:
              return Container();
          }
        }),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          shadowColor: AppColor.text1,
          color: AppColor.main,
          shape: const CircularNotchedRectangle(),
          child: Obx(
            () => Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Trang Tổng quan
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changePage(0),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/home.svg',
                              height: 20,
                              width: 20,
                              colorFilter: controller.currentIndex.value == 0
                                  ? ColorFilter.mode(
                                      AppColor.fourthMain, BlendMode.srcIn)
                                  : null,
                            ),
                            Text(
                              'Trang chủ',
                              textAlign: TextAlign.center,
                              style: controller.currentIndex.value == 0
                                  ? TextStyle(
                                      fontSize: DeviceHelper.getFontSize(12),
                                      color: AppColor.fourthMain,
                                      fontWeight: FontWeight.w700)
                                  : TextStyle(
                                      fontSize: DeviceHelper.getFontSize(12),
                                      color: AppColor.grey,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Trang thông báo
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changePage(1),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/thongbao.svg',
                              height: 20,
                              width: 20,
                              colorFilter: controller.currentIndex.value == 1
                                  ? ColorFilter.mode(
                                      AppColor.fourthMain, BlendMode.srcIn)
                                  : null,
                            ),
                            Text(
                              'Thông báo',
                              textAlign: TextAlign.center,
                              style: controller.currentIndex.value == 1
                                  ? TextStyle(
                                      fontSize: DeviceHelper.getFontSize(12),
                                      color: AppColor.fourthMain,
                                      fontWeight: FontWeight.w700)
                                  : TextStyle(
                                      fontSize: DeviceHelper.getFontSize(12),
                                      color: AppColor.grey,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Trang Lịch hẹn
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changePage(2),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/lichhen.svg',
                              height: 20,
                              width: 20,
                              colorFilter: controller.currentIndex.value == 2
                                  ? ColorFilter.mode(
                                      AppColor.fourthMain, BlendMode.srcIn)
                                  : null,
                            ),
                            Text(
                              'Lịch hẹn',
                              textAlign: TextAlign.center,
                              style: controller.currentIndex.value == 2
                                  ? TextStyle(
                                      fontSize: DeviceHelper.getFontSize(12),
                                      color: AppColor.fourthMain,
                                      fontWeight: FontWeight.w700)
                                  : TextStyle(
                                      fontSize: DeviceHelper.getFontSize(12),
                                      color: AppColor.grey,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Trang tin tức
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changePage(3),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/news.svg',
                              height: 20,
                              width: 20,
                              colorFilter: controller.currentIndex.value == 3
                                  ? ColorFilter.mode(
                                      AppColor.fourthMain, BlendMode.srcIn)
                                  : null,
                            ),
                            Text(
                              'Tin tức',
                              textAlign: TextAlign.center,
                              style: controller.currentIndex.value == 3
                                  ? TextStyle(
                                      fontSize: DeviceHelper.getFontSize(12),
                                      color: AppColor.fourthMain,
                                      fontWeight: FontWeight.w700)
                                  : TextStyle(
                                      fontSize: DeviceHelper.getFontSize(12),
                                      color: AppColor.grey,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Trang Cá nhân
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changePage(4),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/nguoi.svg',
                              height: 20,
                              width: 20,
                              colorFilter: controller.currentIndex.value == 4
                                  ? ColorFilter.mode(
                                      AppColor.fourthMain, BlendMode.srcIn)
                                  : null,
                            ),
                            Text(
                              'Cá nhân',
                              textAlign: TextAlign.center,
                              style: controller.currentIndex.value == 4
                                  ? TextStyle(
                                      fontSize: DeviceHelper.getFontSize(12),
                                      color: AppColor.fourthMain,
                                      fontWeight: FontWeight.w700)
                                  : TextStyle(
                                      fontSize: DeviceHelper.getFontSize(12),
                                      color: AppColor.grey,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
