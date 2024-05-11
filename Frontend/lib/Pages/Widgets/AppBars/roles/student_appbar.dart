import 'package:first_trial/Pages/Questions/question_homepage.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/final_variables.dart';
import 'package:go_router/go_router.dart';

class StudentAppBar extends StatefulWidget implements PreferredSizeWidget {
  const StudentAppBar({super.key});

  @override
  State<StudentAppBar> createState() => _StudentAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _StudentAppBarState extends State<StudentAppBar> {
  final TextEditingController iconController = TextEditingController();
  dynamic studentID;

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    studentID = await TokenStorage.getID();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String course = list.first;

    final List<String> items = [
      'Grades',
      'Schedule',
    ];

    String? selectedValue;

    return Row(
      children: [
        AppBarChoice(
          text: "Grade",
          onPressed: () {
            GoRouter.of(context).go('/student/grade/$studentID');
          },
        ),
        const VerticalD(),
        AppBarChoice(
          text: "Attendance",
          onPressed: () {
            GoRouter.of(context).go('/student/attendance/$studentID');
          },
        ),
        const VerticalD(),
        AppBarChoice(
          text: "Create Event",
          onPressed: () {
            GoRouter.of(context).go('/createEvent');
          },
        ),
        const VerticalD(),
      ],
    );
  }
}
