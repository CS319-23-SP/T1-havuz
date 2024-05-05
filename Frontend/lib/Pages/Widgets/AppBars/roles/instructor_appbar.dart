import 'package:first_trial/Pages/Admin/admin_page.dart';
import 'package:first_trial/Pages/Auth/login_page.dart';
import 'package:first_trial/Pages/Homepage/homepage.dart';
import 'package:first_trial/Pages/Questions/question_homepage.dart';
import 'package:first_trial/Pages/Admin/student_create_page.dart';
import 'package:first_trial/Pages/UserProfile/user_profile_page.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/final_variables.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class InstructorAppBar extends StatefulWidget implements PreferredSizeWidget {
  const InstructorAppBar({super.key});

  @override
  State<InstructorAppBar> createState() => _InstructorAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _InstructorAppBarState extends State<InstructorAppBar> {
  final TextEditingController iconController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const DropdownButtonChoice(),
        const VerticalD(),
        AppBarChoice(
          text: "Weekly Schedule",
          onPressed: () {},
        ),
        const VerticalD(),
        AppBarChoice(
          text: "Attendance",
          onPressed: () {},
        ),
        const VerticalD(),
        AppBarChoice(
            text: "Questions",
            onPressed: () {
              GoRouter.of(context).go('/instructor/question');
            }),
      ],
    );
  }
}
