class Specialization {
  final String uuid;
  final String name;
  final String? createdAt;
  final String? updatedAt;

  Specialization({
    required this.uuid,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  set value(Specialization value) {}
}
