import 'package:ebookingdoc/main.dart';
import 'package:ebookingdoc/src/data/model/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/data/model/review_model.dart';
import 'package:ebookingdoc/src/widgets/controller/detail_doctor_controller.dart';

// Constants for styling (aligned with BuildDoctorCard and ExcellentDoctor)
const _kCardBorderRadius = 12.0;
const _kButtonPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
const _kCardPadding = EdgeInsets.all(12);

class DetailDoctor extends StatefulWidget {
  const DetailDoctor({super.key});

  @override
  State<DetailDoctor> createState() => _DetailDoctorState();
}

class _DetailDoctorState extends State<DetailDoctor> with RouteAware {
  late final DetailDoctorController controller;
  String? doctorId;

  @override
  void initState() {
    super.initState();
    doctorId = Get.arguments as String? ?? '';
    if (doctorId == null || doctorId!.isEmpty) {
      Get.snackbar('Lỗi', 'Không tìm thấy ID bác sĩ',
          snackPosition: SnackPosition.BOTTOM);
    }
    controller = Get.put(DetailDoctorController(), tag: doctorId);
    controller.loadAllData(doctorId!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    if (doctorId != null && doctorId!.isNotEmpty) {
      controller.loadAllData(doctorId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value || controller.doctor.value == null) {
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
      backgroundColor: AppColor.fourthMain,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: Get.back,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Obx(() {
          final doctor = controller.doctor.value!;
          return _buildImage(
              controller.imageDoctor[doctor.userId ?? doctor.uuid] ??
                  'assets/images/default_doctor.jpg');
        }),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return Container(
      color: AppColor.fourthMain.withOpacity(0.2),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) =>
                  _buildPlaceholderAvatar(),
            )
          : _buildPlaceholderAvatar(),
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      color: AppColor.fourthMain.withOpacity(0.5),
      child: const Center(
          child: Icon(Icons.person, size: 120, color: Colors.white)),
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      padding: _kCardPadding,
      color: Colors.white,
      child: Obx(() {
        final doctor = controller.doctor.value!;
        final doctorKey = doctor.userId ?? doctor.uuid ?? '';
        final doctorName =
            controller.doctorNames[doctorKey] ?? 'Bác sĩ không xác định';
        final specialization =
            controller.doctorSpecialties[doctorKey] ?? 'Chưa có chuyên khoa';
        final image = controller.imageDoctor[doctorKey] ??
            'assets/images/default_doctor.jpg';
        final avgRating = controller.getAverageRating();
        final reviewCount = controller.getReviewCount();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctorName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              specialization,
              style: TextStyle(fontSize: 18, color: AppColor.fourthMain),
            ),
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
                  style: const TextStyle(fontSize: 14),
                ),
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
                Icons.star, "${(avgRating / 5 * 100).toInt()}%", "Hài lòng"),
          ],
        );
      }),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColor.fourthMain, size: 28),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildAboutDoctor() {
    return Container(
      padding: _kCardPadding,
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Obx(() {
        final doctor = controller.doctor.value!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Giới thiệu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              doctor.introduce ?? 'Không có thông tin giới thiệu',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAvailableDates() {
    final dates = controller.schedules
        .map((s) => DateTime.parse(s.workDate))
        .toSet()
        .toList()
      ..sort();

    if (dates.isEmpty) {
      return const Padding(
        padding: _kCardPadding,
        child: Text("Không có ngày khám hợp lệ",
            style: TextStyle(color: Colors.grey)),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
              onTap: () => controller.selectDate(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 70,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.fourthMain : Colors.white,
                  borderRadius: BorderRadius.circular(_kCardBorderRadius),
                  border: Border.all(
                    color: isSelected ? AppColor.fourthMain : Colors.grey[300]!,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.fourthMain.withOpacity(0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
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
                          color:
                              isSelected ? Colors.white : AppColor.fourthMain,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Hôm nay',
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                isSelected ? AppColor.fourthMain : Colors.white,
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
    final dates = controller.schedules
        .map((s) => DateTime.parse(s.workDate))
        .toSet()
        .toList()
      ..sort();

    if (dates.isEmpty ||
        controller.selectedDateIndex.value < 0 ||
        controller.selectedDateIndex.value >= dates.length) {
      return const Padding(
        padding: _kCardPadding,
        child: Text('Vui lòng chọn ngày hoặc không có lịch khám',
            style: TextStyle(color: Colors.grey)),
      );
    }

    final selectedDate = dates[controller.selectedDateIndex.value];
    final allSlots = controller.schedules.where((s) {
      final d = DateTime.parse(s.workDate);
      return d.year == selectedDate.year &&
          d.month == selectedDate.month &&
          d.day == selectedDate.day;
    }).toList();

    // Remove duplicates based on start time and end time
    final uniqueSlots = <Schedule>[];
    final seenTimes = <String>{};

    for (final slot in allSlots) {
      final timeKey = '${slot.startTime}-${slot.endTime}';
      if (!seenTimes.contains(timeKey)) {
        seenTimes.add(timeKey);
        uniqueSlots.add(slot);
      }
    }

    // Sort slots by start time
    uniqueSlots.sort((a, b) {
      final timeA = a.startTime ?? '';
      final timeB = b.startTime ?? '';
      return timeA.compareTo(timeB);
    });

    if (uniqueSlots.isEmpty) {
      return const Padding(
        padding: _kCardPadding,
        child: Text('Không có khung giờ trống',
            style: TextStyle(color: Colors.grey)),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: uniqueSlots.length,
      itemBuilder: (context, index) {
        return Obx(() {
          final isSelected = index == controller.selectedTimeIndex.value;
          final slot = uniqueSlots[index];
          final startTime = slot.startTime?.substring(0, 5) ?? '';
          final endTime = slot.endTime?.substring(0, 5) ?? '';
          return GestureDetector(
            onTap: () => controller.selectTime(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppColor.fourthMain,
                          AppColor.fourthMain.withOpacity(0.8)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(_kCardBorderRadius),
                border: Border.all(
                  color: isSelected ? AppColor.fourthMain : Colors.grey[300]!,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColor.fourthMain.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  '$startTime - $endTime',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
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
      padding: _kCardPadding,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: _buildCardDecoration(),
      child: Obx(() {
        final reviews = controller.reviews;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildSectionHeader(
                    Icons.reviews, "Đánh giá (${reviews.length})"),
                const Spacer(),
                if (reviews.length > 3)
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
                    style: TextStyle(color: Colors.grey)),
              )
            else
              Column(children: reviews.take(3).map(_buildReviewItem).toList()),
          ],
        );
      }),
    );
  }

  Widget _buildReviewItem(Review review) {
    ImageProvider? avatarProvider;
    if (review.patientAvatar.isNotEmpty) {
      avatarProvider = NetworkImage(review.patientAvatar);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(_kCardBorderRadius),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColor.fourthMain.withOpacity(0.2),
                backgroundImage: avatarProvider,
                child: avatarProvider == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.patientName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
          Text(
            review.comment ?? '',
            style: const TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }

  void _showAllReviews() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: _kCardPadding,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tất cả đánh giá",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final reviews = controller.reviews;
                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (_, index) => _buildReviewItem(reviews[index]),
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildBookAppointmentButton() {
    return Padding(
      padding: _kCardPadding,
      child: Obx(() {
        final isEnabled = controller.selectedTimeIndex.value != -1;
        return ElevatedButton(
          onPressed: isEnabled ? () => controller.bookAppointment() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? AppColor.fourthMain : Colors.grey[400],
            foregroundColor: AppColor.main,
            padding: _kButtonPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_kCardBorderRadius),
              side: BorderSide(
                  color: isEnabled ? AppColor.fourthMain : Colors.grey[400]!),
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
        Icon(icon, size: 20, color: AppColor.fourthMain),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_kCardBorderRadius),
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
}
