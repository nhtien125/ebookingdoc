import 'dart:io';
import 'package:ebookingdoc/src/widgets/controller/dashboard_controller.dart';
import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/constants/services/device_helper.dart';
import 'package:ebookingdoc/src/Utils/custom_dialog.dart';
import 'package:ebookingdoc/src/screen/Appointment/appointment.dart';
import 'package:ebookingdoc/src/screen/Home/home.dart';
import 'package:ebookingdoc/src/screen/News/new.dart';
import 'package:ebookingdoc/src/screen/Notification/notification.dart';
import 'package:ebookingdoc/src/screen/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final controller = Get.put(DashboardController());

  final List<_NavItem> _navItems = const [
    _NavItem(
      iconPath: 'assets/icons/home.svg',
      label: 'Trang chủ',
    ),
    _NavItem(
      iconPath: 'assets/icons/thongbao.svg',
      label: 'Thông báo',
    ),
    _NavItem(
      iconPath: 'assets/icons/lichhen.svg',
      label: 'Lịch hẹn',
    ),
    _NavItem(
      iconPath: 'assets/icons/news.svg',
      label: 'Tin tức',
    ),
    _NavItem(
      iconPath: 'assets/icons/nguoi.svg',
      label: 'Cá nhân',
    ),
  ];

  final List<Widget> _pages = [
    Home(),
    MyNotification(),
    Appointment(),
    const News(),
    Profile(),
  ];

  Future<void> _onBackPressed(BuildContext context) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onBackPressed(context);
      },
      child: Scaffold(
        backgroundColor: AppColor.subMain,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Obx(() => _pages[controller.currentIndex.value]),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          shadowColor: AppColor.text1,
          color: AppColor.main,
          shape: const CircularNotchedRectangle(),
          child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(_navItems.length, (index) {
                  final isSelected = controller.currentIndex.value == index;
                  final navItem = _navItems[index];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changePage(index),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              navItem.iconPath,
                              height: 20,
                              width: 20,
                              colorFilter: isSelected
                                  ? ColorFilter.mode(
                                      AppColor.fourthMain, BlendMode.srcIn)
                                  : null,
                            ),
                            Text(
                              navItem.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: DeviceHelper.getFontSize(12),
                                color: isSelected
                                    ? AppColor.fourthMain
                                    : AppColor.grey,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              )),
        ),
      ),
    );
  }
}

class _NavItem {
  final String iconPath;
  final String label;

  const _NavItem({required this.iconPath, required this.label});
}