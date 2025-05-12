
import 'package:ebookingdoc/Models/AppointmentScreen_model.dart';
import 'package:get/get.dart';

class AppointmentScreenController extends GetxController {
  // Current step (1-4)
  final currentStep = 1.obs;

  // Step 1: Hospital selection data
  final hospitals = <Hospital>[].obs;
  final selectedHospital = Rxn<Hospital>();
  final selectedDepartment = Rxn<Department>();
  final selectedService = Rxn<MedicalService>();
  final selectedRoom = Rxn<ClinicRoom>();
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
    // Initialize sample hospitals data
    hospitals.addAll([
      Hospital(
        id: '1',
        name: 'Bệnh viện Đa khoa Tỉnh Gia Lai',
        address: '123 Đường Lê Lợi, Pleiku, Gia Lai',
        phone: '02693 123 456',
        rating: 4.5,
        departments: [
          Department(
            id: '1',
            name: 'Khoa Nội tổng quát',
            services: [
              MedicalService(id: '1', name: 'Khám tổng quát', price: 150000),
              MedicalService(id: '2', name: 'Khám theo yêu cầu', price: 300000),
            ],
            rooms: [
              ClinicRoom(id: '1', name: 'Phòng 101', floor: 'Tầng 1'),
              ClinicRoom(id: '2', name: 'Phòng 102', floor: 'Tầng 1'),
            ],
          ),
          Department(
            id: '2',
            name: 'Khoa Nhi',
            services: [
              MedicalService(id: '3', name: 'Khám nhi tổng quát', price: 180000),
              MedicalService(id: '4', name: 'Tư vấn dinh dưỡng', price: 200000),
            ],
            rooms: [
              ClinicRoom(id: '3', name: 'Phòng 201', floor: 'Tầng 2'),
              ClinicRoom(id: '4', name: 'Phòng 202', floor: 'Tầng 2'),
            ],
          ),
        ],
      ),
      // Add more hospitals if needed
    ]);

    // Initialize sample patients data
    patients.addAll([
      Patient(
        id: '1',
        name: 'LÔ THỊ NỘ',
        dob: '01/01/1990',
        gender: 'Nữ',
        phone: '0987654321',
        relationship: 'Bản thân',
        address: 'Tỉnh Gia Lai',
      ),
      Patient(
        id: '2',
        name: 'NGUYỄN VĂN A',
        dob: '15/05/1985',
        gender: 'Nam',
        phone: '0912345678',
        relationship: 'Bản thân',
        address: 'Tỉnh Gia Lai',
      ),
    ]);

    // Set default selections
    selectedHospital.value = hospitals.first;
    selectedPatient.value = patients.firstWhereOrNull((p) => p.name == 'LÔ THỊ NỘ');
  }

  // Navigation methods
  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 4) {
      currentStep.value = step;
    }
  }

  // Step 1 methods
  void selectHospital(Hospital hospital) {
    selectedHospital.value = hospital;
    selectedDepartment.value = null;
    selectedService.value = null;
    selectedRoom.value = null;
  }

  void selectDepartment(Department department) {
    selectedDepartment.value = department;
    selectedService.value = null;
    selectedRoom.value = null;
  }

  void selectService(MedicalService service) {
    selectedService.value = service;
  }

  void selectRoom(ClinicRoom room) {
    selectedRoom.value = room;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
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
    // Here you would typically send data to backend
  }

  // Validation methods
  bool isStep1Complete() {
    return selectedHospital.value != null &&
        selectedDepartment.value != null &&
        selectedService.value != null &&
        selectedRoom.value != null &&
        selectedDate.value != null &&
        selectedTimeSlot.value != null;
  }

  bool isStep2Complete() {
    return selectedPatient.value != null;
  }
}