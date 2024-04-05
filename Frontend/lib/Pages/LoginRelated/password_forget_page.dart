import 'package:first_trial/Pages/LoginRelated/login_page.dart';
import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';
import '../Instructor/course_homepage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordForgetPage extends StatelessWidget {
  const PasswordForgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forgot Page',
      color: PoolColors.cardWhite,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardColor: PoolColors.fairBlue,
      ),
      home: ForgotPageWidget(),
    );
  }
}

class ForgotPageWidget extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  ForgotPageWidget({super.key});

  Future<void> _changePassword(BuildContext context) async {
    final id = int.tryParse(usernameController.text);
    if (id == null) {
      print("bad id");
      return;
    }
    final newpassword = newPasswordController.text;
    final url = Uri.parse('http://localhost:3000/changepassword');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'password': newpassword,
      }),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to change password: ${response.body}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(screenHeight / 7),
            child: Row(
              children: [
                SizedBox(
                  width: 8 * (screenWidth / 7) / 14,
                ),
                LoginPageContainer(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  usernameController: usernameController,
                  newPasswordController: newPasswordController,
                  onPressed: () => _changePassword(context),
                ),
              ],
            ),
          ),
          Image.asset(
            AssetLocations.loginDesign,
          ),
        ],
      ),
    );
  }
}

class LoginPageContainer extends StatelessWidget {
  const LoginPageContainer({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.usernameController,
    required this.newPasswordController,
    required this.onPressed,
  });

  final double screenWidth;
  final double screenHeight;
  final TextEditingController usernameController;
  final TextEditingController newPasswordController;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: PoolColors.cardWhite,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: SizedBox(
        width: screenWidth / 4,
        height: 3 * (screenHeight / 4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PasswordForgotPageInputButton(
                usernameController: usernameController,
                labelText: "Enter email or Bilkent ID",
              ),
              const SizedBox(height: 30),
              PasswordForgotPageInputButton(
                  usernameController: newPasswordController,
                  labelText: "Enter new ID"),
              const SizedBox(height: 30),
              SizedBox(
                height: screenHeight / 14,
                width: 3 * (8 * (screenWidth / 7) / 14) / 2,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll<Color>(
                      PoolColors.fairBlue,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: onPressed,
                  child: const Text(
                    'Change',
                    style: TextStyle(color: PoolColors.black, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordForgotPageInputButton extends StatelessWidget {
  const PasswordForgotPageInputButton({
    super.key,
    required TextEditingController usernameController,
    required this.labelText,
  }) : _usernameController = usernameController;

  final TextEditingController _usernameController;

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: PoolColors.black),
          color: PoolColors.fairTurkuaz,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
          ),
        ),
      ),
    );
  }
}
