import 'package:first_trial/Objects/question.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/AppBars/roles/instructor_appbar.dart';
import 'package:first_trial/Pages/Widgets/access_denied.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'question_create.dart';
import 'package:go_router/go_router.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> list = <String>[
  'All',
  '2018-2019 Fall',
  '2019-2020 Fall',
  '2019-2020 Spring',
  '2020-2021 Fall',
];

class QuestionHomepage extends StatefulWidget {
  const QuestionHomepage({super.key});

  @override
  State<QuestionHomepage> createState() => _QuestionHomepageState();
}

class _QuestionHomepageState extends State<QuestionHomepage> {
  final TextEditingController _QIDController = TextEditingController();
  final TextEditingController _CourseController = TextEditingController();
  //final QIDController = TextEditingController();
  final TextEditingController _KeywordController = TextEditingController();

  List<Question> questions = [];

  String? role = "unknown";

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    if (role == "instructor") {
      fetchQuestions();
      setState(() {});
    } else {
      return;
    }
  }

  void searchQuestions() async {
    final id = int.tryParse(_QIDController.text);
    final courses = _CourseController.text;
    final keyword = _KeywordController.text;

    Map<String, dynamic> queryData = {};

    if (id != null) {
      queryData['id'] = id.toString();
    }
    if (courses.isNotEmpty) {
      queryData['courses'] = courses;
    }
    if (keyword.isNotEmpty) {
      queryData['topics'] = keyword;
    }
    if (dropdownValue.isNotEmpty) {
      queryData['pastExams'] = dropdownValue;
    }

    if (queryData.isEmpty) {
      fetchQuestions();
      return;
    }

    final url = Uri.http('localhost:8080', '/question/search');

    try {
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
        body: json.encode(queryData),
      );

      if (response.statusCode == 200) {
        setState(() {
          parseQuestionsData(json.decode(response.body));
        });
      } else {
        throw Exception('Failed to fetch question data');
      }
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }

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
    for (var questionData in responseData['questions'] as List<dynamic>) {
      final question = Question.fromJson(questionData);
      parsedQuestions.add(question);
    }
    setState(() {
      questions = parsedQuestions;
    });
  }

  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (role != 'instructor') {
      return AccessDeniedPage();
    }
    //controllers
    else {
      return Scaffold(
        appBar: const InstructorAppBar(),
        body: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(screenHeight / 7),
              child: Row(
                children: [
                  SizedBox(
                    width: 2 * (screenWidth / 7) / 14,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: PoolColors.cardWhite,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: SizedBox(
                      width: screenWidth / 4,
                      height: 3 * (screenHeight / 4),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: PoolColors.black),
                                  color: PoolColors.fairTurkuaz,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: TextField(
                                  controller: _QIDController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: "Question ID",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: PoolColors.black),
                                  color: PoolColors.fairTurkuaz,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: TextField(
                                  controller: _CourseController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: "Course",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                  color: PoolColors.fairTurkuaz,
                                  border: Border.all(color: PoolColors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: DropdownMenu<String>(
                                width: 430,
                                inputDecorationTheme: InputDecorationTheme(
                                    border: InputBorder.none),
                                hintText: "  Select Term",
                                //initialSelection: "Course",
                                onSelected: (String? value) {
                                  setState(() {
                                    if (value == "All") {
                                      dropdownValue = "";
                                    } else {
                                      dropdownValue = value!;
                                    }
                                  });
                                },
                                dropdownMenuEntries: list
                                    .map<DropdownMenuEntry<String>>(
                                        (String value) {
                                  return DropdownMenuEntry<String>(
                                      value: value, label: "  " + value);
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border.all(color: PoolColors.black),
                                  color: PoolColors.fairTurkuaz,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: TextField(
                                  controller: _KeywordController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: "Keyword",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: screenHeight / 14,
                              width: 3 * (8 * (screenWidth / 7) / 14) / 2,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      const MaterialStatePropertyAll<Color>(
                                    PoolColors.fairBlue,
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  searchQuestions();
                                },
                                child: const Text(
                                  'Search',
                                  style: TextStyle(
                                      color: PoolColors.black, fontSize: 25),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: screenHeight / 14,
                              width: 3 * (8 * (screenWidth / 7) / 14) / 2,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      const MaterialStatePropertyAll<Color>(
                                    PoolColors.fairBlue,
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  GoRouter.of(context)
                                      .go('/instructor/question/create');
                                },
                                child: const Text(
                                  'Add Question',
                                  style: TextStyle(
                                      color: PoolColors.black, fontSize: 25),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight / 7, bottom: screenHeight / 7),
              child: SizedBox(
                width: screenWidth / 2,
                child: Container(
                  decoration: const BoxDecoration(
                      color: PoolColors.cardWhite,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(screenHeight / 30),
                        child: SizedBox(
                          height: screenHeight / 15,
                          width: 3 * screenWidth / 7,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                //border: Border.all(color: PoolColors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: screenWidth / 14,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: PoolColors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  height: screenHeight / 15,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                        PoolColors.fairTurkuaz,
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'Question ID',
                                      style: TextStyle(
                                          color: PoolColors.black,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 3 * screenWidth / 28,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: PoolColors.black),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15))),
                                  height: screenHeight / 15,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                        PoolColors.fairTurkuaz,
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'Question Name',
                                      style: TextStyle(
                                          color: PoolColors.black,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: screenWidth / 14,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: PoolColors.black),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15))),
                                  height: screenHeight / 15,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                        PoolColors.fairTurkuaz,
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'Courses',
                                      style: TextStyle(
                                          color: PoolColors.black,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: PoolColors.black),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15))),
                                  height: screenHeight / 15,
                                  width: 5 * screenWidth / 28 - 2,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                        PoolColors.fairTurkuaz,
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'Keywords',
                                      style: TextStyle(
                                          color: PoolColors.black,
                                          fontSize: 18),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenHeight / 30,
                          right: screenHeight / 30,
                        ),
                        child: SizedBox(
                          height: screenHeight / 2,
                          width: 3 * screenWidth / 7,
                          child: Container(
                            decoration: BoxDecoration(
                                color: PoolColors.white,
                                border: Border.all(color: PoolColors.black),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: ListView.builder(
                              itemCount: questions.length,
                              itemBuilder: (context, index) {
                                final question = questions[index];
                                return ListTile(
                                  title: Text('Question ID: ${question.id}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Header: ${question.header}'),
                                      Text(
                                          'Courses: ${question.courses.join(', ')}'),
                                      Text(
                                          'Topics: ${question.topics.join(', ')}'),
                                      Text(
                                          'Past Terms: ${question.pastExams.join(', ')}'),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
