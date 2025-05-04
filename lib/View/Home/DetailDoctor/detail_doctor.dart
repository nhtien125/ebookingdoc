import 'package:ebookingdoc/Controller/Home/DetailDoctor/detail_doctor_controller.dart';
import 'package:ebookingdoc/Models/doctor_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    persistentFooterButtons: [_buildBookAppointmentButton()], // Giữ nút luôn ở đáy
  );
}


  // AppBar với ảnh bác sĩ
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
          () => controller.doctor.value!.imageUrl.isNotEmpty
              ? Image.asset(
                  controller.doctor.value!.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholderAvatar(),
                )
              : _buildPlaceholderAvatar(),
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

  // Thông tin cơ bản bác sĩ
  Widget _buildDoctorInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Obx(() {
        final doctor = controller.doctor.value!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              doctor.specialization,
              style: TextStyle(fontSize: 18, color: Colors.blue[700]),
            ),
            const SizedBox(height: 4),
            Text(
              doctor.hospital,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                RatingBarIndicator(
                  rating: doctor.rating,
                  itemBuilder: (_, __) =>
                      const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "${doctor.rating} (${doctor.reviewCount} đánh giá)",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  // Thống kê kinh nghiệm
  Widget _buildStatistics() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Obx(() {
        final doctor = controller.doctor.value!;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
                Icons.work, "${doctor.experience} năm", "Kinh nghiệm"),
            _buildStatItem(
                Icons.people, "${doctor.patientCount}+", "Bệnh nhân"),
            _buildStatItem(Icons.star, "${(doctor.rating / 5 * 100).toInt()}%",
                "Hài lòng"),
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

  // Giới thiệu bác sĩ
  Widget _buildAboutDoctor() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Giới thiệu",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              controller.doctor.value!.about,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        );
      }),
    );
  }

  // Lịch khám
  Widget _buildAvailableDates() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(Icons.calendar_today, "Lịch khám"),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Obx(() {
              // Kiểm tra danh sách ngày khám có hợp lệ không
              if (controller.availableDates.isEmpty) {
                return const Center(
                  child: Text(
                    "Không có ngày khám hợp lệ",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.availableDates.length,
                itemBuilder: (_, index) =>
                    _buildDateItem(controller.availableDates[index], index),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(DateTime date, int index) {
    return Obx(() {
      final isSelected = index == controller.selectedDateIndex.value;
      final isAvailable = controller.isDoctorAvailableOnDate(date);
      final dayName = DateFormat('E', 'vi_VN').format(date);
      final isToday = date.day == DateTime.now().day &&
          date.month == DateTime.now().month &&
          date.year == DateTime.now().year;

      return GestureDetector(
        onTap: isAvailable ? () => controller.selectDate(index) : null,
        child: Container(
          width: 70,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[700] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.blue[700]!
                  : isAvailable
                      ? Colors.grey[300]!
                      : Colors.grey[200]!,
            ),
            boxShadow: isSelected ? [_buildBoxShadow()] : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayName,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isAvailable
                          ? Colors.grey[800]
                          : Colors.grey[400],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : isAvailable
                          ? Colors.black
                          : Colors.grey[400],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isToday ? "Hôm nay" : DateFormat('MMM', 'vi_VN').format(date),
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? Colors.white
                      : isAvailable
                          ? Colors.grey[600]
                          : Colors.grey[400],
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                isAvailable ? Icons.check_circle : Icons.block,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? Colors.green
                        : Colors.red,
              ),
            ],
          ),
        ),
      );
    });
  }

  // Khung giờ khám
  Widget _buildAvailableSlots() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildSectionHeader(Icons.access_time, "Giờ khám"),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Obx(() => Text(
                      NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                          .format(controller.doctor.value!.consultationFee),
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            final selectedDate =
                controller.availableDates[controller.selectedDateIndex.value];

            if (!controller.isDoctorAvailableOnDate(selectedDate)) {
              return const Center(
                child: Text("Bác sĩ không làm việc vào ngày này",
                    style: TextStyle(color: Colors.grey)),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: controller.doctor.value!.availableSlots.length,
              itemBuilder: (_, index) => _buildTimeSlotItem(index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimeSlotItem(int index) {
    return Obx(() {
      final isSelected = index == controller.selectedTimeIndex.value;
      final slot = controller.doctor.value!.availableSlots[index];

      return GestureDetector(
        onTap: () => controller.selectTime(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[700] : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
            ),
            boxShadow: isSelected ? [_buildBoxShadow()] : null,
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
    });
  }

  // Đánh giá bệnh nhân
 Widget _buildReviewsSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: _buildCardDecoration(),
    child: Obx(() {
      final doctor = controller.doctor.value!;
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
          if (doctor.reviews.isEmpty)
            const Center(
              child: Text("Chưa có đánh giá nào",
                  style: TextStyle(color: Colors.grey)),
            )
          else
            Column(
              children: [
                ...doctor.reviews.take(3).map(_buildReviewItem),
              ],
            ),
        ],
      );
    }),
  );
}



  Widget _buildReviewItem(Review review) {
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
                backgroundImage: AssetImage(review.patientAvatar),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.patientName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  RatingBarIndicator(
                    rating: review.rating,
                    itemBuilder: (_, __) =>
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                    itemCount: 5,
                    itemSize: 16,
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
          final reviews = controller.doctor.value!.reviews;
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

  // Nút đặt lịch
Widget _buildBookAppointmentButton() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Obx(() {
      final isEnabled = controller.selectedTimeIndex.value != -1;

      return ElevatedButton(
        onPressed: isEnabled ? _showBookingConfirmation : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? Colors.blue[700] : Colors.transparent, 
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isEnabled ? Colors.blue[700]! : Colors.grey[400]!), 
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

  void _showBookingConfirmation() {
    final selectedDate =
        controller.availableDates()[controller.selectedDateIndex.value];
    final selectedTime = controller
        .doctor.value!.availableSlots[controller.selectedTimeIndex.value];
    final doctor = controller.doctor.value!;
    final fee = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
        .format(doctor.consultationFee);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "XÁC NHẬN ĐẶT LỊCH",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 20),
              _buildConfirmationItem(Icons.person, "Bác sĩ", doctor.name),
              _buildConfirmationItem(
                  Icons.medical_services, "Chuyên khoa", doctor.specialization),
              _buildConfirmationItem(Icons.calendar_today, "Ngày",
                  DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(selectedDate)),
              _buildConfirmationItem(Icons.access_time, "Giờ", selectedTime),
              _buildConfirmationItem(Icons.monetization_on, "Phí tư vấn", fee),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: Get.back,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.blue[700]!),
                      ),
                      child: const Text("HỦY",
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.bookAppointment();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("XÁC NHẬN",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  // Các helper methods
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
