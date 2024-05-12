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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LeftBar(role: role),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).go("/admin/allSections");
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Text("List Sections"),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).go("/admin/allInstructors");
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Text("List Instructors"),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).go("/admin/allStudents");
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Text("List Students"),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).go("/admin/section");
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Text("Create Section"),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).go("/admin/instructorCreate");
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Text("Create Instructor"),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).go("/admin/studentCreate");
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Text("Create Student"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
