import 'dart:convert';
import 'package:ebookingdoc/src/constants/services/Doctorservice.dart';
import 'package:ebookingdoc/src/constants/services/appointmentService.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/constants/services/vaccination_center_service.dart';
import 'package:ebookingdoc/src/data/model/appointment_model.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/specialization_model.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:ebookingdoc/src/constants/services/hospitalService.dart';
import 'package:ebookingdoc/src/data/model/vaccination_center_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentController extends GetxController {
  final RxList<Appointment> appointments = <Appointment>[].obs;
  final AppointmentService _appointmentService = AppointmentService();
  final HospitalService _hospitalService = HospitalService();
  final RxList<Hospital> hospital = <Hospital>[].obs;
  final ClinicService _clinicService = ClinicService();
  final RxList<Clinic> clinic = <Clinic>[].obs;
  final VaccinationCenterService _vaccinationCenterService =
      VaccinationCenterService();
  final RxList<VaccinationCenter> vaccinationcenter = <VaccinationCenter>[].obs;
  final DoctorService _doctorService = DoctorService();
  var isLoading = false.obs;
  User? user;

  @override
  void onInit() {
    super.onInit();
    featAppointments();
  }

  Future<void> featAppointments() async {
    isLoading.value = true;
    appointments.clear();

    user = await getUserFromPrefs();
    if (user != null) {
      try {
        List<Appointment> fetchedAppointments =
            await _appointmentService.getByUserId(user!.uuid);
        appointments.addAll(fetchedAppointments);

        for (var appointment in appointments) {
          if (appointment.hospitalId != null) {
            var hospital =
                await _hospitalService.getHospitalById(appointment.hospitalId!);
            appointment.hospitalName =
                hospital?.name ?? 'Chưa có thông tin bệnh viện';
          }

          if (appointment.clinicId != null) {
            var clinic = await _clinicService.getById(appointment.clinicId!);
            appointment.clinicName =
                clinic?.name ?? 'Chưa có thông tin phòng khám';
          }

          if (appointment.vaccinationCenterId != null) {
            var vaccinationCenter = await _vaccinationCenterService
                .getById(appointment.vaccinationCenterId!);
            appointment.vaccinationCenterName = vaccinationCenter?.name ??
                'Chưa có thông tin trung tâm tiêm chủng';
          }

          if (appointment.doctorId != null) {
            var doctor =
                await _doctorService.getDoctorById(appointment.doctorId!);
            if (doctor != null && doctor.userId != null) {
              var user = await getUserById(doctor.userId!);
              appointment.doctorName = user?.name ?? 'Chưa có thông tin bác sĩ';
            }
            if (doctor != null && doctor.specializationId != null) {
              var specialization =
                  await getspecializationId(doctor.specializationId!);
              appointment.specializationName =
                  specialization?.name ?? 'Chưa có thông tin chuyên khoa';
            }
          }
        }
      } catch (e) {
        Get.snackbar(
          'Lỗi',
          'Không thể tải lịch hẹn: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Lỗi',
        'Không tìm thấy thông tin người dùng',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }

  Future<void> updateAppointmentStatus(String uuid, int status) async {
    bool result = await _appointmentService.updateStatus(uuid, status);
    if (result) {
      Get.snackbar(
        'Thành công',
        'Cập nhật trạng thái thành công',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      featAppointments();
    } else {
      Get.snackbar(
        'Lỗi',
        'Cập nhật trạng thái thất bại',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<User?> getUserById(String userId) async {
    try {
      final response =
          await APICaller.getInstance().get('api/auth/getById/$userId');
      if (response != null && response['code'] == 200) {
        return User.fromJson(response['data']);
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin người dùng: $e");
    }
    return null;
  }

  Future<Specialization?> getspecializationId(String specializationId) async {
    try {
      final response = await APICaller.getInstance()
          .get('api/specialization/getById/$specializationId');
      if (response != null && response['code'] == 200) {
        return Specialization.fromJson(response['data']);
      }
    } catch (e) {
      print('Lỗi khi lấy thông tin chuyên khoa: $e');
    }
    return null;
  }

  Future<User?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
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
      if (date != null) {
        if (date.contains(' ')) {
          final parts = date.split(' ');
          dayPart = parts[0];
          String? timeRaw = parts[1];
          if (timeRaw != null) {
            timePart = _formatTime(timeRaw);
          }
        } else {
          timePart = _formatTime(date);
          dayPart = DateTime.now().toIso8601String().split('T')[0];
        }
      }

      Get.dialog(
        AlertDialog(
          title: Text('Chi tiết lịch hẹn'),
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
                  _buildDetailItem(
                      'Trung tâm tiêm chủng', appointment.vaccinationCenterName)
                else
                  _buildDetailItem('Chưa có thông tin', 'Chưa có thông tin'),
                _buildDetailItem('Bác sĩ',
                    appointment.doctorName ?? 'Chưa có thông tin bác sĩ'),
                _buildDetailItem(
                    'Chuyên khoa',
                    appointment.specializationName ??
                        'Chưa có thông tin chuyên khoa'),
                _buildDetailItem('Ngày khám', dayPart),
                _buildDetailItem('Giờ khám', timePart),
                _buildDetailItem(
                    'Trạng thái', _getStatusText(appointment.status.value)),
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

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Đang chờ';
      case AppointmentStatus.confirmed:
        return 'Đã xác nhận';
      case AppointmentStatus.rejected:
        return 'Đã hủy';
      case AppointmentStatus.cancelled:
        return 'Đã hoàn thành';
      default:
        return 'Chưa xác định';
    }
  }

  void cancelAppointment(int appointmentIndex) {
    if (appointmentIndex < 0 || appointmentIndex >= appointments.length) {
      return;
    }

    final appointment = appointments[appointmentIndex];
    final now = DateTime.now();
    final appointmentDateTime = DateTime.parse(appointment.dateTime ??
        '${now.toIso8601String().split('T')[0]} ${now.hour}:00:00.000Z');
    final timeDifference = appointmentDateTime.difference(now).inHours;

    String refundPolicy = '';
    if (timeDifference > 24) {
      refundPolicy =
          'Theo chính sách hủy lịch hẹn được áp dụng bởi hệ thống của chúng tôi, bạn sẽ được hoàn trả 80% tổng số tiền đã thanh toán nếu bạn thực hiện việc hủy lịch trước ít nhất 24 giờ so với thời gian đã được đặt lịch. Quy định này được thiết kế nhằm mang lại sự linh hoạt tối đa cho khách hàng, đồng thời đảm bảo rằng chúng tôi có thể sắp xếp lại lịch trình một cách hiệu quả để phục vụ các nhu cầu khác, đồng thời hỗ trợ bạn trong trường hợp cần điều chỉnh kế hoạch cá nhân một cách bất ngờ.';
    } else {
      refundPolicy =
          'Theo chính sách hủy lịch hẹn được áp dụng bởi hệ thống của chúng tôi, không có khoản hoàn tiền nào được áp dụng nếu bạn hủy lịch sau 24 giờ trước thời gian đã đặt lịch. Quy định này được đưa ra để duy trì sự ổn định trong việc quản lý lịch trình, đảm bảo cam kết với các dịch vụ đã được lên kế hoạch trước đó, cũng như tránh những gián đoạn không đáng có đối với đội ngũ nhân sự và các khách hàng khác.';
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận hủy lịch'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bạn có chắc chắn muốn hủy lịch hẹn này không?'),
            const SizedBox(height: 10),
            Text('Điều khoản hủy:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(refundPolicy),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              if (appointment != null) {
                updateAppointmentStatus(
                    appointment.uuid, AppointmentStatus.cancelled.index);
              }
              Get.back();
            },
            child: const Text('Hủy lịch', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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

  String _formatTime(String timeRaw) {
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
}
