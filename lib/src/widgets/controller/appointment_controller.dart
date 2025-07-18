import 'dart:convert';
import 'dart:developer' as dev;
import 'package:ebookingdoc/src/constants/services/Doctorservice.dart';
import 'package:ebookingdoc/src/constants/services/PaymentService.dart';
import 'package:ebookingdoc/src/constants/services/appointmentService.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/constants/services/vaccination_center_service.dart';
import 'package:ebookingdoc/src/constants/services/hospitalService.dart';
import 'package:ebookingdoc/src/data/model/appointment_model.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:ebookingdoc/src/data/model/specialization_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentController extends GetxController {
  final RxList<Appointment> appointments = <Appointment>[].obs;
  final AppointmentService _appointmentService = AppointmentService();
  final HospitalService _hospitalService = HospitalService();
  final ClinicService _clinicService = ClinicService();
  final VaccinationCenterService _vaccinationCenterService = VaccinationCenterService();
  final DoctorService _doctorService = DoctorService();
  final PaymentService _paymentService = PaymentService();
  var isLoading = false.obs;
  User? user;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    update(); // Trigger UI update
    try {
      await fetchAppointments();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tải dữ liệu: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      update(); // Trigger UI update
    }
  }

  Future<void> fetchAppointments() async {
    appointments.clear();

    user = await getUserFromPrefs();
    if (user == null) {
      throw Exception('Không tìm thấy thông tin người dùng');
    }

    try {
      List<Appointment> fetchedAppointments = await _appointmentService.getByUserId(user!.uuid);
      appointments.assignAll(fetchedAppointments.toSet().toList());
      dev.log('Appointments loaded (unique): ${appointments.map((a) => a.uuid).toList()}');
      dev.log('Statuses: ${appointments.map((a) => a.status.value.index).toList()}');
      dev.log('Status names: ${appointments.map((a) => _getStatusText(a.status.value)).toList()}');
    } catch (e) {
      dev.log('Error in fetchAppointments: $e');
      rethrow;
    }

    try {
      await Future.wait(appointments.map((appointment) async {
        if (appointment.hospitalId != null) {
          var hospital = await _hospitalService.getHospitalById(appointment.hospitalId!);
          appointment.hospitalName = hospital?.name ?? 'Chưa có thông tin bệnh viện';
        }
        if (appointment.clinicId != null) {
          var clinic = await _clinicService.getById(appointment.clinicId!);
          appointment.clinicName = clinic?.name ?? 'Chưa có thông tin phòng khám';
        }
        if (appointment.vaccinationCenterId != null) {
          var vaccinationCenter = await _vaccinationCenterService.getById(appointment.vaccinationCenterId!);
          appointment.vaccinationCenterName = vaccinationCenter?.name ?? 'Chưa có thông tin trung tâm tiêm chủng';
        }
        if (appointment.doctorId != null) {
          var doctor = await _doctorService.getDoctorById(appointment.doctorId!);
          if (doctor != null && doctor.userId != null) {
            var user = await getUserById(doctor.userId!);
            appointment.doctorName = user?.name ?? 'Chưa có thông tin bác sĩ';
          }
          if (doctor != null && doctor.specializationId != null) {
            var specialization = await getSpecializationById(doctor.specializationId!);
            appointment.specializationName = specialization?.name ?? 'Chưa có thông tin chuyên khoa';
          }
        }
      }));
    } catch (e) {
      dev.log('Error in fetching additional details: $e');
      rethrow;
    }

    update(); // Trigger UI update after data is loaded
  }

  Future<void> updateAppointmentStatus(String uuid, int status) async {
    try {
      bool result = await _appointmentService.updateStatus(uuid, status);
      if (result) {
        Get.snackbar(
          'Thành công',
          'Cập nhật trạng thái thành công',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchAppointments();
      } else {
        Get.snackbar(
          'Lỗi',
          'Cập nhật trạng thái thất bại',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Lỗi khi cập nhật trạng thái: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<User?> getUserById(String userId) async {
    try {
      final response = await APICaller.getInstance().get('api/auth/getById/$userId');
      if (response != null && response['code'] == 200) {
        return User.fromJson(response['data']);
      }
    } catch (e) {
      dev.log("Lỗi khi lấy thông tin người dùng: $e");
    }
    return null;
  }

  Future<Specialization?> getSpecializationById(String specializationId) async {
    try {
      final response = await APICaller.getInstance().get('api/specialization/getById/$specializationId');
      if (response != null && response['code'] == 200) {
        return Specialization.fromJson(response['data']);
      }
    } catch (e) {
      dev.log('Lỗi khi lấy thông tin chuyên khoa: $e');
    }
    return null;
  }

  Future<User?> getUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      dev.log('Lỗi khi lấy thông tin người dùng từ SharedPreferences: $e');
    }
    return null;
  }

  void viewAppointmentDetail(int appointmentIndex) async {
    if (appointmentIndex < 0 || appointmentIndex >= appointments.length) {
      return;
    }

    final appointment = appointments[appointmentIndex];

    if (user != null) {
      String? date = appointment.dateTime;
      String? dayPart = 'Chưa xác định ngày';
      String? timePart = 'Chưa xác định giờ';
      String? paymentMethod = 'Không có thanh toán';
      
      if (appointment.uuid.isNotEmpty) {
        try {
          final paymentList = await _paymentService.getByAppointmentId(appointment.uuid);
          if (paymentList.isNotEmpty) {
            paymentMethod = paymentList.first.paymentMethod ?? 'Không có thanh toán';
          }
        } catch (e) {
          dev.log('Error getting payment info: $e');
        }
      }

      if (date != null) {
        if (date.contains(' ')) {
          final parts = date.split(' ');
          dayPart = parts[0];
          String? timeRaw = parts[1];
          timePart = _formatTime(timeRaw);
        } else {
          timePart = _formatTime(date);
          dayPart = DateTime.now().toIso8601String().split('T')[0];
        }
      }

      Get.dialog(
        AlertDialog(
          title: const Text('Chi tiết lịch hẹn'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (appointment.hospitalName != null &&
                    appointment.hospitalName!.isNotEmpty &&
                    appointment.hospitalName != 'Chưa có thông tin bệnh viện')
                  _buildDetailItem('Bệnh viện', appointment.hospitalName)
                else if (appointment.clinicName != null &&
                    appointment.clinicName!.isNotEmpty &&
                    appointment.clinicName != 'Chưa có thông tin phòng khám')
                  _buildDetailItem('Phòng khám', appointment.clinicName)
                else if (appointment.vaccinationCenterName != null &&
                    appointment.vaccinationCenterName!.isNotEmpty &&
                    appointment.vaccinationCenterName !=
                        'Chưa có thông tin trung tâm tiêm chủng')
                  _buildDetailItem('Trung tâm tiêm chủng', appointment.vaccinationCenterName)
                else
                  _buildDetailItem('Chưa có thông tin', 'Chưa có thông tin'),
                _buildDetailItem('Bác sĩ', appointment.doctorName ?? 'Chưa có thông tin bác sĩ'),
                _buildDetailItem('Chuyên khoa', appointment.specializationName ?? 'Chưa có thông tin chuyên khoa'),
                _buildDetailItem('Ngày khám', dayPart),
                _buildDetailItem('Giờ khám', timePart),
                _buildDetailItem('Phương thức thanh toán', paymentMethod),
                _buildDetailItem('Trạng thái', _getStatusText(appointment.status.value)),
                if (appointment.status.value == AppointmentStatus.cancelled)
                  _buildDetailItem('Lý do hủy', 'Bệnh nhân hủy lịch'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }

  void cancelAppointment(int appointmentIndex) async {
    if (appointmentIndex < 0 || appointmentIndex >= appointments.length) {
      return;
    }

    final appointment = appointments[appointmentIndex];

    if (appointment.uuid.isNotEmpty) {
      try {
        final paymentList = await _paymentService.getByAppointmentId(appointment.uuid);
        if (paymentList.isNotEmpty) {
          bool hasOnlinePayment = paymentList.any((payment) =>
              payment.paymentMethod != null &&
              payment.paymentMethod!.toLowerCase() == 'online');
          
          if (hasOnlinePayment) {
            Get.dialog(
              AlertDialog(
                title: const Text('Không thể hủy lịch'),
                content: const Text(
                    'Lịch hẹn thanh toán online không thể hủy theo chính sách của hệ thống.'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Đóng'),
                  ),
                ],
              ),
            );
            return;
          }
        }
      } catch (e) {
        dev.log('Error checking payment: $e');
      }
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận hủy lịch'),
        content: const Text('Bạn có chắc chắn muốn hủy lịch hẹn này không?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () async {
              await updateAppointmentStatus(appointment.uuid, 3); // Cập nhật thành 3 (Hủy)
              Get.back();
            },
            child: const Text('Hủy lịch', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void submitComment(int appointmentIndex, String comment) async {
    if (appointmentIndex < 0 || appointmentIndex >= appointments.length) {
      return;
    }

    final appointment = appointments[appointmentIndex];

    try {
      // Placeholder for API call to submit comment
      // await _appointmentService.submitComment(appointment.uuid, comment);
      dev.log('Comment submitted for appointment ${appointment.uuid}: $comment');
      Get.snackbar(
        'Thành công',
        'Bình luận đã được gửi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Gửi bình luận thất bại: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showCommentDialog(int appointmentIndex) {
    final TextEditingController commentController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Gửi bình luận'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: 'Nhập bình luận của bạn',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              if (commentController.text.trim().isNotEmpty) {
                submitComment(appointmentIndex, commentController.text.trim());
                Get.back();
              } else {
                Get.snackbar(
                  'Lỗi',
                  'Vui lòng nhập bình luận',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Gửi', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.done:
        return 'Hoàn thành';
      case AppointmentStatus.pending:
        return 'Chờ';
      case AppointmentStatus.confirmed:
        return 'Đã xác nhận';
      case AppointmentStatus.cancelled:
        return 'Hủy';
      case AppointmentStatus.rejected:
        return 'Từ chối';
      default:
        return 'Chưa xác định';
    }
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Chưa có thông tin',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? timeRaw) {
    if (timeRaw == null) return 'Chưa xác định giờ';
    String timePart = 'Chưa xác định giờ';
    timeRaw = timeRaw.replaceAll('h', ':');
    if (timeRaw.contains(':')) {
      final timeComponents = timeRaw.split(':');
      int hour = int.tryParse(timeComponents[0]) ?? 0;
      int minute = int.tryParse(timeComponents[1]) ?? 0;
      if (hour >= 0 && minute >= 0 && minute < 60) {
        String period = hour >= 12 ? 'PM' : 'AM';
        hour = hour > 12 ? hour - 12 : hour;
        hour = hour == 0 ? 12 : hour;
        timePart = '$hour:${minute.toString().padLeft(2, '0')} $period';
      }
    }
    return timePart;
  }

  Widget buildAppointmentCard(Appointment appointment, BuildContext context) {
    final status = appointment.status.value;
    final isCompleted = status == AppointmentStatus.done;
    final isCancelled = status == AppointmentStatus.cancelled;
    final isActive = status == AppointmentStatus.pending || status == AppointmentStatus.confirmed;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(appointment),
            const SizedBox(height: 12),
            buildDetails(appointment),
            if (isCompleted) ...[
              const SizedBox(height: 12),
              buildCompletedInfo(appointment),
            ],
            const SizedBox(height: 16),
            buildActions(appointment, context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(Appointment appointment) {
    String placeName = appointment.hospitalName ??
        appointment.clinicName ??
        appointment.vaccinationCenterName ??
        'Chưa có thông tin';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                placeName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(appointment.status.value),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _getStatusText(appointment.status.value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.done:
        return Colors.green;
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.green.shade600;
      case AppointmentStatus.cancelled:
        return Colors.red.shade700;
      case AppointmentStatus.rejected:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildDetails(Appointment appointment) {
    DateTime now = DateTime.now();
    String defaultDay =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    String? date = appointment.dateTime;
    String? dayPart = defaultDay;
    String? timePart = 'Chưa xác định giờ';

    if (date != null) {
      if (date.contains(' ')) {
        final parts = date.split(' ');
        dayPart = parts[0];
        String? timeRaw = parts[1];
        timePart = _formatTime(timeRaw);
      } else {
        timePart = _formatTime(date);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Ngày khám: $dayPart',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Giờ khám: $timePart',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.medical_services, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Chuyên khoa: ${appointment.specializationName ?? 'Chưa xác định chuyên khoa'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.person, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Bác sĩ: ${appointment.doctorName ?? 'Chưa xác định bác sĩ'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildCompletedInfo(Appointment appointment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
          const SizedBox(width: 8),
          Text(
            'Đã hoàn thành khám bệnh',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActions(Appointment appointment, BuildContext context) {
    final status = appointment.status.value;
    final canCancel = status == AppointmentStatus.pending || status == AppointmentStatus.confirmed;
    final canView = true;
    final canComment = status == AppointmentStatus.done; // Allow comments only for completed appointments

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (canView) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                final index = appointments.indexOf(appointment);
                viewAppointmentDetail(index);
              },
              icon: const Icon(Icons.visibility, size: 16),
              label: const Text('Xem chi tiết'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: BorderSide(color: Colors.blue.shade300),
                foregroundColor: Colors.blue.shade700,
              ),
            ),
          ),
        ],
        if (canCancel) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                final index = appointments.indexOf(appointment);
                cancelAppointment(index);
              },
              icon: const Icon(Icons.cancel, size: 16),
              label: const Text('Hủy lịch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
        if (canComment) ...[
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                final index = appointments.indexOf(appointment);
                showCommentDialog(index);
              },
              icon: const Icon(Icons.comment, size: 16),
              label: const Text('Bình luận'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: BorderSide(color: Colors.green.shade300),
                foregroundColor: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}