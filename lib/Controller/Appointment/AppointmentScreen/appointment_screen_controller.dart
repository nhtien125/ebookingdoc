// // appointment_controller.dart - Controller xử lý logic cho màn hình đặt lịch khám

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';


// class AppointmentScreenController extends GetxController {
//   // Observable state
//   final Rx<AppointmentInfo> appointmentInfo;
  
//   // Data lists
//   final List<Specialty> specialties;
//   final List<Service> services;
//   final List<Room> rooms;
//   final List<TimeSlot> timeSlots;

//   AppointmentScreenController()
//       : appointmentInfo = Rx<AppointmentInfo>(
//           AppointmentInfo(
//             hospital: Hospital(
//               id: '1',
//               name: 'Bệnh viện Đa khoa Quốc tế Vinmec',
//               address: '458 Minh Khai, Vĩnh Tuy, Hai Bà Trưng, Hà Nội',
//             ),
//           ),
//         ),
//         specialties = [],
//         services = [],
//         rooms = [],
//         timeSlots = [];

//   @override
//   void onInit() {
//     super.onInit();
//     _initializeData();
//   }

//   void _initializeData() {
//     // Initialize specialties
//     specialties.addAll([
//       Specialty(id: '1', name: 'Khoa Nội tổng quát'),
//       Specialty(id: '2', name: 'Khoa Nhi'),
//       Specialty(id: '3', name: 'Khoa Tai Mũi Họng'),
//       Specialty(id: '4', name: 'Khoa Mắt'),
//     ]);
    
//     // Initialize services
//     services.addAll([
//       Service(id: '1', name: 'Khám tổng quát', specialtyId: '1'),
//       Service(id: '2', name: 'Điều trị nội khoa', specialtyId: '1'),
//       Service(id: '3', name: 'Khám nhi khoa', specialtyId: '2'),
//       Service(id: '4', name: 'Tiêm chủng', specialtyId: '2'),
//       Service(id: '5', name: 'Khám Tai Mũi Họng', specialtyId: '3'),
//       Service(id: '6', name: 'Nội soi Tai Mũi Họng', specialtyId: '3'),
//       Service(id: '7', name: 'Khám Mắt', specialtyId: '4'),
//       Service(id: '8', name: 'Đo thị lực', specialtyId: '4'),
//     ]);

//     // Initialize rooms
//     rooms.addAll([
//       Room(id: '1', name: 'Phòng 101 - Tầng 1', specialtyId: '1'),
//       Room(id: '2', name: 'Phòng 102 - Tầng 1', specialtyId: '1'),
//       Room(id: '3', name: 'Phòng 201 - Tầng 2', specialtyId: '2'),
//       Room(id: '4', name: 'Phòng 202 - Tầng 2', specialtyId: '2'),
//       Room(id: '5', name: 'Phòng 301 - Tầng 3', specialtyId: '3'),
//       Room(id: '6', name: 'Phòng 302 - Tầng 3', specialtyId: '3'),
//       Room(id: '7', name: 'Phòng 401 - Tầng 4', specialtyId: '4'),
//       Room(id: '8', name: 'Phòng 402 - Tầng 4', specialtyId: '4'),
//     ]);

//     // Initialize time slots
//     timeSlots.addAll([
//       TimeSlot(id: '1', time: '08:00 - 08:30'),
//       TimeSlot(id: '2', time: '08:30 - 09:00'),
//       TimeSlot(id: '3', time: '09:00 - 09:30'),
//       TimeSlot(id: '4', time: '09:30 - 10:00'),
//       TimeSlot(id: '5', time: '10:00 - 10:30'),
//       TimeSlot(id: '6', time: '13:30 - 14:00'),
//       TimeSlot(id: '7', time: '14:00 - 14:30'),
//       TimeSlot(id: '8', time: '14:30 - 15:00'),
//     ]);
//   }

//   // Filter services by selected specialty
//   List<Service> getServicesBySpecialty(String specialtyId) {
//     return services.where((service) => service.specialtyId == specialtyId).toList();
//   }

//   // Filter rooms by selected specialty
//   List<Room> getRoomsBySpecialty(String specialtyId) {
//     return rooms.where((room) => room.specialtyId == specialtyId).toList();
//   }

//   // Getters for selected objects
//   Specialty? get selectedSpecialty {
//     final id = appointmentInfo.value.specialtyId;
//     if (id == null) return null;
//     try {
//       return specialties.firstWhere((s) => s.id == id);
//     } catch (e) {
//       return null;
//     }
//   }

//   Service? get selectedService {
//     final id = appointmentInfo.value.serviceId;
//     if (id == null) return null;
//     try {
//       return services.firstWhere((s) => s.id == id);
//     } catch (e) {
//       return null;
//     }
//   }

//   Room? get selectedRoom {
//     final id = appointmentInfo.value.roomId;
//     if (id == null) return null;
//     try {
//       return rooms.firstWhere((r) => r.id == id);
//     } catch (e) {
//       return null;
//     }
//   }

//   String? get formattedSelectedDate {
//     final date = appointmentInfo.value.date;
//     if (date == null) return null;
//     return '${date.day}/${date.month}/${date.year}';
//   }

//   // Selection methods
//   void selectSpecialty(String specialtyId) {
//     appointmentInfo.update((info) {
//       appointmentInfo.value = info!.copyWith(
//         specialtyId: specialtyId,
//         clearService: true,
//         clearRoom: true,
//       );
//     });
//   }

//   void selectService(String serviceId) {
//     appointmentInfo.update((info) {
//       appointmentInfo.value = info!.copyWith(serviceId: serviceId);
//     });
//   }

//   void selectRoom(String roomId) {
//     appointmentInfo.update((info) {
//       appointmentInfo.value = info!.copyWith(roomId: roomId);
//     });
//   }

//   void selectDate(DateTime date) {
//     appointmentInfo.update((info) {
//       appointmentInfo.value = info!.copyWith(date: date);
//     });
//   }

//   void selectTimeSlot(String timeSlot) {
//     appointmentInfo.update((info) {
//       appointmentInfo.value = info!.copyWith(timeSlot: timeSlot);
//     });
//   }

//   // Submission logic
//   bool canSubmit() {
//     return appointmentInfo.value.isComplete();
//   }

//   Future<bool> submitAppointment() async {
//     try {
//       // In a real app, this would send data to an API
//       await Future.delayed(Duration(seconds: 2)); // Simulate network request
//       return true; // Success
//     } catch (e) {
//       print("Error submitting appointment: $e");
//       return false;
//     }
//   }

//   // Submit appointment with loading dialog
//   Future<bool> submitAppointmentWithLoading() async {
//     // Show loading
//     Get.dialog(
//       Center(child: CircularProgressIndicator()),
//       barrierDismissible: false,
//     );

//     // Simulate API call
//     final success = await submitAppointment();

//     // Hide loading
//     Get.back();

//     // Reset form if successful
//     if (success) {
//       resetForm();
//     }

//     return success;
//   }

//   void resetForm() {
//     appointmentInfo.value = AppointmentInfo(hospital: appointmentInfo.value.hospital);
//   }
// }