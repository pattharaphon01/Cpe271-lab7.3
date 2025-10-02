import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/exam_result.dart';
import 'package:http/http.dart' as http;

class EditExamResultScreen extends StatefulWidget {
  final ExamResult? examResult;
  const EditExamResultScreen({super.key, this.examResult});

  @override
  State<EditExamResultScreen> createState() => _EditExamResultScreenState();
}

class _EditExamResultScreenState extends State<EditExamResultScreen> {
  ExamResult? examResult;
  TextEditingController courseCodeController = TextEditingController();
  TextEditingController studentCodeController = TextEditingController();
  TextEditingController pointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    examResult = widget.examResult!;
    courseCodeController.text = examResult!.courseCode;
    studentCodeController.text = examResult!.studentCode;
    pointController.text = examResult!.point;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Exam Result"),
        actions: [
          IconButton(
            onPressed: () async {
              int rt = await updateExamResult(
                ExamResult(
                  courseCode: courseCodeController.text,
                  studentCode: studentCodeController.text,
                  point: pointController.text,
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: courseCodeController,
              enabled: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Course Code',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: studentCodeController,
              enabled: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Student Code',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: pointController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Point',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> updateExamResult(ExamResult examResult) async {
  final response = await http.put(
    Uri.parse(
      'http://158.108.112.226/Lab7/api/exam_result.php?course_code=${examResult.courseCode}&student_code=${examResult.studentCode}',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'course_code': examResult.courseCode,
      'student_code': examResult.studentCode,
      'point': examResult.point,
    }),
  );

  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    throw Exception('Failed to update exam result.');
  }
}
