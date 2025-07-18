import 'package:ebookingdoc/src/data/model/doctor_model.dart' show Doctor;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorStatisticsPage extends StatefulWidget {
  final String? doctorId;

  const DoctorStatisticsPage({Key? key, this.doctorId}) : super(key: key);

  @override
  _DoctorStatisticsPageState createState() => _DoctorStatisticsPageState();
}

class _DoctorStatisticsPageState extends State<DoctorStatisticsPage> {
  final ValueNotifier<Doctor?> doctor = ValueNotifier<Doctor?>(null);
  bool isLoadingDoctor = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadDoctorData();
  }

  Future<void> loadDoctorData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final doctorJson = prefs.getString('doctor_data');
      if (doctorJson != null) {
        doctor.value = Doctor.fromJson(jsonDecode(doctorJson));
        await fetchSpecializationFromAPI();
      } else {
        await fetchDoctorFromAPI();
      }
      setState(() {
        isLoadingDoctor = false;
      });
    } catch (e) {
      setState(() {
        isLoadingDoctor = false;
        errorMessage = 'Lỗi khi tải dữ liệu bác sĩ: $e';
      });
    }
  }

  // Placeholder for fetchDoctorFromAPI (implement as needed)
  Future<void> fetchDoctorFromAPI() async {
    // Example implementation (replace with your actual API call)
    final response =
        await http.get(Uri.parse('http://192.168.1.17:3210/api/doctor'));
    if (response.statusCode == 200) {
      doctor.value = Doctor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Lỗi khi tải dữ liệu bác sĩ từ API');
    }
  }

  // Placeholder for fetchSpecializationFromAPI (implement as needed)
  Future<void> fetchSpecializationFromAPI() async {}

  Future<Map<String, dynamic>> fetchDoctorRevenue() async {
    try {
      final doctorId = widget.doctorId ?? doctor.value?.uuid ?? '';
      final response = await http.get(
        Uri.parse('http://192.168.1.17:3210/api/$doctorId/revenue'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          return jsonData['data'] as Map<String, dynamic>;
        } else {
          throw Exception(jsonData['msg'] ?? 'Lỗi dữ liệu từ server');
        }
      } else {
        throw Exception('Lỗi kết nối server: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: ${e.toString()}');
    }
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingDoctor) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Thống Kê Doanh Thu Bác Sĩ',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF0288D1),
          elevation: 4,
        ),
        body: const Center(
            child: CircularProgressIndicator(color: Color(0xFF0288D1))),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Thống Kê Doanh Thu Bác Sĩ',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF0288D1),
          elevation: 4,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0288D1)),
                onPressed: () {
                  setState(() {
                    isLoadingDoctor = true;
                    errorMessage = null;
                  });
                  loadDoctorData();
                },
                child: const Text('Thử lại',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thống Kê Doanh Thu Bác Sĩ',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0288D1),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchDoctorRevenue(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0288D1)));
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lỗi: ${snapshot.error}',
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0288D1)),
                      onPressed: () => setState(() {}),
                      child: const Text('Thử lại',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!['totalRevenue'] == 0 ||
                snapshot.data!['breakdown'] == null) {
              return const Center(
                child: Text(
                  'Không có dữ liệu thanh toán',
                  style: TextStyle(fontSize: 18, color: Color(0xFF757575)),
                ),
              );
            }

            final data = snapshot.data!;
            final totalRevenue =
                (data['totalRevenue'] as num?)?.toDouble() ?? 0.0;
            final breakdown = data['breakdown'] as Map<String, dynamic>?;
            final cashRevenue = (breakdown?['cash'] as num?)?.toDouble() ?? 0.0;
            final onlineRevenue =
                (breakdown?['online'] as num?)?.toDouble() ?? 0.0;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: const Color(0xFFF9F9F9),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Text(
                            'Tổng Doanh Thu',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0288D1),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            formatCurrency(totalRevenue),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: const Color(0xFFF9F9F9),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Text(
                            'Tỷ Lệ Doanh Thu',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0288D1),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: onlineRevenue,
                                    title:
                                        '${(onlineRevenue / totalRevenue * 100).toStringAsFixed(1)}%',
                                    color: const Color(0xFF66BB6A),
                                    radius: 80,
                                    titleStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: cashRevenue,
                                    title:
                                        '${(cashRevenue / totalRevenue * 100).toStringAsFixed(1)}%',
                                    color: const Color(0xFFFFA726),
                                    radius: 80,
                                    titleStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: const Color(0xFFF9F9F9),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Thanh Toán Online',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF66BB6A),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  formatCurrency(onlineRevenue),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: const Color(0xFFF9F9F9),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Thanh Toán Tiền Mặt',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFFA726),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  formatCurrency(cashRevenue),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
