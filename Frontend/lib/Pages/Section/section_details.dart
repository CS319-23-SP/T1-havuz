import 'dart:io';
import 'dart:typed_data';

import 'package:first_trial/Objects/assignment.dart';
import 'package:first_trial/Objects/section.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/token.dart';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

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
  String? term = PoolTerm.term;
  String? role = "unknown";
  @override
  void initState() {
    super.initState();
    checkRole();
  }

  List<String> students = [];
  String selectedStudent = "";

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    fetchAssignments();
    fetchMaterials();
    setState(() {});
    students = widget.section.students;
  }

  List<Assignment> assignments = [];
  List<List<DateTime>> weeks = [];
  var assignmentsByWeek;

  Future<void> fetchAssignments() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();
      String sectionID = widget.section.id;

      final response = await http.get(
        Uri.http('localhost:8080', '/assignment/$term/$sectionID'),
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
            printid();
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

  void printid() {
    DateTime startDate = DateTime(2024, 01, 29);
    DateTime endDate = DateTime(2024, 05, 31);
    // Calculate the number of weeks
    int numberOfWeeks = ((endDate.difference(startDate).inDays) / 7).ceil();

    // Generate the list of weeks
    assignmentsByWeek = List.generate(numberOfWeeks, (_) => []);

    DateTime tempDate = startDate;
    for (int i = 0; i < numberOfWeeks; i++) {
      DateTime weekStart =
          tempDate.subtract(Duration(days: tempDate.weekday - 1));
      DateTime weekEnd = weekStart.add(Duration(days: 6));

      // Ensure the week doesn't extend beyond the end date
      if (weekEnd.isAfter(endDate)) {
        weekEnd = endDate;
      }

      weeks.add([weekStart, weekEnd]);

      // Move to the start of the next week
      tempDate = weekEnd.add(Duration(days: 1));
    }

    // Simulated assignment data

    // Assign each assignment to its corresponding week
    for (Assignment assignment in assignments) {
      for (int i = 0; i < weeks.length; i++) {
        DateTime deadline = DateTime.parse(assignment.deadline);

        if ((deadline.isAfter(weeks[i][0]) && deadline.isBefore(weeks[i][1])) ||
            deadline.isAtSameMomentAs(weeks[i][0]) ||
            deadline.isAtSameMomentAs(weeks[i][1])) {
          assignmentsByWeek[i].add(assignment);
          break;
        }
      }
    }
  }

  List<String> materials = [];

  Future<void> fetchMaterials() async {
    try {
      var path = "$term/${widget.section.id}/materials";
      var url = Uri.parse('http://localhost:8080/document/list?path=$path');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> fileList = json.decode(response.body);

        setState(() {
          materials.clear();
        });

        fileList.forEach((filename) {
          String filenameStr = filename.toString();
          setState(() {
            materials.add(filenameStr);
          });
        });

        if (response.statusCode == 200) {
        } else {
          throw Exception('Failed to fetch student list');
        }
      } else {
        throw Exception('Failed to fetch student list');
      }
    } catch (e) {
      print('Error fetching student list: $e');
    }
  }

  Uint8List? _selectedFileBytes;
  String? _selectedFileName;

  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFileBytes = result.files.single.bytes!;
        _selectedFileName = result.files.single.name;
      });
    }

    if (_selectedFileBytes == null || _selectedFileName == null) {
      return;
    }

    var path = "$term/${widget.section.id}/materials";
    var url = Uri.parse('http://localhost:8080/document?path=$path');

    var request = http.MultipartRequest('POST', url)
      ..files.add(http.MultipartFile.fromBytes('file', _selectedFileBytes!,
          filename: _selectedFileName!));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully');
        setState(() {
          fetchMaterials();
        });
      } else {
        print('Error uploading file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erroro uploading file: $e');
    }
  }

  Future<void> downloadFile(filename) async {
    try {
      var path = "$term/${widget.section.id}/materials";
      var url =
          Uri.parse('http://localhost:8080/document?path=$path/$filename');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<int> fileBytes = response.bodyBytes;

        var blob = html.Blob([fileBytes]);

        var url = html.Url.createObjectUrlFromBlob(blob);

        var anchor = html.AnchorElement(href: url.toString())
          ..setAttribute("download", filename)
          ..click();

        html.Url.revokeObjectUrl(url.toString());
      } else {
        print('Failed to download file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<void> deleteFile(fileName) async {
    try {
      var fileExtension = "$fileName";
      var path = "$term/${widget.section.id}/materials";
      var url =
          Uri.parse('http://localhost:8080/document?path=$path/$fileExtension');

      var response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          fetchMaterials();
        });
        print('File deleted successfully');
      } else {
        print('Failed to delete file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error deletin file: $e');
    }
  }

  List<dynamic> attendances = [];

  Future<void> createReport(studentName) async {
    if (studentName == null) {
      return;
    }
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      var response = await http.post(
          Uri.parse('http://localhost:8080/instructor/attendance'),
          body: jsonEncode(
              {'studentID': studentName, 'sectionID': widget.section.id}),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

      final responseJson = jsonDecode(response.body);
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(responseJson['data']);

      final pdf = pw.Document();

      final ByteData datao =
          await rootBundle.load('lib/Assets/fonts/Roboto-Regular.ttf');
      final ttf = pw.Font.ttf(datao);

      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Attendance Report for Student: $studentName',
                style: pw.TextStyle(font: ttf, fontSize: 25)),
            pw.SizedBox(height: 20),
            pw.Table(
              children: [
                pw.TableRow(
                  children: ['Date', 'Attended Hour', 'Total Hour']
                      .map((header) => pw.Text(header,
                          style: pw.TextStyle(font: ttf, fontSize: 20)))
                      .toList(),
                ),
                ...data
                    .map((entry) => pw.TableRow(
                          children: [
                            DateFormat('MMM dd, yyyy')
                                .format(DateTime.parse(entry['date'])),
                            entry['hour'].toString(),
                            entry['totalHour'].toString()
                          ]
                              .map((value) => pw.Text(value,
                                  style: pw.TextStyle(font: ttf, fontSize: 15)))
                              .toList(),
                        ))
                    .toList(),
              ],
            ),
            /*pw.Text('Attendance Report for Student: $studentName',
                style: pw.TextStyle(font: ttf, fontSize: 25)),
            pw.SizedBox(height: 20),
            pw.Table(
              children: [
                pw.TableRow(
                  children: ['Date', 'Attended Hour', 'Total Hour']
                      .map((header) => pw.Text(header,
                          style: pw.TextStyle(font: ttf, fontSize: 20)))
                      .toList(),
                ),
                ...data
                    .map((entry) => pw.TableRow(
                          children: [
                            DateFormat('MMM dd, yyyy')
                                .format(DateTime.parse(entry['date'])),
                            entry['hour'].toString(),
                            entry['totalHour'].toString()
                          ]
                              .map((value) => pw.Text(value,
                                  style: pw.TextStyle(font: ttf, fontSize: 15)))
                              .toList(),
                        ))
                    .toList(),
              ],
            ),*/ //Enter grade values here
          ],
        );
      }));

      final Uint8List pdfBytes = await pdf.save();
      final blob = html.Blob([pdfBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final filename = 'report=$studentName.pdf';
      final anchor = html.AnchorElement(href: url.toString())
        ..setAttribute('download', filename)
        ..click();
      html.Url.revokeObjectUrl(url.toString());
    } catch (e) {
      print('Error deletin file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            InkWell(
              onTap: widget.onBack,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Icon(Icons.arrow_back),
              ),
            ),
            if (role == "instructor") ...[
              InkWell(
                  onTap: () {
                    GoRouter.of(context)
                        .go('/createAssignment/${widget.section.id}');
                  },
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: const Text("Create assignment"))),
              InkWell(
                  onTap: () {
                    GoRouter.of(context).go('/evaluation/${widget.section.id}');
                  },
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: const Text("See Evaluation"))),
              InkWell(
                  onTap: () {
                    final String sectionId = widget.section.id;
                    GoRouter.of(context).go("/section/$sectionId/exams");
                  },
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: const Text("Give Exam Grade"))),
            ],
            if (role == "student") ...[
              InkWell(
                  onTap: () {
                    GoRouter.of(context).go('/evaluation/${widget.section.id}');
                  },
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: const Text("Make Evaluation"))),
            ],
            InkWell(
                onTap: () {
                  final String sectionId = widget.section.id;
                  GoRouter.of(context).go("/$sectionId/createForum");
                },
                child: Container(
                    padding: EdgeInsets.all(20), child: Text("Create Forum"))),
            InkWell(
                onTap: () {
                  final String sectionId = widget.section.id;
                  GoRouter.of(context).go("/$sectionId/forum");
                },
                child: Container(
                    padding: EdgeInsets.all(20), child: Text("View Forums"))),
            InkWell(
                onTap: () {
                  final String courseId = widget.section.sectionID;
                  GoRouter.of(context).go("/$courseId/ABET");
                },
                child: Container(
                    padding: EdgeInsets.all(20), child: Text("ABET"))),
            if (role == "instructor") ...[
              DropdownMenu<String>(
                inputDecorationTheme:
                    InputDecorationTheme(border: InputBorder.none),
                hintText: "Select Term",
                onSelected: (String? value) {
                  setState(() {
                    selectedStudent = value.toString();
                  });
                },
                dropdownMenuEntries:
                    students.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              InkWell(
                onTap: () {
                  if (selectedStudent != null) {
                    createReport(selectedStudent);
                  } else {
                    print("choose a student man cmon");
                  }
                },
                child: Container(
                    padding: EdgeInsets.all(20), child: Text("Create Report")),
              ),
            ]
          ],
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: PoolColors.cardWhite,
                borderRadius: BorderRadius.circular(15)),
            height: 1250,
            width: 1250,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < weeks.length; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            "Week ${i + 1}: ${DateFormat('MMM dd').format(weeks[i][0])} - ${DateFormat('MMM dd').format(weeks[i][1])}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: assignmentsByWeek[i].length,
                          itemBuilder: (BuildContext context, int index) {
                            Assignment assignment = assignmentsByWeek[i][index];
                            DateTime deadline =
                                DateTime.parse(assignment.deadline);
                            return ListTile(
                                title: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    child: Row(
                                      children: [
                                        Icon(Icons.assignment),
                                        SizedBox(width: 15),
                                        Expanded(
                                          child: Text(
                                            "${assignment.name} (Due: ${DateFormat('MMM dd').format(deadline)})",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      final String assignmentid = assignment.id;
                                      final String sectionid =
                                          assignment.sectionID;
                                      String? role =
                                          await TokenStorage.getRole();
                                      GoRouter.of(context).go(
                                          '/$role/assignment/$sectionid/$assignmentid');
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: role == "instructor"
                                      ? TextButton(
                                          child: Row(
                                            children: [
                                              Icon(Icons.grade),
                                              SizedBox(width: 15),
                                              Expanded(
                                                child: Text(
                                                  "Grade",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed: () async {
                                            final String assignmentid =
                                                assignment.id;
                                            final String sectionid =
                                                assignment.sectionID;
                                            String? role =
                                                await TokenStorage.getRole();
                                            GoRouter.of(context).go(
                                              '/$role/assignment/$sectionid/$assignmentid/grade',
                                            );
                                          },
                                        )
                                      : SizedBox
                                          .shrink(), // This widget will be invisible if the condition is false
                                ),
                                Expanded(
                                  child: role == "instructor"
                                      ? TextButton(
                                          child: Row(
                                            children: [
                                              Icon(Icons.analytics),
                                              SizedBox(width: 15),
                                              Expanded(
                                                child: Text(
                                                  "Analysis",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed: () async {
                                            final String assignmentID =
                                                assignment.id;
                                            final String sectionID =
                                                assignment.sectionID;
                                            String? role =
                                                await TokenStorage.getRole();
                                            print(role);
                                            print(sectionID);
                                            print(assignmentID);
                                            GoRouter.of(context).go(
                                              '/$role/assignment/$sectionID/$assignmentID/analysis',
                                            );
                                          },
                                        )
                                      : SizedBox
                                          .shrink(), // This widget will be invisible if the condition is false
                                ),
                              ],
                            ));
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: PoolColors.cardWhite,
                borderRadius: BorderRadius.circular(15)),
            height: 1250,
            width: 1250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    "Materials",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (role == "instructor") ...[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        uploadFile();
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          child: Text("Upload File")),
                    ),
                  ),
                ],
                ...materials.map((filename) {
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(filename),
                        ),
                        if (role == "instructor") ...[
                          TextButton(
                            onPressed: () {
                              downloadFile(filename);
                            },
                            child: Text("Download"),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteFile(filename);
                            },
                            child: Text("Delete"),
                          ),
                        ],
                        if (role == "student") ...[
                          InkWell(
                            onTap: () {
                              downloadFile(filename);
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Download",
                                  style:
                                      TextStyle(color: Colors.deepOrangeAccent),
                                )),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
