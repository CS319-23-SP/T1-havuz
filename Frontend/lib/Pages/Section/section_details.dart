import 'package:first_trial/Objects/assignment.dart';
import 'package:first_trial/Objects/section.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/token.dart';
import 'package:go_router/go_router.dart';
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
  String term = "2024 Spring";
  String? role = "unknown";
  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    fetchAssignments();
    setState(() {});
  }

  List<Assignment> assignments = [];
  Future<void> fetchAssignments() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();
      String sectionID = widget.section.id;

      final response = await http.get(
        Uri.http('localhost:8080', '/assignment/instructor/$term/$sectionID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            assignments = parseAssignmentData(responseData['assignments']);
          });
        } else {
          throw Exception('Failed to fetch courses data');
        }
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching co3fjgsdh322urses: $e');
    }
  }

  List<Assignment> parseAssignmentData(dynamic responseData) {
    return (responseData as List<dynamic>)
        .map((assignmentData) => Assignment.fromJson(assignmentData))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        ElevatedButton(onPressed: widget.onBack, child: Icon(Icons.back_hand)),
        Expanded(
          child: SizedBox(
            height: 1250,
            width: 1250,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Widget for section details if needed
                  // e.g., Text(widget.section.title),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: assignments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: width / 6,
                        child: ListTile(
                          title: TextButton(
                            child: Row(
                              children: [
                                Icon(Icons.assignment),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    assignments[index].id,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              final String assignmentid = assignments[index].id;
                              final String sectionid =
                                  assignments[index].sectionID;
                              GoRouter.of(context).go(
                                  '/instructor/assignment/$sectionid/$assignmentid');
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
