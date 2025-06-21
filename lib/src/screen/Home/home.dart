import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/home/build_categories.dart';
import 'package:ebookingdoc/src/widgets/home/build_comprehensive_services.dart';
import 'package:ebookingdoc/src/widgets/home/build_featured_doctors.dart';
import 'package:ebookingdoc/src/widgets/home/build_health_articles.dart';
import 'package:ebookingdoc/src/widgets/home/build_nearest_clinics.dart';
import 'package:ebookingdoc/src/widgets/home/build_recommended_hospitals.dart';
import 'package:ebookingdoc/src/widgets/home/build_upcoming_appointments.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: AppColor.fourthMain,
                elevation: 0,
                pinned: true,
                expandedHeight: kToolbarHeight,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'EbookingDoc',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.fourthMain,
                          AppColor.primaryDark,
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {}, // controller.onSearchPressed,
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                    onPressed: () {}, // controller.onNotificationPressed,
                  ),
                ],
              ),
            ],
            body: RefreshIndicator(
              onRefresh: controller.refreshData,
              child: const SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildCategories(),
                    SizedBox(height: 12),
                    BuildFeaturedDoctors(),
                    SizedBox(height: 12),
                    BuildComprehensiveServices(),
                    SizedBox(height: 12),
                    BuildRecommendedHospitals(),
                    SizedBox(height: 12),
                    BuildNearestClinics(),
                    SizedBox(height: 12),
                    BuildHealthArticles(),
                    SizedBox(height: 12),
                    BuildUpcomingAppointments(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
