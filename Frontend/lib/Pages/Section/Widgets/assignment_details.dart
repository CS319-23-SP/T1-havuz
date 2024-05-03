import 'dart:convert';

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
  });

  final String assignmentID, sectionID;

  @override
  State<Assignment_Details> createState() => _Assignment_DetailsState();
}

class _Assignment_DetailsState extends State<Assignment_Details> {
  String term = "2024 Spring";
  Assignment assignment = Assignment(
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

<<<<<<< HEAD
    if (role != "instructor") {
      return;
    } else {
      await getAssignmentById();
      await fetchQuestions();
=======
    if (role == "instructor") {
      await getAssignmentAndQuestions();
>>>>>>> 17504358e959ba5e3346018e313fc8517fd5bc32
      setState(() {});
    }
  }

  Future<void> fetchQuestions() async {
    String? token = await TokenStorage.getToken();
<<<<<<< HEAD
      if (token == null) {
        throw Exception('Token not found');
      }

      for (var i = 0; i < assignment.questions.length; i++) {
      var questionID = assignment.questions[i];
=======
    if (token == null) {
      throw Exception('Token not found');
    }
    await Future.forEach(assignment.questions, (questionID) async {
>>>>>>> 17504358e959ba5e3346018e313fc8517fd5bc32
      try {
        final response = await http.get(
          Uri.http('localhost:8080', '/question/$questionID'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
<<<<<<< HEAD
          setState(() {
            parseQuestionsData(json.decode(response.body));
          });
=======
          parseQuestionsData(json.decode(response.body));
>>>>>>> 17504358e959ba5e3346018e313fc8517fd5bc32
        } else {
          throw Exception('Failed to fetch questions data');
        }
      } catch (e) {
        print('Error fetching questions: $e');
      }
<<<<<<< HEAD
      }
  }

  void parseQuestionsData(dynamic responseData) {
    List<Question> parsedQuestions = questions;
    final question = Question.fromJson(responseData["question"]);
    parsedQuestions.add(question);
    setState(() {
      questions = parsedQuestions;
    });
=======
    });
  }

  void parseQuestionsData(dynamic responseData) async {
    final question = Question.fromJson(responseData['question']);
    questions.add(question);
    print(question.text);
>>>>>>> 17504358e959ba5e3346018e313fc8517fd5bc32
  }

  Future<void> getAssignmentById() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? instructorID = await TokenStorage.getID();
      String? sectionID = widget.sectionID;

      final response = await http.get(
        Uri.http('localhost:8080', '/assignment/instructor/$term/$sectionID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            assignment = parseAssignmentData(responseData['assignments'])[0];
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

  List<Assignment> parseAssignmentData(dynamic responseData) {
    return (responseData as List<dynamic>)
        .map((assignmentData) => Assignment.fromJson(assignmentData))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
              ],
            ),
          ),
        ],
  ),
);
=======
    if (role == "instructor") {
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
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Placeholder();
  }
>>>>>>> 17504358e959ba5e3346018e313fc8517fd5bc32
}
  
}