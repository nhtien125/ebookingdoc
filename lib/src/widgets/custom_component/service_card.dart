import 'package:ebookingdoc/src/data/model/medical_service_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';

class ServiceCard extends StatelessWidget {
  final MedicalServiceModel service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return GestureDetector(
      onTap: () => controller.selectService(service.uuid),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar hình tròn chứa ảnh thật của dịch vụ
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: ClipOval(
                child: service.image != null && service.image!.isNotEmpty
                    ? Image.network(
                        service.image!,
                        fit: BoxFit.cover,
                        width: 62,
                        height: 62,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, color: Colors.grey, size: 32),
                      )
                    : Icon(Icons.medical_services, color: Colors.blue, size: 32),
              ),
            ),
            const SizedBox(height: 10),
            // Tên dịch vụ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                service.name ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
