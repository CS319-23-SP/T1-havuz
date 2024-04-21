import 'package:first_trial/Pages/Student/student_widgets/left_bar.dart';
import 'package:first_trial/Pages/UserProfile/Widgets/user_card.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBar(),
      body: Row(
        children: [
          LeftBar(),
          Padding(
            padding: const EdgeInsets.only(left: 100),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                UserCard(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
