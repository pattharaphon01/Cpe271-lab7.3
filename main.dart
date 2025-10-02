import 'package:flutter/material.dart';
import './screen/student_screen.dart';
import './screen/course_screen.dart';
import './screen/exam_result_screen.dart'; // ✅ นำเข้าหน้าใหม่

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Flutter App',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(), // เมนูหลัก
        '/student': (context) => StudentScreen(),
        '/course': (context) => CourseScreen(),
        '/examresult': (context) => ExamResultScreen(), // ✅ เพิ่ม route
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Students'),
              onTap: () {
                Navigator.pushNamed(context, '/student');
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Courses'),
              onTap: () {
                Navigator.pushNamed(context, '/course');
              },
            ),
            ListTile(
              leading: Icon(Icons.grade), // ✅ เพิ่มไอคอนให้ดูเกี่ยวกับผลสอบ
              title: Text('Exam Results'),
              onTap: () {
                Navigator.pushNamed(context, '/examresult'); // ✅ เปิดหน้า exam result
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Select a page from the drawer menu.'),
      ),
    );
  }
}
