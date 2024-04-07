import 'package:first_trial/Pages/Student/student_widgets/left_bar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:flutter/material.dart';

class StudentHomepage extends StatefulWidget {
  const StudentHomepage({super.key});

  @override
  State<StudentHomepage> createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBar(),
      body: LeftBar(),
    );
  }
}
