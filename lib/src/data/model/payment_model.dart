class Payment {
  final String uuid;
  final String? userId;
  final String? appointmentId;
  final double? amount;
  final String? paymentMethod;
  final int? status; // 1: pending, 2: success, 3: failed
  final DateTime? paymentTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Payment({
    required this.uuid,
    this.userId,
    this.appointmentId,
    this.amount,
    this.paymentMethod,
    this.status,
    this.paymentTime,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        uuid: json['uuid'] ?? '',
        userId: json['user_id'],
        appointmentId: json['appointment_id'],
        amount: json['amount'] != null
            ? (json['amount'] is int
                ? (json['amount'] as int).toDouble()
                : json['amount'] is String
                    ? double.tryParse(json['amount']) ?? 0
                    : json['amount'])
            : null,
        paymentMethod: json['payment_method'],
        status: json['status'],
        paymentTime: json['payment_time'] != null
            ? DateTime.tryParse(json['payment_time'])
            : null,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'user_id': userId,
        'appointment_id': appointmentId,
        'amount': amount,
        'payment_method': paymentMethod,
        'status': status,
        'payment_time': paymentTime?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
