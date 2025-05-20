import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:ebookingdoc/src/widgets/controller/detail_doctor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorAppBar extends StatelessWidget {
  final DetailDoctorController controller;

  const DoctorAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      collapsedHeight: 80,
      pinned: true,
      flexibleSpace: Obx(() {
        final entity = controller.entity.value;
        if (entity == null) return Container();

        return FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              _buildHeroImage(entity),
              _buildGradientOverlay(),
            ],
          ),
          titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
          title: _buildAppBarTitle(entity),
        );
      }),
      leading: _buildBackButton(),
    );
  }

  Widget _buildHeroImage(MedicalEntity entity) {
    return Hero(
      tag: 'medical-${entity.id}',
      child: Image.asset(
        entity.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.6), Colors.transparent],
        ),
      ),
    );
  }

  Widget _buildAppBarTitle(MedicalEntity entity) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: entity.type.color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            entity.type.displayName.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          entity.name,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      onPressed: Get.back,
    );
  }
}