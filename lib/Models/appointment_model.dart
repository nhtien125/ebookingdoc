import 'package:ebookingdoc/Models/hospital_model.dart';

class Appointment {
  final String id;

  final String doctorName;
  final String specialtyName;
  final String doctorImageUrl;
  final String dateTime;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.specialtyName,
    required this.doctorImageUrl,
    required this.dateTime,
  });
}

class AppointmentInfo {
  Hospital? hospital;
  String? specialtyId;
  String? serviceId;
  String? roomId;
  DateTime? date;
  String? timeSlot;

}
