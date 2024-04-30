import 'package:first_trial/Objects/section.dart';
import 'package:first_trial/Pages/Student/student_widgets/left_bar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:flutter/material.dart';

class Section_Details extends StatefulWidget {
  final Section section;
  final VoidCallback onBack;

  // Constructor with required named parameters
  const Section_Details({
    Key? key,
    required this.section,
    required this.onBack,
  }) : super(key: key);

  @override
  State<Section_Details> createState() => _Section_DetailsState();
}

class _Section_DetailsState extends State<Section_Details> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(onPressed: widget.onBack, child: Icon(Icons.back_hand)),
        Expanded(
          child: Center(
            child: Text(widget.section
                .instructorID), // You can replace this with your actual section details UI
          ),
        ),
      ],
    );
  }
}
