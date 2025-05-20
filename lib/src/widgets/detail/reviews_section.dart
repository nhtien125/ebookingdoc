import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReviewsSection extends StatelessWidget {
  final MedicalEntity entity;

  const ReviewsSection({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Đánh giá',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (entity.reviews.isEmpty)
          const Center(child: Text('Chưa có đánh giá nào'))
        else
          ...entity.reviews.take(2).map((review) => _buildReviewItem(review)),
        if (entity.reviews.length > 2)
          TextButton(
            onPressed: () => _showAllReviews(entity.reviews),
            child: Text(
              'Xem thêm ${entity.reviews.length - 2} đánh giá',
              style: TextStyle(color: entity.type.color),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewItem(Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(review.patientAvatar),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.patientName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: index < review.rating.floor()
                              ? Colors.amber
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  DateFormat('dd/MM/yyyy').format(review.date),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(review.comment, style: const TextStyle(height: 1.5)),
          ],
        ),
      ),
    );
  }

  void _showAllReviews(List<Review> reviews) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text(
              'Tất cả đánh giá',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) => _buildReviewItem(reviews[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}