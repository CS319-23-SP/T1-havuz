import 'package:first_trial/Objects/course.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import '../Widgets/AppBars/app_bars.dart';
import 'package:first_trial/final_variables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseHomePage extends StatefulWidget {
  const CourseHomePage({super.key});

  @override
  State<CourseHomePage> createState() => _CourseHomePageState();
}

class _CourseHomePageState extends State<CourseHomePage> {
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
  try {
    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.http('localhost:8080', '/course/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          courses = parseCoursesData(responseData['courses']);
        });
      } else {
        throw Exception('Failed to fetch courses data');
      }
    }else {
      throw Exception('Failed to fetch courses data');
    }
  } catch (e) {
    print('Error fetching courses: $e');
  }
}

List<Course> parseCoursesData(dynamic responseData) {
  return (responseData as List<dynamic>)
      .map((CourseData) => Course.fromJson(CourseData))
      .toList();
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        appBar: InstructorAppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            courses.forEach((course) {
              print('Course ID: ${course.id}, Term: ${course.term}, Department: ${course.department}, Coordinator ID: ${course.coordinatorID}');
            });
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
