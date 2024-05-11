import 'dart:convert';

import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/success_fail.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class CreateContactPage extends StatefulWidget {
  const CreateContactPage({Key? key}) : super(key: key);

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {
  String? role = "unknown";
  String? term = PoolTerm.term;

  final TextEditingController headerController = TextEditingController();
  final TextEditingController topicsController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final TextEditingController groupTextController = TextEditingController();
  final List<TextEditingController> groupFieldControllers = [];

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    setState(() {});
  }

  String? _selectedValue;
  List<Widget> _additionalTextFields = [];

  void createContact() async {
    List<String> orgy = [];
    if (_selectedValue == "group") {
      for (var i = 0; i < groupFieldControllers.length; i++) {
        orgy.add(groupFieldControllers[i].text);
      }
      print(orgy);
    } else {
      orgy.add(textController.text); // = textController.text;
      print(orgy);
    }
    final url = Uri.parse('http://localhost:8080/chad/initiate');

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
      body: jsonEncode({'userIds': orgy}),
    );
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SuccessWidget(
            context: context,
            onDismiss: () {
              GoRouter.of(context).go("/chad");
            },
          );
        },
      );
    } else {
      print('Failed to create: ${response.reasonPhrase}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FailWidget(
            context: context,
            onDismiss: () {},
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Column(
        children: [
          Text("CreateUser"),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: 'group',
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value;
                            // Reset the additional text fields and controllers
                            _additionalTextFields.clear();
                            groupFieldControllers.clear();
                          });
                        },
                      ),
                      Text('Group'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: 'solo',
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value;
                            // Reset the additional text fields and controllers
                            _additionalTextFields.clear();
                            groupFieldControllers.clear();
                          });
                        },
                      ),
                      Text('Solo'),
                    ],
                  ),
                  if (_selectedValue == 'group')
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(height: 20.0),
                          ..._additionalTextFields,
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                TextEditingController newController =
                                    TextEditingController();
                                groupFieldControllers.add(newController);
                                _additionalTextFields.add(Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
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
                            child: Text('Add'),
                          ),
                        ],
                      ),
                    ),
                  if (_selectedValue == 'solo')
                    Expanded(
                      child: TextFormField(
                        controller: textController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: 'Enter User ID',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        createContact();
                      });
                    },
                    child: Text('Create Contact'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
