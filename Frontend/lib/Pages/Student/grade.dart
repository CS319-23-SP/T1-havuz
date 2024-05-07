import 'package:flutter/material.dart';
import 'package:first_trial/Objects/section.dart';
import 'package:first_trial/Objects/assignment.dart';
import 'package:first_trial/token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';

class StudentGradePage extends StatefulWidget {
  const StudentGradePage({Key? key}) : super(key: key);

  @override
  _StudentGradePageState createState() => _StudentGradePageState();
}

class _StudentGradePageState extends State<StudentGradePage> {
  List<Section> sections = [];
  Map<String, List<Assignment>> assignmentsBySection =
      {}; // Store assignments by section
  bool isLoading = true; // Track loading status

  @override
  void initState() {
    super.initState();
    _loadSections(); // Fetch sections on initialization
  }

  Future<void> _loadSections() async {
    try {
      final studentID = await TokenStorage.getID();
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('http://localhost:8080/student/grade/$studentID'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final sectionsData =
            (data['sections'] as List<dynamic>).map((sectionData) {
          return Section.fromJson(sectionData);
        }).toList();

        setState(() {
          sections = sectionsData;
        });

        await _loadAssignmentsForSections(); // Fetch assignments for the sections
      } else {
        throw Exception("Failed to load sections");
      }
    } catch (e) {
      print("Error loading sections: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadAssignmentsForSections() async {
    try {
      const term = "2024 Spring";
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      for (final section in sections) {
        final sectionID = section.id;
        final assignments = <Assignment>[];

        for (final assignmentID in section.assignments) {
          final response = await http.get(
            Uri.parse(
                'http://localhost:8080/assignment/$assignmentID/$term/$sectionID'),
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json',
            },
          );

          if (response.statusCode == 200) {
            final assignmentData = json.decode(response.body);
            final assignment = Assignment.fromJson(assignmentData);
            assignments.add(assignment);
          } else {
            throw Exception("Failed to load assignment with ID $assignmentID");
          }
        }

        setState(() {
          assignmentsBySection[sectionID] =
              assignments; // Store assignments by section
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error loading assignments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grades"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/student');
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: sections.map((section) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          section.id.substring(0, section.id.length - 2),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ..._buildAssignmentList(section.id),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  List<Widget> _buildAssignmentList(String sectionID) {
    final assignments = assignmentsBySection[sectionID] ?? [];

    return assignments.map((assignment) {
      final assignmentName = assignment.name;
      final studentID = TokenStorage.getID();
      final grade = assignment.grades[studentID];
      return Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Assignment: $assignmentName"),
                Text("Grade: $grade"),
              ],
            ),
          ),
          Divider(),
        ],
      );
    }).toList();
  }
}
