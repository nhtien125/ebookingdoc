import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:flutter/material.dart';

class DoctorAboutSection extends StatelessWidget {
  final MedicalEntity entity;

  const DoctorAboutSection({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giới thiệu',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              entity.about,
              style: const TextStyle(height: 1.6),
            ),
          ),
        ),
      ],
    );
  }
}