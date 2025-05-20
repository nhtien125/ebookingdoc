import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:flutter/material.dart';

class DoctorInfoCard extends StatelessWidget {
  final MedicalEntity entity;

  const DoctorInfoCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingRow(entity),
            const SizedBox(height: 12),
            _buildDivider(),
            const SizedBox(height: 12),
            _buildStatsGrid(entity),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(MedicalEntity entity) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: entity.type.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: entity.type.color, size: 18),
              const SizedBox(width: 4),
              Text(
                '${entity.rating}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: entity.type.color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${entity.reviewCount})',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (entity is Doctor) ...[
          _buildInfoChip(Icons.work, '${(entity).experience}+ năm'),
          const SizedBox(width: 8),
          _buildInfoChip(Icons.people, '${(entity).patientCount}+ BN'),
        ],
        if (entity is Hospital) ...[
          _buildInfoChip(Icons.business, '${(entity).departmentCount} khoa'),
          const SizedBox(width: 8),
          _buildInfoChip(Icons.people, '${(entity).doctorCount} bác sĩ'),
        ],
        if (entity is Clinic) ...[
          _buildInfoChip(Icons.phone, (entity).phoneNumber),
        ],
        if (entity is VaccinationCenter) ...[
          _buildInfoChip(Icons.vaccines,
              '${(entity).availableVaccines.length} loại vắc xin'),
        ],
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.grey[100],
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[200]);
  }

  Widget _buildStatsGrid(MedicalEntity entity) {
    if (entity is Doctor) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        children: [
          _buildStatItem('Kinh nghiệm', '${(entity).experience} năm'),
          _buildStatItem('Bệnh nhân', '${(entity).patientCount}+'),
          _buildStatItem('Đánh giá', '${entity.rating}/5'),
        ],
      );
    } else if (entity is Hospital) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        children: [
          _buildStatItem('Khoa phòng', '${(entity).departmentCount}'),
          _buildStatItem('Bác sĩ', '${(entity).doctorCount}'),
          _buildStatItem('Đánh giá', '${entity.rating}/5'),
        ],
      );
    } else if (entity is Clinic) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2,
        children: <Widget>[
          _buildStatItem('Giám đốc', (entity).director),
          _buildStatItem('Điện thoại', (entity).phoneNumber),
        ],
      );
    } else if (entity is VaccinationCenter) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2,
        children: [
          _buildStatItem('Vắc xin', '${(entity).availableVaccines.length} loại'),
          _buildStatItem('Giờ mở cửa', (entity).is24h ? '24/7' : '7:30 - 17:00'),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}