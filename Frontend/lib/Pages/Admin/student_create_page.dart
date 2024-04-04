import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Admin/admin_page.dart';
import 'package:first_trial/token.dart';
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
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  void _createStudent() async {
    final studentId = studentIdController.text;
    List<String> parts = studentNameController.text.split(' ');
    String firstName = "";
    String middleName = "";
    String lastName = "";

    if (parts.length == 1) {
      print("last name missing");
      return;
    } else if (parts.length == 2) {
      firstName = parts[0];
      lastName = parts[1];
    } else if (parts.length >= 3) {
      firstName = parts[0];
      middleName = parts.sublist(1, parts.length - 1).join(' ');
      lastName = parts.last;
    }

    final courses = coursesController.text
        .split(',')
        .map((course) => course.trim())
        .toList();
    final department = departmentController.text;
    final password = passwordController.text;

    final url = Uri.parse('http://localhost:8080/student');
    final id = int.tryParse(studentId);
    if (id == null) {
      print("bad id");
      return;
    }

    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'firstName': firstName,
        if (middleName.isNotEmpty) 'middleName': middleName,
        'lastName': lastName,
        'department': department,
      }),
    );
    if (response.statusCode == 200) {
      print('Student created successfully');
    } else {
      print('Failed to create student: ${response.reasonPhrase}');
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Admin(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(),
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
                  hintText: 'Enter Student Name (be careful about spacing)',
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
              const SizedBox(height: 16),
              const Text('Password'),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Department'),
              TextFormField(
                controller: departmentController,
                decoration: const InputDecoration(
                  hintText: 'Enter Department',
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
