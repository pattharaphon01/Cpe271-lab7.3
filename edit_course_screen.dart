import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/course.dart';
import 'package:http/http.dart' as http;

class EditCourseScreen extends StatefulWidget {
  final Course? course;
  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  late Course course;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  String dropdownValue = "";

  @override
  void initState() {
    super.initState();

    // ตรวจสอบว่ามี course ที่ส่งมาหรือไม่
    if (widget.course == null) {
      throw ArgumentError("Course cannot be null in EditCourseScreen");
    }

    course = widget.course!;
    codeController.text = course.courseCode;
    nameController.text = course.courseName;
    dropdownValue = course.credit.toString();

    print(
      "Loaded for edit => Code: ${course.courseCode}, Name: ${course.courseName}, Credit: ${course.credit}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Course"),
        actions: [
          IconButton(
            onPressed: () async {
              // Debug log
              print(
                "Updating course => Code: ${course.courseCode}, Name: ${nameController.text}, Credit: $dropdownValue",
              );

              // Call update
              int rt = await updateCourse(
                Course(
                  courseCode: course.courseCode,
                  courseName: nameController.text,
                  credit: dropdownValue,
                ),
              );

              if (rt == 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Course updated successfully')),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update course')),
                );
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              enabled: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Course Code',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Course Name',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value:
                  dropdownValue.isNotEmpty &&
                      ['1', '2', '3', '4'].contains(dropdownValue)
                  ? dropdownValue
                  : '1', // ค่า fallback ถ้า dropdownValue ไม่ถูกต้อง
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Credit',
                border: OutlineInputBorder(),
              ),
              items: ['1', '2', '3', '4']
                  .toSet() // ป้องกันค่าซ้ำ
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> updateCourse(Course course) async {
  final url =
      'http://158.108.112.226/Lab7/api/course.php?course_code=${course.courseCode}';
  final headers = {'Content-Type': 'application/json; charset=UTF-8'};
  final body = jsonEncode({
    'course_code': course.courseCode,
    'course_name': course.courseName,
    'course_credit': course.credit,
  });

  print("Sending PUT request to: $url");
  print("Body: $body");

  final response = await http.put(Uri.parse(url), headers: headers, body: body);

  if (response.statusCode == 200) {
    print("Update successful");
    return response.statusCode;
  } else {
    print("Update failed: ${response.statusCode}, ${response.body}");
    throw Exception('Failed to update course.');
  }
}
