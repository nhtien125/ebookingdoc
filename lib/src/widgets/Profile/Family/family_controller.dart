import 'package:ebookingdoc/src/constants/services/patient_service.dart';
import 'package:ebookingdoc/src/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ebookingdoc/src/data/model/patient_model.dart';

class FamilyController extends GetxController {
  var familyMembers = <Patient>[].obs;
  final _patientService = PatientService();

  @override
  void onInit() {
    super.onInit();
    loadFamilyMembers();
  }

  Future<void> loadFamilyMembers() async {
    final userId = await getUserIdFromPrefs();
    if (userId != null) {
      final list = await _patientService.getPatientsByUserId(userId);
      familyMembers.value = list;
    }
  }

  Future<void> addMember(BuildContext context) async {
    await loadFamilyMembers();
  }

  void confirmDeleteMember(BuildContext context, int index) async {
    final member = familyMembers[index];
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa thành viên "${member.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Không')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Có')),
        ],
      ),
    );
    if (confirm == true) {
      await _patientService.deletePatient(member.uuid);
      await loadFamilyMembers();
    }
  }
}
