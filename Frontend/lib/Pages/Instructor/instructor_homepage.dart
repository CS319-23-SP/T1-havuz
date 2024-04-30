import 'package:first_trial/Objects/course.dart';
import 'package:first_trial/Objects/section.dart';
import 'package:first_trial/Pages/Course/course_details.dart';
import 'package:first_trial/Pages/Section/section_details.dart';
import 'package:first_trial/Pages/Student/student_widgets/left_bar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/roles/instructor_appbar.dart';
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
  String? role = "unknown";

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    if (role != "instructor") {
      return;
    } else {
      fetchSections();
      setState(() {});
    }
  }

  List<Section> sections = [];
  late final ScrollController _scrollController;

  Future<void> fetchSections() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? instructorID = await TokenStorage.getID();
      String? term = '2024 Spring';

      print(instructorID);

      final response = await http.get(
        Uri.http('localhost:8080', '/section/$instructorID/$term'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          print(responseData);
          setState(() {
            sections = parseSectionsData(responseData['section']);
          });
        } else {
          throw Exception('Failed to fetch courses data');
        }
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching co32322urses: $e');
    }
  }

  List<Section> parseSectionsData(dynamic responseData) {
    return (responseData as List<dynamic>)
        .map((sectionData) => Section.fromJson(sectionData))
        .toList();
  }

  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool _showDetails = showDetails;

    int _ind = ind;
/*
    Widget page = Placeholder();

    if (_showDetails) {
      page = Course_Details(course: courses[ind]);
    } else {
      page = CourseData(courses: courses);
    }*/

    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(
            role: role,
          ),
          body: Row(
            children: [
              LeftBar(),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!showDetails)
                      Expanded(
                        child: SectionData(
                          sections: sections,
                          onTapCourse: (index) {
                            print('Section $index tapped');
                            setState(() {
                              ind = index;
                              showDetails = true;
                            });
                          },
                        ),
                      ),
                    if (showDetails)
                      Expanded(
                        child: Section_Details(
                          section: sections[ind],
                          onBack: () {
                            setState(() {
                              showDetails = false;
                            });
                          },
                        ),
                      ),
                    Container(
                      width: screenHeight / 2,
                      height: screenHeight / 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: MonthView(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionData extends StatefulWidget {
  final List<Section> sections;
  final void Function(int) onTapCourse;

  const SectionData({
    Key? key,
    required this.sections,
    required this.onTapCourse,
  }) : super(key: key);

  @override
  State<SectionData> createState() => _SectionDataState();
}

class _SectionDataState extends State<SectionData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: ListView.builder(
/*        scrollDirection: Axis.vertical,
        shrinkWrap: true,*/
        itemCount: 1,
        itemBuilder: (context, index) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 24.0,
              mainAxisSpacing: 20.0,
            ),
            itemCount: widget.sections.length,
            itemBuilder: (context, index) {
              Section post = widget.sections[index];
              return InkWell(
                onTap: () {
                  widget.onTapCourse(index);
                },
                /* onTap: () {
                    print(ind);
                    print(showDetails);
                    setState(() {
                      ind = index;
                      showDetails = true;
                    });
                  }, */
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
          );
          ;
        },
      ),
    );
  }
}
