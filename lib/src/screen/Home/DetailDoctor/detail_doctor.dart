
import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:ebookingdoc/src/widgets/Home/DetailDoctor/detail_doctor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailDoctor extends StatelessWidget {
  DetailDoctor({super.key});
  final DetailDoctorController controller = Get.put(DetailDoctorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          _buildFlexibleAppBar(),
          _buildContentSection(),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  // 1. Phần AppBar động
  SliverAppBar _buildFlexibleAppBar() {
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

  // 2. Phần nội dung chính
  SliverToBoxAdapter _buildContentSection() {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.entity.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final entity = controller.entity.value!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildMainInfoCard(entity),
            _buildDetailSections(entity),
            const SizedBox(height: 100), // Space for bottom button
          ],
        );
      }),
    );
  }

  Widget _buildMainInfoCard(MedicalEntity entity) {
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
          _buildInfoChip(Icons.work, '${entity.experience}+ năm'),
          const SizedBox(width: 8),
          _buildInfoChip(Icons.people, '${entity.patientCount}+ BN'),
        ],
        if (entity is Hospital) ...[
          _buildInfoChip(Icons.business, '${entity.departmentCount} khoa'),
          const SizedBox(width: 8),
          _buildInfoChip(Icons.people, '${entity.doctorCount} bác sĩ'),
        ],
        if (entity is Clinic) ...[
          _buildInfoChip(Icons.phone, entity.phoneNumber),
        ],
        if (entity is VaccinationCenter) ...[
          _buildInfoChip(Icons.vaccines,
              '${entity.availableVaccines.length} loại vắc xin'),
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
          _buildStatItem('Kinh nghiệm', '${entity.experience} năm'),
          _buildStatItem('Bệnh nhân', '${entity.patientCount}+'),
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
          _buildStatItem('Khoa phòng', '${entity.departmentCount}'),
          _buildStatItem('Bác sĩ', '${entity.doctorCount}'),
          _buildStatItem('Đánh giá', '${entity.rating}/5'),
        ],
      );
    } else if (entity is Clinic) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2,
        children: [
          _buildStatItem('Giám đốc', entity.director),
          _buildStatItem('Điện thoại', entity.phoneNumber),
        ],
      );
    } else if (entity is VaccinationCenter) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2,
        children: [
          _buildStatItem('Vắc xin', '${entity.availableVaccines.length} loại'),
          _buildStatItem('Giờ mở cửa', entity.is24h ? '24/7' : '7:30 - 17:00'),
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

  Widget _buildDetailSections(MedicalEntity entity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle('Giới thiệu'),
          _buildAboutSection(entity),
          if (entity is Doctor) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Chuyên khoa'),
            _buildSpecializationSection(entity),
          ],
          if (entity is Hospital) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Địa chỉ'),
            _buildAddressSection(entity),
          ],
          if (entity is Clinic) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Thông tin liên hệ'),
            _buildContactSection(entity),
          ],
          if (entity is VaccinationCenter) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Loại vắc xin'),
            _buildVaccinesSection(entity),
          ],
          const SizedBox(height: 24),
          _buildSectionTitle('Lịch làm việc'),
          _buildScheduleSection(entity),
          const SizedBox(height: 24),
          _buildSectionTitle('Đánh giá'),
          _buildReviewsSection(entity),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAboutSection(MedicalEntity entity) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          entity.about,
          style: const TextStyle(height: 1.6),
        ),
      ),
    );
  }

  Widget _buildSpecializationSection(Doctor doctor) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chuyên khoa: ${doctor.specialization}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Bệnh viện: ${doctor.hospital}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(Hospital hospital) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.red[400]),
            const SizedBox(width: 8),
            Expanded(child: Text(hospital.address)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(Clinic clinic) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red[400]),
                const SizedBox(width: 8),
                Expanded(child: Text(clinic.address)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue[400]),
                const SizedBox(width: 8),
                Text(clinic.phoneNumber),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccinesSection(VaccinationCenter center) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Các loại vắc xin có sẵn:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: center.availableVaccines
                  .map((vaccine) => Chip(
                        label: Text(vaccine),
                        backgroundColor: Colors.orange[50],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection(MedicalEntity entity) {
    return Column(
      children: [
        _buildDateSelector(),
        const SizedBox(height: 16),
        _buildTimeSlotsGrid(),
      ],
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 100,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.availableDates.length,
          itemBuilder: (context, index) {
            final date = controller.availableDates[index];
            return _buildDateItem(date, index);
          },
        ),
      ),
    );
  }

  Widget _buildDateItem(DateTime date, int index) {
    final isSelected = index == controller.selectedDateIndex.value;
    final dayName = DateFormat('E', 'vi_VN').format(date);
    final isToday = date.day == DateTime.now().day;

    return GestureDetector(
      onTap: () => controller.selectDate(index),
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? controller.entity.value!.type.color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? controller.entity.value!.type.color
                : Colors.grey[300]!,
          ),
          boxShadow: [
            if (isToday && !isSelected)
              BoxShadow(
                color: controller.entity.value!.type.color.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            if (isToday)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : controller.entity.value!.type.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Hôm nay',
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? controller.entity.value!.type.color
                        : Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotsGrid() {
    return Obx(() {
      if (controller.selectedDateIndex.value == -1) {
        return const Center(child: Text('Vui lòng chọn ngày'));
      }

      if (controller.entity.value == null || 
          controller.entity.value!.availableSlots.isEmpty) {
        return const Center(child: Text('Không có khung giờ trống'));
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: controller.entity.value!.availableSlots.length,
        itemBuilder: (context, index) {
          return _buildTimeSlotItem(index);
        },
      );
    });
  }

  Widget _buildTimeSlotItem(int index) {
    final isSelected = index == controller.selectedTimeIndex.value;
    final slot = controller.entity.value!.availableSlots[index];

    return GestureDetector(
      onTap: () => controller.selectTime(index),  
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected ? controller.entity.value!.type.color : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? controller.entity.value!.type.color
                : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            slot,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsSection(MedicalEntity entity) {
    return Column(
      children: [
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
  }//sửa

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
                itemBuilder: (context, index) =>
                    _buildReviewItem(reviews[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //////////// Phâmn cuối cùng ////////////

  // 3. Phần bottom action
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() {
        final isEnabled = controller.selectedTimeIndex.value != -1;
        final entity = controller.entity.value;

        return Row(
          children: [
            if (entity != null && entity.type == MedicalType.doctor) ...[
              _buildIconActionButton(
                icon: Icons.message,
                color: Colors.blue[100]!,
                iconColor: Colors.blue,
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              _buildIconActionButton(
                icon: Icons.call,
                color: Colors.green[100]!,
                iconColor: Colors.green,
                onPressed: () {},
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: isEnabled ? controller.bookAppointment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEnabled
                      ? controller.entity.value?.type.color ?? Colors.blue
                      : Colors.grey[300],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(entity?.type.icon ?? Icons.calendar_today, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      entity?.type == MedicalType.doctor
                          ? 'ĐẶT LỊCH KHÁM'
                          : 'ĐẶT HẸN NGAY',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildIconActionButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor),
        onPressed: onPressed,
      ),
    );
  }
}