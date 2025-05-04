import 'dart:io';

import 'package:ebookingdoc/Route/app_page.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Rx<File> image = File("").obs;

  personal() {
    Get.toNamed(Routes.personal);
  }

  family() {
    Get.toNamed(Routes.family);
  }

  appointmentHistory() {
    Get.toNamed(Routes.appointmentHistory);
  }

   medicalRecord() {
    Get.toNamed(Routes.medicalRecord);
  }

  logout(){
    Get.offAllNamed(Routes.login);
  }
}
