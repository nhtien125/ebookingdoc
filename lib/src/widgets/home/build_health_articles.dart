// lib/widgets/home/build_health_articles.dart
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:ebookingdoc/src/widgets/custom_component/article_card.dart';
import 'package:ebookingdoc/src/widgets/custom_component/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';

final controller = Get.put(HomeController());

class BuildHealthArticles extends StatelessWidget {
  const BuildHealthArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Sống khỏe mỗi ngày',
            onViewMore: () => controller.viewAllArticles(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.healthArticles.length,
              itemBuilder: (context, index) {
                return ArticleCard(article: controller.healthArticles[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}