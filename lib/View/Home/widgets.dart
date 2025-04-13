// // TODO Implement this library.
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:ebookingdoc/Controller/Home/home_controller.dart';
// import 'package:ebookingdoc/Global/app_color.dart';
// import 'package:ebookingdoc/Global/app_text_style.dart';
// import 'package:flutter/material.dart';
// import 'package:ebookingdoc/Controller/Home/home_controller.dart';

// import 'package:get/get.dart';


// final controller = Get.put(HomeController());


// Widget buildCategories() {
//   var controller;
//   return Container(
//     padding: const EdgeInsets.symmetric(vertical: 16),
//     color: Colors.white,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Text(
//             'Danh mục',
//             style: AppTextStyle.sectionTitle,
//           ),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 40,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             children: [
//               buildCategoryButton('Tất cả', controller, isSelected: true),
//               buildCategoryButton('Tại nhà', controller),
//               buildCategoryButton('Tại viện', controller),
//               buildCategoryButton('Chuyên khoa', controller),
//               buildCategoryButton('Khám tổng quát', controller),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
// Widget buildCategoryButton(String title, HomeController controller, {bool isSelected = false}) {
//   return Padding(
//     padding: const EdgeInsets.only(right: 8),
//     child: ElevatedButton(
//       onPressed: () => controller.selectCategory(title),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isSelected ? AppColor.primary : Colors.white,
//         foregroundColor: isSelected ? Colors.white : AppColor.primary,
//         elevation: isSelected ? 2 : 0,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: BorderSide(color: AppColor.primary),
//         ),
//       ),
//       child: Text(title),
//     ),
//   );
// }


//   Widget buildCarouselSlider() {
//     var controller;
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CarouselSlider(
//             options: CarouselOptions(
//               height: 180,
//               autoPlay: true,
//               enlargeCenterPage: true,
//               viewportFraction: 0.9,
//               autoPlayInterval: const Duration(seconds: 4),
//               onPageChanged: (index, reason) =>
//                   controller.updateCarouselIndex(index),
//             ),
//             items: controller.carouselItems.map((item) {
//               return Container(
//                 width: MediaQuery.of(Get.context!).size.width,
//                 margin: const EdgeInsets.symmetric(horizontal: 5),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       spreadRadius: 1,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                   image: DecorationImage(
//                     image: AssetImage(item.imageUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.7),
//                       ],
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   alignment: Alignment.bottomLeft,
//                   child: Text(
//                     item.title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 8),
//           Center(
//             child: Obx(() => Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children:
//                       controller.carouselItems.asMap().entries.map((entry) {
//                     return Container(
//                       width: 8,
//                       height: 8,
//                       margin: const EdgeInsets.symmetric(horizontal: 4),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color:
//                             controller.currentCarouselIndex.value == entry.key
//                                 ? AppColor.primary
//                                 : Colors.grey.shade300,
//                       ),
//                     );
//                   }).toList(),
//                 )),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildFeaturedDoctors() {
//     var controller;
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Bác sĩ nổi bật',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 GestureDetector(
//                   onTap: () => controller.viewAllDoctors(),
//                   child: const Text(
//                     'Xem thêm',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 150,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: controller.featuredDoctors.length,
//               itemBuilder: (context, index) {
//                 final doctor = controller.featuredDoctors[index];
//                 return GestureDetector(
//                   onTap: () => controller.viewDoctorDetails(doctor.id),
//                   child: Container(
//                     width: 110,
//                     margin: const EdgeInsets.only(right: 12),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 spreadRadius: 1,
//                                 blurRadius: 3,
//                               ),
//                             ],
//                             image: DecorationImage(
//                               image: AssetImage(doctor.imageUrl),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           doctor.name,
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 13,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           doctor.specialty,
//                           textAlign: TextAlign.center,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildRecommendedHospitals() {
//     var controller;
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Bệnh viện đề xuất',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 GestureDetector(
//                   onTap: () => controller.viewAllHospitals(),
//                   child: const Text('Xem thêm',
//                       style: TextStyle(color: Colors.blue)),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 130,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: controller.recommendedHospitals.length,
//               itemBuilder: (context, index) {
//                 final hospital = controller.recommendedHospitals[index];
//                 return GestureDetector(
//                   onTap: () => controller.viewHospitalDetails(hospital.id),
//                   child: Container(
//                     width: 280,
//                     margin: const EdgeInsets.only(right: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(12),
//                             bottomLeft: Radius.circular(12),
//                           ),
//                           child: Image.asset(
//                             hospital.imageUrl,
//                             width: 80,
//                             height: 130,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 hospital.name,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.location_on,
//                                       size: 14, color: Colors.grey),
//                                   const SizedBox(width: 4),
//                                   Expanded(
//                                     child: Text(
//                                       hospital.address,
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey.shade600,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 8),
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 6, vertical: 2),
//                                     decoration: BoxDecoration(
//                                       color: AppColor.primary.withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: Text(
//                                       '${hospital.rating}★',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: AppColor.primary,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// Widget buildNearestClinics() {
//     var controller;
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Phòng khám đề xuất',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 GestureDetector(
//                   onTap: () => controller.viewAllClinics(),
//                   child: const Text('Xem thêm',
//                       style: TextStyle(color: Colors.blue)),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 130,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: controller.nearestClinics.length,
//               itemBuilder: (context, index) {
//                 final clinic = controller.nearestClinics[index];
//                 return GestureDetector(
//                   onTap: () => controller.viewClinicDetails(clinic.id),
//                   child: Container(
//                     width: 280,
//                     margin: const EdgeInsets.only(right: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(12),
//                             bottomLeft: Radius.circular(12),
//                           ),
//                           child: Image.asset(
//                             clinic.imageUrl,
//                             width: 80,
//                             height: 130,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 clinic.name,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.location_on,
//                                       size: 14, color: Colors.grey),
//                                   const SizedBox(width: 4),
//                                   Expanded(
//                                     child: Text(
//                                       clinic.address,
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey.shade600,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 8),
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 6, vertical: 2),
//                                     decoration: BoxDecoration(
//                                       color: AppColor.primary.withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: Text(
//                                       clinic.isOpen ? 'Mở cửa' : 'Đóng cửa',
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         color: clinic.isOpen
//                                             ? Colors.green
//                                             : Colors.red,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }


//   Widget buildComprehensiveServices() {
//     var controller;
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               'Dịch vụ toàn diện',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(height: 12),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               childAspectRatio: 0.9,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//             ),
//             itemCount: controller.medicalServices.length,
//             itemBuilder: (context, index) {
//               final service = controller.medicalServices[index];
//               return GestureDetector(
//                 onTap: () => controller.selectService(service.id),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         spreadRadius: 1,
//                         blurRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: service.color.withOpacity(0.1),
//                           shape: BoxShape.circle,
//                         ),
//                         child:
//                             Icon(service.icon, color: service.color, size: 28),
//                       ),
//                       const SizedBox(height: 8),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: Text(
//                           service.name,
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }



//   Widget buildHealthArticles() {
//     var controller;
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Sống khỏe mỗi ngày',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 GestureDetector(
//                   onTap: () => controller.viewAllArticles(),
//                   child: const Text('Xem thêm',
//                       style: TextStyle(color: Colors.blue)),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 210,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: controller.healthArticles.length,
//               itemBuilder: (context, index) {
//                 final article = controller.healthArticles[index];
//                 return GestureDetector(
//                   onTap: () => controller.viewArticleDetails(article.id),
//                   child: Container(
//                     width: 250,
//                     margin: const EdgeInsets.only(right: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(16),
//                             topRight: Radius.circular(16),
//                           ),
//                           child: Image.asset(
//                             article.imageUrl,
//                             height: 120,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(12),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 article.title,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 6, vertical: 2),
//                                     decoration: BoxDecoration(
//                                       color: AppColor.primary.withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: Text(
//                                       article.category,
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         color: AppColor.primary,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     article.publishDate,
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }


// Widget buildUpcomingAppointments() {
//   var controller = Get.find<HomeController>();
//   return Container(
//     color: Colors.white,
//     padding: const EdgeInsets.symmetric(vertical: 16),
//     margin: const EdgeInsets.only(bottom: 12),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Lịch hẹn sắp tới',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               GestureDetector(
//                 onTap: () => controller.viewAllAppointments(),
//                 child:
//                     const Text('Tất cả', style: TextStyle(color: Colors.blue)),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
//         Obx(() => controller.hasUpcomingAppointment.value
//             ? ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: controller.upcomingAppointments.length > 2
//                     ? 2
//                     : controller.upcomingAppointments.length,
//                 itemBuilder: (context, index) {
//                   final appointment = controller.upcomingAppointments[index];
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 8),
//                       leading: CircleAvatar(
//                         backgroundImage: AssetImage(appointment.doctorImageUrl),
//                         radius: 24,
//                       ),
//                       title: Text(
//                         appointment.doctorName,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 4),
//                           Text(appointment.specialtyName),
//                           const SizedBox(height: 4),
//                           Row(
//                             children: [
//                               const Icon(Icons.calendar_today,
//                                   size: 14, color: Colors.grey),
//                               const SizedBox(width: 4),
//                               Text(
//                                 appointment.dateTime,
//                                 style: TextStyle(color: Colors.grey.shade600),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       trailing: ElevatedButton(
//                         onPressed: () =>
//                             controller.viewAppointmentDetails(appointment.id),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColor.primary,
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           minimumSize: const Size(60, 36),
//                         ),
//                         child: const Text(
//                           'Chi tiết',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   'Bạn không có lịch hẹn sắp tới',
//                   style: TextStyle(color: Colors.grey.shade600),
//                 ),
//               )),
//       ],
//     ),
//   );
// }