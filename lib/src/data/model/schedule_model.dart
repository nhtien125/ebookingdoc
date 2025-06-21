class Schedule {
  final String uuid;
  final String doctorId;
  final String? clinicId;
  final String workDate; 
  final String? startTime;
  final String? endTime;   

  Schedule({
    required this.uuid,
    required this.doctorId,
    this.clinicId,
    required this.workDate,
    this.startTime,
    this.endTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      uuid: json['uuid'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      clinicId: json['clinic_id'],
      workDate: json['work_date'] ?? '',
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'doctor_id': doctorId,
      'clinic_id': clinicId,
      'work_date': workDate,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}
