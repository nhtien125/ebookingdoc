import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:flutter/material.dart';

class HospitalAddressSection extends StatelessWidget {
  final Hospital hospital;

  const HospitalAddressSection({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Địa chỉ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.red[400]),
                const SizedBox(width: 8),
                Expanded(child: Text(hospital.address)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}