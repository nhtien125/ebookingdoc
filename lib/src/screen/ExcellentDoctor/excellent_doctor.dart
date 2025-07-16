import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookingdoc/src/Global/app_color.dart';
import 'package:ebookingdoc/src/data/model/clinic_model.dart';
import 'package:ebookingdoc/src/data/model/hospital_model.dart';
import 'package:ebookingdoc/src/data/model/vaccination_center_model.dart';
import 'package:ebookingdoc/src/data/model/doctor_model.dart';
import 'package:ebookingdoc/src/widgets/controller/excellent_doctor_controller.dart';

// Constants for styling
const _kCardBorderRadius = 12.0;
const _kButtonPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
const _kCardPadding = EdgeInsets.all(12);
const _kImageSize = 80.0;

class ExcellentDoctor extends StatelessWidget {
  final controller = Get.put(ExcellentDoctorController());
  final TextEditingController searchController = TextEditingController();

  ExcellentDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    _initializeTabFromArgs();
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColor.fivethMain,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(),
        body: RefreshIndicator(
          onRefresh: controller.fetchData,
          child: Column(
            children: [
              _buildTopTabs(),
              Expanded(child: _buildTabContent()),
              _buildPaginationControls(),
            ],
          ),
        ),
      ),
    );
  }

  void _initializeTabFromArgs() {
    final args = Get.arguments;
    controller.topTabIndex.value = switch (args) {
      {'hospitals': true} => 1,
      {'clinics': true} => 2,
      {'vaccines': true} => 3,
      _ => 0,
    };
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.fourthMain,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColor.main,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm bác sĩ, chuyên khoa, bệnh viện...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: AppColor.fourthMain),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          onChanged: controller.search,
        ),
      ),
    );
  }

  Widget _buildTopTabs() {
    const tabs = ['Bác sĩ', 'Bệnh viện', 'Phòng khám', 'Trung tâm tiêm chủng'];
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = controller.topTabIndex.value == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => controller.changeTab(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.fourthMain : AppColor.main,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.fourthMain),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColor.fourthMain,
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

  Widget _buildTabContent() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildSkeletonList();
      }
      if (controller.hasError.value) {
        return _buildErrorWidget();
      }
      return switch (controller.topTabIndex.value) {
        0 => _buildList(controller.doctors, _buildDoctorCard, 'Không tìm thấy bác sĩ nào'),
        1 => _buildList(controller.hospitals, _buildHospitalCard, 'Không tìm thấy bệnh viện nào'),
        2 => _buildList(controller.clinics, _buildClinicCard, 'Không tìm thấy phòng khám nào'),
        3 => _buildList(controller.vaccinationCenters, _buildVaccinationCard, 'Không tìm thấy trung tâm tiêm chủng nào'),
        _ => Container(),
      };
    });
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kCardBorderRadius)),
          elevation: 3,
          child: Padding(
            padding: _kCardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: _kImageSize,
                  height: _kImageSize,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 150, height: 16, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Container(width: 100, height: 14, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Container(width: 120, height: 14, color: Colors.grey[300]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Không thể tải dữ liệu. Vui lòng thử lại.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.fetchData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.fourthMain,
              padding: _kButtonPadding,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Thử lại',
              style: TextStyle(color: AppColor.main),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList<T>(List<T> items, Widget Function(T) builder, String emptyMessage) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, index) => builder(items[index]),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    final name = controller.doctorNames[doctor.userId ?? doctor.uuid] ?? 'Bác sĩ không xác định';
    final specialty = controller.doctorSpecialties[doctor.userId ?? doctor.uuid] ?? 'Chưa có chuyên khoa';
    final image = controller.imageDoctor[doctor.userId ?? doctor.uuid] ?? 'assets/images/default_doctor.jpg';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kCardBorderRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(_kCardBorderRadius),
        onTap: () => controller.viewDoctorDetails(doctor.uuid ?? ''),
        child: Padding(
          padding: _kCardPadding,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(image, Icons.person),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1A2E55),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Chuyên khoa: $specialty',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Kinh nghiệm: ${doctor.experience ?? 0} năm',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildActionButtons(
                onDetails: () => controller.viewDoctorDetails(doctor.uuid ?? ''),
                onBook: () => controller.bookDoctorAppointment(doctor, 'doctor'),
                bookText: 'Đặt lịch ngay',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalCard(Hospital hospital) {
    return _buildCard(
      imageUrl: hospital.image,
      title: hospital.name ?? 'Bệnh viện không xác định',
      subtitle: hospital.address ?? 'Không có địa chỉ',
      onDetails: () => controller.viewHospitalDetails(hospital),
      onBook: () => controller.bookHospitalAppointment(hospital, 'hospital'),
      bookText: 'Đặt lịch khám',
    );
  }

  Widget _buildClinicCard(Clinic clinic) {
    return _buildCard(
      imageUrl: clinic.image,
      title: clinic.name ?? 'Phòng khám không xác định',
      subtitle: clinic.address ?? 'Không có địa chỉ',
      onDetails: () => controller.viewClinicDetails(clinic),
      onBook: () => controller.bookClinicAppointment(clinic, 'clinic'),
      bookText: 'Đặt lịch khám',
    );
  }

  Widget _buildVaccinationCard(VaccinationCenter vaccina) {
    return _buildCard(
      imageUrl: vaccina.image,
      title: vaccina.name ?? 'Trung tâm không xác định',
      subtitle: vaccina.address ?? 'Không có địa chỉ',
      extra: Text(
        vaccina.status == 'open' ? 'Đang mở' : 'Đã đóng',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: vaccina.status == 'open' ? Colors.green : Colors.red,
        ),
      ),
      onDetails: () => controller.viewVaccinaDetails(vaccina),
      onBook: () => controller.bookVaccinationAppointment(vaccina, 'vaccination'),
      bookText: 'Đặt lịch tiêm',
    );
  }

  Widget _buildCard({
    required String? imageUrl,
    required String title,
    required String subtitle,
    Widget? extra,
    required VoidCallback onDetails,
    required VoidCallback onBook,
    required String bookText,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kCardBorderRadius)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(_kCardBorderRadius),
        onTap: onDetails,
        child: Padding(
          padding: _kCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(imageUrl, Icons.medical_services),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                subtitle,
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (extra != null) ...[
                          const SizedBox(height: 8),
                          extra,
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildActionButtons(onDetails: onDetails, onBook: onBook, bookText: bookText),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, IconData fallbackIcon) {
    return Container(
      width: _kImageSize,
      height: _kImageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3366FF).withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) =>
                    Icon(fallbackIcon, size: 36, color: Colors.grey[400]),
              )
            : Icon(fallbackIcon, size: 36, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildActionButtons({
    required VoidCallback onDetails,
    required VoidCallback onBook,
    required String bookText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: onDetails,
          style: OutlinedButton.styleFrom(
            padding: _kButtonPadding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: BorderSide(color: AppColor.fourthMain),
          ),
          child: Text(
            'Xem chi tiết',
            style: TextStyle(fontSize: 14, color: AppColor.fourthMain),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onBook,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.fourthMain,
            padding: _kButtonPadding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            bookText,
            style: TextStyle(fontSize: 14, color: AppColor.main),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls() {
    return Obx(() {
      final tabIndex = controller.topTabIndex.value;
      final current = controller.currentPage[tabIndex] ?? 1;
      final total = controller.totalPages[tabIndex] ?? 1;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: current > 1 ? controller.previousPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.fourthMain,
                padding: _kButtonPadding,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Trước',
                style: TextStyle(color: AppColor.main),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Trang $current / $total',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: current < total ? controller.nextPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.fourthMain,
                padding: _kButtonPadding,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Sau',
                style: TextStyle(color: AppColor.main),
              ),
            ),
          ],
        ),
      );
    });
  }
}