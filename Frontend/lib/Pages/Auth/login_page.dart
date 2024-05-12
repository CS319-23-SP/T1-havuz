import 'package:first_trial/Pages/Auth/password_forget_page.dart';
import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:first_trial/token.dart";
import 'package:go_router/go_router.dart';

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
        await TokenStorage.saveToken(
            data['authorization'], role, id.toString());

        if (role == "admin") {
          GoRouter.of(context).go('/admin');
        } else if (role == "student") {
          GoRouter.of(context).go('/student');
        } else if (role == "instructor") {
          GoRouter.of(context).go('/instructor');
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
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              opacity: const AlwaysStoppedAnimation(.5),
              AssetLocations.loginDesign,
              //  fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                  backgroundBlendMode: BlendMode.dst,
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
                            backgroundColor: MaterialStatePropertyAll<Color>(
                              PoolColors.fairBlue.withOpacity(0.8),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          onPressed: () => _login(context),
                          child: FittedBox(
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                  color: PoolColors.black.withOpacity(0.8),
                                  fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
              ? Icon(
                  Icons.visibility_off,
                  color: Colors.black12.withOpacity(0.6),
                )
              : Icon(
                  Icons.visibility,
                  color: Colors.black12.withOpacity(0.6),
                ),
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
        color: PoolColors.fairTurkuaz.withOpacity(0.65),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: widget.isObscured ? textFieldForPassword : textField,
      ),
    );
  }
}
