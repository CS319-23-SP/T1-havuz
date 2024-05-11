import 'package:first_trial/Pages/Widgets/AppBars/roles/admin_appbar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Admin/admin_page.dart';
import 'package:first_trial/Pages/Widgets/access_denied.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';

class InstructorCreationPage extends StatefulWidget {
  const InstructorCreationPage({Key? key}) : super(key: key);

  @override
  _InstructorCreationPageState createState() => _InstructorCreationPageState();
}

class _InstructorCreationPageState extends State<InstructorCreationPage> {
  final TextEditingController instructorNameController =
      TextEditingController();
  final TextEditingController instructorMiddleNameController =
      TextEditingController();
  final TextEditingController instructorSurNameController =
      TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  String? role = "unknown";
  String? term = PoolTerm.term;

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    setState(() {});
  }

  void _createInstuctor() async {
    String firstName = instructorNameController.text;
    String middleName = instructorMiddleNameController.text;
    String lastName = instructorSurNameController.text;
    final department = departmentController.text;

    final url = Uri.parse('http://localhost:8080/instructor');

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
      print('Instructor created successfully');
    } else {
      print('Failed to create instructor: ${response.reasonPhrase}');
    }
    GoRouter.of(context).go('/admin');
  }

  @override
  Widget build(BuildContext context) {
    if (role != 'admin') {
      return AccessDeniedPage();
    } else {
      return Scaffold(
        appBar: CustomAppBar(
          role: role,
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    GoRouter.of(context).go('/admin');
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Instructor Name'),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: instructorNameController,
                              decoration: const InputDecoration(
                                hintText: 'Enter Name',
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Add spacing between fields
                          Expanded(
                            child: TextFormField(
                              controller: instructorMiddleNameController,
                              decoration: const InputDecoration(
                                hintText: 'Enter Middle Name',
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Add spacing between fields
                          Expanded(
                            child: TextFormField(
                              controller: instructorSurNameController,
                              decoration: const InputDecoration(
                                hintText: 'Enter Surname',
                              ),
                            ),
                          ),
                        ],
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
                          onPressed: _createInstuctor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Create instructor'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
