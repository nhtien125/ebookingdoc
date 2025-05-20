import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:flutter/material.dart';

class ClinicContactSection extends StatelessWidget {
  final Clinic clinic;

  const ClinicContactSection({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin liên hệ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red[400]),
                    const SizedBox(width: 8),
                    Expanded(child: Text(clinic.address)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.blue[400]),
                    const SizedBox(width: 8),
                    Text(clinic.phoneNumber),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}