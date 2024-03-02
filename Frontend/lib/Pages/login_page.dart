import 'package:first_trial/Pages/admin_page.dart';
import 'package:first_trial/Pages/password_forget_page.dart';
import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';
import 'course_homepage.dart';

void main() {
  runApp(const LoginPage());
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      color: PoolColors.cardWhite,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardColor: PoolColors.fairBlue,
      ),
      home: LoginPageWidget(),
    );
  }
}

class LoginPageWidget extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPageWidget({super.key});

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
                Container(
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
                          LoginPageInputButton(
                            usernameController: _usernameController,
                            labelText: "Bilkent ID",
                          ),
                          const SizedBox(height: 20),
                          LoginPageInputButton(
                              usernameController: _passwordController,
                              labelText: "Password"),
                          const RememberUsernameCheckbox(),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: screenHeight / 14,
                            width: 3 * (8 * (screenWidth / 7) / 14) / 2,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                  PoolColors.fairBlue,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                //String username = _usernameController.text;
                                //String password = _passwordController.text;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Admin()));
                                //TODO
                              },
                              child: const Text(
                                'Log in',
                                style: TextStyle(
                                    color: PoolColors.black, fontSize: 25),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PasswordForgetPage()));
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: PoolColors.black,
                              padding: const EdgeInsets.all(20),
                              textStyle: const TextStyle(fontSize: 15),
                            ),
                            child: const Text("Forgot Password?"),
                          ),
                        ],
                      ),
                    ),
                  ),
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

class LoginPageInputButton extends StatelessWidget {
  const LoginPageInputButton({
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

class RememberUsernameCheckbox extends StatefulWidget {
  const RememberUsernameCheckbox({super.key});

  @override
  State<RememberUsernameCheckbox> createState() =>
      _RememberUsernameCheckboxState();
}

class _RememberUsernameCheckboxState extends State<RememberUsernameCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text("Remember me"),
      checkColor: PoolColors.black,
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
      activeColor: Colors.transparent,
    );
  }
}
