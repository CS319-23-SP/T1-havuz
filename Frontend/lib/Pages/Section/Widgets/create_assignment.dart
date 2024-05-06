import 'dart:async';
import 'dart:ffi';

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
  final TextEditingController solutionKeyController = TextEditingController();
  final TextEditingController topicsController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final term = "2024 Spring";
  DateTime finalDay = DateTime(2024, 05, 31);
  String? role = "unknown";
  var deadline;
  var sectionId;
  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    sectionId = widget.sectionID;

    fetchQuestions();
    print("there");
    setState(() {});
  }

  void _createAssignment() async {
    final assignmentName = nameController.text;
    String solutionKey = solutionKeyController.text;
    String topics = topicsController.text;
    String text = textController.text;

    final url = Uri.parse('http://localhost:8080/student');

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
        'id': assignmentName,
        'term': term,
        'sectionID': sectionId,
        'deadline': deadline.toString(),
        'solutionKey': solutionKey,
        'questions': [],
        'grades': [
          {String: String}
        ]
      }),
    );
    if (response.statusCode == 200) {
      print('Student created successfully');
    } else {
      print('Failed to create student: ${response.reasonPhrase}');
    }
    GoRouter.of(context).go('/admin');
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
          print(questions.toString());
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

      if (question.courses.contains(sectionId)) {
        parsedQuestions.add(question);
        parsedQuestionTexts.add(question.text);
        print(question.text);
      }
    }
    setState(() {
      questions = parsedQuestions;
      questionsText = parsedQuestionTexts;
    });
  }

  final MultiSelectController _controller = MultiSelectController();

  late List<ValueItem> questionOptions = questionsText
      .map((question) => ValueItem(label: question, value: question))
      .toList();
  @override
  Widget build(BuildContext context) {
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
                              print(deadline);
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
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Assignment Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: solutionKeyController,
                      decoration: InputDecoration(
                        labelText: 'Assignment Solution Key',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: topicsController,
                      decoration: InputDecoration(
                        labelText: 'Assignment Topics',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: textController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Assignment Text',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        //createQuestion();
                      },
                      child: Text('Create Assignment'),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
