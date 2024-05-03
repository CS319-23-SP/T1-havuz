import 'package:flutter/material.dart';

class Assignment_Details extends StatefulWidget {
  const Assignment_Details({super.key, this.assignmentID = "", this.sectionID = ""});

  final String assignmentID, sectionID;

  @override
  State<Assignment_Details> createState() => _Assignment_DetailsState();
}

class _Assignment_DetailsState extends State<Assignment_Details> {
  @override
  Widget build(BuildContext context) {
    print(widget.assignmentID + "   " + widget.sectionID);
    return const Placeholder();
  }
}
