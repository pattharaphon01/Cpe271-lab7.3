import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lab7_101/screen/add_course_screen.dart';
import '../model/course.dart';
import 'edit_course_screen.dart';

class CourseScreen extends StatefulWidget {
  static const routeName = '/';
  const CourseScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _CourseScreenState();
  }
}

class _CourseScreenState extends State<CourseScreen> {
  late Future<List<Course>> courses;

  @override
  void initState() {
    super.initState();
    courses = fetchCourses();
  }

  void _refreshData() {
    setState(() {
      courses = fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCourseScreen()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Course>>(
          future: courses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.teal.withAlpha(100),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Total ${snapshot.data!.length} items',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: snapshot.data!.isNotEmpty
                        ? ListView.separated(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data![index].courseName),
                                subtitle: Text(
                                  snapshot.data![index].courseCode,
                                ),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditCourseScreen(
                                                  course:
                                                      snapshot.data![index],
                                                ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: Text('Confirm Delete'),
                                                content: Text(
                                                  "Do you want to delete: ${snapshot.data![index].courseCode}",
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                    ),
                                                    onPressed: () async {
                                                      await deleteCourse(
                                                        snapshot.data![index],
                                                      );
                                                      setState(() {
                                                        courses =
                                                            fetchCourses();
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Delete'),
                                                  ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Colors.blueGrey,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Close'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                          )
                        : const Center(
                            child: Text('No items'),
                          ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// ฟังก์ชันดึงข้อมูล Course
Future<List<Course>> fetchCourses() async {
  final response = await http.get(
    Uri.parse('http://158.108.112.226/Lab7/api/course.php'),
  );
  if (response.statusCode == 200) {
    return compute(parseCourses, response.body);
  } else {
    throw Exception('Failed to load courses');
  }
}

// แปลง JSON เป็น List<Course>
List<Course> parseCourses(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Course>((json) => Course.fromJson(json)).toList();
}

// ลบ Course
Future<int> deleteCourse(Course course) async {
  final response = await http.delete(
    Uri.parse(
      'http://158.108.112.226/Lab7/api/course.php?course_code=${course.courseCode}',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    throw Exception('Failed to delete course.');
  }
}
