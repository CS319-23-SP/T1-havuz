import 'package:flutter/material.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:first_trial/token.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatefulWidget {
  final String role;
  final String assignmentID;
  final String sectionID;

  const AnalysisPage({
    Key? key,
    required this.role,
    required this.assignmentID,
    required this.sectionID,
  }) : super(key: key);

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  List<double>? attendancePercentages = [];
  List<double>? grades = [];
  List<String>? studentIDs;
  Map<String, dynamic>? assignmentData;

  @override
  void initState() {
    super.initState();
    fetchSectionData();
  }

  Future<void> fetchSectionData() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      print(widget.role);
      print(widget.assignmentID);
      print(widget.sectionID);
      final courseID =
          widget.sectionID.substring(0, widget.sectionID.length - 2);
      final term = "2024 Spring";
      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/section/${widget.sectionID}/$term/$courseID'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final section = json.decode(response.body)['section'];
        setState(() {
          studentIDs = section[0]['students']
              .map<String>(
                  (studentID) => studentID.toString()) // Ensure string type
              .toList();
          loadAttendancePercentages(studentIDs!);
          fetchAssignmentData();
        });
      }
    } catch (error) {
      print('Error fetching section data: $error');
    }
  }

  Future<void> fetchAssignmentData() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/assignment/${widget.assignmentID}/2024 Spring/${widget.sectionID}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          assignmentData = json.decode(response.body)['assignment'];
          for (Map<String, dynamic> grade in assignmentData!['grades']) {
            for (String studentID in studentIDs!) {
              if (grade['studentID'] == studentID) {
                grades!.add(grade['grade']);
              }
            }
          }
          print(grades);
        });
      }
    } catch (error) {
      print('Error fetching assignment data: $error');
    }
  }

  Future<void> loadAttendancePercentages(List<String> studentIDs) async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      for (var studentID in studentIDs) {
        final response = await http.get(
          Uri.parse(
              'http://localhost:8080/student/attendance/$studentID/2024 Spring'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final rawAttendanceRecords = data['attendance'];

          double totalHour = 0;
          double hour = 0;
          for (var record in rawAttendanceRecords) {
            totalHour += record['totalHour'];
            hour += record['hour'];
          }
          double attendancePercentage = (hour / totalHour) * 100;
          attendancePercentages!.add(attendancePercentage);
          print(attendancePercentages);
        } else {
          throw Exception("Failed to load attendance data.");
        }
      }

      setState(() {}); // Update the UI
    } catch (error) {
      print('Error loading attendance percentages: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: widget.role),
      body: Row(
        children: [
          LeftBar(role: widget.role),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Analysis', // Page title
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                if (attendancePercentages != null && grades != null)
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 100,
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                attendancePercentages!.length,
                                (index) => FlSpot(
                                  attendancePercentages![index],
                                  grades![index],
                                ),
                              ),
                              isCurved: true,
                            ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              getTitles: (value) {
                                // You can customize this function to provide custom labels for x-axis
                                return value.toInt().toString();
                              },
                              margin: 10,
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTitles: (value) {
                                // You can customize this function to provide custom labels for y-axis
                                return value.toInt().toString();
                              },
                              reservedSize: 28,
                              margin: 12,
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            drawHorizontalLine: true,
                            horizontalInterval: 10,
                            verticalInterval: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                Text("Attendance", textAlign: TextAlign.center)
              ],
            ),
          ),
        ],
      ),
    );
  }
}