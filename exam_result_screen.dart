import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/exam_result.dart'; // โมเดลใหม่
import 'add_exam_result.dart'; // ฟอร์มเพิ่มข้อมูล
import 'edit_exam_result_screen.dart';
class ExamResultScreen extends StatefulWidget {
  static const routeName = '/exam_results';
  const ExamResultScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  late Future<List<ExamResult>> examResults;

  @override
  void initState() {
    super.initState();
    examResults = fetchExamResults();
  }

  void _refreshData() {
    setState(() {
      examResults = fetchExamResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Results'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExamResultScreen()),
              );
              _refreshData(); // Refresh หลังกลับจากหน้าฟอร์ม
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<ExamResult>>(
          future: examResults,
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
                      children: [Text('Total ${snapshot.data!.length} items')],
                    ),
                  ),
                  Expanded(
                    child: snapshot.data!.isNotEmpty
                        ? ListView.separated(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final result = snapshot.data![index];
                              return ListTile(
                                title: Text('Course: ${result.courseCode}'),
                                subtitle: Text(
                                  'Student: ${result.studentCode} - Point: ${result.point}',
                                ),
                                trailing: Wrap(
                                  spacing: 8,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditExamResultScreen(
                                                  examResult: result,
                                                ),
                                          ),
                                        );
                                        _refreshData(); // รีเฟรชหลังกลับจากหน้าแก้ไข
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: Text('Confirm Delete'),
                                                content: Text(
                                                  "Delete result for: ${result.studentCode} in ${result.courseCode}?",
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                    onPressed: () async {
                                                      await deleteExamResult(
                                                        result,
                                                      );
                                                      Navigator.pop(context);
                                                      _refreshData();
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
                                                    child: Text('Cancel'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                          )
                        : const Center(child: Text('No items')),
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

// ---------- Functions ----------

Future<List<ExamResult>> fetchExamResults() async {
  final response = await http.get(
    Uri.parse('http://158.108.112.226/Lab7/api/exam_result.php'),
  );

  if (response.statusCode == 200) {
    return compute(parseExamResults, response.body);
  } else {
    throw Exception('Failed to load Exam Results');
  }
}

List<ExamResult> parseExamResults(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ExamResult>((json) => ExamResult.fromJson(json)).toList();
}

Future<int> deleteExamResult(ExamResult result) async {
  final url =
      'http://158.108.112.226/Lab7/api/exam_result.php?course_code=${result.courseCode}&student_code=${result.studentCode}';

  final response = await http.delete(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    throw Exception('Failed to delete exam result.');
  }
}
