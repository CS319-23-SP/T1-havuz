import 'package:first_trial/Pages/Student/student_widgets/left_bar.dart';
import 'package:flutter/material.dart';

class Course_Details extends StatelessWidget {
  const Course_Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [LeftBar(), Expanded(child: Placeholder())],
    );
  }
}
