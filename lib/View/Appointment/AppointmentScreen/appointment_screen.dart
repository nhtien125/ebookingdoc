// import 'package:ebookingdoc/Controller/Appointment/AppointmentScreen/appointment_screen_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AppointmentScreen extends StatelessWidget {
//   final AppointmentScreenController controller = Get.put(AppointmentScreenController());

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Đặt lịch khám bệnh',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20),
//         child: Obx(() => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hospital Card
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.local_hospital, color: theme.primaryColor),
//                         SizedBox(width: 8),
//                         Text(
//                           'Bệnh viện',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: theme.primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 12),
//                     Text(
//                       controller.hospital.value.name,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       controller.hospital.value.address,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 24),

//             // Booking Steps
//             Text(
//               'Thông tin đặt lịch',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),

//             // Selection Items
//             _buildSelectionItem(
//               context,
//               title: 'Chuyên khoa',
//               value: controller.appointmentInfo.value.specialtyId != null
//                   ? controller.specialties
//                       .firstWhere((s) => s.id == controller.appointmentInfo.value.specialtyId)
//                       .name
//                   : null,
//               onTap: () => controller.selectSpecialty('1'),
//               icon: Icons.medical_services,
//             ),
//             _buildSelectionItem(
//               context,
//               title: 'Dịch vụ',
//               value: controller.appointmentInfo.value.serviceId != null
//                   ? controller.services
//                       .firstWhere((s) => s['id'] == controller.appointmentInfo.value.serviceId)['name']
//                   : null,
//               onTap: () => controller.selectService('1'),
//               icon: Icons.miscellaneous_services,
//             ),
//             _buildSelectionItem(
//               context,
//               title: 'Phòng khám',
//               value: controller.appointmentInfo.value.roomId != null
//                   ? controller.rooms
//                       .firstWhere((r) => r['id'] == controller.appointmentInfo.value.roomId)['name']
//                   : null,
//               onTap: () => controller.selectRoom('1'),
//               icon: Icons.meeting_room,
//             ),
//             _buildSelectionItem(
//               context,
//               title: 'Ngày khám',
//               value: controller.appointmentInfo.value.date != null
//                   ? '${controller.appointmentInfo.value.date!.day}/${controller.appointmentInfo.value.date!.month}/${controller.appointmentInfo.value.date!.year}'
//                   : null,
//               onTap: () => controller.selectDate(DateTime.now().add(Duration(days: 1))),
//               icon: Icons.calendar_today,
//             ),
//             _buildSelectionItem(
//               context,
//               title: 'Giờ khám',
//               value: controller.appointmentInfo.value.timeSlot,
//               onTap: () => controller.selectTimeSlot('08:30'),
//               icon: Icons.access_time,
//             ),

//             SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   if (controller.canSubmit()) {
//                     await controller.submitAppointmentWithLoading();
//                     Get.snackbar(
//                       'Thành công',
//                       'Đặt lịch thành công!',
//                       snackPosition: SnackPosition.BOTTOM,
//                       borderRadius: 10,
//                       margin: EdgeInsets.all(15),
//                     );
//                   } else {
//                     Get.snackbar(
//                       'Lỗi',
//                       'Vui lòng chọn đầy đủ thông tin',
//                       snackPosition: SnackPosition.BOTTOM,
//                       borderRadius: 10,
//                       margin: EdgeInsets.all(15),
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 2,
//                 ),
//                 child: Text(
//                   'XÁC NHẬN ĐẶT LỊCH',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         )),
//       ),
//     );
//   }

//   Widget _buildSelectionItem(
//     BuildContext context, {
//     required String title,
//     required VoidCallback onTap,
//     String? value,
//     IconData? icon,
//   }) {
//     final isSelected = value != null;
//     final theme = Theme.of(context);

//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.white,
//             border: Border.all(
//               color: isSelected ? theme.primaryColor : Colors.grey.shade300,
//               width: isSelected ? 1.5 : 1,
//             ),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? theme.primaryColor
//                       : Colors.grey.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   icon ?? Icons.help_outline,
//                   color: isSelected ? Colors.white : Colors.grey,
//                   size: 20,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       value ?? 'Chọn $title',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                         color: isSelected ? Colors.black87 : Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.chevron_right,
//                 color: Colors.grey,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }