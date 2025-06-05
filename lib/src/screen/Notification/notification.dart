import 'package:ebookingdoc/src/widgets/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/Global/app_color.dart';

class MyNotification extends StatelessWidget {
  MyNotification({super.key});

  final controller = Get.put(MyNotificationController());

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
          automaticallyImplyLeading: true, // Cho phép hiển thị nút quay lại
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
            icon: const Icon(Icons.arrow_back,
                color: Colors.white), // Mũi tên màu trắng
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
                    return Dismissible(
                      key: Key(item['title'] ?? ''),
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: item['isRead']
                              ? Colors.white
                              : Colors.blue.shade200,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['description'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['time'] ?? '',
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
                    );
                  },
                );
        }),
      ),
    );
  }
}
