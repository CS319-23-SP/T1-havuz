import 'package:flutter/material.dart';
import 'package:first_trial/Pages/Widgets/AppBars/roles/admin_appbar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Admin/admin_page.dart';
import 'package:first_trial/Pages/Widgets/access_denied.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';

class SectionCreate extends StatefulWidget {
  const SectionCreate({super.key});

  @override
  State<SectionCreate> createState() => _SectionCreateState();
}

class _SectionCreateState extends State<SectionCreate> {
  final TextEditingController termController = TextEditingController();
  final TextEditingController CourseController = TextEditingController();

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

  void _createSection() async {
    String termName = termController.text;
    String courseController = CourseController.text;
    final url = Uri.parse('http://localhost:8080/section');

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
        'term': termName,
        'courseID': courseController,
      }),
    );
    if (response.statusCode == 200) {
      print('Section created successfully');
    } else {
      print('Failed to create section: ${response.reasonPhrase}');
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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: termController,
                              decoration: const InputDecoration(
                                hintText: 'Enter Term (YEAR TERM)',
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Add spacing between fields
                          Expanded(
                            child: TextFormField(
                              controller: CourseController,
                              decoration: const InputDecoration(
                                hintText: 'Course ID',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _createSection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Create Section'),
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
