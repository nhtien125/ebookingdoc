import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceCard extends StatelessWidget {
  final dynamic service;
  final Widget? icon;
  final Color? color;

  const ServiceCard({
    super.key,
    required this.service,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return GestureDetector(
      onTap: () => controller.selectService(service.id ?? service.uuid),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (color ?? Colors.blue).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: icon ?? const Icon(Icons.medical_services, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                service.name ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
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