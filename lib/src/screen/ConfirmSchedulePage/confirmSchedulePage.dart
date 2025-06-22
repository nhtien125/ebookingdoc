import 'package:ebookingdoc/src/widgets/controller/confirmSchedulepagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmSchedulePage extends StatelessWidget {
  ConfirmSchedulePage({super.key});
  
  final controller = Get.put(ConfirmScheduleController());

  Color statusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.rejected:
        return Colors.redAccent;
    }
  }

  String statusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return "Chờ xác nhận";
      case AppointmentStatus.confirmed:
        return "Đã xác nhận";
      case AppointmentStatus.rejected:
        return "Đã từ chối";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác nhận lịch khám", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFFF6F8FA),
      body: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.all(18),
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemCount: controller.appointments.length,
          itemBuilder: (_, idx) {
            final appt = controller.appointments[idx];
            return Obx(() => Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: statusColor(appt.status.value).withOpacity(0.17),
                          child: Icon(Icons.person, color: statusColor(appt.status.value), size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appt.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              Text("Triệu chứng: ${appt.symptom}",
                                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor(appt.status.value).withOpacity(0.16),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            statusText(appt.status.value),
                            style: TextStyle(
                                color: statusColor(appt.status.value), fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.grey.shade700, size: 19),
                        const SizedBox(width: 7),
                        Text("${appt.time} - ${appt.date}", style: const TextStyle(fontSize: 14)),
                        const Spacer(),
                        if (appt.status.value == AppointmentStatus.pending)
                          Row(
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    minimumSize: const Size(0, 38),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                                icon: const Icon(Icons.check, size: 18, color: Colors.white),
                                label: const Text("Xác nhận", style: TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () => controller.confirmAppointment(appt),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red.shade600,
                                  minimumSize: const Size(0, 38),
                                  side: BorderSide(color: Colors.red.shade400),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                                ),
                                icon: const Icon(Icons.close, size: 18),
                                label: const Text("Từ chối", style: TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () => controller.rejectAppointment(appt),
                              ),
                            ],
                          )
                        else
                          const SizedBox(height: 0),
                      ],
                    ),
                  ],
                ),
              ),
            ));
          },
        ),
      ),
    );
  }
}
