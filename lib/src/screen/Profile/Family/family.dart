import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/widgets/Profile/Family/family_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Family extends StatefulWidget {
  Family({super.key});
  @override
  _FamilyState createState() => _FamilyState();
}

class _FamilyState extends State<Family> {
  final FamilyController controller = Get.put(FamilyController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.loadFamilyMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thành viên gia đình',
          style: TextStyle(color: AppColor.main, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColor.fourthMain,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.familyMembers.length,
                      itemBuilder: (context, index) {
                        final member = controller.familyMembers[index];
                        return Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              backgroundColor: AppColor.primaryDark,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              member.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.relationship,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Ngày sinh: ${member.dob}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.confirmDeleteMember(context, index),
                            ),
                          ),
                        );
                      },
                    ),
                    if (controller.isLoading.value)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primaryDark,
                          ),
                        ),
                      ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.addMember(context),
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Thêm thành viên',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
