import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:flutter/material.dart';

class VaccinationCenterVaccinesSection extends StatelessWidget {
  final VaccinationCenter center;

  const VaccinationCenterVaccinesSection({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại vắc xin',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Các loại vắc xin có sẵn:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: center.availableVaccines
                      .map((vaccine) => Chip(
                            label: Text(vaccine),
                            backgroundColor: Colors.orange[50],
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}