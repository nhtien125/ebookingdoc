import 'package:flutter/material.dart';
import 'status_badge.dart';

class AppointmentHeader extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentHeader({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            appointment['hospitalName'] ?? 'Phòng khám chưa xác định',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        StatusBadge(status: appointment['status']),
      ],
    );
  }
}