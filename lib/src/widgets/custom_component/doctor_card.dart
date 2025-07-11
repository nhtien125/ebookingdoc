import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';

final controller = Get.put(HomeController());

class DoctorCard extends StatelessWidget {
  final DoctorDisplay doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.viewDoctorDetails(doctor.doctor.uuid),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa nội dung
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
                image: DecorationImage(
                  image: doctor.doctor.image != null
                      ? NetworkImage(doctor.doctor.image!)
                      : const AssetImage('assets/images/default_doctor.jpg') as ImageProvider,
                  fit: BoxFit.cover,
                ),
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

class DoctorList extends StatelessWidget {
  final List<DoctorDisplay> doctors;

  const DoctorList({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: doctors.map((doctor) => Flexible(
          flex: 1, 
          child: DoctorCard(doctor: doctor),
        )).toList(),
      ),
    );
  }
}
