import 'package:first_trial/Objects/course.dart';
import 'package:first_trial/Pages/Course/course_details.dart';
import 'package:first_trial/Pages/Student/student_widgets/left_bar.dart';
import 'package:first_trial/Pages/Widgets/access_denied.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../Widgets/AppBars/app_bars.dart';
import 'package:first_trial/final_variables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:calendar_view/calendar_view.dart';

int ind = 0;
bool showDetails = false;

class CourseHomePage extends StatefulWidget {
  const CourseHomePage({super.key});

  @override
  State<CourseHomePage> createState() => _CourseHomePageState();
}

class _CourseHomePageState extends State<CourseHomePage> {
  List<Course> courses = [];
  late final ScrollController _scrollController;
  String? role = "unknown";    

  @override
  void initState() {
    checkRole();
    super.initState();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    if(role != "instructor"){
        return;
    }
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

  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (role != 'instructor') {
      return AccessDeniedPage();
    }
    bool _showDetails = showDetails;

    int _ind = ind;

    Widget page = Placeholder();

    if (_showDetails) {
      page = Course_Details(course: courses[ind]);
    } else {
      page = CourseData(courses: courses);
    }
    return CalendarControllerProvider(
      controller: EventController(),
      child: Scaffold(
          appBar: InstructorAppBar(),
          body: Container(
            child: Row(
              children: [
                LeftBar(),
                Container(
                  height: screenHeight,
                  width: screenWidth / 2,
                  child: page,
                ),
                Container(
                  width: screenHeight / 2,
                  height: screenHeight / 2,
                  child: MonthView(),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class CourseData extends StatefulWidget {
  final List<Course> courses;

  const CourseData({
    Key? key,
    required this.courses,
  }) : super(key: key);

  @override
  State<CourseData> createState() => _CourseDataState();
}

class _CourseDataState extends State<CourseData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: ListView.builder(
/*        scrollDirection: Axis.vertical,
        shrinkWrap: true,*/
        itemCount: 1,
        itemBuilder: (context, index) {
          return Center(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 24.0,
                mainAxisSpacing: 20.0,
              ),
              itemCount: widget.courses.length,
              itemBuilder: (context, index) {
                Course post = widget.courses[index];
                return InkWell(
                  onTap: () {
                    print(ind);
                    print(showDetails);
                    setState(() {
                      ind = index;
                      showDetails = true;
                    });
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: SingleChildScrollView(
                      // Disable scrolling
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  // Wrap the title with Expanded
                                  child: Text(
                                    post.id ?? "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    post.term ?? "",
                                    style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            /*Text(
                  "Date: ${widget.post.sdate}",
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  "Location: ${widget.post.location}",
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  "Organizer: ${widget.post.organizer}",
                  style: const TextStyle(fontSize: 12),
                ),*/
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
          ;
        },
      ),
    );
  }
}

class Course_Details extends StatefulWidget {
  final Course course;

  // Constructor with required named parameters
  const Course_Details({Key? key, required this.course}) : super(key: key);

  @override
  State<Course_Details> createState() => _Course_DetailsState();
}

class _Course_DetailsState extends State<Course_Details> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
            onPressed: () {
              print(showDetails);
              setState(() {
                showDetails = false;
              });
            },
            child: Icon(Icons.back_hand)),
        Expanded(
          child: Center(
            child: Text(widget.course
                .coordinatorID), // You can replace this with your actual course details UI
          ),
        ),
      ],
    );
  }
}
