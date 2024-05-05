import 'package:first_trial/Pages/Auth/login_page.dart';
import 'package:first_trial/Pages/Homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'Pages/Questions/question_homepage.dart';
import 'Pages/Questions/question_create.dart';
import 'package:go_router/go_router.dart';
import 'Pages/Admin/admin_page.dart';
import 'package:url_strategy/url_strategy.dart';
import 'route_generator.dart';

void main() async {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'POOL',
      debugShowCheckedModeBanner: false,
      routerConfig: RouteGenerator().getRouter(),
    );
  }
}
