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

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    if (role != "instructor") {
      return;
    } else {
      getAssignmentById();
      fetchQuestions();
      setState(() {});
      questions.forEach((element) {print(element.id);});
    }
  }

  Future<void> fetchQuestions() async {
    String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

    assignment.questions.forEach((questionID) async{
      try {
      final response = await http.get(
        Uri.http('localhost:8080', '/question/$questionID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          parseQuestionsData(json.decode(response.body));
        });
      } else {
        throw Exception('Failed to fetch questions data');
      }
    } catch (e) {
      print('Error fetching questions: $e');
    }
    });
  }

  void parseQuestionsData(dynamic responseData) {
    List<Question> parsedQuestions = [];
    for (var questionData in responseData['questions'] as List<dynamic>) {
      final question = Question.fromJson(questionData);
      parsedQuestions.add(question);
    }
    setState(() {
      questions = parsedQuestions;
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
      print('Error fetching co3fjgsdh322urses: $e');
    }
    Assignment assignments = assignment;
  }

  List<Assignment> parseAssignmentData(dynamic responseData) {
    return (responseData as List<dynamic>)
        .map((assignmentData) => Assignment.fromJson(assignmentData))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        children: [
          LeftBar(role: role),
          Column(children: [
            Text(assignment.id),
            Text(assignment.sectionID),
            Text(assignment.solutionKey),
            Text(assignment.term),
            Text(assignment.questions.toString()),
          ])
        ],
      ),
    );
  }
}
