import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/Home/Excellent_doctor/excellent_doctor_controller.dart';

class ExcellentDoctor extends StatelessWidget {
  final controller = Get.put(ExcellentDoctorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bác sĩ nổi bật"),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.doctorList.length,
          itemBuilder: (context, index) {
            final doctor = controller.doctorList[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        doctor.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(doctor.specialty, style: TextStyle(color: Colors.grey[700])),
                          Text(doctor.hospital),
                          Text(doctor.experience),
                          SizedBox(height: 6),
                          ElevatedButton(
                            onPressed: () {
                              Get.snackbar('Đặt lịch hẹn', 'Bạn đã chọn bác sĩ ${doctor.name}');
                            },
                            child: Text("Đặt lịch hẹn"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
