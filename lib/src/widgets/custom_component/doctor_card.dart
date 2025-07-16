import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';

// Đảm bảo bạn có DoctorDisplay trong project!

final controller = Get.find<HomeController>();

class DoctorCard extends StatelessWidget {
  final DoctorDisplay doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.viewDoctorDetails(doctor.doctor.uuid),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 110, // fix width card cho ổn định khi scroll nhanh
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: ClipOval(
                child: doctor.user?.image != null && doctor.user!.image!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: doctor.user!.image!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (context, url, error) => Image.asset('assets/images/default_doctor.jpg'),
                    )
                  : Image.asset('assets/images/default_doctor.jpg', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              doctor.user?.name ?? 'Không rõ tên',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              doctor.specialization?.name ?? 'Chưa rõ chuyên khoa',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
