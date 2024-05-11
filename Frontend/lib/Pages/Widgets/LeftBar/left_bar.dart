// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:first_trial/Objects/section.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:http/http.dart' as http;

int ind = 0;
bool showDetails = true;

class LeftBar extends StatefulWidget {
  String? term = PoolTerm.term;

  final String? role;

  LeftBar({
    Key? key,
    required this.role,
  }) : super(key: key);
  @override
  State<LeftBar> createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> {
  String? role = "unknown";

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    fetchSections();
    setState(() {});
  }

  List<Section> sections = [];
  late final ScrollController _scrollController;

  Future<void> fetchSections() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();
      String? term = PoolTerm.term;

      final response = await http.get(
        Uri.http('localhost:8080', '/section/$ID/$term'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            sections = parseSectionsData(responseData['section']);
          });
        } else {
          throw Exception('Failed to fetch courses data');
        }
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching co3asdad22urses: $e');
    }
  }

  List<Section> parseSectionsData(dynamic responseData) {
    return (responseData as List<dynamic>)
        .map((sectionData) => Section.fromJson(sectionData))
        .toList();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SideNavigationBar(
      footer: SideNavigationBarFooter(
          label: Text(
        'By team Pool',
        style: GoogleFonts.alike(),
      )),
      selectedIndex: selectedIndex,
      initiallyExpanded: false,
      toggler: SideBarToggler(
          expandIcon: Icons.arrow_circle_right_outlined,
          shrinkIcon: Icons.arrow_circle_left_outlined),
      items: [
        SideNavigationBarItem(
          icon: Icons.dashboard,
          label: 'Dashboard',
        ),
        SideNavigationBarItem(
          icon: Icons.person,
          label: 'Account',
        ),
        SideNavigationBarItem(
          icon: Icons.chat,
          label: 'Chat',
        ),
      ],
      onTap: (index) async {
        setState(() {
          selectedIndex = index;
        });
        var id = await TokenStorage.getID();
        print(selectedIndex);
        switch (selectedIndex) {
          case 0:
            return GoRouter.of(context).go(_getRouteForRole(widget.role));
          case 1:
            return GoRouter.of(context).go('/user/profile/$id');
          case 2:
            return GoRouter.of(context).go('/chad');
        }
      },
      theme: SideNavigationBarTheme(
        backgroundColor: PoolColors.appBarBackground,
        togglerTheme: SideNavigationBarTogglerTheme.standard(),
        itemTheme: SideNavigationBarItemTheme(
          selectedBackgroundColor: Colors.transparent,
          unselectedBackgroundColor: Colors.transparent,
          selectedItemColor: PoolColors.black,
          unselectedItemColor: PoolColors.black,
          iconSize: 28,
          labelTextStyle: GoogleFonts.alike(
            textStyle: TextStyle(fontSize: 20),
          ),
        ),
        dividerTheme: SideNavigationBarDividerTheme(
            showFooterDivider: false,
            showMainDivider: true,
            mainDividerColor: PoolColors.black,
            mainDividerThickness: 0.2,
            showHeaderDivider: true),
      ),
    );
  }

  String _getRouteForRole(String? role) {
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
