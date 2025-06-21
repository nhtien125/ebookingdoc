import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ebookingdoc/src/widgets/controller/detail_doctor_controller.dart';
import 'package:ebookingdoc/src/data/model/review_model.dart';

class DetailDoctor extends StatelessWidget {
  DetailDoctor({super.key});
  final controller = Get.put(DetailDoctorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Obx(() {
          if (controller.doctor.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildDoctorInfo(),
                    _buildStatistics(),
                    _buildAboutDoctor(),
                    _buildAvailableDates(),
                    _buildAvailableSlots(),
                    _buildReviewsSection(),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      persistentFooterButtons: [_buildBookAppointmentButton()],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.blue[700],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: Get.back,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Obx(
          () {
            final doctor = controller.doctor.value!;
            if (doctor.image != null && doctor.image!.isNotEmpty) {
              return doctor.image!.startsWith('http')
                  ? Image.network(doctor.image!, fit: BoxFit.cover)
                  : Image.asset(doctor.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholderAvatar());
            }
            return _buildPlaceholderAvatar();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      color: Colors.blue[900],
      child: const Center(
          child: Icon(Icons.person, size: 120, color: Colors.white)),
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Obx(() {
        final doctor = controller.doctor.value!;
        final avgRating = controller.getAverageRating();
        final reviewCount = controller.getReviewCount();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //   Text(doctor.name ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            //     Text(doctor.specialization ?? '', style: TextStyle(fontSize: 18, color: Colors.blue[700])),
            const SizedBox(height: 4),
            //    Text(doctor.hospital ?? '', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 12),
            Row(
              children: [
                RatingBarIndicator(
                  rating: avgRating,
                  itemBuilder: (_, __) =>
                      const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20,
                ),
                const SizedBox(width: 8),
                Text(
                    "${avgRating.toStringAsFixed(1)} (${reviewCount} đánh giá)",
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatistics() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Obx(() {
        final doctor = controller.doctor.value!;
        final avgRating = controller.getAverageRating();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
                Icons.work, "${doctor.experience ?? 0} năm", "Kinh nghiệm"),
            _buildStatItem(
                Icons.people, "${doctor.patientCount ?? 0}+", "Bệnh nhân"),
            _buildStatItem(
                Icons.star, "${(avgRating / 5 * 100).toInt()}%", "Hài lòng"),
          ],
        );
      }),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[700], size: 28),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildAboutDoctor() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Obx(() {
        final doctor = controller.doctor.value!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Giới thiệu",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(doctor.introduce ?? '',
                style: const TextStyle(fontSize: 14, height: 1.5)),
          ],
        );
      }),
    );
  }

// ...existing code...
  Widget _buildAvailableDates() {
    final dates = controller.schedules
        .map((s) => DateTime.parse(s.workDate))
        .toSet()
        .toList()
      ..sort();

    if (dates.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Không có ngày khám hợp lệ",
            style: TextStyle(color: Colors.grey)),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 32), // Thêm dòng này!
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isToday = date.day == DateTime.now().day &&
              date.month == DateTime.now().month &&
              date.year == DateTime.now().year;
          final dayName = DateFormat('E', 'vi_VN').format(date);

          return Obx(() {
            final isSelected = index == controller.selectedDateIndex.value;
            return GestureDetector(
              onTap: () => controller.selectedDateIndex.value = index,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 70,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[700] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: Colors.blue.withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[800],
                        fontWeight: FontWeight.w600,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.blue[700],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Hôm nay',
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.blue[700] : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildAvailableSlots() {
    // Lấy danh sách ngày duy nhất từ schedules
    final dates = controller.schedules
        .map((s) => DateTime.parse(s.workDate))
        .toSet()
        .toList()
      ..sort();

    if (controller.selectedDateIndex.value < 0 ||
        controller.selectedDateIndex.value >= dates.length) {
      return const Center(child: Text('Vui lòng chọn ngày'));
    }

    final selectedDate = dates[controller.selectedDateIndex.value];

    // Lấy các schedule theo ngày đã chọn
    final slots = controller.schedules.where((s) {
      final d = DateTime.parse(s.workDate);
      return d.year == selectedDate.year &&
          d.month == selectedDate.month &&
          d.day == selectedDate.day;
    }).toList();

    if (slots.isEmpty) {
      return const Center(child: Text('Không có khung giờ trống'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8), // Thêm padding ngoài
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        return Obx(() {
          final isSelected = index == controller.selectedTimeIndex.value;
          final slot = slots[index];
          return GestureDetector(
            onTap: () => controller.selectedTimeIndex.value = index,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.all(2), // Thêm margin cho từng slot
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[700] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: Colors.blue.withOpacity(0.13),
                            blurRadius: 6,
                            offset: const Offset(0, 2))
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  '${slot.startTime} - ${slot.endTime}',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildReviewsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Obx(() {
        final reviews = controller.reviews;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildSectionHeader(Icons.reviews, "Đánh giá"),
                const Spacer(),
                TextButton(
                  onPressed: _showAllReviews,
                  child: const Text(
                    "Xem thêm",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (reviews.isEmpty)
              const Center(
                  child: Text("Chưa có đánh giá nào",
                      style: TextStyle(color: Colors.grey)))
            else
              Column(children: reviews.take(3).map(_buildReviewItem).toList()),
          ],
        );
      }),
    );
  }

  Widget _buildReviewItem(Review review) {
    ImageProvider? avatarProvider;
    if (review.patientAvatar != null && review.patientAvatar.isNotEmpty) {
      if (review.patientAvatar.startsWith('http')) {
        avatarProvider = NetworkImage(review.patientAvatar);
      } else {
        avatarProvider = AssetImage(review.patientAvatar);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue[100],
                backgroundImage: avatarProvider,
                child: avatarProvider == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.patientName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  RatingBarIndicator(
                    rating: review.stars.toDouble(),
                    itemBuilder: (_, __) =>
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                    itemCount: 5,
                    itemSize: 16,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                DateFormat('dd/MM/yyyy').format(review.createdAt),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.comment ?? '', style: const TextStyle(height: 1.5)),
        ],
      ),
    );
  }

  void _showAllReviews() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          final reviews = controller.reviews;
          return Column(
            children: [
              const Text(
                "Tất cả đánh giá",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (_, index) => _buildReviewItem(reviews[index]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBookAppointmentButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final isEnabled = controller.selectedTimeIndex.value != -1;
        return ElevatedButton(
          onPressed: isEnabled ? () => controller.bookAppointment() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? Colors.blue[700] : Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                  color: isEnabled ? Colors.blue[700]! : Colors.grey[400]!),
            ),
            elevation: isEnabled ? 3 : 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 12),
              Text(
                "ĐẶT LỊCH KHÁM",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  BoxShadow _buildBoxShadow() {
    return BoxShadow(
      color: Colors.blue.withOpacity(0.2),
      spreadRadius: 1,
      blurRadius: 5,
    );
  }
}
