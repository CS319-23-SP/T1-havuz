import 'dart:convert';

import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:http/http.dart' as http;

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  List<Widget> _additionalTextFields = [];
  final List<TextEditingController> groupFieldControllers = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageTextController = TextEditingController();
  var date;

  String? term = PoolTerm.term;
  String? role = "unknown";
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    setState(() {});
  }

  void createEvent() async {
    final title = titleController.text;
    final messageText = messageTextController.text;
    List<String> orgy = [];
    for (var i = 0; i < groupFieldControllers.length; i++) {
      orgy.add(groupFieldControllers[i].text);
    }
    date = date.toString().split(' ').first;

    final url = Uri.parse('http://localhost:8080/event');
    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'messageText': messageText,
        'date': date,
        'userIds': orgy,
      }),
    );
    if (response.statusCode > 198 && response.statusCode < 212) {
      print('Event created successfully');
    } else {
      print('Failed to create assignment: ${response.reasonPhrase}');
    }
    GoRouter.of(context).go('/calendar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        children: [
          LeftBar(role: role),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 1000,
              ),
              padding: const EdgeInsets.all(50.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          GoRouter.of(context).go('/calendar');
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Event Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: messageTextController,
                      decoration: InputDecoration(
                        labelText: 'Explanations',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            setState(() {
                              date = pickedDate;
                            });
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            date != null
                                ? 'Date: ${DateFormat('dd-MM-yyyy').format(date!)}'
                                : 'Date',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: ListView(
                          children: [
                            SizedBox(height: 10.0),
                            ..._additionalTextFields,
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  TextEditingController newController =
                                      TextEditingController();
                                  groupFieldControllers.add(newController);
                                  _additionalTextFields.add(Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextFormField(
                                      controller: newController,
                                      decoration: InputDecoration(
                                        labelText: 'Enter User ID',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ));
                                });
                              },
                              icon: Row(
                                children: [
                                  Icon(Icons.add_circle_outline_sharp),
                                  Text('Add Participants'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
            ),
          ),
          InkWell(
            onTap: () {
              createEvent();
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black)),
              child: Text("Create Event"),
            ),
          ),
        ],
      ),
    );
  }
}