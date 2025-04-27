// // appointment_screen.dart - View hiển thị giao diện đặt lịch khám

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'models.dart';

// class AppointmentScreen extends StatelessWidget {
//   final AppointmentController controller = Get.put(AppointmentController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(),
//       body: _buildBody(context),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       title: Text(
//         'Đặt lịch khám bệnh',
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       centerTitle: true,
//       elevation: 0,
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(20),
//       child: Obx(() => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHospitalCard(context),
//           SizedBox(height: 24),
//           _buildBookingInfoHeader(),
//           SizedBox(height: 16),
//           _buildSelectionItems(context),
//           SizedBox(height: 32),
//           _buildSubmitButton(context),
//         ],
//       )),
//     );
//   }

//   Widget _buildHospitalCard(BuildContext context) {
//     final theme = Theme.of(context);
//     final hospital = controller.appointmentInfo.value.hospital;

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.local_hospital, color: theme.primaryColor),
//                 SizedBox(width: 8),
//                 Text(
//                   'Bệnh viện',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: theme.primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             Text(
//               hospital.name,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               hospital.address,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBookingInfoHeader() {
//     return Text(
//       'Thông tin đặt lịch',
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }

//   Widget _buildSelectionItems(BuildContext context) {
//     return Column(
//       children: [
//         // Specialty selection
//         _buildSelectionItem(
//           context,
//           title: 'Chuyên khoa',
//           value: controller.selectedSpecialty?.name,
//           onTap: () => _showSpecialtyPicker(context),
//           icon: Icons.medical_services,
//         ),
        
//         // Service selection (only enabled if specialty is selected)
//         _buildSelectionItem(
//           context,
//           title: 'Dịch vụ',
//           value: controller.selectedService?.name,
//           onTap: controller.appointmentInfo.value.specialtyId != null
//               ? () => _showServicePicker(context)
//               : null,
//           icon: Icons.miscellaneous_services,
//         ),
        
//         // Room selection (only enabled if specialty is selected)
//         _buildSelectionItem(
//           context,
//           title: 'Phòng khám',
//           value: controller.selectedRoom?.name,
//           onTap: controller.appointmentInfo.value.specialtyId != null
//               ? () => _showRoomPicker(context)
//               : null,
//           icon: Icons.meeting_room,
//         ),
        
//         // Date selection
//         _buildSelectionItem(
//           context,
//           title: 'Ngày khám',
//           value: controller.formattedSelectedDate,
//           onTap: () => _showDatePicker(context),
//           icon: Icons.calendar_today,
//         ),
        
//         // Time slot selection
//         _buildSelectionItem(
//           context,
//           title: 'Giờ khám',
//           value: controller.appointmentInfo.value.timeSlot,
//           onTap: () => _showTimeSlotPicker(context),
//           icon: Icons.access_time,
//         ),
//       ],
//     );
//   }

//   Widget _buildSelectionItem(
//     BuildContext context, {
//     required String title,
//     required VoidCallback? onTap,
//     String? value,
//     IconData? icon,
//   }) {
//     final isSelected = value != null;
//     final theme = Theme.of(context);
//     final isDisabled = onTap == null;

//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: isSelected 
//                 ? theme.primaryColor.withOpacity(0.1) 
//                 : (isDisabled ? Colors.grey.shade100 : Colors.white),
//             border: Border.all(
//               color: isSelected 
//                   ? theme.primaryColor 
//                   : (isDisabled ? Colors.grey.shade200 : Colors.grey.shade300),
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
//                       : (isDisabled ? Colors.grey.shade300 : Colors.grey.withOpacity(0.2)),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   icon ?? Icons.help_outline,
//                   color: isSelected ? Colors.white : (isDisabled ? Colors.grey.shade400 : Colors.grey),
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
//                         color: isDisabled ? Colors.grey.shade400 : Colors.grey[600],
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       value ?? 'Chọn $title',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                         color: isDisabled 
//                             ? Colors.grey.shade400 
//                             : (isSelected ? Colors.black87 : Colors.grey),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.chevron_right,
//                 color: isDisabled ? Colors.grey.shade300 : Colors.grey,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSubmitButton(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: controller.canSubmit() ? _submitAppointment : null,
//         style: ElevatedButton.styleFrom(
//           padding: EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 2,
//         ),
//         child: Text(
//           'XÁC NHẬN ĐẶT LỊCH',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   // Picker dialogs
//   void _showSpecialtyPicker(BuildContext context) {
//     Get.bottomSheet(
//       Container(
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Chọn chuyên khoa',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () => Get.back(),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: controller.specialties.length,
//                 itemBuilder: (context, index) {
//                   final specialty = controller.specialties[index];
//                   final isSelected = controller.appointmentInfo.value.specialtyId == specialty.id;
                  
//                   return ListTile(
//                     title: Text(specialty.name),
//                     trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
//                     onTap: () {
//                       controller.selectSpecialty(specialty.id);
//                       Get.back();
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//     );
//   }

//   void _showServicePicker(BuildContext context) {
//     final specialtyId = controller.appointmentInfo.value.specialtyId!;
//     final services = controller.getServicesBySpecialty(specialtyId);
    
//     Get.bottomSheet(
//       Container(
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Chọn dịch vụ',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () => Get.back(),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: services.length,
//                 itemBuilder: (context, index) {
//                   final service = services[index];
//                   final isSelected = controller.appointmentInfo.value.serviceId == service.id;
                  
//                   return ListTile(
//                     title: Text(service.name),
//                     trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
//                     onTap: () {
//                       controller.selectService(service.id);
//                       Get.back();
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//     );
//   }

//   void _showRoomPicker(BuildContext context) {
//     final specialtyId = controller.appointmentInfo.value.specialtyId!;
//     final rooms = controller.getRoomsBySpecialty(specialtyId);
    
//     Get.bottomSheet(
//       Container(
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Chọn phòng khám',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () => Get.back(),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: rooms.length,
//                 itemBuilder: (context, index) {
//                   final room = rooms[index];
//                   final isSelected = controller.appointmentInfo.value.roomId == room.id;
                  
//                   return ListTile(
//                     title: Text(room.name),
//                     trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
//                     onTap: () {
//                       controller.selectRoom(room.id);
//                       Get.back();
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//     );
//   }

//   void _showDatePicker(BuildContext context) {
//     final now = DateTime.now();
//     showDatePicker(
//       context: context,
//       initialDate: now.add(Duration(days: 1)),
//       firstDate: now,
//       lastDate: now.add(Duration(days: 30)),
//     ).then((date) {
//       if (date != null) {
//         controller.selectDate(date);
//       }
//     });
//   }

//   void _showTimeSlotPicker(BuildContext context) {
//     Get.bottomSheet(
//       Container(
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Chọn giờ khám',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () => Get.back(),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: controller.timeSlots.length,
//                 itemBuilder: (context, index) {
//                   final timeSlot = controller.timeSlots[index];
//                   final isSelected = controller.appointmentInfo.value.timeSlot == timeSlot.time;
                  
//                   return ListTile(
//                     title: Text(timeSlot.time),
//                     trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
//                     onTap: () {
//                       controller.selectTimeSlot(timeSlot.time);
//                       Get.back();
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//     );
//   }

//   void _submitAppointment() async {
//     try {
//       final success = await controller.submitAppointmentWithLoading();
      
//       if (success) {
//         Get.snackbar(
//           'Thành công',
//           'Đặt lịch khám thành công!',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade800,
//           margin: EdgeInsets.all(15),
//           borderRadius: 10,
//           duration: Duration(seconds: 3),
//         );
//       } else {
//         Get.snackbar(
//           'Lỗi',
//           'Có lỗi xảy ra khi đặt lịch. Vui lòng thử lại sau.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade800,
//           margin: EdgeInsets.all(15),
//           borderRadius: 10,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Lỗi',
//         'Có lỗi xảy ra: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade800,
//         margin: EdgeInsets.all(15),
//         borderRadius: 10,
//       );
//     }
//   }
// }