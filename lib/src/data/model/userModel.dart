class User {
  final String uuid;
  final int? premissionId;
  final String? name;
  final String? email;
  final String? phone;
  final int? gender;
  final String? address;
  final String? username;
  final String? password;
  final int? status;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.uuid,
    this.premissionId,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.address,
    this.username,
    this.password,
    this.status,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'] ?? '',
      premissionId: json['premission_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      address: json['address'],
      username: json['username'],
      password: json['password'],
      status: json['status'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'premission_id': premissionId,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'address': address,
      'username': username,
      'password': password,
      'status': status,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}