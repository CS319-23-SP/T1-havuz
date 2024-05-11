import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/success_fail.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateForumPage extends StatefulWidget {
  const CreateForumPage({super.key, required this.sectionID});
  final String sectionID;

  @override
  State<CreateForumPage> createState() => CreateForumPageState();
}

class CreateForumPageState extends State<CreateForumPage> {
  String? term = PoolTerm.term;
  String? role = "unknown";

  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    setState(() {});
  }

  void createForum() async {
    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final title = titleController.text;
    final text = textController.text;

    final creatorID = TokenStorage.getID();
    final sectionID = widget.sectionID;
    print(sectionID);
    final url = Uri.parse('http://localhost:8080/forum/$term/$sectionID');
    Map<String, dynamic> requestBody = {
      'title': title,
      'messageText': text,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    print("object");
    if (response.statusCode > 199 && response.statusCode < 212) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SuccessWidget(
            context: context,
            onDismiss: () {
              clearInputs();
            },
          );
        },
      );
    } else {
      print('Failed to create question: ${response.reasonPhrase}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FailWidget(
            context: context,
            onDismiss: () {
              clearInputs();
            },
          );
        },
      );
    }
  }

  void clearInputs() {
    setState(() {
      textController.clear();
      titleController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Forum Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Forum Text',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                createForum();
              },
              child: Text('Create Forum'),
            ),
          ],
        ),
      ),
    );
  }
}
