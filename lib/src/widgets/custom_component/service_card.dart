import 'package:ebookingdoc/src/data/model/medical_service_model.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final MedicalServiceModel service;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ảnh dịch vụ
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                service.image ?? '',
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            // Tên dịch vụ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                service.name ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Mô tả dịch vụ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                service.description ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
            // Giá dịch vụ
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                service.price != null
                    ? '${service.price} VNĐ'
                    : 'Liên hệ',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.redAccent,
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