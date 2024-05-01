import 'package:first_trial/Objects/assignment.dart';
import 'package:first_trial/Objects/course.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';

class Course_Details extends StatefulWidget {
  final Course course;
  final VoidCallback onBack;

  // Constructor with required named parameters
  const Course_Details({
    Key? key,
    required this.course,
    required this.onBack,
  }) : super(key: key);

  @override
  State<Course_Details> createState() => _Course_DetailsState();
}

class _Course_DetailsState extends State<Course_Details> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(onPressed: widget.onBack, child: Icon(Icons.back_hand)),
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
