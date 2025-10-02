class Course {
  final String courseCode;
  final String courseName;
  final String credit;
  Course({
    required this.courseCode,
    required this.courseName,
    required this.credit,
  });

  // ส่วนของ name constructor ทีÉจะแปลง json string มาเป็น Student object
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseCode: json['course_code'],
      courseName: json['course_name'],
      credit: json['credit'],
    );
  }
}
