import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/data/model/specialization_model.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';

class DoctorDisplay {
  final Doctor doctor;
  final User user;
  final Specialization specialization;

  DoctorDisplay({
    required this.doctor,
    required this.user,
    required this.specialization,
  });
}
