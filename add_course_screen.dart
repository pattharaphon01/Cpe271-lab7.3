import 'package:flutter/material.dart';
import 'course_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  String _unitValue = '3'; // Default unit

  Future<void> addCourse() async {
    final response = await http.post(
      Uri.parse('http://158.108.112.226/Lab7/api/course.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'course_code': _codeController.text,
        'course_name': _nameController.text,
        'course_unit': _unitValue,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Failed to add course');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Course')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Course Code'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter course code' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Course Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter course name' : null,
              ),
              DropdownButtonFormField<String>(
                value: _unitValue,
                decoration: InputDecoration(labelText: 'credit'),
                onChanged: (value) {
                  setState(() {
                    _unitValue = value!;
                  });
                },
                items: ['1', '2', '3', '4']
                    .map((unit) => DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addCourse();
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
