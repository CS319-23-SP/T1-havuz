import 'package:first_trial/Pages/Admin/admin_page.dart';
import 'package:first_trial/Pages/Questions/question_homepage.dart';
import 'package:first_trial/Pages/LoginRelated/password_forget_page.dart';
import 'package:first_trial/Pages/Student/student_homepage.dart';
import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';
import '../course_homepage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:first_trial/token.dart";

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
  String _errorMessage = 'Invalid ID or password';

  LoginPageWidget({super.key});

  Future<void> _login(BuildContext context) async {
    
    final id = int.tryParse(_usernameController.text);
    if (id == null) {
      print("bad id");
      return;
    }
    String password = _passwordController.text;
    String role = "";
    
    try {
      var response = await http.post(
        Uri.parse('http://localhost:8080/auth/login/${id}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'password': password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        role = data['role'];
        await TokenStorage.saveToken(data['authorization']);

        print(role);

        if (role == "admin") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Admin()));
        } else if (role == "student") {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => StudentHomepage()));
        }
        else if (role == "instructor") {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CourseHomePage()));
        }
      } else {
        print("Login failed: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              padding: const EdgeInsets.all(20.0),
              height: 90,
              margin: const EdgeInsetsDirectional.fromSTEB(200, 0, 200, 0),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 48,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sorry!',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        Text(
                          'Invalid ID or password',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 3),
        ));
      }
    } catch (e) {
      print("erro");
      print(e);
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
                            isObscured: false,
                          ),
                          const SizedBox(height: 20),
                          LoginPageInputButton(
                            usernameController: _passwordController,
                            labelText: "Password",
                            isObscured: true,
                          ),
                          const SizedBox(height: 30),
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
                              onPressed: () => _login(context),
                              /*String username = _usernameController.text;
                                //String password = _passwordController.text;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Admin()));
                                //TODO
                              },*/
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

class LoginPageInputButton extends StatefulWidget {
  const LoginPageInputButton({
    Key? key,
    required TextEditingController usernameController,
    required this.labelText,
    required this.isObscured,
  })  : _usernameController = usernameController,
        super(key: key);

  final TextEditingController _usernameController;
  final String labelText;
  final bool isObscured;

  @override
  _LoginPageInputButtonState createState() => _LoginPageInputButtonState();
}

class _LoginPageInputButtonState extends State<LoginPageInputButton> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    var textField = TextField(
      controller: widget._usernameController,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: widget.labelText,
      ),
    );
    var textFieldForPassword = TextField(
      obscureText: _isObscured,
      controller: widget._usernameController,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: widget.labelText,
        suffixIcon: IconButton(
          icon: _isObscured
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: PoolColors.black),
        color: PoolColors.fairTurkuaz,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: widget.isObscured ? textFieldForPassword : textField,
      ),
    );
  }
}
