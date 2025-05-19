// lib/widgets/home/section_header.dart
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewMore;
  final String viewMoreText;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewMore,
    this.viewMoreText = 'Xem thêm',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (onViewMore != null)
            GestureDetector(
              onTap: onViewMore,
              child: Text(
                viewMoreText,
                style: const TextStyle(color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }
}