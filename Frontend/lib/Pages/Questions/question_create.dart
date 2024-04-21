import 'package:first_trial/Pages/Widgets/access_denied.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Widgets/success_fail.dart';
import 'package:go_router/go_router.dart';

class AddQuestionPage extends StatefulWidget {
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  List<String> selectedCourses = [];
  List<String> courses = ['CS101', 'CS102', 'CS103'];
  bool showCoursesList = false;

  final TextEditingController headerController = TextEditingController();
  final TextEditingController topicsController = TextEditingController();
  final TextEditingController creatorIDController = TextEditingController();
  final TextEditingController textController = TextEditingController();

String? role = "unknown";    

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    setState(() {});
  }

  void clearInputs() {
    setState(() {
      selectedCourses.clear();
      headerController.clear();
      topicsController.clear();
      creatorIDController.clear();
      textController.clear();
    });
  }

  void createQuestion() async {
    final header = headerController.text;
    final topics = topicsController.text
        .split(',')
        .map((topic) => topic.trim())
        .where((topic) => topic.isNotEmpty)
        .toList();
    final creatorID = creatorIDController.text;
    final text = textController.text;
    final toughness = "5";

    final url = Uri.parse('http://localhost:8080/question');

    Map<String, dynamic> requestBody = {
      'courses': selectedCourses,
      'header': header,
      'topics': topics,
      'creatorID': creatorID,
      'text': text,
      'toughness': toughness
    };

    String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SuccessWidget(
            context: context,
            onDismiss: () {
              clearInputs();
            },
          );
        },
      );
    } else {
      print('Failed to create question: ${response.reasonPhrase}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FailWidget(
            context: context,
            onDismiss: () {
              clearInputs();
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (role != 'instructor') {
      return AccessDeniedPage();
    }
    else{
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    showCoursesList = !showCoursesList;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Courses:',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              if (showCoursesList)
                Column(
                  children: courses.map((course) {
                    return CheckboxListTile(
                      title: Text(course),
                      value: selectedCourses.contains(course),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null && value) {
                            selectedCourses.add(course);
                          } else {
                            selectedCourses.remove(course);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: headerController,
                decoration: InputDecoration(
                  labelText: 'Question Header',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: topicsController,
                decoration: InputDecoration(
                  labelText: 'Question Topics',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: creatorIDController,
                decoration: InputDecoration(
                  labelText: 'Creator ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: textController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Question Text',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  createQuestion();
                },
                child: Text('Create Question'),
              ),
              Container(
                width: 60,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    GoRouter.of(context).go('/instructor/question');
                  },
                ),
              ),]
          ),
        ),
      ),
    );
  }}
}
