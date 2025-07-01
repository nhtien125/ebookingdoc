import 'dart:convert';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/home/build_categories.dart';
import 'package:ebookingdoc/src/widgets/home/build_comprehensive_services.dart';
import 'package:ebookingdoc/src/widgets/home/build_featured_doctors.dart';
import 'package:ebookingdoc/src/widgets/home/build_health_articles.dart';
import 'package:ebookingdoc/src/widgets/home/build_nearest_clinics.dart';
import 'package:ebookingdoc/src/widgets/home/build_recommended_hospitals.dart';
import 'package:ebookingdoc/src/widgets/controller/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final controller = Get.put(HomeController());

  Future<User?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return FutureBuilder<User?>(
            future: getUserFromPrefs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: Text('No user data found'));
              }

              User? user = snapshot.data;

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 90,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      flexibleSpace: Container(
                        padding: const EdgeInsets.only(
                            top: 10, left: 15, right: 15, bottom: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade800,
                              Colors.blue.shade400
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(38),
                            bottomRight: Radius.circular(38),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade100.withOpacity(0.27),
                              blurRadius: 16,
                              offset: const Offset(0, 7),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 37,
                              backgroundImage:
                                  user!.image != null && user.image!.isNotEmpty
                                      ? NetworkImage(user.image!)
                                      : const AssetImage(
                                              'assets/default_avatar.png')
                                          as ImageProvider,
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Căn giữa theo chiều dọc
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Xin chào,',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 16)),
                                  Text(
                                    user.name ?? 'Unknown User',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
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
                        BuildHealthArticles(),
                        SizedBox(height: 12),
                        BuildRecommendedHospitals(),
                        SizedBox(height: 12),
                        BuildNearestClinics(),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
