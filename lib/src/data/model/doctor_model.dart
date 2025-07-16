
class Doctor {
  final String uuid;
  final String? userId;
  final String? hospitalId;
  final String? clinicId;
  final int? doctorType;
  final String? specializationId;
  final String? license;
  final String? introduce;
  final int? experience;
  final int? patientCount;
  final int? status; 
  final String? createdAt;
  final String? updatedAt;

  var rating;
  var title;

  Doctor({
    required this.uuid,
    this.userId,
    this.hospitalId,
    this.clinicId,
    this.doctorType,
    this.specializationId,
    this.license,
    this.introduce,
    this.experience,
    this.patientCount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      uuid: json['uuid'] ?? '',
      userId: json['user_id'],
      hospitalId: json['hospital_id'],
      clinicId: json['clinic_id'],
      doctorType: json['doctor_type'],
      specializationId: json['specialization_id'],
      license: json['license'],
      introduce: json['introduce'],
      experience: json['experience'],
      patientCount: json['patient_count'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'user_id': userId,
      'hospital_id': hospitalId,
      'clinic_id': clinicId,
      'doctor_type': doctorType,
      'specialization_id': specializationId,
      'license': license,
      'introduce': introduce,
      'experience': experience,
      'patient_count': patientCount,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String getStatusText() {
    switch (status) {
      case 0:
        return 'Đã duyệt';
      case 1:
        return 'Chờ duyệt';
      case 2:
        return 'Từ chối';
      default:
        return 'Không xác định';
    }
  }

  @override
  String toString() {
    return 'Doctor(uuid: $uuid, userId: $userId, hospitalId: $hospitalId, clinicId: $clinicId, doctorType: $doctorType, specializationId: $specializationId, license: $license, introduce: $introduce, experience: $experience, patientCount: $patientCount, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

// ADD THIS NEW CLASS for registration only
class DoctorRegistrationRequest {
  final String userId;
  final String? hospitalId;
  final String? clinicId;
  final int? doctorType;
  final String specializationId;
  final String license;
  final String? introduce;
  final int? experience;
  final int? patientCount;
  final int? status; // Optional, defaults to 1 (pending) on server

  DoctorRegistrationRequest({
    required this.userId,
    this.hospitalId,
    this.clinicId,
    this.doctorType,
    required this.specializationId,
    required this.license,
    this.introduce,
    this.experience,
    this.patientCount,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      if (hospitalId != null) 'hospital_id': hospitalId,
      if (clinicId != null) 'clinic_id': clinicId,
      if (doctorType != null) 'doctor_type': doctorType,
      'specialization_id': specializationId,
      'license': license,
      if (introduce != null && introduce!.isNotEmpty) 'introduce': introduce,
      if (experience != null) 'experience': experience,
      if (patientCount != null) 'patient_count': patientCount,
      if (status != null) 'status': status,
    };
  }

  @override
  String toString() {
    return 'DoctorRegistrationRequest(userId: $userId, hospitalId: $hospitalId, clinicId: $clinicId, doctorType: $doctorType, specializationId: $specializationId, license: $license, introduce: $introduce, experience: $experience, patientCount: $patientCount, status: $status)';
  }
}