import 'dart:html';

import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ABET extends StatefulWidget {
  const ABET({super.key, required this.course});
  final String course;
  @override
  State<ABET> createState() => _ABETState();
}

class _ABETState extends State<ABET> {
  String? term = PoolTerm.term;
  String? role = "unknown";
  String annen = "Enter ABET Information";
  String course = "course";
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    fetchABET();
    setState(() {});
  }

  Future<void> fetchABET() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();
      course = widget.course;

      final response = await http.get(
        Uri.http('localhost:8080', '/ABET/$course'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode > 199 && response.statusCode < 210) {
        var responseData = json.decode(response.body);
        setState(() {
          course = responseData['abet']['sectionId'];
          annen = responseData['abet']['messageText'];
        });
        print(responseData);
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching s: $e');
    }
  }

  void editUser(String newAbout) async {
    String? id = await TokenStorage.getID();

    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.http('localhost:8080', '/ABET/$course'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({"messageText": annen}),
    );
    print(annen);

    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('Failed to update about');
    }
  }

  late TextEditingController _textController;

  void _toggleEditing() {
    setState(() {
      _editing = !_editing;
      if (_editing) {
        _textController = TextEditingController(text: annen);
      } else {
        annen = _textController.text;
        editUser(annen);
        _textController.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LeftBar(role: role),
          Flexible(
              flex: 2,
              child: Placeholder(
                color: Colors.transparent,
              )),
          Flexible(
              flex: 7,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        course,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 64),
                      ),
                      role == "instructor" || role == "admin"
                          ? _editing
                              ? IconButton(
                                  onPressed: () {
                                    _toggleEditing();
                                  },
                                  icon: Icon(Icons.done))
                              : IconButton(
                                  onPressed: () {
                                    _toggleEditing();
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.edit))
                          : Container()
                    ],
                  ),
                  _editing
                      ? Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              textAlignVertical: TextAlignVertical.top,
                              maxLines: null,
                              expands: true,
                              maxLength: 30000,
                              keyboardType: TextInputType.multiline,
                              controller: _textController,
                              decoration: InputDecoration(
                                labelText: 'Enter New Text',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView(
                            children: [
                              Container(
                                height: 1500, // Adjust height as needed
                                padding: EdgeInsets.only(bottom: 10),
                                width:
                                    double.infinity, // Adjust width as needed
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    annen,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              )),
          Flexible(
            flex: 2,
            child: Placeholder(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
