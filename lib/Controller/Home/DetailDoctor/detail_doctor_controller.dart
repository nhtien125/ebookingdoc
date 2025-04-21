import 'package:get/get.dart';

class DetailDoctorController extends GetxController {
  String id = '';

  @override
  void onInit() {
    super.onInit();
    print(Get.arguments);
    id = Get.arguments;
  }
}