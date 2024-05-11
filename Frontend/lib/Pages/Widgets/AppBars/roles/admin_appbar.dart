import 'package:first_trial/Pages/Admin/admin_page.dart';
import 'package:first_trial/Pages/Auth/login_page.dart';
import 'package:first_trial/Pages/Homepage/homepage.dart';
import 'package:first_trial/Pages/Questions/question_homepage.dart';
import 'package:first_trial/Pages/Admin/Create/student_create_page.dart';
import 'package:first_trial/Pages/UserProfile/user_profile_page.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/final_variables.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AdminAppBar({super.key});

  @override
  State<AdminAppBar> createState() => _AdminAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AdminAppBarState extends State<AdminAppBar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String course = list.first;

    final List<String> items = [
      'Student',
      'Instructor',
    ];

    String? selectedValue;

    final _addKey = GlobalKey<FormState>();
    final _listKey = GlobalKey<FormState>();

    return Row(
      children: [
        AppBarChoice(
          text: "Students",
          onPressed: () {
            GoRouter.of(context).go('/admin/allStudents');
          },
        ),
        const VerticalD(),
        AppBarChoice(
          text: "Instructors",
          onPressed: () {
            GoRouter.of(context).go('/admin/allInstructors');
          },
        ),
        const VerticalD(),
        AppBarChoice(
          text: "Sections",
          onPressed: () {
            GoRouter.of(context).go('/admin/allSections');
          },
        ),
      ],
    );
  }
}
