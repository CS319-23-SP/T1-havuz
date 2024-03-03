import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_create_page.dart';
import 'student.dart';
import 'dart:convert';

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
      final response = await http.get(Uri.http('localhost:3000', '/student/'));

      if (response.statusCode == 200) {
        setState(() {
          students = parseStudentsData(json.decode(response.body));
        });
      } else {
        throw Exception('Failed to fetch students data');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  List<Student> parseStudentsData(dynamic responseData) {
    print("5");
    return (responseData as List<dynamic>)
        .map((studentData) => Student.fromJson(studentData))
        .toList();
  }


  void addStudent(Student student) {
    setState(() {
      students.add(student);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Admin')),
        body: StudentData(students: students, onDelete: (index) {
          setState(() {
            students.removeAt(index);
          });
        }),
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
  final Function(int) onDelete;

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
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onDelete(index),
          ),
        );
      },
    );
  }
}
