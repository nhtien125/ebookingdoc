import 'package:get/get.dart';

class Patient {
  final String id;
  final String name;
  final String avatarUrl;
  final String dob;
  final String phone;
  final String mainDisease;

  Patient({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.dob,
    required this.phone,
    required this.mainDisease,
  });
}

class PatientListController extends GetxController {
  final patients = <Patient>[
    Patient(
      id: "pt0001",
      name: "Nguyễn Văn A",
      avatarUrl: "https://randomuser.me/api/portraits/men/11.jpg",
      dob: "1990-04-15",
      phone: "0912345678",
      mainDisease: "Tăng huyết áp",
    ),
    Patient(
      id: "pt0002",
      name: "Trần Thị B",
      avatarUrl: "https://randomuser.me/api/portraits/women/22.jpg",
      dob: "1985-09-10",
      phone: "0938765432",
      mainDisease: "Bệnh động mạch vành",
    ),
    Patient(
      id: "pt0003",
      name: "Lê Hoàng C",
      avatarUrl: "https://randomuser.me/api/portraits/men/33.jpg",
      dob: "1975-01-28",
      phone: "0981234567",
      mainDisease: "Rối loạn nhịp tim",
    ),
    Patient(
      id: "pt0004",
      name: "Phạm Thị Dung",
      avatarUrl: "https://randomuser.me/api/portraits/women/44.jpg",
      dob: "1992-12-02",
      phone: "0944123456",
      mainDisease: "Suy tim",
    ),
    Patient(
      id: "pt0005",
      name: "Vũ Minh Tú",
      avatarUrl: "https://randomuser.me/api/portraits/men/55.jpg",
      dob: "1988-03-19",
      phone: "0977123890",
      mainDisease: "Thiếu máu cơ tim",
    ),
    Patient(
      id: "pt0006",
      name: "Hoàng Thị Lan",
      avatarUrl: "https://randomuser.me/api/portraits/women/66.jpg",
      dob: "1981-06-22",
      phone: "0909123888",
      mainDisease: "Hở van tim",
    ),
    Patient(
      id: "pt0007",
      name: "Đặng Quốc Bảo",
      avatarUrl: "https://randomuser.me/api/portraits/men/77.jpg",
      dob: "1997-10-31",
      phone: "0966123777",
      mainDisease: "Tăng cholesterol máu",
    ),
  ].obs;
}
