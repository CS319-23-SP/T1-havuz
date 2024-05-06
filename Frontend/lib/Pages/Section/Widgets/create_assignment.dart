import 'dart:async';

import 'package:first_trial/Objects/question.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAssignmentPage extends StatefulWidget {
  const CreateAssignmentPage({super.key, required this.sectionID});
  final String sectionID;

  @override
  State<CreateAssignmentPage> createState() => _CreateAssignmentPageState();
}

class _CreateAssignmentPageState extends State<CreateAssignmentPage> {
  final TextEditingController nameController = TextEditingController();
  final term = "2024 Spring";
  DateTime finalDay = DateTime(2024, 05, 31);
  String? role = "unknown";
  var deadline;
  var sectionId;
  var courseId;
  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    sectionId = widget.sectionID;
    courseId = sectionId.split('-').first;

    fetchQuestions();
    setState(() {});
  }

  void _createAssignment(List<String> questionIDs) async {
    deadline = deadline.toString().split(' ').first;

    final url = Uri.parse('http://localhost:8080/assignment');

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
      body: json.encode({
        'term': term,
        'sectionID': sectionId,
        'deadline': deadline,
        'questions': questionIDs,
        'name': nameController.text
      }),
    );
    if (response.statusCode == 200) {
      print('Assignment created successfully');
    } else {
      print('Failed to create assignment: ${response.reasonPhrase}');
    }
    GoRouter.of(context).go('/instructor');
    
  }

  List<Question> questions = [];
  List<String> questionsText = [];
  List<String> selectedCourses = [];

  Future<void> fetchQuestions() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.http('localhost:8080', '/question/'),
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
  }

  void parseQuestionsData(dynamic responseData) {
    List<Question> parsedQuestions = [];
    List<String> parsedQuestionTexts = [];
    for (var questionData in responseData['questions'] as List<dynamic>) {
      final question = Question.fromJson(questionData);

      if (question.courses.contains(courseId)) {
        parsedQuestions.add(question);
        parsedQuestionTexts.add(question.text);
      }
    }
    setState(() {
      questions = parsedQuestions;
      questionsText = parsedQuestionTexts;
    });
  }

  final MultiSelectController _controller = MultiSelectController();

  @override
  Widget build(BuildContext context) {
    if (questionsText.isEmpty) {
      return CircularProgressIndicator(); 
    }
    late List<ValueItem> questionOptions = questionsText
        .map((question) => ValueItem(label: question, value: question))
        .toList();
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        children: [
          LeftBar(role: role),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          GoRouter.of(context).go('/instructor');
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Assignment Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MultiSelectDropDown(
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        setState(() {
                          selectedCourses.clear();
                          selectedCourses.addAll(selectedOptions
                              .map((option) => option.value as String));
                        });
                      },
                      options: questionOptions,
                      controller: _controller,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            setState(() {
                              deadline = pickedDate;
                            });
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            deadline != null
                                ? 'Deadline: ${DateFormat('dd-MM-yyyy').format(deadline!)}'
                                : 'Deadline',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton(
                      onPressed: () {
                        List<String> selectedQuestionIDS = [];
                        selectedCourses.forEach((questionText) => 
                          questions.forEach((question) {
                            if(question.text == questionText)
                              selectedQuestionIDS.add(question.id);
                           })
                        );
                        _createAssignment(selectedQuestionIDS);
                      },
                      child: Text('Create Assignment'),
                    ),
                    )
                  ]),
            ),
          ),
        ],
    ),
);
}
}
