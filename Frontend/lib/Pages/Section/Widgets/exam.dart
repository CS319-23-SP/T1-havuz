import 'package:flutter/material.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/token.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'dart:convert';

class ExamPage extends StatefulWidget {
  final String sectionID;

  const ExamPage({Key? key, required this.sectionID}) : super(key: key);

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  TextEditingController studentIDController = TextEditingController();
  TextEditingController midtermGradeController = TextEditingController();
  TextEditingController finalGradeController = TextEditingController();
  String? role;
  String? token;
  List<String>? studentIDs;

  @override
  void initState() {
    super.initState();
    checkRole();
    fetchSectionData();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    token = await TokenStorage.getToken();
  }

  Widget buildStudentIDButtons() {
    if (studentIDs == null || studentIDs!.isEmpty) {
      return SizedBox.shrink();
    }

    return Wrap(
      spacing: 8.0,
      children: studentIDs!.map((id) {
        return ElevatedButton(
          onPressed: () {
            studentIDController.text = id;
          },
          child: Text(id),
        );
      }).toList(),
    );
  }

  Future<void> fetchSectionData() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final courseID =
          widget.sectionID.substring(0, widget.sectionID.length - 2);
      final term = "2024 Spring";
      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/section/${widget.sectionID}/$term/$courseID'),
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

  Future<void> submitMidtermGrade() async {
    String studentID = studentIDController.text;
    String midtermGrade = midtermGradeController.text;

    // Validate input
    if (studentID.isEmpty || midtermGrade.isEmpty) {
      // Show error message if any field is empty
      flashError(context, 'Please fill in all fields');
      return;
    }
    bool exist = false;
    for (var id in studentIDs!) {
      if (id == studentID) {
        exist = true;
      }
    }
    if (!exist) {
      flashError(context, 'Please enter valid student ID');
      return;
    }
    // Check if the midterm grade is a valid number between 0 and 100
    double? midtermGradeValue = double.tryParse(midtermGrade);
    if (midtermGradeValue == null ||
        midtermGradeValue < 0 ||
        midtermGradeValue > 100) {
      // Show error message if midterm grade is not valid
      flashError(context, 'Midterm grade must be a number between 0 and 100');
      return;
    }

    // Send HTTP request to update midterm grade
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/section/${widget.sectionID}/midterm'),
        body: json.encode({
          'studentID': studentID,
          'grade': midtermGrade,
          'term': "2024 Spring",
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Midterm grade updated successfully
        flashSuccess(context, 'Midterm grade updated successfully');
      } else {
        // Error updating midterm grade
        print('Error updating midterm grade');
      }
    } catch (error) {
      // Error sending HTTP request
      print('Error sending HTTP request: $error');
    }
  }

  Future<void> submitFinalGrade() async {
    String studentID = studentIDController.text;
    String finalGrade = finalGradeController.text;

    // Validate input
    if (studentID.isEmpty || finalGrade.isEmpty) {
      // Show error message if any field is empty
      flashError(context, 'Please fill in all fields');
      return;
    }
    bool exist = false;
    for (var id in studentIDs!) {
      if (id == studentID) {
        exist = true;
      }
    }
    if (!exist) {
      flashError(context, 'Please enter valid student ID');
      return;
    }
    // Check if the final grade is a valid number between 0 and 100
    double? finalGradeValue = double.tryParse(finalGrade);
    if (finalGradeValue == null ||
        finalGradeValue < 0 ||
        finalGradeValue > 100) {
      // Show error message if final grade is not valid
      flashError(context, 'Final grade must be a number between 0 and 100');
      return;
    }

    // Send HTTP request to update final grade
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/section/${widget.sectionID}/final'),
        body: json.encode({
          'studentID': studentID,
          'grade': finalGrade,
          'term': "2024 Spring",
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Final grade updated successfully
        flashSuccess(context, 'Final grade updated successfully');
      } else {
        // Error updating final grade
        print('Error updating final grade');
      }
    } catch (error) {
      // Error sending HTTP request
      print('Error sending HTTP request: $error');
    }
  }

  void flashError(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        padding: const EdgeInsets.all(20.0),
        height: 90,
        margin: const EdgeInsetsDirectional.fromSTEB(200, 0, 200, 0),
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 48,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sorry!',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 3),
    ));
  }

  void flashSuccess(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        padding: const EdgeInsets.all(20.0),
        height: 90,
        margin: const EdgeInsetsDirectional.fromSTEB(200, 0, 200, 0),
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 48,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Success!',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: 'role'), // Replace 'role' with actual role
      body: Row(
        children: [
          LeftBar(role: 'role'), // Replace 'role' with actual role
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exam Page',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text('Student ID:'),
                  TextField(controller: studentIDController),
                  SizedBox(height: 10),
                  Text('Midterm Grade:'),
                  TextField(controller: midtermGradeController),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: submitMidtermGrade,
                    child: Text('Submit Midterm Grade'),
                  ),
                  SizedBox(height: 20),
                  Text('Final Grade:'),
                  TextField(controller: finalGradeController),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: submitFinalGrade,
                    child: Text('Submit Final Grade'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: buildStudentIDButtons(),
          ),
        ],
      ),
    );
  }
}
