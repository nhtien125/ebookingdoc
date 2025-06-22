import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
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
          )
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 37,
            backgroundImage: NetworkImage(
                'https://chienthanky.vn/wp-content/uploads/2024/01/top-100-anh-gai-2k7-cuc-xinh-ngay-tho-thuan-khiet-2169-31.jpg'),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Xin chào,',
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                Text('BS. Nguyễn Văn An',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold)),
                Text('Chuyên khoa Tim mạch',
                    style: TextStyle(color: Colors.white70, fontSize: 15)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Xử lý logout nếu muốn
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}

class _QuickStatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Data cứng, sau này truyền từ controller
    final todayPatients = 4;
    final schedules = 8;
    final day = 7;
    final waitingConfirm = 2;
    final totalPatients = 105;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatCard(
            label: "Lịch hôm nay",
            value: "$todayPatients",
            icon: Icons.calendar_today,
            color: Colors.orange,
            onTap: () {
              print('Đã click Lịch hôm nay');
              Get.toNamed(Routes.todayschedule);
            },
          ),
          _StatCard(
            label: "Cần xác nhận",
            value: "$waitingConfirm",
            icon: Icons.pending_actions,
            color: Colors.redAccent,
            onTap: () {
              print('Đã click Lịch hôm nay');
              Get.toNamed(Routes.confirmschedule);
            },
          ),
          _StatCard(
            label: "Bệnh nhân",
            value: "$totalPatients",
            icon: Icons.people,
            color: Colors.green,
            onTap: () => Get.toNamed('/doctor/patients'),
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
              onTap: () => Get.offAllNamed('/login'),
            ),
          ),
        ],
      ),
    );
  }
}
