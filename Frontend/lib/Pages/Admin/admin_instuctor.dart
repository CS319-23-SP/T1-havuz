import 'package:first_trial/Objects/instructor.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/Pages/Auth/login_page.dart';
import 'package:first_trial/Pages/Widgets/AppBars/roles/admin_appbar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/access_denied.dart';
import 'package:first_trial/final_variables.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'Create/student_create_page.dart';
import '../../Objects/student.dart';
import 'dart:convert';
import 'package:first_trial/token.dart';
import 'package:go_router/go_router.dart';

class AdminInstructorsPage extends StatefulWidget {
  const AdminInstructorsPage({super.key});

  @override
  State<AdminInstructorsPage> createState() => _AdminInstructorsPageState();
}

class _AdminInstructorsPageState extends State<AdminInstructorsPage> {
  String? role = "unknown";
  List<Instructor> instructors = [];

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    if (role != "admin") {
      return;
    } else {
      fetchStudents();
      setState(() {});
    }
  }

  Future<void> fetchStudents() async {
    try {
      String? token = await TokenStorage.getToken();

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.http('localhost:8080', '/instructor/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            instructors = parseInstructorsData(responseData['instructors']);
          });
        } else {
          throw Exception('Failed to fetch students data');
        }
      } /*else if (response.statusCode == 401) {
      print('Unauthorized access: Token may be invalid or expired');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } */
      else {
        throw Exception('Failed to fetch students data');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  List<Instructor> parseInstructorsData(dynamic responseData) {
    return (responseData as List<dynamic>)
        .map((InstructorData) => Instructor.fromJson(InstructorData))
        .toList();
  }

  Future<void> deleteStudent(String instructorId, int index) async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.delete(
        Uri.http('localhost:8080', '/instructor/$instructorId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          instructors.removeAt(index);
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
    if (role != 'admin') {
      return AccessDeniedPage();
    } else {
      return Scaffold(
        appBar: CustomAppBar(
          role: role,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LeftBar(role: role),
            Flexible(
                flex: 2,
                child: Placeholder(
                  color: Colors.transparent,
                )),
            Flexible(
                flex: 7,
                child: InstructorData(
                    instructors: instructors, onDelete: deleteStudent)),
            Flexible(
                flex: 2,
                child: Placeholder(
                  color: Colors.transparent,
                )),
          ],
        ),
        /*floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                GoRouter.of(context).go('/admin/studentCreate');
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
            SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () {
                GoRouter.of(context).go('/allSections');
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.line_style_sharp),
            ),
          ],
        ),*/
      );
    }
  }
}

class InstructorData extends StatelessWidget {
  final List<Instructor> instructors;
  final Function(String, int) onDelete;

  const InstructorData({
    Key? key,
    required this.instructors,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            color: PoolColors.appBarBackground,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('ID'),
              ),
              Expanded(
                flex: 2,
                child: Text('Name'),
              ),
              Expanded(
                flex: 3,
                child: Text('Courses'),
              ),
              Expanded(
                flex: 1,
                child: Text('Action'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: instructors.length,
            itemBuilder: (context, index) {
              var instructor = instructors[index];
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  color: PoolColors.appBarBackground,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(instructor.id),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(instructor.name),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(instructor.coursesGiven.toString()),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDelete(instructor.id, index),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        IconButton(
            onPressed: () {
              GoRouter.of(context).go("/admin/instructorCreate");
            },
            icon: Icon(Icons.add))
      ],
    );
  }
}
