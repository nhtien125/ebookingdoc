import 'package:get/get.dart';

enum AppointmentStatus { pending, confirmed, rejected, cancelled, done }

AppointmentStatus toStatus(int? s) {
  switch (s) {
    case 1:
      return AppointmentStatus.pending;
    case 2:
      return AppointmentStatus.confirmed;
    case 3:
      return AppointmentStatus.cancelled;
    case 4:
      return AppointmentStatus.rejected;
    case 0:
      return AppointmentStatus.done;
    default:
      return AppointmentStatus.pending;
  }
}

/// Convert AppointmentStatus to integer
int appointmentStatusToInt(AppointmentStatus status) {
  switch (status) {
    case AppointmentStatus.pending:
      return 1;
    case AppointmentStatus.confirmed:
      return 2;
    case AppointmentStatus.cancelled:
      return 3;
    case AppointmentStatus.rejected:
      return 4;
    case AppointmentStatus.done:
      return 0; // New status
  }
}

class Appointment {
  final String uuid;
  final String? doctorId;
  final String? patientId;
  final String? clinicId;
  final String? hospitalId;
  final String? scheduleId;
  final String? vaccinationCenterId;
  final String? medicalServiceId;
  final String? dateTime;
  final Rx<AppointmentStatus> status;
  final String? healthStatus;
  final String? userId;
  final String? createdAt;
  final String? updatedAt;

  // Additional fields to store pre-loaded details
  String? hospitalName; // Tên bệnh viện
  String? clinicName; // Tên phòng khám
  String? vaccinationCenterName; // Tên trung tâm tiêm chủng
  String? doctorName; // Tên bác sĩ
  String? specializationName; // Tên chuyên khoa

  Appointment({
    required this.uuid,
    this.doctorId,
    this.patientId,
    this.clinicId,
    this.hospitalId,
    this.scheduleId,
    this.vaccinationCenterId,
    this.medicalServiceId,
    this.dateTime,
    required AppointmentStatus status,
    this.healthStatus,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.hospitalName,
    this.clinicName,
    this.vaccinationCenterName,
    this.doctorName,
    this.specializationName,
  }) : status = status.obs;

  factory Appointment.fromJson(Map<String, dynamic> json) {
    try {
      final status = toStatus(json['status'] as int?);
      print(
          'Parsing appointment uuid: ${json['uuid']}, status: ${json['status']} -> ${status}');
      return Appointment(
        uuid: json['uuid'] ?? json['id'] ?? '',
        doctorId: json['doctor_id'],
        patientId: json['patient_id'],
        clinicId: json['clinic_id'],
        hospitalId: json['hospital_id'],
        scheduleId: json['schedule_id'],
        vaccinationCenterId: json['vaccination_center_id'],
        medicalServiceId: json['medical_service_id'],
        dateTime: json['date'] ?? json['date_time'],
        status: status,
        healthStatus: json['health_status'],
        userId: json['user_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        hospitalName: json['hospital_name'],
        clinicName: json['clinic_name'],
        vaccinationCenterName: json['vaccination_center_name'],
        doctorName: json['doctor_name'],
        specializationName: json['specialization_name'],
      );
    } catch (e) {
      print('Lỗi khi parse Appointment từ JSON: $e, json: $json');
      throw Exception('Failed to parse Appointment: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'clinic_id': clinicId,
      'hospital_id': hospitalId,
      'schedule_id': scheduleId,
      'vaccination_center_id': vaccinationCenterId,
      'medical_service_id': medicalServiceId,
      'date': dateTime,
      'status': appointmentStatusToInt(status.value),
      'health_status': healthStatus,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'hospital_name': hospitalName,
      'clinic_name': clinicName,
      'vaccination_center_name': vaccinationCenterName,
      'doctor_name': doctorName,
      'specialization_name': specializationName,
    };
  }
}
