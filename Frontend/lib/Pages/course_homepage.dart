import 'package:flutter/material.dart';
import 'Widgets/AppBars/app_bars.dart';
import 'package:first_trial/final_variables.dart';
//import 'package:google_fonts/google_fonts.dart';

class CourseHomePage extends StatefulWidget {
  const CourseHomePage({super.key});

  @override
  State<CourseHomePage> createState() => _CourseHomePageState();
}

class _CourseHomePageState extends State<CourseHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return const Scaffold(
      appBar: InstructorAppBar(),
      backgroundColor: PoolColors.black,
      body: Row(),
    );
  }
}
