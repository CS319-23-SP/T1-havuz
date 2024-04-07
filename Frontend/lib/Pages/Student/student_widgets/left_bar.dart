import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:side_navigation/side_navigation.dart';

class LeftBar extends StatefulWidget {
  const LeftBar({super.key});

  @override
  State<LeftBar> createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> {
  List<Widget> views = const [
    Center(
      child: Text('Dashboard'),
    ),
    Center(
      child: Text('Account'),
    ),
    Center(
      child: Text('Settings'),
    ),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            footer: SideNavigationBarFooter(
                label: Text(
              'By team Pool',
              style: GoogleFonts.alike(),
            )),
            selectedIndex: selectedIndex,
            toggler: SideBarToggler(
                expandIcon: Icons.arrow_circle_right_outlined,
                shrinkIcon: Icons.arrow_circle_left_outlined),
            items: const [
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
              ),
              SideNavigationBarItem(
                icon: Icons.person,
                label: 'Account',
              ),
              SideNavigationBarItem(
                icon: Icons.settings,
                label: 'Settings',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            theme: SideNavigationBarTheme(
              backgroundColor: PoolColors.appBarBackground,
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              itemTheme: SideNavigationBarItemTheme(
                selectedBackgroundColor: PoolColors.fairBlue,
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
          ),
          Expanded(
            child: views.elementAt(selectedIndex),
          )
        ],
      ),
    );
  }
}
