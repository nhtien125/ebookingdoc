class Patient {
  final String id;
  final String name;
  final String dob;
  final String gender;
  final String? phone;
  final String relationship;
  final String? insuranceNumber;
  final String? address;
  final String? image;

  Patient({
    required this.id,
    required this.name,
    required this.dob,
    required this.gender,
    this.phone,
    required this.relationship,
    this.insuranceNumber,
    this.address,
    this.image,
  });
}

class Hospital {
  final String id;
  final String name;
  final String address;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
  });
}

class Doctor {
  final String id;
  final String name;
  final String address;
  final String hospitalId;
  final String? image;
  final String? phone;
  final double? rating;
  final List<Department> departments;

  Doctor({
    required this.id,
    required this.name,
    required this.address,
    required this.hospitalId,
    this.image,
    this.phone,
    this.rating,
    required this.departments,
  });
}

class Department {
  final String id;
  final String name;
  final List<MedicalService> services;

  Department({
    required this.id,
    required this.name,
    required this.services,
  });
}

class MedicalService {
  final String id;
  final String name;
  final double price;
  final String? description;

  MedicalService({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });
}

class ClinicRoom {
  final String id;
  final String name;
  final String? floor;

  ClinicRoom({
    required this.id,
    required this.name,
    this.floor,
  });
}

class Appointment {
  final String id;
  final Patient patient;
  final Doctor doctor;
  final Department department;
  final MedicalService service;
  final DateTime date;
  final String timeSlot;
  final String status;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.patient,
    required this.doctor,
    required this.department,
    required this.service,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.createdAt,
  });
}
