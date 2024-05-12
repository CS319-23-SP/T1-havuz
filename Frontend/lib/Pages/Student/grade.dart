import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
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
  Map<String, String> midtermGrades = {};
  Map<String, String> finalGrades = {};

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
            await _fetchAssignmentsForSection(section);
            await _fetchMidtermGrade(section.id);
            await _fetchFinalGrade(section.id);
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

  Future<void> _fetchAssignmentsForSection(Section section) async {
    try {
      final token = await TokenStorage.getToken();

      final response = await http.get(
        Uri.parse('http://localhost:8080/assignment/$term/${section.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Filter assignments to only include those with grades for the student
        final filteredAssignments = (responseData['assignments'] as List)
            .where((assignment) => (assignment['grades'] as List).any(
                (gradeData) =>
                    gradeData['studentID'] == studentID &&
                    gradeData['grade'] != null))
            .toList();

        sectionAssignments![section.id] = filteredAssignments;
      } else {
        throw Exception(
            "Failed to fetch assignments for section ${section.id}");
      }
    } catch (e) {
      print("Error fetching assignments for section ${section.id}: $e");
    }
  }

  Future<void> _fetchMidtermGrade(String sectionID) async {
    try {
      final token = await TokenStorage.getToken();

      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/section/midterm/$studentID/$sectionID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(sectionID);
      print(studentID);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success']) {
          print(responseData.toString());

          final grade = responseData['grade'].toString();
          midtermGrades[sectionID] = grade;
        } else {
          midtermGrades[sectionID] = 'N/A';
        }
      } else {
        throw Exception("Failed  midterm grade for section $sectionID");
      }
    } catch (e) {
      print("Error midterm grade for section $sectionID: $e");
    }
  }

  Future<void> _fetchFinalGrade(String sectionID) async {
    try {
      final token = await TokenStorage.getToken();

      final response = await http.get(
        Uri.parse('http://localhost:8080/section/$studentID/$sectionID/final'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          print(responseData.toString());
          final grade = responseData['grade'].toString();
          finalGrades[sectionID] = grade;
        } else {
          finalGrades[sectionID] = 'N/A';
        }
      } else {
        throw Exception("Failed final grade for section $sectionID");
      }
    } catch (e) {
      print("Error final grade for section $sectionID: $e");
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
                  Text('Midterm Grade: ${midtermGrades[section.id] ?? "N/A"}'),
                  Text('Final Grade: ${finalGrades[section.id] ?? "N/A"}'),
                  const Divider(),
                  ...assignments.map((assignment) {
                    final assignmentData = assignment as Map<String, dynamic>;

                    final assignmentName =
                        assignmentData['name'] ?? 'Unknown Assignment';

                    // Get the grade for the student
                    final studentGrade = assignmentData['grades']
                        .firstWhere(
                            (gradeData) => gradeData['studentID'] == studentID,
                            orElse: () => {'grade': 'N/A'})['grade']
                        .toString();

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
