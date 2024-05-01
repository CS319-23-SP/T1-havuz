import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/Pages/UserProfile/Widgets/user_card.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/AppBars/roles/student_appbar.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, this.userId = ""});

  final String userId;
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  var user = {};
  var role;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    String id = widget.userId;

    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    role = await TokenStorage.getRole();

    if (role == "student") {
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
        print(response.body);
        if (responseData['success']) {
          setState(() {
            user = responseData["instructor"];
          });
        } else {
          throw Exception('Failed to fetch instructors data');
        }
      }
    }
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        role: role,
      ),
      body: Row(
        children: [
          LeftBar(
            role: role,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 100),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                UserCard(user: user),
              ],
            ),
          )
        ],
      ),
    );
  }
}
