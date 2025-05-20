import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/controller/family_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Family extends StatelessWidget {
  Family({super.key});

  final controller = Get.put(FamilyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thành viên gia đình',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.familyMembers.length,
                  itemBuilder: (context, index) {
                    final member = controller.familyMembers[index];
                    return Stack(
                      children: [
                        Card(
                          color: Colors.blue.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(member),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () =>
                                controller.confirmDeleteMember(context, index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.addMember,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Thêm thành viên',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 18, // Tăng kích thước chữ
                    fontWeight: FontWeight.bold, // Làm đậm chữ
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
