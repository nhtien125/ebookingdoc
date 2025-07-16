import 'package:ebookingdoc/src/Global/app_color.dart';
// import 'package:ebookingdoc/Service/api_caller.dart';
import 'package:ebookingdoc/src/Utils/custom_dialog.dart';
import 'package:ebookingdoc/src/Utils/utils.dart';
import 'package:ebookingdoc/src/widgets/Profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileDoctor extends StatelessWidget {
  ProfileDoctor({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.subMain,
      appBar: AppBar(
        backgroundColor: AppColor.fourthMain,
        title: const SafeArea(
          child: Center(
            child: Text(
              'EbookingDoc',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // User profile section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, bottom: 30),
            color: AppColor.fivethMain,
            child: Column(
              children: [
                // User avatar
                GestureDetector(
                  onTap: () {
                    // Đây là mẫu sau sửa lại thành chọn ảnh
                    // APICaller.getInstance().post("v1/permission/create-permission",
                    //     body: {"uuid": 4, "name": "Sẽ bị xoá sau"}).then((value) {
                    //   print(value);
                    // });
                    Utils.getImagePicker(2).then((value) {
                      if (value != null) {
                        controller.image.value = value!;
                      }
                    });
                  },
                  child: Obx(() {
                    // Avatar
                    Widget avatarWidget;
                    if (controller.image.value.path.isNotEmpty) {
                      avatarWidget = Image.file(
                        controller.image.value,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person_outline,
                          size: 50,
                          color: AppColor.fourthMain,
                        ),
                      );
                    } else if (controller.avatarUrl.value.isNotEmpty) {
                      avatarWidget = Image.network(
                        controller.avatarUrl.value,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person_outline,
                          size: 50,
                          color: AppColor.fourthMain,
                        ),
                      );
                    } else {
                      avatarWidget = Icon(
                        Icons.person_outline,
                        size: 50,
                        color: AppColor.fourthMain,
                      );
                    }

                    return Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.fivethMain,
                            border: Border.all(
                                color: AppColor.fourthMain, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: avatarWidget,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Tên user
                        Text(
                          controller.userName.value.isNotEmpty
                              ? controller.userName.value
                              : 'Người dùng',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),

          // Remaining content section with background color
          Expanded(
            child: Container(
              color: AppColor.fivethMain,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Thông tin cá nhân',
                    onTap: () => controller.personal(),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Hồ sơ bác sĩ',
                    onTap: () => controller.doctorinformation(),
                  ),
                  const SizedBox(height: 16),
                 
                  const SizedBox(height: 16),
                  buildMenuItem(
                      icon: Icons.logout_outlined,
                      title: 'Đăng xuất',
                      onTap: () {
                        CustomDialog.showCustomDialog(
                          context: context,
                          title: 'Đăng xuất',
                          content: 'Bạn có chắc muốn đăng xuất không?',
                          onPressed: () => controller.logout(),
                        );
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Menu item widget builder
  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: AppColor.fourthMain,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
