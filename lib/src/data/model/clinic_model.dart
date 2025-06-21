class Clinic {
  final String uuid;
  final String name;
  final String address;
  final String? phone;
  final String? email;
  final String? image;
  final String? hospitalId;
  final String? createdAt;
  final String? updatedAt;

  Clinic({
    required this.uuid,
    required this.name,
    required this.address,
    this.phone,
    this.email,
    this.image,
    this.hospitalId,
    this.createdAt,
    this.updatedAt,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'],
      email: json['email'],
      image: json['image'],
      hospitalId: json['hospital_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
