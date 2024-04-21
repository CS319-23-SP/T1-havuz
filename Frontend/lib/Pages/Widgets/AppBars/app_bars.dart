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

const List<String> listforExam = <String>[
  'Create',
  'List',
];

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String role;

  const CustomAppBar({Key? key, required this.role}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PoolColors.appBarBackground,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: Row(
                children: [
                  Image.asset(
                    AssetLocations.bilkentLogo,
                    width: 35,
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: const Text("Course Homepage"),
                  ),
                ],
              ),
              onPressed: () {
                GoRouter.of(context).go(_getRouteForRole(role));
              },
            ),
          ),
          const VerticalD(),
          if (role == "admin") ...[
            // CustomAppBar(role: userRole) mesela
          ] else if (role == "instructor")
            ...[]
          else if (role == "student")
            ...[],
          //logout
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfilePage()),
            );
          },
          icon: const Icon(Icons.person_2),
        ),
        IconButton(
          onPressed: () async {
            await TokenStorage.deleteToken();
            GoRouter.of(context).go('/login');
          },
          icon: const MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Icon(Icons.logout),
          ),
        ),
      ],
    );
  }

  String _getRouteForRole(String role) {
    switch (role) {
      case "admin":
        return '/admin';
      case "instructor":
        return '/instructor';
      case "student":
        return '/student';
      default:
        return '/login';
    }
  }
}
