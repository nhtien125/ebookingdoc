import 'dart:convert';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/Doctorservice.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/constants/services/specialization_service.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/data/model/specialization_model.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorHomeController controller = Get.put(DoctorHomeController());
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            _HeaderSection(),
            const SizedBox(height: 18),
            _QuickStatsSection(),
            const SizedBox(height: 22),
            _QuickActionGrid(),
            const SizedBox(height: 28),
            _ManageSection(),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DoctorHomeController controller = Get.find<DoctorHomeController>();

    return Obx(() {
      final user = controller.user.value;
      final specialization = controller.specialization.value;

      if (user == null) {
        return const Center(child: Text('Không tìm thấy thông tin người dùng'));
      }

      return Container(
        padding: const EdgeInsets.only(top: 40, left: 22, right: 22, bottom: 24),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(38),
            bottomRight: Radius.circular(38),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withOpacity(0.27),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 37,
              backgroundImage: user.image != null && user.image!.isNotEmpty
                  ? NetworkImage(user.image!)
                  : const AssetImage('assets/default_avatar.png'),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Xin chào,',
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text(
                    user.name ?? 'Unknown User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    specialization != null
                        ? specialization.name
                        : 'Chuyên khoa không xác định',
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class DoctorHomeController extends GetxController {
  final isLoading = false.obs;
  final doctor = Rxn<Doctor>();
  final specialization = Rxn<Specialization>();
  final user = Rxn<User>();
  final DoctorService _doctorService = DoctorService();
  final SpecializationService _specialization = SpecializationService();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadDoctorData();
    fetchSpecializationFromAPI();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    final fetchedUser = await getUserFromPrefs();
    user.value = fetchedUser;
    isLoading.value = false;
  }

  Future<void> loadDoctorData() async {
    final prefs = await SharedPreferences.getInstance();
    final doctorJson = prefs.getString('doctor_data');
    if (doctorJson != null) {
      doctor.value = Doctor.fromJson(jsonDecode(doctorJson));
      await fetchSpecializationFromAPI();
    } else {
      await fetchDoctorFromAPI();
    }
  }

  Future<void> fetchDoctorFromAPI() async {
    final currentUser = user.value;
    if (currentUser != null) {
      try {
        final doctors = await _doctorService.getDoctorsByUserId(currentUser.uuid);
        if (doctors.isNotEmpty) {
          doctor.value = doctors.first;
          await saveDoctorToPrefs(doctor.value!);
          await fetchSpecializationFromAPI();
        }
      } catch (e) {
        print('Error fetching doctor: $e');
      }
    }
  }

  Future<void> fetchSpecializationFromAPI() async {
    final currentDoctor = doctor.value;

    if (currentDoctor != null) {
      try {
        print('Fetching specialization for Doctor ID: ${currentDoctor.uuid}');

        final fetchedSpecialization = await _specialization.getById(currentDoctor.specializationId);

        print('Received specialization: $fetchedSpecialization');

        if (fetchedSpecialization != null) {
          if (fetchedSpecialization.name != null) {
            print('Specialization Name: ${fetchedSpecialization.name}');
          } else {
            print('Specialization does not have a name');
          }

          specialization.value = fetchedSpecialization;
          print('Specialization value updated successfully: ${fetchedSpecialization.name}');
        } else {
          print('No specialization found for Doctor ID: ${currentDoctor.uuid}');
        }
      } catch (e) {
        print('Error fetching specialization: $e');
      }
    } else {
      print('Doctor is null, cannot fetch specialization');
    }
  }

  Future<User?> getUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
      return null;
    } catch (e) {
      print('Error decoding user data: $e');
      return null;
    }
  }

  Future<void> saveDoctorToPrefs(Doctor doctor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('doctor_data', jsonEncode(doctor.toJson()));
  }
}

class _QuickStatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _StatCard(
              label: "Lịch hôm nay",
              icon: Icons.calendar_today,
              color: Colors.orange,
              onTap: () {
                print('Đã click Lịch hôm nay');
                try {
                  Get.toNamed(Routes.todayschedule);
                } catch (e) {
                  print('Error navigating to today schedule: $e');
                  // Fallback navigation
                  Get.to(() => Scaffold(
                    appBar: AppBar(title: const Text('Lịch hôm nay')),
                    body: const Center(child: Text('Trang lịch hôm nay')),
                  ));
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              label: "Cần xác nhận",
              icon: Icons.pending_actions,
              color: Colors.redAccent,
              onTap: () {
                print('Đã click Cần xác nhận');
                try {
                  Get.toNamed(Routes.confirmschedule);
                } catch (e) {
                  print('Error navigating to confirm schedule: $e');
                  // Fallback navigation
                  Get.to(() => Scaffold(
                    appBar: AppBar(title: const Text('Cần xác nhận')),
                    body: const Center(child: Text('Trang cần xác nhận')),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  
  const _StatCard({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        print('StatCard clicked: $label');
        if (onTap != null) {
          try {
            onTap!();
          } catch (e) {
            print('Error in onTap: $e');
          }
        }
      },
      child: Card(
        elevation: 5,
        shadowColor: color.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          width: 102,
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.14),
                radius: 18,
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(height: 8),
              Text(label,
                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'icon': Icons.person,
        'label': "Thông tin cá nhân",
        'color': Colors.blue,
        'route': '/profile',
      },
      {
        'icon': Icons.check_circle,
        'label': "Hồ sơ bác sĩ",
        'color': Colors.orange,
        'route': '/doctorinformation',
      },
      {
        'icon': Icons.add_circle_outline,
        'label': "Lịch làm việc",
        'color': Colors.purple,
        'route': '/doctorworkschedulepage',
      },
      {
        'label': "Thống kê số tiền",
        'icon': Icons.pie_chart,
        'color': Colors.green,
        'route': '/doctorstatisticspage',
        
      }
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 22,
          crossAxisSpacing: 22,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (_, i) {
          final item = actions[i];
          return Material(
            color: (item['color'] as Color).withOpacity(0.09),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                try {
                  Get.toNamed(item['route'] as String);
                } catch (e) {
                  print('Error navigating to ${item['route']}: $e');
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData,
                        size: 34, color: item['color'] as Color),
                    const SizedBox(height: 11),
                    Text(item['label'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ManageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quản lý khác',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Material(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(14),
            child: ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red, size: 28),
              title: const Text("Đăng xuất",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () {
                try {
                  Get.offAllNamed('/login');
                } catch (e) {
                  print('Error navigating to login: $e');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}