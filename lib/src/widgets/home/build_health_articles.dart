import 'package:ebookingdoc/src/screen/News/article_detail.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:ebookingdoc/src/widgets/custom_component/article_card.dart';
import 'package:ebookingdoc/src/widgets/custom_component/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildHealthArticles extends StatelessWidget {
  const BuildHealthArticles({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

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
          Obx(() {
            if (controller.article.isEmpty) {
              return const Center(child: Text('Không có dữ liệu'));
            }
            return SizedBox(
              height: 265,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.article.length,
                itemBuilder: (context, index) {
                  final article = controller.article[index];
                  return ArticleCard(
                    article: article,
                    onTap: () => Get.to(() => ArticleDetail(article: article)),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
