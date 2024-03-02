import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:flip_card/flip_card.dart';

class PoolColors {
  static const Color white = Colors.white;
  static const Color cardWhite = Color.fromARGB(255, 241, 241, 242);
  static const Color fairBlue = Color.fromARGB(255, 32, 146, 240);
  static const Color turkuaz = Color.fromARGB(255, 25, 149, 173);
  static const Color appBarBackground = Color.fromARGB(64, 49, 110, 202);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color fairTurkuaz = Color.fromARGB(255, 161, 214, 226);
}

class AssetLocations {
  static const String bilkentLogo = "lib/Assets/bilkent_logo.png";
  static const String loginDesign = "lib/Assets/login_design.png";
  static const String userPhoto = "lib/Assets/user_photo.jpg";
}

/*
class PoolFonts {
  static const TextStyle Function(
      {Paint? background,
      Color? backgroundColor,
      Color? color,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
      List<FontFeature>? fontFeatures,
      double? fontSize,
      FontStyle? fontStyle,
      FontWeight? fontWeight,
      Paint? foreground,
      double? height,
      double? letterSpacing,
      Locale? locale,
      List<Shadow>? shadows,
      TextBaseline? textBaseline,
      TextStyle? textStyle,
      double? wordSpacing}) alike = GoogleFonts.alike;
}
*/
const List<String> examButtonList = <String>[
  'Exams',
  'Create',
  'List',
]; /*
const List<String> weeklyScheduleButtonList = <String>[
  'Weekly Schedule',
  'Create',
  'List',
];
*/

/*
class AppBarDropdownChoice extends StatefulWidget {
  const AppBarDropdownChoice(
      {super.key, required this.text, required this.list});

  final String text;
  final List<String> list;

  @override
  State<AppBarDropdownChoice> createState() => _AppBarDropdownChoiceState();
}

class _AppBarDropdownChoiceState extends State<AppBarDropdownChoice> {
  late String selectedItem;
  //late String text;
  @override 
  void initState() {
    super.initState();
    // Initialize the selected item to the first item in the list
    selectedItem = widget.list.first;
    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      
      value: "text",
      onChanged: (String? newValue) {
        setState(() {
          selectedItem = newValue!;
        });
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
*/

class DropdownButtonChoice extends StatefulWidget {
  const DropdownButtonChoice({
    super.key,
  });
  @override
  State<DropdownButtonChoice> createState() => _DropdownButtonChoiceState();
}

class _DropdownButtonChoiceState extends State<DropdownButtonChoice> {
  String dropdownValue = examButtonList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 8,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: examButtonList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class AppBarChoice extends StatelessWidget {
  const AppBarChoice({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final void Function()? onPressed; // Good
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}

class VerticalD extends StatelessWidget {
  const VerticalD({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30,
      child: VerticalDivider(
        color: PoolColors.black,
        width: 22.5,
      ),
    );
  }
}
