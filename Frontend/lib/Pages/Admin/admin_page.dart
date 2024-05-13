import 'dart:math';

import 'package:first_trial/Pages/Auth/login_page.dart';
import 'package:first_trial/Pages/Widgets/AppBars/roles/admin_appbar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/Pages/Widgets/access_denied.dart';
import 'package:first_trial/final_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'Create/student_create_page.dart';
import '../../Objects/student.dart';
import 'dart:convert';
import 'package:first_trial/token.dart';
import 'package:go_router/go_router.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  String? role = "unknown";
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    if (role != "admin") {
      return;
    } else {
      setState(() {});
    }
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      0.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LeftBar(role: role),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              GoRouter.of(context).go("/admin/allSections");
                            },
                            child: SizedBox(
                              width: 250,
                              height: 200,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: getRandomColor()),
                                child: Text(
                                  "List Sections",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              GoRouter.of(context).go("/admin/allInstructors");
                            },
                            child: SizedBox(
                              width: 250,
                              height: 200,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: getRandomColor()),
                                child: Text("List Instructors",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              GoRouter.of(context).go("/admin/allStudents");
                            },
                            child: SizedBox(
                              width: 250,
                              height: 200,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: getRandomColor()),
                                child: Text("List Students",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              GoRouter.of(context).go("/admin/section");
                            },
                            child: SizedBox(
                              width: 250,
                              height: 200,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: getRandomColor()),
                                child: Text("Create Section",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              GoRouter.of(context)
                                  .go("/admin/instructorCreate");
                            },
                            child: SizedBox(
                              width: 250,
                              height: 200,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: getRandomColor()),
                                child: Text("Create Instructor",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              GoRouter.of(context).go("/admin/studentCreate");
                            },
                            child: SizedBox(
                              width: 250,
                              height: 200,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: getRandomColor()),
                                child: Text("Create Student",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
