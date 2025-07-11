class Clinic {
  final String uuid;
  final String name;
  final String address;
  final String? phone;
  final String? email;
  final String? image;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  Clinic({
    required this.uuid,
    required this.name,
    required this.address,
    this.phone,
    this.email,
    this.image,
    this.description,
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
      description: json['description'],
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
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
