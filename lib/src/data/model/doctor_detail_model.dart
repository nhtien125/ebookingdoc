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