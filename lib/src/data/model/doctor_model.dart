class Doctor {
  final String uuid;
  final String? userId;
  final String? hospitalId; // Thêm trường này
  final int? doctorType;
  final String? specializationId;
  final String? license;
  final String? introduce;
  final int? experience;
  final int? patientCount;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  Doctor({
    required this.uuid,
    this.userId,
    this.hospitalId, // Thêm vào constructor
    this.doctorType,
    this.specializationId,
    this.license,
    this.introduce,
    this.experience,
    this.patientCount,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      uuid: json['uuid'] ?? '',
      userId: json['user_id'],
      hospitalId: json['hospital_id'], // Parse trường mới
      doctorType: json['doctor_type'],
      specializationId: json['specialization_id'],
      license: json['license'],
      introduce: json['introduce'],
      experience: json['experience'],
      patientCount: json['patient_count'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'user_id': userId,
      'hospital_id': hospitalId, // Thêm trường này
      'doctor_type': doctorType,
      'specialization_id': specializationId,
      'license': license,
      'introduce': introduce,
      'experience': experience,
      'patient_count': patientCount,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
