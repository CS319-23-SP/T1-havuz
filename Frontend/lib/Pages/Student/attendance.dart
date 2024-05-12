import 'package:first_trial/Pages/Homepage/homepage.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:first_trial/Objects/section.dart';
import 'package:first_trial/Objects/student.dart';
import 'package:first_trial/token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({Key? key}) : super(key: key);

  @override
  _StudentAttendancePageState createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  List<Section> sections = []; // Sections student is enrolled in
  List<dynamic> attendanceRecords = []; // Attendance records for the student
  String? role = "unknown";
  String? id = "unknown";
  String? term = "2024 Spring";
  @override
  void initState() {
    super.initState();
    checkRole();
    _loadStudentSections();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    id = await TokenStorage.getID();
    setState(() {});
  }

  Future<void> _loadStudentSections() async {
    try {
      final studentID = await TokenStorage.getID();
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final response = await http.get(
        Uri.parse('http://localhost:8080/student/attendance/$studentID/$term'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> rawAttendanceRecords = data['attendance'];

        // Sort the attendance records by date
        rawAttendanceRecords.sort((a, b) {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateA.compareTo(dateB); // Sort in ascending order
        });

        setState(() {
          attendanceRecords = rawAttendanceRecords;
        });

        // Extract sections from sorted attendance records
        final sectionIDs =
            attendanceRecords.map((record) => record['sectionID']).toList();
        sections = sectionIDs.toSet().map((id) {
          return Section(
            id: id,
            sectionID: id.substring(
                0, id.length - 2), // Display without the last 2 digits
            term: "",
            quota: "",
            students: [],
            assignments: [],
            instructorID: "",
            material: [],
          );
        }).toList();
      } else {
        throw Exception("Failed to load attendance data.");
      }
    } catch (e) {
      print("Error loading student sections: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        children: [
          LeftBar(role: role),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: ListView(
                children: sections.map((section) {
                  // Get attendance records related to this section
                  final sectionAttendance = attendanceRecords
                      .where((record) => record['sectionID'] == section.id)
                      .toList();

                  return Card(
                    // Wrap each section in a Card

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            section.sectionID,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...sectionAttendance.asMap().entries.map((entry) {
                          final record = entry.value;
                          final index = entry.key;

                          final date =
                              DateTime.parse(record['date']); // Parse the date
                          final formattedDate =
                              "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

                          return Column(
                            children: [
                              ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // Ensure proper spacing
                                  children: [
                                    Text("Date: $formattedDate"),
                                    Text(
                                        "Attendance: ${record['hour']}/${record['totalHour']}"),
                                  ],
                                ),
                              ),
                              if (index <
                                  sectionAttendance.length -
                                      1) // Add divider if not the last item
                                Divider(),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
