import 'dart:convert';

import 'package:first_trial/Objects/course.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:http/http.dart' as http;

class LeftBar extends StatefulWidget {
  const LeftBar({super.key});

  @override
  State<LeftBar> createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> {
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
          throw Exception('Failed to fetch students data');
        }
      } /*else if (response.statusCode == 401) {
      print('Unauthorized access: Token may be invalid or expired');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } */
      else {
        throw Exception('Failed to fetch students data');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  List<Course> parseCoursesData(dynamic responseData) {
    return (responseData as List<dynamic>)
        .map((courseData) => Course.fromJson(courseData))
        .toList();
  }

  List<Widget> views = const [
    Center(
      child: Text('Dashboard'),
    ),
    Center(
      child: Text('Account'),
    ),
    Center(
      child: Text('Settings'),
    ),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SideNavigationBar(
      footer: SideNavigationBarFooter(
          label: Text(
        'By team Pool',
        style: GoogleFonts.alike(),
      )),
      selectedIndex: selectedIndex,
      toggler: SideBarToggler(
          expandIcon: Icons.arrow_circle_right_outlined,
          shrinkIcon: Icons.arrow_circle_left_outlined),
      items: const [
        SideNavigationBarItem(
          icon: Icons.dashboard,
          label: 'Dashboard',
        ),
        SideNavigationBarItem(
          icon: Icons.person,
          label: 'Account',
        ),
        SideNavigationBarItem(
          icon: Icons.settings,
          label: 'Settings',
        ),
      ],
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      theme: SideNavigationBarTheme(
        backgroundColor: PoolColors.appBarBackground,
        togglerTheme: SideNavigationBarTogglerTheme.standard(),
        itemTheme: SideNavigationBarItemTheme(
          selectedBackgroundColor: Colors.transparent,
          unselectedBackgroundColor: Colors.transparent,
          selectedItemColor: PoolColors.black,
          unselectedItemColor: PoolColors.black,
          iconSize: 28,
          labelTextStyle: GoogleFonts.alike(
            textStyle: TextStyle(fontSize: 20),
          ),
        ),
        dividerTheme: SideNavigationBarDividerTheme(
            showFooterDivider: false,
            showMainDivider: true,
            mainDividerColor: PoolColors.black,
            mainDividerThickness: 0.2,
            showHeaderDivider: true),
      ),
    );
  }
}
