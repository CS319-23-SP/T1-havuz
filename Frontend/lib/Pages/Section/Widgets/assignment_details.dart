import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:first_trial/Objects/assignment.dart';
import 'package:first_trial/Objects/question.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Assignment_Details extends StatefulWidget {
  const Assignment_Details({
    super.key,
    this.assignmentID = "",
    this.sectionID = "",
    this.role = "",
  });

  final String assignmentID, sectionID, role;

  @override
  State<Assignment_Details> createState() => _Assignment_DetailsState();
}

class _Assignment_DetailsState extends State<Assignment_Details> {
  String term = "2024 Spring";
  String? id = "";
  Assignment assignment = Assignment(
      name: "nonigga",
      term: "term",
      sectionID: "sectionID",
      questions: ["questions"],
      deadline: "deadline");
  String? role = "unknown";

  List<Question> questions = [];

  Future<void> getAssignmentAndQuestions() async {
    await getAssignmentById();
    await fetchQuestions();
  }

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    id = await TokenStorage.getID();

    await getAssignmentAndQuestions();

    if (role == "instructor") {
      await fetchStudentList();
    }
    setState(() {});
  }

  Future<void> fetchQuestions() async {
    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    await Future.forEach(assignment.questions, (questionID) async {
      try {
        final response = await http.get(
          Uri.http('localhost:8080', '/question/$questionID'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          parseQuestionsData(json.decode(response.body));
        } else {
          throw Exception('Failed to fetch questions data');
        }
      } catch (e) {
        print('Error fetching questions: $e');
      }
    });
  }

  void parseQuestionsData(dynamic responseData) {
    final question = Question.fromJson(responseData['question']);
    setState(() {
      questions.add(question);
    });
  }

  Future<void> getAssignmentById() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? instructorID = await TokenStorage.getID();
      String? sectionID = widget.sectionID;
      String assID = widget.assignmentID;
      print('/assignment/$assID/$term/$sectionID');

      final response = await http.get(
        Uri.http('localhost:8080', '/assignment/$assID/$term/$sectionID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            assignment = parseAssignmentData(responseData['assignment']);
          });
        } else {
          throw Exception('Failed to fetch courses data');
        }
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  Assignment parseAssignmentData(dynamic json) {
    return Assignment(
      name: json['name'],
      id: json['id'].toString(),
      term: json['term'].toString(),
      sectionID: json['sectionID'].toString(),
      deadline: json['deadline'].toString(),
      questions: List<String>.from(json['questions']),
      solutionKey: json['solutionKey'].toString(),
    );
  }

  Uint8List? _selectedFileBytes;
  String? _selectedFileName;

  Future<void> _uploadFile() async {
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

    String fileExtension = _selectedFileName!.split('.').last;
    String newFileName = '${id.toString()}.$fileExtension';

    var path = "$term/${widget.sectionID}/${assignment.id}";
    var url = Uri.parse('http://localhost:8080/document?path=$path');

    var request = http.MultipartRequest('POST', url)
      ..files.add(http.MultipartFile.fromBytes('file', _selectedFileBytes!,
          filename: newFileName!));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Error uploading file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erroro uploading file: $e');
    }
  }

  Future<void> _openFile() async {
    if (_selectedFileBytes != null && _selectedFileName != null) {
      final blob = html.Blob([_selectedFileBytes!]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", _selectedFileName!);
      anchor.click();
      html.Url.revokeObjectUrl(url);
    }
  }

  List<String> students = [];

  Future<void> fetchStudentList() async {
    try {
      var path = "$term/${widget.sectionID}/${assignment.id}";
      var url = Uri.parse('http://localhost:8080/document/list?path=$path');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> fileList = json.decode(response.body);

        setState(() {
          students.clear();
        });

        fileList.forEach((filename) {
          String filenameStr = filename.toString();
          setState(() {
            students.add(filenameStr);
          });
        });
      } else {
        throw Exception('Failed to fetch student list');
      }
    } catch (e) {
      print('Error fetching student list: $e');
    }
  }

  Future<void> downloadFile(filename) async {
    try {
      var path = "$term/${widget.sectionID}/${assignment.id}";
      var url =
          Uri.parse('http://localhost:8080/document?path=$path/$filename');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        File file = File('$appDocPath/$filename');
        await file.writeAsBytes(response.bodyBytes);
        print('File downloaded and saved locally at: ${file.path}');
      } else {
        print('Failed to download file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        children: [
          LeftBar(role: role),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Assignment Details",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("ID: ${assignment.id}"),
                Text("Section ID: ${assignment.sectionID}"),
                Text("Solution Key: ${assignment.solutionKey}"),
                Text("Term: ${assignment.term}"),
                if (role == "student") ...[
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: _uploadFile,
                    child: Row(
                      children: [
                        Icon(Icons.upload),
                        Text("select File"),
                      ],
                    ),
                  )
                ],
                if (role == "instructor") ...[
                  SizedBox(height: 20),
                  // Dynamic list of download buttons
                  ...students.map((filename) {
                    return TextButton(
                      onPressed: () => downloadFile(filename),
                      child: Text(filename),
                    );
                  }).toList(),
                ],
                SizedBox(height: 20),
                if (_selectedFileBytes != null)
                  ElevatedButton(
                    onPressed: _openFile,
                    child: Text('Open Uploaded File'),
                  ),
                Text("Questions:",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          questions[index].text,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*Future uploadPdf() async {
    var dio = Dio();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path ?? " ");

      String filename = file.path.split("/").last;
      String filepath = file.path;

      FormData data = FormData.fromMap({
        'x-api-key': 'apikey',
        'file': await MultipartFile.fromFile(filepath, filename: filename),
      });
      var response = dio.post("")
    }
  }*/
}
