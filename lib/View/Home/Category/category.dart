import 'package:ebookingdoc/Global/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Category extends StatelessWidget {
  Category({super.key});

  final controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        backgroundColor: AppColor.subMain,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Column(
          children: [
            _buildTopTabs(),
            Expanded(child: _buildTopTabContent()),
          ],
        ),
      ),
    );
  }

  
  Widget _buildTopTabs() {
    
    final tabs = ['Tất cả', 'Tại nhà', 'Tại viện', 'Chuyên khoa'];

    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = controller.topTabIndex.value == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => controller.topTabIndex.value = index,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.main : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.main),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColor.main,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ));
  }

  Widget _buildTopTabContent() {
    return Obx(() {
      switch (controller.topTabIndex.value) {
        case 0:
          return Center(child: Text('Nội dung Tất cả'));
        case 1:
          return Center(child: Text('Nội dung Tại nhà'));
        case 2:
          return Center(child: Text('Nội dung Tại viện'));
        case 3:
          return Center(child: Text('Nội dung Chuyên khoa'));
        default:
          return Container();
      }
    });
  }
}

class CategoryController extends GetxController {
  var currentIndex = 0.obs;
  var topTabIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
