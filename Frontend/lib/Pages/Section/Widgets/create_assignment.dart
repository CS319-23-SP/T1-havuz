import 'dart:async';

import 'package:first_trial/Objects/question.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAssignmentPage extends StatefulWidget {
  const CreateAssignmentPage({Key? key, required this.sectionID})
      : super(key: key);
  final String sectionID;

  @override
  _CreateAssignmentPageState createState() => _CreateAssignmentPageState();
}

class _CreateAssignmentPageState extends State<CreateAssignmentPage> {
  final TextEditingController nameController = TextEditingController();
  late String? term = "2024 Spring";
  var deadline;
  late String? role;
  late String? sectionId;
  late String? courseId;

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    sectionId = widget.sectionID;
    courseId = sectionId!.split('-').first;
    fetchQuestions();
  }

  void _createAssignment(List<String> questionIDs, List<int?> weights) async {
    if (deadline != null) {
      deadline = deadline.toString().split(' ').first;

      final url = Uri.parse('http://localhost:8080/assignment');

      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      print(weights);
      print("questions: ${questionIDs}");
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
          'weights': weights,
          'name': nameController.text,
        }),
      );
      if (response.statusCode == 200) {
        print('Assignment created successfully');
      } else {
        print('Failed to create assignment: ${response.reasonPhrase}');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Deadline'),
            content: Text('Please select a deadline for the assignment.'),
          );
        },
      );
    }
  }

  List<Question> questions = [];
  List<String> questionsText = [];
  List<String> selectedQuestions = [];
  List<int?> weights = [];

  Future<void> fetchQuestions() async {
    try {
      term = "2024 Spring";
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
        parseQuestionsData(json.decode(response.body));
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

  @override
  Widget build(BuildContext context) {
    if (questionsText.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        children: [
          LeftBar(role: role),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Assignment Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Select Questions:'),
                  MultiSelectDropDown(
                    onOptionSelected: (List<ValueItem> selectedOptions) {
                      setState(() {
                        selectedQuestions = selectedOptions
                            .map((option) => option.value as String)
                            .toList();
                        // Initialize weights with null for selected questions
                        weights =
                            List<int?>.filled(selectedQuestions.length, null);
                      });
                    },
                    options: questionsText
                        .map((question) =>
                            ValueItem(label: question, value: question))
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  Text('Select Deadline:'),
                  InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
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
                        border: Border.all(color: Colors.black),
                      ),
                      padding: EdgeInsets.all(15),
                      child: Text(
                        deadline != null
                            ? 'Deadline: ${DateFormat('dd-MM-yyyy').format(deadline!)}'
                            : 'Select Deadline',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Enter Weights:'),
                  ...List.generate(selectedQuestions.length, (index) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(selectedQuestions[index]),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Weight',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              // Update weights list when input changes
                              setState(() {
                                weights[index] = int.tryParse(value);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Extract question IDs based on their text
                        List<String> questionIDs =
                            selectedQuestions.map((questionText) {
                          return questions
                              .firstWhere(
                                  (question) => question.text == questionText)
                              .id;
                        }).toList();
                        _createAssignment(questionIDs, weights);
                      },
                      child: Text('Create Assignment'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
