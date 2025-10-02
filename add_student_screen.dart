import 'package:flutter/material.dart';
import 'student_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _genderController = TextEditingController();

  Future<void> addStudent() async {
    final response = await http.post(
      Uri.parse('http://158.108.112.226/Lab7/api/student.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'student_code': _codeController.text,
        'student_name': _nameController.text,
        'gender': _genderController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Failed to add student');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Student')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Student Code'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a code' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Student Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a Gender' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addStudent();
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
