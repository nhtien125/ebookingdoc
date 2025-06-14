class Clinic {
  final String uuid;
  final String? name;
  final String? address;
  final String? phone;
  final String? email;
  final String? image;
  final String? hospital_id;

  Clinic({
    required this.uuid,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.image,
    this.hospital_id,
  });
}
