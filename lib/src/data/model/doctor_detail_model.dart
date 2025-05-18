class Review {
  final String patientName;
  final String patientAvatar;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.patientName,
    required this.patientAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

// Cập nhật class Doctor với danh sách reviews
class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String hospital;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int experience;
  final int patientCount;
  final String about;
  final List<String> availableDays;
  final List<String> availableSlots;
  final double consultationFee;
  final List<Review> reviews; // Thêm danh sách đánh giá

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.hospital,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.experience,
    required this.patientCount,
    required this.about,
    required this.availableDays,
    required this.availableSlots,
    required this.consultationFee,
    required this.reviews, // Thêm vào constructor
  });
}