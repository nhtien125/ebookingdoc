import 'package:ebookingdoc/src/screen/News/new.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';

final controller = Get.put(HomeController());

class ArticleCard extends StatelessWidget {
  final dynamic article;

  const ArticleCard(
      {super.key, required this.article, required void Function() onTap});

  @override
Widget build(BuildContext context) {
  return GestureDetector(
    // onTap: () {
    //   Get.to(() => News(article: article.id));
    // },
    child: Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: article.image != null && article.image.isNotEmpty
                ? Image.network(
                    article.image,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 36, color: Colors.white70),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 36, color: Colors.white70),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      article.createdAt,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
} 