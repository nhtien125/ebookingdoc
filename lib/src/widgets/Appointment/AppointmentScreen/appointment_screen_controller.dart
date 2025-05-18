/// Initialize data for the appointment booking process. This includes

/// loading hospitals, doctors, and patients from the database. The

/// selected patient is set to the first patient in the list.
import 'package:ebookingdoc/src/data/model/AppointmentScreen_model.dart';
import 'package:get/get.dart';

class AppointmentScreenController extends GetxController {
  // Current step (1-4)
  final currentStep = 1.obs;

  // Step 1: Hospital and doctor selection
  final hospitals = <Hospital>[].obs;
  final selectedHospital = Rxn<Hospital>();
  final doctors = <Doctor>[].obs;
  final selectedDoctor = Rxn<Doctor>();
  final selectedDepartment = Rxn<Department>();
  final selectedService = Rxn<MedicalService>();
  final selectedDate = Rxn<DateTime>();
  final selectedTimeSlot = Rxn<String>();

  // Step 2: Patient profile data
  final patients = <Patient>[].obs;
  final selectedPatient = Rxn<Patient>();

  // Step 3: Confirmation data
  final appointmentConfirmed = false.obs;

  // Step 4: Payment data
  final paymentCompleted = false.obs;

  // Available time slots
  final timeSlots = [
    '08:00 - 09:00',
    '09:00 - 10:00',
    '10:00 - 11:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    // Initialize hospitals
    hospitals.addAll([
      Hospital(
        id: '1',
        name: 'Bệnh viện Da Liễu TP.HCM',
        address: '2 Nguyễn Thông, Phường Võ Thị Sáu, Quận 3, TP.HCM',
      ),
      Hospital(
        id: '2',
        name: 'BV Đại học Y Dược TP HCM',
        address: '215 Hồng Bàng, Phường 11, Quận 5, TP.HCM',
      ),
    ]);

    // ✅ Gán mặc định bệnh viện đầu tiên
    selectedHospital.value = hospitals.first;

    // Initialize doctors
    doctors.addAll([
      Doctor(
        id: '1',
        name: 'Trần Văn Nam',
        address: 'BV Đại học Y Dược TP HCM',
        hospitalId: '2',
        phone: '0987654321',
        rating: 4.8,
        departments: [
          Department(
            id: '1',
            name: 'Khoa Nội tổng quát',
            services: [
              MedicalService(id: '1', name: 'Khám tổng quát', price: 150000),
              MedicalService(id: '2', name: 'Khám theo yêu cầu', price: 300000),
            ],
          ),
        ],
      ),
      Doctor(
        id: '2',
        name: 'Nguyễn Thị Hà',
        address: 'Bệnh viện Da Liễu TP.HCM',
        hospitalId: '1',
        phone: '0912345678',
        rating: 4.7,
        departments: [
          Department(
            id: '2',
            name: 'Khoa Nhi',
            services: [
              MedicalService(
                  id: '3', name: 'Khám nhi tổng quát', price: 180000),
              MedicalService(id: '4', name: 'Tư vấn dinh dưỡng', price: 200000),
            ],
          ),
        ],
      ),
    ]);

    // Initialize patients
    patients.addAll([
      Patient(
        id: '1',
        name: 'LÔ THỊ NỘ',
        dob: '01/01/1990',
        gender: 'Nữ',
        phone: '0987654321',
        relationship: 'Bản thân',
        address: 'TP HCM',
      ),
      Patient(
        id: '2',
        name: 'NGUYỄN VĂN A',
        dob: '15/05/1985',
        gender: 'Nam',
        phone: '0912345678',
        relationship: 'Bản thân',
        address: 'TP HCM',
      )
    ]);

    // Set default selected patient
    selectedPatient.value =
        patients.firstWhereOrNull((p) => p.name == 'LÔ THỊ NỘ');
  }

  // Get doctors by hospital
  List<Doctor> getDoctorsByHospital(String? hospitalId) {
    if (hospitalId == null) return [];
    return doctors.where((doctor) => doctor.hospitalId == hospitalId).toList();
  }

  // Get available departments for selected doctor
  List<Department> get availableDepartments =>
      selectedDoctor.value?.departments ?? [];

  // Get available services for selected department
  List<MedicalService> get availableServices =>
      selectedDepartment.value?.services ?? [];

  // Navigation methods
  void nextStep() {
    if (currentStep.value < 4) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 1) currentStep.value--;
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 4) currentStep.value = step;
  }

  // Step 1 methods
  void selectHospital(Hospital hospital) {
    selectedHospital.value = hospital;

    // ✅ Reset các mục liên quan khi thay đổi bệnh viện
    selectedDoctor.value = null;
    selectedDepartment.value = null;
    selectedService.value = null;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
  }

  void selectDoctor(Doctor doctor) {
    selectedDoctor.value = doctor;
    selectedDepartment.value = null;
    selectedService.value = null;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
  }

  void selectDepartment(Department department) {
    selectedDepartment.value = department;
    selectedService.value = null;
    selectedTimeSlot.value = null;
  }

  void selectService(MedicalService service) {
    selectedService.value = service;
    selectedTimeSlot.value = null;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    selectedTimeSlot.value = null;
  }

  void selectTimeSlot(String time) {
    selectedTimeSlot.value = time;
  }

  // Step 2 methods
  void selectPatient(Patient patient) {
    selectedPatient.value = patient;
  }

  void addPatient(Patient patient) {
    patients.add(patient);
    selectedPatient.value = patient;
  }

  void deletePatient(Patient patient) {
    if (patients.length > 1) {
      patients.remove(patient);
      if (selectedPatient.value == patient) {
        selectedPatient.value = patients.first;
      }
    }
  }

  // Step 3 methods
  void confirmAppointment() {
    appointmentConfirmed.value = true;
    nextStep();
  }

  // Step 4 methods
  void completePayment() {
    paymentCompleted.value = true;
  }

  // Validation methods
  bool isStep1Complete() {
    return selectedHospital.value != null &&
        selectedDoctor.value != null &&
        selectedDepartment.value != null &&
        selectedService.value != null &&
        selectedDate.value != null &&
        selectedTimeSlot.value != null;
  }

  bool isStep2Complete() {
    return selectedPatient.value != null;
  }
}

