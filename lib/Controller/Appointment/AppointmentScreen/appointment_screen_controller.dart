import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Hospital {
  final String id;
  final String name;
  final String address;

  Hospital({required this.id, required this.name, required this.address});
}

class AppointmentInfo {
  String? specialtyId;
  String? serviceId;
  String? roomId;
  DateTime? date;
  String? timeSlot;
}
class AppointmentScreenController extends GetxController {
  // Hospital information
  final hospital = Hospital(
    id: '1',
    name: 'Bệnh viện Đa khoa Quốc tế Vinmec',
    address: '458 Minh Khai, Vĩnh Tuy, Hai Bà Trưng, Hà Nội',
  );

  // Appointment information
  var appointmentInfo = AppointmentInfo().obs;

  // Mock data for specialties, services, and rooms
  final specialties = <Specialty>[
    Specialty(id: '1', name: 'Khoa Nội tổng quát'),
    Specialty(id: '2', name: 'Khoa Nhi'),
    Specialty(id: '3', name: 'Khoa Tai Mũi Họng'),
    Specialty(id: '4', name: 'Khoa Mắt'),
  ];

  final services = [
    {'id': '1', 'name': 'Khám tổng quát', 'specialtyId': '1'},
    {'id': '2', 'name': 'Khám nhi khoa', 'specialtyId': '2'},
    {'id': '3', 'name': 'Khám Tai Mũi Họng', 'specialtyId': '3'},
    {'id': '4', 'name': 'Khám Mắt', 'specialtyId': '4'},
  ];

  final rooms = [
    {'id': '1', 'name': 'Phòng 101 - Tầng 1', 'specialtyId': '1'},
    {'id': '2', 'name': 'Phòng 201 - Tầng 2', 'specialtyId': '2'},
    {'id': '3', 'name': 'Phòng 301 - Tầng 3', 'specialtyId': '3'},
    {'id': '4', 'name': 'Phòng 401 - Tầng 4', 'specialtyId': '4'},
  ];

  // Time slots available
  final timeSlots = [
    '08:00 - 08:30',
    '08:30 - 09:00',
    '09:00 - 09:30',
    '09:30 - 10:00',
    '10:00 - 10:30',
    '13:30 - 14:00',
    '14:00 - 14:30',
    '14:30 - 15:00',
  ];

  // Select specialty
  void selectSpecialty(String specialtyId) {
    appointmentInfo.update((info) {
      info?.specialtyId = specialtyId;
      info?.serviceId = null; // Reset service when specialty changes
      info?.roomId = null; // Reset room when specialty changes
    });
    
    // In a real app, you might fetch services for this specialty here
  }

  // Select service
  void selectService(String serviceId) {
    appointmentInfo.update((info) {
      info?.serviceId = serviceId;
    });
  }

  // Select room
  void selectRoom(String roomId) {
    appointmentInfo.update((info) {
      info?.roomId = roomId;
    });
  }

  // Select date
  void selectDate(DateTime date) {
    appointmentInfo.update((info) {
      info?.date = date;
    });
  }

  // Select time slot
  void selectTimeSlot(String timeSlot) {
    appointmentInfo.update((info) {
      info?.timeSlot = timeSlot;
    });
  }

  // Check if all required fields are filled
  bool canSubmit() {
    return appointmentInfo.value.specialtyId != null &&
        appointmentInfo.value.serviceId != null &&
        appointmentInfo.value.roomId != null &&
        appointmentInfo.value.date != null &&
        appointmentInfo.value.timeSlot != null;
  }

  // Submit appointment with loading state
  Future<void> submitAppointmentWithLoading() async {
    // Show loading
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // Hide loading
    Get.back();

    // In a real app, you would handle the API response here
    // For now, we'll just reset the form
    resetForm();
  }

  // Reset the appointment form
  void resetForm() {
    appointmentInfo.value = AppointmentInfo();
  }
}

// Model classes


class Specialty {
  final String id;
  final String name;

  Specialty({
    required this.id,
    required this.name,
  });
}

class AppointmentInf {
  String? specialtyId;
  String? serviceId;
  String? roomId;
  DateTime? date;
  String? timeSlot;

  AppointmentInf({
    this.specialtyId,
    this.serviceId,
    this.roomId,
    this.date,
    this.timeSlot,
  });
}