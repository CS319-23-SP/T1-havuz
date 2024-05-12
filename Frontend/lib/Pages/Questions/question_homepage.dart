import 'package:first_trial/Objects/question.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/AppBars/roles/instructor_appbar.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
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
  '2022-2023 Fall',
  '2023-2024 Fall',
  '2022-2023 Spring',
  '2023-2024 Spring',
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
  //var histories = [[], []];
  List<double>? histories;
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
      print(calculateAverageGrade(questionData!["history"]));
    }
    setState(() {
      questions = parsedQuestions;
    });
  }

  double calculateAverageGrade(List<dynamic> history) {
    if (history.isEmpty) return 0.0;

    double sum = 0.0;
    for (var entry in history) {
      sum += entry['grade'];
    }
    histories?.add(sum / history.length);
    return sum / history.length;
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
        appBar: CustomAppBar(
          role: role,
        ),
        body: Row(
          children: [
            LeftBar(role: role),
            Padding(
              padding: EdgeInsets.all(screenHeight / 7),
              child: Container(
                decoration: const BoxDecoration(
                    color: PoolColors.cardWhite,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: SizedBox(
                  width: screenWidth / 4,
                  height: 3 * (screenHeight / 4),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: PoolColors.black),
                              color: PoolColors.fairTurkuaz,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
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
                        Container(
                          decoration: BoxDecoration(
                              color: PoolColors.fairTurkuaz,
                              border: Border.all(color: PoolColors.black),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: DropdownMenu<String>(
                              width: screenWidth / 4 - 50,
                              inputDecorationTheme: InputDecorationTheme(
                                  border: InputBorder.none),
                              hintText: "Select Term",
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
                                    value: value, label: value);
                              }).toList(),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: PoolColors.black),
                              color: PoolColors.fairTurkuaz,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
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
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: PoolColors.black),
                              color: PoolColors.fairTurkuaz,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: TextField(
                              controller: _KeywordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Topics",
                              ),
                            ),
                          ),
                        ),
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
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Text(
                                'Search',
                                style: TextStyle(
                                    color: PoolColors.black, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
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
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Text(
                                'Add Question',
                                style: TextStyle(
                                    color: PoolColors.black, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight / 7,
                    bottom: screenHeight / 7,
                    right: screenHeight / 7),
                child: Container(
                  decoration: const BoxDecoration(
                      color: PoolColors.cardWhite,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: EdgeInsets.all(
                      screenHeight / 30,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Question ID',
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Term',
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Courses',
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Topics',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
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
                                  title: Divider(
                                    thickness: 3,
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                        child: Text('${question.id}'),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${question.pastExams.toString()}',
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${question.courses.join(', ')}',
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${question.topics.join(', ')}',
                                        ),
                                      ),
                                      // Expanded column for average grade
                                      Expanded(
                                        child: Text(
                                          '${histories != null ? histories![index].toStringAsFixed(0) : "N/A"}', // Display average grade or "N/A" if not available
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
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
