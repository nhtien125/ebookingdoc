import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MedicalService {
  final String id;
  final String name;
  final SvgPicture icon;
  final Color color;

  MedicalService({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}