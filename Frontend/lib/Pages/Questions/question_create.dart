import 'dart:async';

import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/Pages/Widgets/access_denied.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'dart:convert';
import '../Widgets/success_fail.dart';
import 'package:go_router/go_router.dart';

class AddQuestionPage extends StatefulWidget {
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  List<String> selectedCourses = [];
  List<String> courses = [
    'CS101',
    'CS102',
    'CS103',
    'CS104',
    'CS1053',
    'CS1062',
    'CS1203',
    'CS1032',
    'CS1403',
    'CS1502',
    'CS1303'
  ];
  bool showCoursesList = false;

  final TextEditingController headerController = TextEditingController();
  final TextEditingController topicsController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  String? role = "unknown";
  String? id = "unknown";
  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    id = await TokenStorage.getID();
    setState(() {});
  }

  void clearInputs() {
    setState(() {
      selectedCourses.clear();
      headerController.clear();
      topicsController.clear();
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
    final creatorID = id;
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

  String dropdownValue = "";
  late List<ValueItem> courseOptions =
      courses.map((course) => ValueItem(label: course, value: course)).toList();

  final MultiSelectController _controller = MultiSelectController();
  @override
  Widget build(BuildContext context) {
    if (role == 'student') {
      return AccessDeniedPage();
    } else {
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
                    children: [
                      MultiSelectDropDown(
                        onOptionSelected: (List<ValueItem> selectedOptions) {
                          setState(() {
                            selectedCourses.clear();
                            selectedCourses.addAll(selectedOptions
                                .map((option) => option.value as String));
                          });
                        },
                        options: courseOptions,
                        controller: _controller,
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
                      ),
                    ]),
              ),
            ),
          ],
        ),
      );
    }
  }
}
