import 'dart:io';
import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileController extends GetxController {
  Rx<File> image = File("").obs;
  RxString avatarUrl = ''.obs;
  RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    print('user_data: $userJson'); // Thêm dòng này để debug
    if (userJson != null) {
      final user = User.fromJson(jsonDecode(userJson));
      avatarUrl.value = user.image ?? '';
      userName.value = user.name ?? 'Người dùng';
    }
  }

  personal() {
    Get.toNamed(Routes.personal);
  }

  family() {
    Get.toNamed(Routes.family);
  }

  appointmentHistory() {
    Get.toNamed(Routes.appointment);
  }

  PatientListPage() {
    Get.toNamed(Routes.patientlist);
  }

  doctorinformation() {
    Get.toNamed(Routes.doctorinformation);
  }

  medicalRecord() {
    Get.toNamed(Routes.medicalRecord);
  }

  logout() {
    Get.toNamed(Routes.login);
  }

  paymentHistory() {
    Get.toNamed(Routes.paymentHistory);
  }
}
