import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:first_trial/token.dart';
import 'package:go_router/go_router.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/roles/instructor_appbar.dart';
import 'package:intl/intl.dart';

class AssignmentGradePage extends StatefulWidget {
  final String role;
  final String assignmentID;
  final String sectionID;
  final String term;

  const AssignmentGradePage({
    Key? key,
    required this.role,
    required this.assignmentID,
    required this.sectionID,
    required this.term,
  }) : super(key: key);

  @override
  _AssignmentGradePageState createState() => _AssignmentGradePageState();
}

class _AssignmentGradePageState extends State<AssignmentGradePage> {
  TextEditingController studentIDController = TextEditingController();
  List<TextEditingController> questionControllers = [];

  Map<String, dynamic>? assignmentData;
  List<dynamic>? sectionData = [[], []];

  List<String>? studentIDs;

  @override
  void initState() {
    super.initState();
    fetchAssignmentData();
    fetchSectionData();
  }

  Future<void> fetchAssignmentData() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/assignment/${widget.assignmentID}/${widget.term}/${widget.sectionID}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          assignmentData = json.decode(response.body)['assignment'];
          initializeQuestionControllers(); // Initialize input boxes
        });
      }
    } catch (error) {
      print('Error fetching assignment data: $error');
    }
  }

  Future<void> fetchSectionData() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final courseID =
          widget.sectionID.substring(0, widget.sectionID.length - 2);

      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/section/${widget.sectionID}/${widget.term}/$courseID'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final section = json.decode(response.body)['section'];
        setState(() {
          studentIDs = section[0]['students']
              .map<String>(
                  (studentID) => studentID.toString()) // Ensure string type
              .toList();
        });
      }
    } catch (error) {
      print('Error fetching section data: $error');
    }
  }

  void initializeQuestionControllers() {
    if (assignmentData != null) {
      final int questionCount = assignmentData!['questions'].length;
      questionControllers =
          List.generate(questionCount, (_) => TextEditingController());
    }
  }

  void onStudentIDButtonPressed(String studentID) {
    studentIDController.text = studentID; // Set the studentID in the input box
  }

  Future<void> onSubmit() async {
    final studentID = studentIDController.text;
    int size = studentIDs!.length;
    bool exists = false;
    for (var i = 0; i < size; i++) {
      if (studentID == studentIDs![i]) {
        exists = true;
      }
    }
    if (!exists) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
            padding: const EdgeInsets.all(20.0),
            height: 90,
            margin: const EdgeInsetsDirectional.fromSTEB(200, 0, 200, 0),
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sorry!',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      Text(
                        'Invalid Student ID',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            )),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 3),
      ));
      return;
    }
    if (assignmentData != null && studentID.isNotEmpty) {
      final List<dynamic> weights = assignmentData!['weights'];
      final List<double> grades = [];

      for (int i = 0; i < questionControllers.length; i++) {
        final weight = weights[i];
        final point = int.tryParse(questionControllers[i].text) ??
            0; // Default to 0 if invalid
        if (weight < point || 0 > point) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Container(
                padding: const EdgeInsets.all(20.0),
                height: 90,
                margin: const EdgeInsetsDirectional.fromSTEB(200, 0, 200, 0),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 48,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sorry!',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          Text(
                            'Invalid question points',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
            duration: const Duration(seconds: 3),
          ));
          return;
        }
      }
      for (int i = 0; i < questionControllers.length; i++) {
        final weight = weights[i];
        final point = int.tryParse(questionControllers[i].text) ??
            0; // Default to 0 if invalid
        final grade = (point * 100) / weight;

        // Send grade to update the question's history
        final questionID = assignmentData!['questions'][i];
        await updateQuestionHistory(questionID, studentID, grade);
        grades.add(grade);
      }

      final totalWeight = weights.reduce((a, b) => a + b);
      final totalPoints = questionControllers
          .map((c) => int.tryParse(c.text) ?? 0)
          .reduce((a, b) => a + b);
      final finalGrade = (totalPoints * 100) / totalWeight;

      // Update the assignment's grade
      await updateAssignmentGrade(widget.assignmentID, widget.term,
          widget.sectionID, studentID, finalGrade);
    }
    fetchAssignmentData();
  }

  int? findGradeByStudentID(String studentID) {
    for (Map<String, dynamic> grade in assignmentData!['grades']) {
      if (grade['studentID'] == studentID) {
        return grade['grade'];
      }
    }
    return null;
  }

  Future<void> updateQuestionHistory(
      String questionID, String studentID, double grade) async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      await http.put(
        Uri.parse('http://localhost:8080/question/update-history/$questionID'),
        body: json.encode({
          'studentID': studentID,
          'grade': grade.toString(),
          'term': "2024 Spring",
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (error) {
      print('Error updating question history: $error');
    }
  }

  Future<void> updateAssignmentGrade(String assignmentID, String term,
      String sectionID, String studentID, double grade) async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      print(assignmentID);
      print(term);
      print(sectionID);
      print(studentID);
      print(grade.toStringAsFixed(1));
      print(grade.toStringAsFixed(0));
      await http.put(
        Uri.parse(
            'http://localhost:8080/assignment/$assignmentID/$term/$sectionID/$studentID'),
        body: json.encode({
          'grade': grade.toStringAsFixed(0).toString(),
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (error) {
      print('Error updating assignment grade: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignmentID = widget.assignmentID;

    return Scaffold(
      appBar: CustomAppBar(role: widget.role),
      body: Row(
        children: [
          LeftBar(role: widget.role), // Left bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Assignment : ${assignmentData?['name']}', // Page title
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (studentIDs != null)
                            ...studentIDs!.asMap().entries.map((entry) {
                              final index = entry.key;
                              final studentID = entry.value;

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            onStudentIDButtonPressed(studentID),
                                        child: Text(studentID),
                                      ),
                                      SizedBox(
                                          width:
                                              30.0), // Add space between the button and the text
                                      Expanded(
                                        child: findGradeByStudentID(
                                                    studentID) !=
                                                null
                                            ? Text(
                                                "Assignment Grade: ${findGradeByStudentID(studentID)}")
                                            : Text(
                                                "Assignment Grade: Not Given"),
                                      ),
                                    ],
                                  ),
                                  if (index <
                                      studentIDs!.length -
                                          1) // Check if it's not the last item
                                    SizedBox(
                                        height: 20.0), // Add space between rows
                                ],
                              );
                            }).toList(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: studentIDController,
                            decoration:
                                InputDecoration(labelText: 'Student ID'),
                          ),
                          ...questionControllers.asMap().entries.map((entry) {
                            final index = entry.key;
                            return TextField(
                              controller: entry.value,
                              decoration: InputDecoration(
                                labelText:
                                    'Question ${index + 1} Point (0-${assignmentData!['weights'][index]})',
                              ),
                              keyboardType: TextInputType.number,
                            );
                          }).toList(),
                          ElevatedButton(
                            onPressed: onSubmit,
                            child: Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
