import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentCreationPage extends StatefulWidget {

  const StudentCreationPage({Key? key}) : super(key: key);

  @override
  _StudentCreationPageState createState() => _StudentCreationPageState();
}

class _StudentCreationPageState extends State<StudentCreationPage> {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController coursesController = TextEditingController();

 void _createStudent() async {
  final studentId = studentIdController.text;
  final studentName = studentNameController.text;
  final courses = coursesController.text.split(',').map((course) => course.trim()).toList();

  final url = Uri.parse('http://localhost:3000/student');
  final id = int.tryParse(studentId);
  if (id == null) {
    print("bad id");
    return;
  }
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'id': id,
      'name': studentName,
      'courses': courses,
      'password': "123456",
    }),
  );
  if (response.statusCode == 201) {
    print('Student created successfully');
  } else {
    print('Failed to create student: ${response.reasonPhrase}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Student'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 200.0, vertical: 20.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Student ID'),
              TextFormField(
                controller: studentIdController,
                decoration: const InputDecoration(
                  hintText: 'Enter Student ID',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Student Name'),
              TextFormField(
                controller: studentNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Student Name',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Courses'),
              TextFormField(
                controller: coursesController,
                decoration: const InputDecoration(
                  hintText: 'Enter Courses',
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _createStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Create Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}