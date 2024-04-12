import 'package:first_trial/Objects/course.dart';
import 'package:first_trial/Pages/Student/student_widgets/left_bar.dart';
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
      } else {
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
        body: Row(
          children: [LeftBar(), CourseData(courses: courses)],
        ),
      ),
    );
  }
}

class CourseData extends StatelessWidget {
  final List<Course> courses;

  const CourseData({
    Key? key,
    required this.courses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      //     shrinkWrap: true, // Add this line to enable shrink wrap
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 4.0,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        var course = courses[index];
        return Card(
          color: PoolColors.cardWhite,
          margin: EdgeInsets.all(10), // Optional: Adjust margin as needed
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            splashColor: PoolColors.fairTurkuaz,
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true, // Reduce vertical size
                  title: Text('${course.id} '),
                ),
                ListTile(
                  dense: true, // Reduce vertical size
                  title: Text(course.term),
                ),
                ListTile(
                  dense: true, // Reduce vertical size
                  title: Text('${course.sections}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
