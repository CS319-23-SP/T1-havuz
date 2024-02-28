import 'package:first_trial/Pages/course_homepage.dart';
import 'package:first_trial/Pages/question_homepage.dart';
import 'package:first_trial/Pages/user_prifile_page.dart';
import 'package:flutter/material.dart';
import 'package:first_trial/final_variables.dart';

const List<String> listforExam = <String>[
  'Create',
  'List',
];

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CourseHomePage()));
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuestionHomepage()));
                  }),
            ],
          ),
        ),
        actions: <Widget>[
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
                        builder: (context) => const UserProfilePage()));
              },
              icon: const Icon(Icons.person_outline)),
          const SizedBox(
            width: 45,
          ),
        ],
      ),
    );
  }
}/*

class StudentAppBar extends StatefulWidget implements PreferredSizeWidget {
  const StudentAppBar({super.key});

  @override
  State<StudentAppBar> createState() => _StudentAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _StudentAppBarState extends State<StudentAppBar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PoolColors.appBarBackground,
        automaticallyImplyLeading: false,
        title: Expanded(
          child: Row(
            children: [
              /*DropdownButton<String>(
                alignment: AlignmentDirectional.topStart,
                icon: const Icon(Icons.menu),
                elevation: 8,
                style: const TextStyle(color: Colors.black),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    course = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),*/
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
                onPressed: () {},
              ),
              const VerticalD(),
              const AppBarChoice(text: "Exams"),
              const VerticalD(),
              const AppBarChoice(text: "Weekly Schedule"),
              const VerticalD(),
              const AppBarChoice(text: "Attendance"),
              const VerticalD(),
              const AppBarChoice(text: "Assignments"),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_active_outlined)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
          const SizedBox(
            width: 45,
          ),
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PoolColors.appBarBackground,
        automaticallyImplyLeading: false,
        title: Expanded(
          child: Row(
            children: [
              /*
              DropdownButton<String>(
                alignment: AlignmentDirectional.topStart,
                icon: const Icon(Icons.menu),
                elevation: 8,
                style: const TextStyle(color: Colors.black),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    course = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),*/
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
                onPressed: () {},
              ),
              const VerticalD(),
              const AppBarChoice(text: "Create"),
              const VerticalD(),
              const AppBarChoice(text: "Exams"),
              const VerticalD(),
              const AppBarChoice(text: "List S or I"),
              const VerticalD(),
              const AppBarChoice(text: "Assignments"),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_active_outlined)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
          const SizedBox(
            width: 45,
          ),
        ],
      ),
    );
  }
}
*/