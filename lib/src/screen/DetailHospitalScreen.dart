import 'package:ebookingdoc/src/widgets/controller/appointment_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/vaccination_center_model.dart';
import 'package:ebookingdoc/src/constants/app_page.dart';

class DetailHospitalScreen extends StatelessWidget {
  const DetailHospitalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    Clinic? clinic;
    Hospital? hospital;
    VaccinationCenter? vaccinationCenter;

    if (args.containsKey('status') || args.containsKey('working_hours')) {
      vaccinationCenter = VaccinationCenter.fromJson(args);
    } else if (args.containsKey('phone') || args.containsKey('email')) {
      clinic = Clinic.fromJson(args);
    } else {
      hospital = Hospital.fromJson(args);
    }

    final name =
        hospital?.name ?? clinic?.name ?? vaccinationCenter?.name ?? '';
    final address = hospital?.address ??
        clinic?.address ??
        vaccinationCenter?.address ??
        '';
    final image =
        hospital?.image ?? clinic?.image ?? vaccinationCenter?.image ?? '';
    final description = hospital?.description ??
        clinic?.description ??
        vaccinationCenter?.description ??
        '';
    final phone = clinic?.phone ?? vaccinationCenter?.phone ?? '';
    final email = clinic?.email ?? vaccinationCenter?.email ?? '';

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[900],
        elevation: 0,
        centerTitle: true,
        title: Text(
          name.isNotEmpty ? name : "Chi tiết",
          style: const TextStyle(
              fontWeight: FontWeight.bold, letterSpacing: 0.5, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 110),
            children: [
              Container(
                height: 240,
                margin: const EdgeInsets.all(0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Ảnh bìa
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        child: Image.network(
                          image.isNotEmpty
                              ? image
                              : 'https://via.placeholder.com/800x300.png?text=No+Image',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.blueGrey[200],
                            child: const Center(
                              child: Icon(Icons.local_hospital,
                                  size: 60, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Avatar nổi, bóng mờ
                    Positioned(
                      left: 32,
                      bottom: -38,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(48),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 34,
                            backgroundImage: image.isNotEmpty
                                ? NetworkImage(image)
                                : const AssetImage(
                                        'assets/images/hospital_default.png')
                                    as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              // Card info chính
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Địa chỉ
                      _buildInfoSection(
                        icon: Icons.location_on_rounded,
                        iconColor: Colors.redAccent[200]!,
                        title: "Địa chỉ",
                        value: address.isNotEmpty
                            ? address
                            : "Chưa cập nhật địa chỉ",
                      ),
                      const SizedBox(height: 22),
                      // Số điện thoại
                      if (phone.isNotEmpty)
                        _buildInfoSection(
                          icon: Icons.phone,
                          iconColor: Colors.green[700]!,
                          title: "Số điện thoại",
                          value: phone,
                        ),
                      // Email
                      if (email.isNotEmpty)
                        _buildInfoSection(
                          icon: Icons.email,
                          iconColor: Colors.blue[700]!,
                          title: "Email",
                          value: email,
                        ),
                      const SizedBox(height: 22),
                      // Giới thiệu
                      _buildInfoSection(
                        icon: Icons.info_outline,
                        iconColor: Colors.blue[700]!,
                        title: "Giới thiệu",
                        value: (description ?? '').isNotEmpty
                            ? description!
                            : "Chưa có thông tin giới thiệu.",
                      ),
                      if (vaccinationCenter != null) ...[
                        const SizedBox(height: 22),
                        _buildInfoSection(
                          icon: Icons.access_time,
                          iconColor: Colors.green[700]!,
                          title: "Giờ hoạt động",
                          value:
                              (vaccinationCenter.workingHours ?? '').isNotEmpty
                                  ? vaccinationCenter.workingHours!
                                  : "Chưa cập nhật giờ hoạt động",
                        ),
                        const SizedBox(height: 22),
                        _buildInfoSection(
                          icon: Icons.verified_user,
                          iconColor: Colors.orange[700]!,
                          title: "Trạng thái",
                          value: (vaccinationCenter.status ?? '').isNotEmpty
                              ? vaccinationCenter.status!
                              : "Chưa cập nhật trạng thái",
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 18),
                color: Colors.transparent,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.delete<AppointmentScreenController>();
                      if (hospital != null) {
                        Get.toNamed(
                          Routes.appointmentScreen,
                          arguments: {
                            'hospital': hospital.toJson(),
                            'selectedPlaceType': 'hospital',
                          },
                        );
                      } else if (clinic != null) {
                        Get.toNamed(
                          Routes.appointmentScreen,
                          arguments: {
                            'clinic': clinic.toJson(),
                            'selectedPlaceType': 'clinic',
                          },
                        );
                      } else if (vaccinationCenter != null) {
                        Get.toNamed(
                          Routes.appointmentScreen,
                          arguments: {
                            'vaccination_center': vaccinationCenter.toJson(),
                            'selectedPlaceType': 'vaccination',
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.blue[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    icon: const Icon(Icons.calendar_month, size: 24),
                    label: const Text('Đặt lịch khám'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper cho từng mục info
  Widget _buildInfoSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: iconColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style:
              const TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
        ),
      ],
    );
  }
}
