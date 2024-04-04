import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_create_page.dart';
import '../../Objects/student.dart';
import 'dart:convert';
import 'package:first_trial/token.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
  try {
    final response = await http.get(Uri.http('localhost:8080', '/student/'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          students = parseStudentsData(responseData['students']);
        });
      } else {
        throw Exception('Failed to fetch students data');
      }
    } else {
      throw Exception('Failed to fetch students data');
    }
  } catch (e) {
    print('Error fetching students: $e');
  }
}

List<Student> parseStudentsData(dynamic responseData) {
  return (responseData as List<dynamic>)
      .map((studentData) => Student.fromJson(studentData))
      .toList();
}

  Future<void> deleteStudent(String studentId, int index) async {
    try {
      print("localhost:3000/student/$studentId");
      final response =
          await http.delete(Uri.http('localhost:8080', '/student/$studentId'));

      if (response.statusCode == 200) {
        setState(() {
          students.removeAt(index);
        });
      } else {
        print("student id yok herhalde bilmiom");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AdminAppBar(),
        body: StudentData(students: students, onDelete: deleteStudent),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentCreationPage(),
              ),
            ).then((_) {
              fetchStudents();
            });
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class StudentData extends StatelessWidget {
  final List<Student> students;
  final Function(String, int) onDelete;

  const StudentData({
    Key? key,
    required this.students,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        var student = students[index];
        return ListTile(
          title: Text('${student.id} - ${student.name} - ${student.courses}'),
          trailing: SizedBox(
            width: 48,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(student.id, index),
            ),
          ),
        );
      },
    );
  }
}
