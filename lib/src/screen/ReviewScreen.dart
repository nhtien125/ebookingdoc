import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/data/model/appointment_model.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:ebookingdoc/src/Global/app_color.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {
  final Appointment appointment;

  const ReviewScreen({Key? key, required this.appointment}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late ReviewController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ReviewController());
    controller.initializeReview(widget.appointment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Nền sáng nhẹ
      appBar: AppBar(
        title: const Text('Đánh giá dịch vụ'),
        backgroundColor: Colors.blue.shade600, // Màu xanh đậm hơn
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
      ),
      body: GetBuilder<ReviewController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade600,
                strokeWidth: 3,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppointmentInfo(),
                const SizedBox(height: 24),
                _buildDoctorInfo(),
                const SizedBox(height: 24),
                _buildRatingSection(),
                const SizedBox(height: 24),
                _buildCommentSection(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentInfo() {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital, color: Colors.blue.shade600, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Thông tin cuộc hẹn',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
                'Cơ sở y tế',
                widget.appointment.hospitalName ??
                    widget.appointment.clinicName ??
                    widget.appointment.vaccinationCenterName ??
                    'Chưa xác định'),
            _buildInfoRow(
                'Ngày khám', _formatDate(widget.appointment.dateTime)),
            _buildInfoRow('Trạng thái', 'Hoàn thành'),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue.shade600, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Thông tin bác sĩ',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
                'Bác sĩ', widget.appointment.doctorName ?? 'Chưa xác định'),
            _buildInfoRow('Chuyên khoa',
                widget.appointment.specializationName ?? 'Chưa xác định'),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber.shade600, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Đánh giá chất lượng dịch vụ',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Bạn cảm thấy thế nào về dịch vụ?',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            GetBuilder<ReviewController>(
              builder: (controller) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => controller.setRating(index + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          index < controller.rating.value
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber.shade600,
                          size: 40,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 8),
            GetBuilder<ReviewController>(
              builder: (controller) {
                return Center(
                  child: Text(
                    controller.getRatingText(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber.shade700,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.comment, color: Colors.blue.shade600, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Nhận xét chi tiết',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.commentController,
              maxLines: 5,
              maxLength: 1000,
              style: TextStyle(color: Colors.grey.shade800),
              decoration: InputDecoration(
                hintText: 'Chia sẻ trải nghiệm của bạn về dịch vụ, thái độ của bác sĩ, cơ sở vật chất...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GetBuilder<ReviewController>(
      builder: (controller) {
        return Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade600.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: controller.isSubmitting.value
                ? null
                : () => controller.submitReview(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: controller.isSubmitting.value
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : const Text(
                    'Gửi đánh giá',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateTime) {
    if (dateTime == null) return 'Chưa xác định';

    try {
      if (dateTime.contains(' ')) {
        return dateTime.split(' ')[0];
      }
      return dateTime;
    } catch (e) {
      return 'Chưa xác định';
    }
  }
}

class ReviewController extends GetxController {
  final TextEditingController commentController = TextEditingController();

  var rating = 0.obs;
  var isLoading = false.obs;
  var isSubmitting = false.obs;

  late Appointment appointment;
  User? user;

  void initializeReview(Appointment appointmentData) {
    appointment = appointmentData;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
      if (userJson != null) {
        user = User.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void setRating(int stars) {
    rating.value = stars;
    update();
  }

  String getRatingText() {
    switch (rating.value) {
      case 1:
        return 'Rất không hài lòng';
      case 2:
        return 'Không hài lòng';
      case 3:
        return 'Bình thường';
      case 4:
        return 'Hài lòng';
      case 5:
        return 'Rất hài lòng';
      default:
        return 'Chưa đánh giá';
    }
  }

  Future<void> submitReview() async {
    if (rating.value == 0) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng chọn số sao đánh giá',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade600,
        colorText: Colors.white,
      );
      return;
    }

    if (user == null) {
      Get.snackbar(
        'Lỗi',
        'Không tìm thấy thông tin người dùng',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    isSubmitting.value = true;
    update();

    try {
      final response = await APICaller.getInstance().post(
        'api/review/add',
        body: {
          'user_id': user!.uuid,
          'doctor_id': appointment.doctorId,
          'appointment_id': appointment.uuid,
          'stars': rating.value,
          'comment': commentController.text.trim().isEmpty
              ? null
              : commentController.text.trim(),
        },
      );

      if (response != null && response['code'] == 200) {
        Get.snackbar(
          'Thành công',
          'Đánh giá của bạn đã được gửi thành công',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
        
        Get.back();

        Future.delayed(const Duration(seconds: 1), () {
          Get.back();
        });
      } else {
        Get.snackbar(
          'Lỗi',
          'Không thể gửi đánh giá. Vui lòng thử lại',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error submitting review: $e');
      Get.snackbar(
        'Lỗi',
        'Lỗi kết nối. Vui lòng thử lại',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
      update();
    }
  }

  String _generateUUID() {
    var now = DateTime.now();
    return '${now.millisecondsSinceEpoch}${user?.uuid?.substring(0, 8) ?? ''}';
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}