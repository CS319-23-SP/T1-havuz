import 'package:first_trial/Pages/Admin/admin_page.dart';
import 'package:first_trial/Pages/Auth/login_page.dart';
import 'package:first_trial/Pages/Instructor/course_homepage.dart';
import 'package:first_trial/Pages/Questions/question_homepage.dart';
import 'package:first_trial/Pages/Admin/student_create_page.dart';
import 'package:first_trial/Pages/UserProfile/user_profile_page.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/final_variables.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentAppBar extends StatefulWidget implements PreferredSizeWidget {
  const StudentAppBar({super.key});

  @override
  State<StudentAppBar> createState() => _StudentAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _StudentAppBarState extends State<StudentAppBar> {
  final TextEditingController iconController = TextEditingController();

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

    return AppBar(
      backgroundColor: PoolColors.appBarBackground,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const SizedBox(
            width: 23,
          ),
          IconButton(
            icon: Row(
              children: [
                Image.asset(
                  AssetLocations.bilkentLogo,
                  width: 35,
                  height: 35,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text("Course Homepage"),
              ],
            ),
            onPressed: () {
              GoRouter.of(context).go('/instructor');
            },
          ),
          const VerticalD(),
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
      ),
      actions: <Widget>[
        const SizedBox(
          width: 45,
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_active_outlined)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserProfilePage()),
              );
            },
            icon: const Icon(Icons.person_outline)),
        const SizedBox(
          width: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: IconButton(
            onPressed: () async {
              await TokenStorage.deleteToken();
              GoRouter.of(context).go('/login');
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ),
      ],
    );
  }
}
