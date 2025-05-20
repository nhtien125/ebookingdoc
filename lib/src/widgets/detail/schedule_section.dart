import 'package:ebookingdoc/src/data/model/doctor_detail_model.dart';
import 'package:ebookingdoc/src/widgets/controller/detail_doctor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduleSection extends StatelessWidget {
  final DetailDoctorController controller;

  const ScheduleSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lịch làm việc',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Column(
          children: [
            _buildDateSelector(),
            const SizedBox(height: 16),
            _buildTimeSlotsGrid(),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 100,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.availableDates.length,
          itemBuilder: (context, index) {
            final date = controller.availableDates[index];
            return _buildDateItem(date, index);
          },
        ),
      ),
    );
  }

  Widget _buildDateItem(DateTime date, int index) {
    final isSelected = index == controller.selectedDateIndex.value;
    final dayName = DateFormat('E', 'vi_VN').format(date);
    final isToday = date.day == DateTime.now().day;

    return GestureDetector(
      onTap: () => controller.selectDate(index),
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? controller.entity.value!.type.color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? controller.entity.value!.type.color
                : Colors.grey[300]!,
          ),
          boxShadow: [
            if (isToday && !isSelected)
              BoxShadow(
                color: controller.entity.value!.type.color.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            if (isToday)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : controller.entity.value!.type.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Hôm nay',
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? controller.entity.value!.type.color
                        : Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotsGrid() {
    return Obx(() {
      if (controller.selectedDateIndex.value == -1) {
        return const Center(child: Text('Vui lòng chọn ngày'));
      }

      if (controller.entity.value == null ||
          controller.entity.value!.availableSlots.isEmpty) {
        return const Center(child: Text('Không có khung giờ trống'));
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: controller.entity.value!.availableSlots.length,
        itemBuilder: (context, index) {
          return _buildTimeSlotItem(index);
        },
      );
    });
  }

  Widget _buildTimeSlotItem(int index) {
    final isSelected = index == controller.selectedTimeIndex.value;
    final slot = controller.entity.value!.availableSlots[index];

    return GestureDetector(
      onTap: () => controller.selectTime(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? controller.entity.value!.type.color : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? controller.entity.value!.type.color
                : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            slot,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}