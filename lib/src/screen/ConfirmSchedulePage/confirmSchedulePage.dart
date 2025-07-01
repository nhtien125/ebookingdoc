import 'package:ebookingdoc/src/data/model/appointment_model.dart';
import 'package:ebookingdoc/src/widgets/controller/confirmSchedulepagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Helper: Định dạng ngày giờ
String formatDateTime(String? dateTime) {
  if (dateTime == null || dateTime.isEmpty) return '';
  try {
    final dt = DateTime.parse(dateTime);
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} "
        "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  } catch (_) {
    return dateTime;
  }
}

class ConfirmSchedulePage extends StatefulWidget {
  const ConfirmSchedulePage({super.key});

  @override
  State<ConfirmSchedulePage> createState() => _ConfirmSchedulePageState();
}

class _ConfirmSchedulePageState extends State<ConfirmSchedulePage>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(ConfirmScheduleController());
  late TabController tabController;

  final List<Map<String, dynamic>> tabs = [
    {'title': 'Chờ xác nhận', 'status': AppointmentStatus.pending},
    {'title': 'Đã xác nhận', 'status': AppointmentStatus.confirmed},
    {'title': 'Từ chối', 'status': AppointmentStatus.rejected},
    {'title': 'Đã hủy', 'status': AppointmentStatus.cancelled},
    {'title': 'Đã khám', 'status': AppointmentStatus.done},
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  List<Appointment> getTabAppointments(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return controller.pendingAppointments;
      case AppointmentStatus.confirmed:
        return controller.confirmedAppointments;
      case AppointmentStatus.rejected:
        return controller.rejectedAppointments;
      case AppointmentStatus.cancelled:
        return controller.cancelledAppointments;
      case AppointmentStatus.done:
        return controller.doneAppointments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quản lý lịch khám",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
        ),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        elevation: 2,
        bottom: TabBar(
          controller: tabController,
          tabs: tabs
              .map((tab) => Tab(
                    text: tab['title'],
                  ))
              .toList(),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorWeight: 3,
        ),
      ),
      backgroundColor: const Color(0xFFF6F8FA),
      body: Obx(
        () => TabBarView(
          controller: tabController,
          children: tabs.map((tab) {
            final status = tab['status'] as AppointmentStatus;
            final filteredList = getTabAppointments(status);
            if (filteredList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy,
                        size: 44, color: Colors.blue.shade200),
                    const SizedBox(height: 18),
                    const Text(
                      "Không có lịch hẹn nào.",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(18),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: filteredList.length,
              itemBuilder: (_, idx) {
                final appt = filteredList[idx];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                  elevation: 6,
                  shadowColor: Colors.blue.withOpacity(0.15),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.blue.withOpacity(0.13),
                              child: Icon(
                                Icons.local_hospital,
                                color: Colors.blue,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          controller.getPatientNameById(
                                                  appt.patientId) ??
                                              '(Chưa có tên)',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                            color: Color(0xFF1A237E),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: controller
                                              .statusColor(appt.status.value)
                                              .withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(13),
                                        ),
                                        child: Text(
                                          controller.statusText(appt.status.value),
                                          style: TextStyle(
                                            color: controller
                                                .statusColor(appt.status.value),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.info_outline,
                                          size: 16, color: Colors.redAccent),
                                      const SizedBox(width: 3),
                                      Expanded(
                                        child: Text(
                                          "Tình trạng sức khỏe: " +
                                              ((appt.healthStatus == null ||
                                                      appt.healthStatus!
                                                          .trim()
                                                          .isEmpty)
                                                  ? "Không có"
                                                  : appt.healthStatus!),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Đặt khám: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        TextSpan(
                                          text: formatDateTime(appt.dateTime),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (appt.status.value == AppointmentStatus.pending)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(0, 38),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text("Xác nhận",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  onPressed: () =>
                                      controller.confirmAppointment(appt),
                                ),
                                const SizedBox(width: 10),
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red.shade600,
                                    side:
                                        BorderSide(color: Colors.red.shade400),
                                    minimumSize: const Size(0, 38),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.close, size: 18),
                                  label: const Text("Từ chối",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  onPressed: () =>
                                      controller.rejectAppointment(appt),
                                ),
                              ],
                            ),
                          ),
                        if (appt.status.value == AppointmentStatus.confirmed)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(0, 38),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.done_all, size: 18),
                                  label: const Text("Đã khám",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  onPressed: () => controller.markAsDone(appt),
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
          }).toList(),
        ),
      ),
    );
  }
}