import 'package:ebookingdoc/src/constants/services/Doctorservice.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/specialization_model.dart';
import 'package:ebookingdoc/src/constants/services/hospitalService.dart';
import 'package:ebookingdoc/src/constants/services/clinic_service.dart';
import 'package:ebookingdoc/src/constants/services/specialization_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorRegistrationScreen extends StatefulWidget {
  const DoctorRegistrationScreen({Key? key}) : super(key: key);

  @override
  _DoctorRegistrationScreenState createState() => _DoctorRegistrationScreenState();
}

class _DoctorRegistrationScreenState extends State<DoctorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _licenseController = TextEditingController();
  final _introduceController = TextEditingController();
  final _experienceController = TextEditingController();
  final _patientCountController = TextEditingController();

  // Services
  final HospitalService _hospitalService = HospitalService();
  final ClinicService _clinicService = ClinicService();
  final SpecializationService _specializationService = SpecializationService();
  final DoctorService _doctorService = DoctorService();

  // Selected values
  String? _selectedHospitalId;
  String? _selectedClinicId;
  String? _selectedSpecializationId;
  bool _isHospitalSelected = false; // Track if hospital is selected
  bool _isClinicSelected = false;  // Track if clinic is selected

  // Data lists
  List<Hospital> _hospitals = [];
  List<Clinic> _clinics = [];
  List<Specialization> _specializations = [];

  // Loading states
  bool _isLoadingHospitals = true;
  bool _isLoadingClinics = true;
  bool _isLoadingSpecializations = true;
  bool _isSubmitting = false;

  String? _errorMessage;
  
  // User data from previous screen
  String? _uuid;

  @override
  void initState() {
    super.initState();
    _getUserDataFromArguments();
    _loadData();
  }

  void _getUserDataFromArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      _uuid = arguments['uuid'] as String?;
      
      print('Received uuid: $_uuid');
    } else {
      Get.snackbar(
        'Lỗi', 
        'Không tìm thấy thông tin user',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    }
  }

  @override
  void dispose() {
    _licenseController.dispose();
    _introduceController.dispose();
    _experienceController.dispose();
    _patientCountController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadHospitals(),
      _loadClinics(),
      _loadSpecializations(),
    ]);
  }

  Future<void> _loadHospitals() async {
    try {
      setState(() => _isLoadingHospitals = true);
      final hospitals = await _hospitalService.getAllHospital();
      setState(() {
        _hospitals = hospitals;
        _isLoadingHospitals = false;
      });
    } catch (e) {
      setState(() => _isLoadingHospitals = false);
      print('Error loading hospitals: $e');
    }
  }

  Future<void> _loadClinics() async {
    try {
      setState(() => _isLoadingClinics = true);
      final clinics = await _clinicService.getAllClinic();
      setState(() {
        _clinics = clinics;
        _isLoadingClinics = false;
      });
    } catch (e) {
      setState(() => _isLoadingClinics = false);
      print('Error loading clinics: $e');
    }
  }

  Future<void> _loadSpecializations() async {
    try {
      setState(() => _isLoadingSpecializations = true);
      final specializations = await _specializationService.getAllSpecialization();
      setState(() {
        _specializations = specializations;
        _isLoadingSpecializations = false;
      });
    } catch (e) {
      setState(() => _isLoadingSpecializations = false);
      print('Error loading specializations: $e');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_uuid == null) {
      Get.snackbar(
        'Lỗi', 
        'Không tìm thấy thông tin user',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final doctorData = {
        'user_id': _uuid!,
        'hospital_id': _selectedHospitalId,
        'clinic_id': _selectedClinicId,
        'doctor_type': null,
        'specialization_id': _selectedSpecializationId!,
        'license': _licenseController.text.trim(),
        'introduce': _introduceController.text.trim().isEmpty ? null : _introduceController.text.trim(),
        'experience': _experienceController.text.trim().isEmpty ? 0 : int.tryParse(_experienceController.text.trim()) ?? 0,
        'patient_count': _patientCountController.text.trim().isEmpty ? 0 : int.tryParse(_patientCountController.text.trim()) ?? 0,
      };

      doctorData.removeWhere((key, value) => value == null);

      print('Submitting doctor data: $doctorData');

      final success = await _doctorService.registerDoctor(doctorData);

      if (success) {
        setState(() => _errorMessage = 'Đăng ký bác sĩ thành công!');
        
        Get.snackbar(
          'Thành công', 
          'Đăng ký thông tin bác sĩ thành công! Vui lòng đăng nhập.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed('/login');
      } else {
        setState(() => _errorMessage = 'Đăng ký bác sĩ thất bại. Vui lòng thử lại!');
        
        Get.snackbar(
          'Lỗi', 
          'Đăng ký thất bại. Vui lòng kiểm tra lại thông tin và thử lại.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Đã xảy ra lỗi: ${e.toString()}');
      
      Get.snackbar(
        'Lỗi', 
        'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      print('Error submitting doctor registration: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Ký Bác Sĩ'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Hospital Dropdown
              if (!_isClinicSelected)
                DropdownButtonFormField<String>(
                  value: _isHospitalSelected && !_isLoadingHospitals && !_hospitals.any((h) => h.uuid == _selectedHospitalId) ? null : _selectedHospitalId,
                  decoration: const InputDecoration(
                    labelText: 'Bệnh viện (Tùy chọn)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_hospital),
                  ),
                  items: _isLoadingHospitals
                      ? [const DropdownMenuItem(value: null, child: Text('Đang tải...'))]
                      : [
                          const DropdownMenuItem(value: null, child: Text('Không chọn bệnh viện')),
                          ..._hospitals.map((hospital) => DropdownMenuItem(
                                value: hospital.uuid,
                                child: Text(hospital.name ?? 'Không có tên'),
                              )),
                        ],
                  onChanged: _isLoadingHospitals || _isSubmitting
                      ? null
                      : (value) {
                          setState(() {
                            _selectedHospitalId = value;
                            _isHospitalSelected = value != null;
                            if (_isHospitalSelected) {
                              _selectedClinicId = null;
                              _isClinicSelected = false;
                            }
                          });
                        },
                ),
              if (!_isClinicSelected) const SizedBox(height: 16),

              // Clinic Dropdown
              if (!_isHospitalSelected)
                DropdownButtonFormField<String>(
                  value: _isClinicSelected && !_isLoadingClinics && !_clinics.any((c) => c.uuid == _selectedClinicId) ? null : _selectedClinicId,
                  decoration: const InputDecoration(
                    labelText: 'Phòng khám (Tùy chọn)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  items: _isLoadingClinics
                      ? [const DropdownMenuItem(value: null, child: Text('Đang tải...'))]
                      : [
                          const DropdownMenuItem(value: null, child: Text('Không chọn phòng khám')),
                          ..._clinics.map((clinic) => DropdownMenuItem(
                                value: clinic.uuid,
                                child: Text(clinic.name ?? 'Không có tên'),
                              )),
                        ],
                  onChanged: _isLoadingClinics || _isSubmitting
                      ? null
                      : (value) {
                          setState(() {
                            _selectedClinicId = value;
                            _isClinicSelected = value != null;
                            if (_isClinicSelected) {
                              _selectedHospitalId = null;
                              _isHospitalSelected = false;
                            }
                          });
                        },
                ),
              const SizedBox(height: 16),

              // Specialization Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSpecializationId,
                decoration: const InputDecoration(
                  labelText: 'Chuyên khoa *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_services),
                ),
                items: _isLoadingSpecializations
                    ? [const DropdownMenuItem(value: null, child: Text('Đang tải...'))]
                    : _specializations.map((specialization) => DropdownMenuItem(
                          value: specialization.uuid,
                          child: Text(specialization.name ?? 'Không có tên'),
                        )).toList(),
                onChanged: _isLoadingSpecializations || _isSubmitting
                    ? null
                    : (value) => setState(() => _selectedSpecializationId = value),
                validator: (value) => value == null ? 'Vui lòng chọn chuyên khoa' : null,
              ),
              const SizedBox(height: 16),

              // License Field
              TextFormField(
                controller: _licenseController,
                enabled: !_isSubmitting,
                decoration: const InputDecoration(
                  labelText: 'Số Giấy Phép *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.assignment),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng nhập số giấy phép' : null,
              ),
              const SizedBox(height: 16),

              // Introduction Field
              TextFormField(
                controller: _introduceController,
                enabled: !_isSubmitting,
                decoration: const InputDecoration(
                  labelText: 'Giới Thiệu (Tùy chọn)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Experience Field
              TextFormField(
                controller: _experienceController,
                enabled: !_isSubmitting,
                decoration: const InputDecoration(
                  labelText: 'Kinh Nghiệm (Năm)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final num = int.tryParse(value.trim());
                  return num == null || num < 0 ? 'Vui lòng nhập số nguyên không âm' : null;
                },
              ),
              const SizedBox(height: 16),

              // Patient Count Field
              TextFormField(
                controller: _patientCountController,
                enabled: !_isSubmitting,
                decoration: const InputDecoration(
                  labelText: 'Số Bệnh Nhân',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final num = int.tryParse(value.trim());
                  return num == null || num < 0 ? 'Vui lòng nhập số nguyên không âm' : null;
                },
              ),
              const SizedBox(height: 24),

              // Error/Success Message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _errorMessage!.contains('thành công') 
                        ? Colors.green.shade50 
                        : Colors.red.shade50,
                    border: Border.all(
                      color: _errorMessage!.contains('thành công') 
                          ? Colors.green.shade200 
                          : Colors.red.shade200,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: _errorMessage!.contains('thành công') 
                          ? Colors.green.shade700 
                          : Colors.red.shade700,
                    ),
                  ),
                ),

              // Submit Button
              ElevatedButton(
                onPressed: (_isLoadingHospitals || _isLoadingClinics || _isLoadingSpecializations || _isSubmitting)
                    ? null
                    : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Đang xử lý...'),
                        ],
                      )
                    : (_isLoadingHospitals || _isLoadingClinics || _isLoadingSpecializations)
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Đang tải dữ liệu...'),
                            ],
                          )
                        : const Text(
                            'Đăng Ký',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}