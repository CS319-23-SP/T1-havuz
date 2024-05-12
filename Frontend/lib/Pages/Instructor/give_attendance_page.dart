import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/Objects/section.dart';
import 'package:first_trial/Objects/student.dart';
import 'package:first_trial/Pages/Homepage/homepage.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:first_trial/token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GiveAttendancePage extends StatefulWidget {
  const GiveAttendancePage({Key? key}) : super(key: key);

  @override
  _GiveAttendancePageState createState() => _GiveAttendancePageState();
}

class _GiveAttendancePageState extends State<GiveAttendancePage> {
  String? selectedSection; // Selected section ID
  List<Section> sections = []; // List of sections
  List<Student> students = []; // List of students in the selected section
  Map<String, bool> studentAttendance = {}; // To track if a student is present
  DateTime selectedDate = DateTime.now(); // Default to today's date
  String? role = "unknown";
  String? term = "2024 Spring";
  var histories = [[], []];
  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    fetchSections();
    setState(() {});
  }

  Future<void> fetchSections() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();
      String? term = PoolTerm.term;

      final response = await http.get(
        Uri.http('localhost:8080', '/section/$ID/$term'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            sections = parseSectionsData(responseData['section']);
          });
        } else {
          throw Exception('Failed to fetch sections data');
        }
      } else {
        throw Exception('Failed to fetch sections data');
      }
    } catch (e) {
      print('Error fetching sections: $e');
    }
  }

  List<Section> parseSectionsData(dynamic responseData) {
    return (responseData as List<dynamic>)
        .map((sectionData) => Section.fromJson(sectionData))
        .toList();
  }

  void _loadStudentsForSection(String sectionID) {
    final Section? selectedSection = sections.firstWhere(
      (section) => section.id == sectionID,
    );

    if (selectedSection != null) {
      setState(() {
        students = selectedSection.students.map((studentID) {
          return Student(
            id: studentID,
            name: studentID,
            courses: [],
          );
        }).toList();

        studentAttendance = Map.fromIterable(
          students,
          key: (student) => student.id,
          value: (student) => false,
        );
      });
    } else {
      print("Section not found with ID: $sectionID");
    }
  }

  void _submitAttendance() async {
    print(
        "Submit button pressed"); // Check if this is printed when you press the button

    final attendanceData = studentAttendance.entries.map((entry) {
      return {
        "studentID": entry.key,
        "sectionID": selectedSection,
        "date": selectedDate.toIso8601String(),
        "hour": entry.value ? 2 : 0,
        "totalHour": 2,
      };
    }).toList();
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final response = await http.post(
        Uri.parse('http://localhost:8080/instructor/give-attendance/${term}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({"attendances": attendanceData}),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Attendance submitted successfully."),
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to submit attendance."),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("Error during submission: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error during submission."),
          duration: const Duration(seconds: 1),
        ),
      );
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
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownButton<String>(
                      hint: Text("Select Section"),
                      value: selectedSection,
                      items: sections.map((section) {
                        return DropdownMenuItem(
                          child: Text(section.sectionID),
                          value: section.id,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSection = value;
                          _loadStudentsForSection(value!);
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (selected != null) {
                          setState(() {
                            selectedDate = selected;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month),
                          Text("Select Date"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 48.0), // Move button up by adding space
                      child: ElevatedButton(
                        onPressed: _submitAttendance,
                        child: Text("Submit"),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(50),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        const ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Student ID",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Present",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: CheckboxListTile(
                                  title: Text(student.name),
                                  value: studentAttendance[student.id],
                                  onChanged: (value) {
                                    setState(() {
                                      studentAttendance[student.id] = value!;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
