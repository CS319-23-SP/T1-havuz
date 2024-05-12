// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:first_trial/Objects/course.dart';
import 'package:first_trial/Objects/section.dart';
import 'package:first_trial/Pages/Section/section_details.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
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
  String? term = PoolTerm.term;

  @override
  void initState() {
    super.initState();
    checkRole();
    showDetails = false;
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    fetchSections();
    setState(() {});
  }

  List<Section> sections = [];
  late final ScrollController _scrollController;

  Future<void> fetchSections() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();

      final response = await http.get(
        Uri.http('localhost:8080', '/section/$ID/$term'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
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
      print('Error fetching co3asdad22urses: $e');
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeftBar(
                role: role,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      !showDetails
                          ? Expanded(
                              child: SectionData(
                                sections: sections,
                                onTapCourse: (index) {
                                  setState(() {
                                    ind = index;
                                    showDetails = true;
                                  });
                                },
                              ),
                            )
                          : Expanded(
                              child: Section_Details(
                                section: sections[ind],
                                onBack: () {
                                  setState(() {
                                    showDetails = false;
                                  });
                                },
                              ),
                            ),
                    ],
                  ),
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
  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20.0,
      ),
      itemCount: widget.sections.length,
      itemBuilder: (context, index) {
        Section post = widget.sections[index];
        return InkWell(
          focusColor: Colors.transparent,
          onTap: () {
            widget.onTapCourse(index);
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Design area with random color
                Container(
                  decoration: BoxDecoration(
                      color: getRandomColor(),
                      borderRadius: BorderRadius.circular(15)),
                  height: 0.7 *
                      (MediaQuery.of(context).size.width - 270) /
                      4, // 70% of card height
                ),
                // ID display area
                Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      post.id,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
