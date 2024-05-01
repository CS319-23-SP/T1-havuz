import 'package:first_trial/Objects/assignment.dart';
import 'package:first_trial/Objects/section.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String? role = "unknown";
  String? id = "unknown";
  List<Assignment> assignments = [];

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(onPressed: widget.onBack, child: Icon(Icons.back_hand)),
        Expanded(child: Column()),
      ],
    );
  }
}
