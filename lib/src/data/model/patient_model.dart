class Patient {
  final String uuid; // hoặc id, nhưng chuẩn backend là uuid
  final String userId; // liên kết với user nếu cần
  final String name;
  final String dob; // nên dùng String để tương thích với mọi backend
  final String gender;
  final String? phone;
  final String relationship;
  final String? insuranceNumber;
  final String? address;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  Patient({
    required this.uuid,
    required this.userId,
    required this.name,
    required this.dob,
    required this.gender,
    this.phone,
    required this.relationship,
    this.insuranceNumber,
    this.address,
    this.image,
    this.createdAt,
    this.updatedAt,
  });


  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      uuid: json['uuid'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      phone: json['phone'],
      relationship: json['relationship'] ?? '',
      insuranceNumber: json['insuranceNumber'] ?? json['insurance_number'],
      address: json['address'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'user_id': userId,
      'name': name,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'relationship': relationship,
      'insurance_number': insuranceNumber,
      'address': address,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
