import 'package:intl/intl.dart';

/// Model đại diện cho hồ sơ bệnh án
class MedicalRecord {
  late final String name;
  late final DateTime dob;
  late final String gender;
  late final String bloodType;
  late final int height; // cm
  late final int weight; // kg
  late final String? allergies;
  late final String? chronicDiseases;
  late final String? surgeries;
  late final String? currentMedications;

  /// Tạo mới MedicalRecord
  MedicalRecord({
    required this.name,
    required this.dob,
    required this.gender,
    required this.bloodType,
    required this.height,
    required this.weight,
    this.allergies,
    this.chronicDiseases,
    this.surgeries,
    this.currentMedications,
  });

  /// Copy constructor với khả năng override từng field
  MedicalRecord copyWith({
    String? name,
    DateTime? dob,
    String? gender,
    String? bloodType,
    int? height,
    int? weight,
    String? bloodPressure,
    String? allergies,
    String? chronicDiseases,
    String? surgeries,
    String? currentMedications,
  }) {
    return MedicalRecord(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      surgeries: surgeries ?? this.surgeries,
      currentMedications: currentMedications ?? this.currentMedications,
    );
  }

  /// Tính toán BMI tự động
  double get bmi => weight / ((height / 100) * (height / 100));

  /// Định dạng ngày tháng năm sinh
  String get formattedDob => DateFormat('dd/MM/yyyy').format(dob);

  /// Chuyển đổi thành Map để lưu trữ
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dob': dob.toIso8601String(),
      'gender': gender,
      'bloodType': bloodType,
      'height': height,
      'weight': weight,
      'allergies': allergies,
      'chronicDiseases': chronicDiseases,
      'surgeries': surgeries,
      'currentMedications': currentMedications,
    };
  }

  /// Tạo MedicalRecord từ Map
  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      name: map['name'] as String,
      dob: DateTime.parse(map['dob'] as String),
      gender: map['gender'] as String,
      bloodType: map['bloodType'] as String,
      height: map['height'] as int,
      weight: map['weight'] as int,
      allergies: map['allergies'] as String?,
      chronicDiseases: map['chronicDiseases'] as String?,
      surgeries: map['surgeries'] as String?,
      currentMedications: map['currentMedications'] as String?,
    );
  }
}

/// Model đại diện cho lịch hẹn khám bệnh
class MedicalAppointment {
  final DateTime date;
  final String hospitalName;
  final String serviceName;
  final String doctorName;

  MedicalAppointment({
    required this.date,
    required this.hospitalName,
    required this.serviceName,
    required this.doctorName,
  });

  /// Định dạng ngày hẹn
  String get formattedDate => DateFormat('dd/MM/yyyy').format(date);

  /// Chuyển đổi thành Map để lưu trữ
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'hospitalName': hospitalName,
      'serviceName': serviceName,
      'doctorName': doctorName,
    };
  }

  /// Tạo MedicalAppointment từ Map
  factory MedicalAppointment.fromMap(Map<String, dynamic> map) {
    return MedicalAppointment(
      date: DateTime.parse(map['date'] as String),
      hospitalName: map['hospitalName'] as String,
      serviceName: map['serviceName'] as String,
      doctorName: map['doctorName'] as String,
    );
  }
}