import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/Objects/section.dart';
import 'package:first_trial/token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';

class StudentSectionGradePage extends StatefulWidget {
  const StudentSectionGradePage({Key? key}) : super(key: key);

  @override
  _StudentSectionGradePageState createState() =>
      _StudentSectionGradePageState();
}

class _StudentSectionGradePageState extends State<StudentSectionGradePage> {
  List<Section> sections = [];
  Map<String, List<dynamic>>? sectionAssignments = {};
  String? studentID;
  String? term = PoolTerm.term;

  @override
  void initState() {
    super.initState();
    _loadStudentSections();
  }

  Future<void> _loadStudentSections() async {
    try {
      studentID = await TokenStorage.getID();
      final token = await TokenStorage.getToken();
      if (token == null || studentID == null) {
        throw Exception('Token or Student ID not found');
      }

      final response = await http.get(
        Uri.parse('http://localhost:8080/student/grade/$studentID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          final sectionData = responseData['sections']; // Extract sections data

          if (sectionData is List) {
            sections = sectionData
                .map((section) => Section.fromJson(section))
                .toList();
          } else {
            throw Exception("Invalid data format for sections");
          }
          // Fetch assignments for each section
          for (var section in sections) {
            await _fetchAssignmentsForSection(section, token);
          }

          setState(() {}); // Refresh UI with updated data
        } else {
          throw Exception("Failed to fetch sections");
        }
      } else {
        throw Exception("Failed to fetch sections");
      }
    } catch (e) {
      print('Error fetching sections: $e');
    }
  }

  Future<void> _fetchAssignmentsForSection(
      Section section, String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/assignment/$term/${section.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        sectionAssignments![section.id] = responseData['assignments'];
      } else {
        throw Exception(
            "Failed to fetch assignments for section ${section.id}");
      }
    } catch (e) {
      print("Error fetching assignments for section ${section.id}: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grades"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/student'); // Navigate back
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0), // Adding padding for the list
        children: sections.map((section) {
          final assignments = sectionAssignments![section.id] ?? [];

          return Card(
            elevation: 4, // Add a shadow effect
            child: Padding(
              padding:
                  const EdgeInsets.all(12.0), // Add padding inside the card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.sectionID,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ...assignments.map((assignment) {
                    final assignmentData = assignment as Map<String, dynamic>;

                    final assignmentName =
                        assignmentData['name'] ?? 'Unknown Assignment';

                    String? grade;

                    for (var gradeData in assignmentData['grades']) {
                      final studentIDFromData = gradeData['studentID'];
                      if (studentIDFromData == studentID) {
                        grade = gradeData['grade'].toString();
                        break;
                      }
                    }

                    final studentGrade = grade ?? 'N/A';

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Vertical spacing
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            assignmentName,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            studentGrade,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
