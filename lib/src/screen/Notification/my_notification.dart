import 'package:ebookingdoc/src/widgets/controller/my_notification_controller_doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/Global/app_color.dart';

class MyNotificationDoctor extends StatelessWidget {
  MyNotificationDoctor({super.key});

  final controller = Get.put(MyNotificationControllerDoctor());

  void showMarkAllReadBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Xác nhận đánh dấu tất cả đã đọc?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.main),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Hủy"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.fourthMain),
                    onPressed: () {
                      controller.markAllAsRead();
                      Navigator.pop(context);
                    },
                    child: Text("Xác nhận",
                        style: TextStyle(color: AppColor.main)),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Color _typeColor(String? type) {
    switch (type) {
      case 'booked':
        return Colors.orange;
      case 'success':
        return Colors.green;
      case 'reject':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _typeIcon(String? type) {
    switch (type) {
      case 'booked':
        return Icons.schedule;
      case 'success':
        return Icons.check_circle_outline;
      case 'reject':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColor.fourthMain,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 4,
          backgroundColor: AppColor.fourthMain,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            'Thông báo',
            style: TextStyle(
              color: AppColor.main,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              tooltip: 'Đánh dấu tất cả đã đọc',
              icon: Icon(Icons.done_all, color: AppColor.main),
              onPressed: () {
                showMarkAllReadBottomSheet(context);
              },
            ),
          ],
        ),
        body: Obx(() {
          return controller.notifications.isEmpty
              ? const Center(
                  child: Text(
                    'Không có thông báo nào',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final item = controller.notifications[index];
                    final color = _typeColor(item['type'] as String?);
                    final icon = _typeIcon(item['type'] as String?);
                    return Dismissible(
                      key: Key((item['title'] ?? '') as String),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        controller.deleteNotification(index);
                      },
                      background: Container(
                        padding: const EdgeInsets.only(right: 20),
                        alignment: Alignment.centerRight,
                        color: Colors.red.shade400,
                        child: const Icon(Icons.delete,
                            color: Colors.white, size: 24),
                      ),
                      child: GestureDetector(
                        onTap: () => controller.markAsRead(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: item['isRead'] != null
                                ? Colors.white
                                : color.withOpacity(0.13),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: color.withOpacity(0.22),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: color.withOpacity(0.13),
                                child: Icon(icon, color: color),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (item['title'] ?? '') as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: color,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Dùng Text.rich để nổi bật giờ hẹn
                                    if (item['hour'] != null &&
                                        item['patient'] != null)
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                                text:
                                                    "Bạn có cuộc hẹn với bệnh nhân "),
                                            TextSpan(
                                              text: item['patient'] as String,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const TextSpan(text: " vào lúc "),
                                            TextSpan(
                                              text: item['hour']?.toString(),
                                              style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const TextSpan(text: "."),
                                          ],
                                        ),
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    else
                                      Text(
                                        (item['description'] ?? '') as String,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    Text(
                                      (item['time'] ?? '') as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        }),
      ),
    );
  }
}
