import 'dart:io';
import 'package:ebookingdoc/src/screen/Home/DoctorHome.dart';
import 'package:ebookingdoc/src/screen/Notification/my_notification.dart';
import 'package:ebookingdoc/src/screen/Profile/profiledoctor.dart';
import 'package:ebookingdoc/src/screen/Todayschedule/today_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/screen/Appointment/appointment.dart';
import 'package:ebookingdoc/src/screen/News/new.dart';
import 'package:ebookingdoc/src/screen/Notification/notification.dart';
import 'package:ebookingdoc/src/screen/Profile/profile.dart';

class DashboardDoctor extends StatelessWidget {
  DashboardDoctor({super.key});

  final controller = Get.put(DashboardDoctorController());

  final List<_NavItem> _navItems = const [
    _NavItem(
      icon: Icons.dashboard,
      label: 'Bác sĩ',
    ),
    _NavItem(
      icon: Icons.notifications,
      label: 'Thông báo',
    ),
    _NavItem(
      icon: Icons.calendar_today,
      label: 'Lịch hẹn',
    ),
    _NavItem(
      icon: Icons.person,
      label: 'Cá nhân',
    ),
  ];

  final List<Widget> _pages = [
    const DoctorHome(),
    MyNotificationDoctor(),
    TodaySchedulePage(),
    ProfileDoctor(),
  ];

  Future<void> _onBackPressed(BuildContext context) async {
    final shouldExit = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đóng ứng dụng'),
        content: const Text('Ứng dụng sẽ được đóng lại?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false), child: const Text("Không")),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true), child: const Text("Đóng")),
        ],
      ),
    );
    if (shouldExit == true) {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed(context);
        return false;
      },
      child: Scaffold(
        body: Obx(() => _pages[controller.currentIndex.value]),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changePage,
              type: BottomNavigationBarType.fixed,
              items: _navItems
                  .map((item) => BottomNavigationBarItem(
                        icon: Icon(item.icon),
                        label: item.label,
                      ))
                  .toList(),
              selectedItemColor: Colors.blue[700],
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
            )),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}

// Controller cho dashboard
class DashboardDoctorController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
