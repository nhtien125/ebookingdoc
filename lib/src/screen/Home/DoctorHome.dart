import 'dart:convert';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/Doctorservice.dart';
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
    Get.put(DoctorHomeController());
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
        padding:
            const EdgeInsets.only(top: 40, left: 22, right: 22, bottom: 24),
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
                    user.name ?? 'Unknown User', // Provide default value
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    specialization != null
                        ? specialization.name // Hiển thị tên chuyên khoa nếu có
                        : 'Chuyên khoa không xác định', // Nếu không có chuyên khoa
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
  final doctor = Rxn<Doctor>(); // Rxn<Doctor> cho phép giá trị null
  final specialization = Rxn<Specialization>();
  final user = Rxn<User>(); // Thêm biến để lưu user
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
      // Sau khi doctor được gán giá trị, gọi fetchSpecializationFromAPI
      await fetchSpecializationFromAPI();
    } else {
      await fetchDoctorFromAPI();
    }
  }

  Future<void> fetchDoctorFromAPI() async {
    final currentUser = user.value;
    if (currentUser != null) {
      try {
        final doctors =
            await _doctorService.getDoctorsByUserId(currentUser.uuid);
        if (doctors.isNotEmpty) {
          doctor.value = doctors.first;
          await saveDoctorToPrefs(doctor.value!);
          // Sau khi doctor được gán giá trị, gọi fetchSpecializationFromAPI
          await fetchSpecializationFromAPI();
        }
      } catch (e) {
        print('Error fetching doctor: $e');
      }
    }
  }

  Future<void> fetchSpecializationFromAPI() async {
    final currentDoctor = doctor.value;

    // Kiểm tra nếu currentDoctor không phải là null
    if (currentDoctor != null) {
      try {
        // Log ID bác sĩ trước khi lấy chuyên khoa
        print('Fetching specialization for Doctor ID: ${currentDoctor.uuid}');

        // Lấy chuyên khoa từ API
        final fetchedSpecialization =
            await _specialization.getById(currentDoctor.specializationId);

        // Log kết quả trả về từ API (In toàn bộ đối tượng chuyên khoa)
        print('Received specialization: $fetchedSpecialization');

        if (fetchedSpecialization != null) {
          // Kiểm tra xem fetchedSpecialization có thuộc tính name không, và log tên chuyên khoa
          print('Specialization Name: ${fetchedSpecialization.name}');

          specialization.value = fetchedSpecialization; // Cập nhật chuyên khoa
          // Log khi chuyên khoa được cập nhật
          print(
              'Specialization value updated successfully: ${fetchedSpecialization.name}');
        } else {
          print('No specialization found for Doctor ID: ${currentDoctor.uuid}');
        }
      } catch (e) {
        // Log lỗi nếu có
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
    // Data cứng, sau này truyền từ controller

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _StatCard(
              label: "Lịch hôm nay",
              value: "",
              icon: Icons.calendar_today,
              color: Colors.orange,
              onTap: () {
                print('Đã click Lịch hôm nay');
                Get.toNamed(Routes.todayschedule);
              },
            ),
          ),
          const SizedBox(width: 8), // Giảm khoảng cách giữa các phần tử
          Expanded(
            child: _StatCard(
              label: "Lịch khám",
              value: "",
              icon: Icons.pending_actions,
              color: Colors.redAccent,
              onTap: () {
                print('Đã click Lịch hôm nay');
                Get.to(Routes.confirmschedule);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap, // <-- Thêm dòng này để nhận sự kiện click
      child: Card(
        elevation: 5,
        shadowColor: color.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          width: 102,
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.14),
                    radius: 18,
                    child: Icon(icon, color: color, size: 21),
                  ),
                  if (label == "Cần xác nhận" &&
                      int.tryParse(value) != null &&
                      int.parse(value) > 0)
                    Positioned(
                      right: -1,
                      top: -3,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(9)),
                        child: Text(value,
                            style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(value,
                  style: TextStyle(
                      fontSize: 20, color: color, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
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
        'route': '/personal',
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
              onTap: () => Get.toNamed(item['route'] as String),
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
              leading:
                  const Icon(Icons.exit_to_app, color: Colors.red, size: 28),
              title: const Text("Đăng xuất",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () => Get.toNamed('/login'),
            ),
          ),
        ],
      ),
    );
  }
}
