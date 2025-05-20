import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String? status;

  const StatusBadge({super.key, this.status});

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Đã xác nhận':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      case 'Đã hoàn thành':
        return Colors.blue;
      case 'Đang chờ':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status ?? 'Không xác định',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}