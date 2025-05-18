// models/medical_entity.dart
import 'dart:ui';

import 'package:flutter/material.dart';

enum MedicalType {
  doctor,
  hospital,
  clinic,
  vaccinationCenter,
}

extension MedicalTypeExtension on MedicalType {
  String get displayName {
    switch (this) {
      case MedicalType.doctor:
        return 'Bác sĩ';
      case MedicalType.hospital:
        return 'Bệnh viện';
      case MedicalType.clinic:
        return 'Phòng khám';
      case MedicalType.vaccinationCenter:
        return 'Trung tâm tiêm chủng';
    }
  }

  Color get color {
    switch (this) {
      case MedicalType.doctor:
        return Colors.blue;
      case MedicalType.hospital:
        return Colors.green;
      case MedicalType.clinic:
        return Colors.purple;
      case MedicalType.vaccinationCenter:
        return Colors.orange;
    }
  }

  IconData get icon {
    switch (this) {
      case MedicalType.doctor:
        return Icons.person;
      case MedicalType.hospital:
        return Icons.local_hospital;
      case MedicalType.clinic:
        return Icons.medical_services;
      case MedicalType.vaccinationCenter:
        return Icons.vaccines;
    }
  }
}

abstract class MedicalEntity {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final MedicalType type;
  final String about;
  final List<String> availableDays;
  final List<String> availableSlots;
  final List<Review> reviews;

  MedicalEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.type,
    required this.about,
    required this.availableDays,
    required this.availableSlots,
    required this.reviews,
  });
}

class Doctor extends MedicalEntity {
  final String specialization;
  final String hospital;
  final int experience;
  final int patientCount;

  Doctor({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    required super.about,
    required super.availableDays,
    required super.availableSlots,
    required super.reviews,
    required this.specialization,
    required this.hospital,
    required this.experience,
    required this.patientCount,
  }) : super(type: MedicalType.doctor);
}

class Hospital extends MedicalEntity {
  final String address;
  final int departmentCount;
  final int doctorCount;

  Hospital({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    required super.about,
    required super.availableDays,
    required super.availableSlots,
    required super.reviews,
    required this.address,
    required this.departmentCount,
    required this.doctorCount,
  }) : super(type: MedicalType.hospital);
}

class Clinic extends MedicalEntity {
  final String address;
  final String director;
  final String phoneNumber;

  Clinic({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    required super.about,
    required super.availableDays,
    required super.availableSlots,
    required super.reviews,
    required this.address,
    required this.director,
    required this.phoneNumber,
  }) : super(type: MedicalType.clinic);
}

class VaccinationCenter extends MedicalEntity {
  final String address;
  final List<String> availableVaccines;
  final bool is24h;

  VaccinationCenter({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    required super.about,
    required super.availableDays,
    required super.availableSlots,
    required super.reviews,
    required this.address,
    required this.availableVaccines,
    required this.is24h,
  }) : super(type: MedicalType.vaccinationCenter);
}

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