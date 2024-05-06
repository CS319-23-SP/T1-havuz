import 'dart:convert';
import 'package:file_picker/file_picker.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:first_trial/Objects/assignment.dart';
import 'package:first_trial/Objects/question.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Assignment_Details extends StatefulWidget {
  const Assignment_Details({
    super.key,
    this.assignmentID = "",
    this.sectionID = "",
    this.role = "",
  });

  final String assignmentID, sectionID, role;

  @override
  State<Assignment_Details> createState() => _Assignment_DetailsState();
}

class _Assignment_DetailsState extends State<Assignment_Details> {
  String term = "2024 Spring";
  Assignment assignment = Assignment(
      name: "nonigga",
      term: "term",
      sectionID: "sectionID",
      questions: ["questions"],
      deadline: "deadline");
  String? role = "unknown";

  List<Question> questions = [];

  Future<void> getAssignmentAndQuestions() async {
    await getAssignmentById();
    await fetchQuestions();
  }

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    await getAssignmentAndQuestions();
    setState(() {});
  }

  Future<void> fetchQuestions() async {
    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    await Future.forEach(assignment.questions, (questionID) async {
      try {
        final response = await http.get(
          Uri.http('localhost:8080', '/question/$questionID'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          parseQuestionsData(json.decode(response.body));
        } else {
          throw Exception('Failed to fetch questions data');
        }
      } catch (e) {
        print('Error fetching questions: $e');
      }
    });
  }

  void parseQuestionsData(dynamic responseData) {
    final question = Question.fromJson(responseData['question']);
    setState(() {
      questions.add(question);
    });
  }

  Future<void> getAssignmentById() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? instructorID = await TokenStorage.getID();
      String? sectionID = widget.sectionID;
      String assID = widget.assignmentID;
      print('/assignment/$assID/$term/$sectionID');

      final response = await http.get(
        Uri.http('localhost:8080', '/assignment/$assID/$term/$sectionID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            assignment = parseAssignmentData(responseData['assignment']);
          });
        } else {
          throw Exception('Failed to fetch courses data');
        }
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  Assignment parseAssignmentData(dynamic json) {
    return Assignment(
      name: json['name'],
      id: json['id'].toString(),
      term: json['term'].toString(),
      sectionID: json['sectionID'].toString(),
      deadline: json['deadline'].toString(),
      questions: List<String>.from(json['questions']),
      solutionKey: json['solutionKey'].toString(),
    );
  }

  List<String> uploadedFiles = [];

  void _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      // Upload the file to server or save locally
      // For simplicity, let's just add it to the list
      setState(() {
        uploadedFiles.add(file.path);
      });
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Assignment Details",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("ID: ${assignment.id}"),
                Text("Section ID: ${assignment.sectionID}"),
                Text("Solution Key: ${assignment.solutionKey}"),
                Text("Term: ${assignment.term}"),
                if (role == "student") ...[
                  TextButton(
                    onPressed: () {
                      _uploadFile();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.upload),
                        Text("Upload File"),
                      ],
                    ),
                  )
                ],
                SizedBox(height: 20),
                Text("Questions:",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          questions[index].text,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: uploadedFiles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(uploadedFiles[index]),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*Future uploadPdf() async {
    var dio = Dio();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path ?? " ");

      String filename = file.path.split("/").last;
      String filepath = file.path;

      FormData data = FormData.fromMap({
        'x-api-key': 'apikey',
        'file': await MultipartFile.fromFile(filepath, filename: filename),
      });
      var response = dio.post("")
    }
  }*/
}
