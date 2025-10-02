class ExamResult {
  final String courseCode;
  final String studentCode;
  final String point;
  ExamResult({
    required this.courseCode,
    required this.studentCode,
    required this.point,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      courseCode: json['course_code'],
      studentCode: json['student_code'],
      point: json['point'],
    );
  }
}
