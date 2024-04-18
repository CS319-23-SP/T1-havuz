import 'package:first_trial/Objects/course.dart';
import 'package:first_trial/Pages/Student/student_widgets/left_bar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:flutter/material.dart';

class Course_Details extends StatelessWidget {
  final Course course;

  // Constructor with required named parameters
  const Course_Details({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InstructorAppBar(),
      body: Row(
        children: [
          LeftBar(),
          Expanded(
            child: Center(
              child: Text(course
                  .coordinatorID), // You can replace this with your actual course details UI
            ),
          ),
        ],
      ),
    );
  }
}
