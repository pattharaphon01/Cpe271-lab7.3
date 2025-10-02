import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddExamResultScreen extends StatefulWidget {
  const AddExamResultScreen({super.key});

  @override
  _AddExamResultScreenState createState() => _AddExamResultScreenState();
}

class _AddExamResultScreenState extends State<AddExamResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseCodeController = TextEditingController();
  final _studentCodeController = TextEditingController();
  final _pointController = TextEditingController();

  Future<void> addExamResult() async {
    final response = await http.post(
      Uri.parse('http://158.108.112.226/Lab7/api/exam_result.php'), // <- เปลี่ยน endpoint ให้เหมาะสม
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'course_code': _courseCodeController.text,
        'student_code': _studentCodeController.text,
        'point': _pointController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Failed to add exam result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Exam Result')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _courseCodeController,
                decoration: InputDecoration(labelText: 'Course Code'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a course code' : null,
              ),
              TextFormField(
                controller: _studentCodeController,
                decoration: InputDecoration(labelText: 'Student Code'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a student code' : null,
              ),
              TextFormField(
                controller: _pointController,
                decoration: InputDecoration(labelText: 'Point'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the point' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addExamResult();
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
