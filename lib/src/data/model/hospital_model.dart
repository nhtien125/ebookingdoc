class Hospital {
  final String uuid;
  final String name;
  final String address;
  final String image;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  Hospital({
    required this.uuid,
    required this.name,
    required this.address,
    required this.image,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',        // chống null
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'address': address,
      'image': image,
      'description': description ?? '',
      'created_at': createdAt ?? '',
      'updated_at': updatedAt ?? '',
    };
  }
}
