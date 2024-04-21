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
          IconButton(onPressed: () {}, icon: Icon(Icons.chat_bubble_outline)),
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
      ),
    );
  }
}
