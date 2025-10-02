import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/course.dart';
import 'package:http/http.dart' as http;

class EditCourseScreen extends StatefulWidget {
  final Course? course;
  const EditCourseScreen({super.key, this.course});
  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  Course? course;
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  String dropdownValue = "";

  @override
  void initState() {
    super.initState();
    course = widget.course!;
    codeController.text = course!.courseCode;
    nameController.text = course!.courseName;
    dropdownValue = course!.credit.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Course"),
        actions: [
          IconButton(
            onPressed: () async {
              int rt = await updateCourse(
                Course(
                  courseCode: course!.courseCode,
                  courseName: nameController.text,
                  credit: dropdownValue,
                ),
              );
              if (rt != 0) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              value: dropdownValue,
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'credit',
                border: OutlineInputBorder(),
              ),
              items: ['1', '2', '3', '4'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [const SizedBox(width: 10), Text(value)],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> updateCourse(Course course) async {
  final response = await http.put(
    Uri.parse(
      'http://158.108.112.226/Lab7/api/course.php?course_code=${course.courseCode}',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'course_code': course.courseCode,
      'course_name': course.courseName,
      'course_credit': course.credit,
    }),
  );
  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    throw Exception('Failed to update course.');
  }
}
