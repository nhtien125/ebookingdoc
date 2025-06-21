class Review {
  final String uuid;
  final String userId;
  final String doctorId;
  final String appointmentId;
  final int stars;
  final String? comment;
  final String patientName;
  final String patientAvatar;
  final DateTime createdAt;

  Review({
    required this.uuid,
    required this.userId,
    required this.doctorId,
    required this.appointmentId,
    required this.stars,
    this.comment,
    required this.patientName,
    required this.patientAvatar,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      uuid: json['uuid'],
      userId: json['user_id'],
      doctorId: json['doctor_id'],
      appointmentId: json['appointment_id'],
      stars: json['stars'],
      comment: json['comment'],
      patientName: json['patient_name'] ?? '',
      // Ưu tiên lấy patient_avatar, nếu không có thì lấy image, nếu không có nữa thì chuỗi rỗng
      patientAvatar: json['patient_avatar'] ?? json['image'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
