import 'package:ebookingdoc/src/constants/services/patient_service.dart';
import 'package:ebookingdoc/src/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ebookingdoc/src/data/model/patient_model.dart';
import 'package:intl/intl.dart';

class FamilyController extends GetxController {
  var familyMembers = <Patient>[].obs;
  var isLoading = false.obs;
  final _patientService = PatientService();

  @override
  void onInit() {
    super.onInit();
    loadFamilyMembers();
  }

  Future<void> loadFamilyMembers() async {
    isLoading.value = true;
    try {
      final userId = await getUserIdFromPrefs();
      if (userId != null) {
        final list = await _patientService.getPatientsByUserId(userId);
        familyMembers.value = list.map((patient) {
          if (patient.dob != null && patient.dob.isNotEmpty) {
            final date = DateTime.parse(patient.dob);
            final formattedDob = DateFormat('dd/MM/yyyy').format(date);
            return Patient(
              uuid: patient.uuid,
              userId: patient.userId,
              name: patient.name,
              dob: formattedDob,
              gender: patient.gender,
              phone: patient.phone,
              relationship: patient.relationship,
              insuranceNumber: patient.insuranceNumber,
              address: patient.address,
              image: patient.image,
              createdAt: patient.createdAt,
              updatedAt: patient.updatedAt,
            );
          }
          return patient;
        }).toList();
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách thành viên: $e');
    } finally {
      isLoading.value = false;
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