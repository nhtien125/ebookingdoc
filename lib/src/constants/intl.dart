import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Helper trả về list 7 ngày (chủ nhật đầu tuần -> thứ 7 cuối tuần) tính từ ngày truyền vào
List<DateTime> getWeekDays(DateTime anchor) {
  final start = anchor.subtract(Duration(days: anchor.weekday % 7));
  return List.generate(7, (i) => start.add(Duration(days: i)));
}

String weekdayShort(DateTime d) {
  const days = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"];
  return days[d.weekday % 7];
}
