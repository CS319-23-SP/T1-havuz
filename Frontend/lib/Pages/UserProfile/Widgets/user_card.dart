import 'dart:convert';

import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key, required this.userID}) : super(key: key);

  final String userID;

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String _displayText = 'Initial Text';
  late TextEditingController _textController;

  var user;
  var originalID;
  var auth;
  bool _editing = false;
  var about;
  @override
  void initState() {
    super.initState();
    setState(() {
      getAuth();
      getUser();
    });
  }

  void getAuth() async {
    String id = widget.userID;
    originalID = await TokenStorage.getID();

    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.http('localhost:8080', '/auth/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          auth = responseData["auth"];
          if (auth['about'] != null && auth['about'].isNotEmpty) {
            about = auth['about'];
            _displayText = about;
          } else {
            about = "Enter something interesting about you";
            _displayText = about;
          }
        });
      } else {
        throw Exception('Failed to fetch students data');
      }
    }
  }

  void getUser() async {
    String id = widget.userID;

    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.http('localhost:8080', '/student/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          user = responseData["student"];
        });
      } else {
        throw Exception('Failed to fetch students data');
      }
    } else {
      final response = await http.get(
        Uri.http('localhost:8080', '/instructor/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            user = responseData["instructor"];
          });
        } else {
          throw Exception('Failed to fetch instructors data');
        }
      }
    }
  }

  void editUser(String newAbout) async {
    String? id = await TokenStorage.getID();

    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.patch(
      Uri.http('localhost:8080', '/auth/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'id': id, 'about': newAbout}),
    );

    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('Failed to update about');
    }
  }

  void _toggleEditing() {
    setState(() {
      _editing = !_editing;
      if (_editing) {
        _displayText = about;
        _textController = TextEditingController(text: _displayText);
      } else {
        about = _textController.text;
        editUser(about);
        _displayText = about;
        _textController.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = user?["id"] ?? "Unknown";
    final firstName = user?["firstName"] ?? "Unknown";
    final middleName = user?["middleName"] ?? "Unknown";
    final lastName = user?["lastName"] ?? "Unknown";
    final department = user?["department"] ?? "Unknown";
    List<dynamic>? coursesTaken = user?["coursesTaken"];
    List<dynamic>? coursesGiven = user?["coursesGiven"];
    final role = auth?["role"];
    final aboutYourself = "dd";
    final screen = MediaQuery.of(context).size;
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheigth = MediaQuery.of(context).size.height;

    return Container(
      width: 7 * screenwidth / 17,
      height: screenheigth / 2,
      decoration: BoxDecoration(
          color: PoolColors.cardWhite, borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: AssetImage(AssetLocations.defaultt),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 35,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (middleName != "Unknown") ...[
                          Text(
                            "$firstName $middleName $lastName",
                            style: TextStyle(),
                          ),
                        ] else ...[
                          Text("$firstName $lastName")
                        ],
                        Text(department),
                        Text(id),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (coursesTaken?.length ?? 0) * 22.0,
                child: VerticalDivider(
                  color: PoolColors.black,
                  width: 22.5,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (role == "student") ...[
                        const Text(
                          "Courses Taken",
                          style: TextStyle(
                            shadows: [
                              Shadow(color: Colors.black, offset: Offset(0, -5))
                            ],
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            decorationThickness: 4,
                          ),
                        ),
                        if (coursesTaken != null)
                          ...coursesTaken
                              .map((course) => Text(course.toString())),
                      ],
                      if (role == "instructor") ...[
                        const Text(
                          "Courses Given",
                          style: TextStyle(
                            shadows: [
                              Shadow(color: Colors.black, offset: Offset(0, -5))
                            ],
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            decorationThickness: 4,
                          ),
                        ),
                        if (coursesGiven != null)
                          ...coursesGiven
                              .map((course) => Text(course.toString())),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 1000,
            child: Divider(
              color: PoolColors.black,
              height: 5,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: 1000,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "About Yourself",
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                    color: Colors.black, offset: Offset(0, -5))
                              ],
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black,
                              decorationThickness: 4,
                            ),
                          ),
                          if (originalID.toString() == id.toString()) ...[
                            _editing
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
                          ]
                        ],
                      ),
                      SizedBox(height: 10),
                      _editing
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.top,
                                  maxLines: null,
                                  expands: true,
                                  maxLength: 750,
                                  keyboardType: TextInputType.multiline,
                                  controller: _textController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter New Text',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Container(
                                height: screen.height / 6,
                                padding: EdgeInsets.only(bottom: 10),
                                width: 1500, // Adjust width as needed
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    _displayText,
                                    style: TextStyle(fontSize: 20.0),
                                    maxLines:
                                        10, // Limit the number of lines displayed
                                    overflow: TextOverflow
                                        .ellipsis, // Handle overflow with ellipsis
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
