import 'package:first_trial/Pages/Admin/admin_page.dart';
import 'package:first_trial/Pages/LoginRelated/login_page.dart';
import 'package:first_trial/Pages/Instructor/course_homepage.dart';
import 'package:first_trial/Pages/Questions/question_homepage.dart';
import 'package:first_trial/Pages/Admin/student_create_page.dart';
import 'package:first_trial/Pages/Instructor/user_profile_page.dart';
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

    return Scaffold(
      appBar: AppBar(
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
                  Text(
                    "Course Homepage",
                    style: GoogleFonts.alike(fontSize: 16),
                  ),
                ],
              ),
              onPressed: () {
                GoRouter.of(context).go('/student');
              },
            ),
            const VerticalD(),
            SizedBox(
              width: 150,
              child: Form(
                //key: _addKey,
                child: DropdownButtonFormField2<String>(
                  hint: Text(
                    "Exams",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.alike(color: PoolColors.black),
                  ),
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.alike(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                  /* validator: (value) {
                                  if (value == null) {
                                    return 'Please select gender.';
                                  }
                                  return null;
                                },*/
                  onChanged: (value) {
                    //Do something when selected item is changed.
                    if (value == items[0]) {
                      GoRouter.of(context).go('/student');
                    }
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
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
                text: "Assignment",
                onPressed: () {
                  GoRouter.of(context).go('/student');
                }),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await TokenStorage.deleteToken();
              GoRouter.of(context).go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                "Log out",
              ),
            ),
          )
        ],
      ),
    );
  }
}

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PoolColors.appBarBackground,
        automaticallyImplyLeading: false,
        title: Expanded(
          child: Row(
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
                GoRouter.of(context).go('/instructor/profile');
              },
              icon: const Icon(Icons.person_outline)),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              await TokenStorage.deleteToken();
              GoRouter.of(context).go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                "Log out",
              ),
            ),
          )
        ],
      ),
    );
  }
}

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

    return Scaffold(
      appBar: AppBar(
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
                GoRouter.of(context).go('/admin');
              },
            ),
            const VerticalD(),
            SizedBox(
              width: 150,
              child: Form(
                //key: _addKey,
                child: DropdownButtonFormField2<String>(
                  hint: Text("Add"),
                  isExpanded: true,
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  /* validator: (value) {
                                  if (value == null) {
                                    return 'Please select gender.';
                                  }
                                  return null;
                                },*/
                  onChanged: (value) {
                    //Do something when selected item is changed.
                    if (value == items[0]) {
                      GoRouter.of(context).go('/admin/studentCreate');
                    }
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const VerticalD(),
            SizedBox(
              width: 150,
              child: Form(
                //key: _addKey,

                child: DropdownButtonFormField2<String>(
                  hint: Text("List"),
                  isExpanded: true,
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  /* validator: (value) {
                                  if (value == null) {
                                    return 'Please select gender.';
                                  }
                                  return null;
                                },*/
                  onChanged: (value) {
                    if (value == items[0]) {
                      GoRouter.of(context).go('/admin/studentCreate');
                    }
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const VerticalD(),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await TokenStorage.deleteToken();
              GoRouter.of(context).go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                "Log out",
              ),
            ),
          )
        ],
      ),
    );
  }
}
