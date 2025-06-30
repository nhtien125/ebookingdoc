import 'package:get/get.dart';

enum AppointmentStatus { pending, confirmed, rejected, cancelled }

AppointmentStatus toStatus(int? s) {
  switch (s) {
    case 1:
      return AppointmentStatus.pending;
    case 2:
      return AppointmentStatus.confirmed;
    case 3:
      return AppointmentStatus.rejected;
    case 4:
      return AppointmentStatus.cancelled;
    default:
      return AppointmentStatus.pending;
  }
}

int appointmentStatusToInt(AppointmentStatus status) {
  switch (status) {
    case AppointmentStatus.pending:
      return 1;
    case AppointmentStatus.confirmed:
      return 2;
    case AppointmentStatus.rejected:
      return 3;
    case AppointmentStatus.cancelled:
      return 4;
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
  }) : status = status.obs;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        uuid: json['uuid'] ?? json['id'] ?? '',
        doctorId: json['doctor_id'],
        patientId: json['patient_id'],
        clinicId: json['clinic_id'],
        hospitalId: json['hospital_id'],
        scheduleId: json['schedule_id'],
        vaccinationCenterId: json['vaccination_center_id'],
        medicalServiceId: json['medical_service_id'],
        dateTime: json['date'],
        status: toStatus(json['status']),
        healthStatus: json['health_status'],
        userId: json['user_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
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
      };
}
