class MedicalServiceModel {
  final String uuid;
  final String? name;
  final String? description;
  final double? price;
  final String? specializationId;
  final String? clinicId;
  final String? hospitalId;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MedicalServiceModel({
    required this.uuid,
    this.name,
    this.description,
    this.price,
    this.specializationId,
    this.clinicId,
    this.hospitalId,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicalServiceModel.fromJson(Map<String, dynamic> json) {
    return MedicalServiceModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      specializationId: json['specialization_id'] as String?,
      clinicId: json['clinic_id'] as String?,
      hospitalId: json['hospital_id'] as String?,
      image: json['image'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'price': price,
      'specialization_id': specializationId,
      'clinic_id': clinicId,
      'hospital_id': hospitalId,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}