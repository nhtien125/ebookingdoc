class VaccinationCenter {
  final String uuid;
  final String name;
  final String address;
  final String? phone;
  final String? email;
  final String? image;
  final String? description;
  final String? status;        // Thêm trạng thái (open/closed)
  final String? workingHours;  // Thêm giờ hoạt động
  final String? createdAt;
  final String? updatedAt;

  VaccinationCenter({
    required this.uuid,
    required this.name,
    required this.address,
    this.phone,
    this.email,
    this.image,
    this.description,
    this.status,
    this.workingHours,
    this.createdAt,
    this.updatedAt,
  });

  factory VaccinationCenter.fromJson(Map<String, dynamic> json) {
    return VaccinationCenter(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'],
      email: json['email'],
      image: json['image'],
      description: json['description'],
      status: json['status'],
      workingHours: json['working_hours'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'image': image,
      'description': description,
      'status': status,
      'working_hours': workingHours,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
