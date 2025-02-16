import 'dart:io';

import 'package:ebookingdoc/Controller/dashboard_controller.dart';
import 'package:ebookingdoc/Global/app_color.dart';
import 'package:ebookingdoc/Service/device_helper.dart';
import 'package:ebookingdoc/View/Home/home.dart';
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
        _showDialog(context);
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
              return Container();
            case 2:
              return Container();
            case 3:
              return Container();
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
                              'assets/icons/home_hashtag.svg',
                              height: 20,
                              width: 20,
                              colorFilter: controller.currentIndex.value == 0
                                  ? ColorFilter.mode(
                                      AppColor.fourthMain, BlendMode.srcIn)
                                  : null,
                            ),
                            Text(
                              'Tổng quan',
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
                  // Trang sổ giao dịch
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changePage(1),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/wallet.svg',
                              height: 20,
                              width: 20,
                              colorFilter: controller.currentIndex.value == 1
                                  ? ColorFilter.mode(
                                      AppColor.fourthMain, BlendMode.srcIn)
                                  : null,
                            ),
                            Text(
                              'Sổ giao dịch',
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

                  // Trang ngân sách
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changePage(2),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/budget.svg',
                              height: 20,
                              width: 20,
                              colorFilter: controller.currentIndex.value == 2
                                  ? ColorFilter.mode(
                                      AppColor.fourthMain, BlendMode.srcIn)
                                  : null,
                            ),
                            Text(
                              'Ngân sách',
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
                  // Trang Cá nhân
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changePage(3),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/user_octagon.svg',
                              height: 20,
                              width: 20,
                              colorFilter: controller.currentIndex.value == 3
                                  ? ColorFilter.mode(
                                      AppColor.fourthMain, BlendMode.srcIn)
                                  : null,
                            ),
                            Text(
                              'Cá nhân',
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
                ]),
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.main,
          contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Đóng ứng dụng",
                style: TextStyle(
                  fontSize: DeviceHelper.getFontSize(20),
                  color: AppColor.text1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Ứng dụng sẽ được đóng lại ?",
                style: TextStyle(
                  fontSize: DeviceHelper.getFontSize(14),
                  color: AppColor.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "Hủy bỏ",
                      style: TextStyle(
                        fontSize: DeviceHelper.getFontSize(15),
                        color: AppColor.fourthMain,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.fourthMain,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                    ),
                    onPressed: () {
                      Get.back();
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else if (Platform.isIOS) {
                        exit(0);
                      }
                    },
                    child: Text(
                      "Xác nhận",
                      style: TextStyle(
                        fontSize: DeviceHelper.getFontSize(14),
                        color: AppColor.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
