import 'dart:js';

import 'package:first_trial/Pages/Admin/admin_page.dart';
import 'package:first_trial/Pages/Admin/student_create_page.dart';
import 'package:first_trial/Pages/UserProfile/user_profile_page.dart';
import 'package:first_trial/Pages/Auth/login_page.dart';
import 'package:first_trial/Pages/Questions/question_create.dart';
import 'package:first_trial/Pages/Questions/question_homepage.dart';
import 'package:first_trial/Pages/Student/student_homepage.dart';
import 'package:first_trial/Pages/Instructor/course_homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class RouteGenerator {
  final String loginRoute = "/login";

  final String instructorRoute = "/instructor";
  final String questionHomepageRoute = "/instructor/question";
  final String questionCreateRoute = "/instructor/question/create";
  final String userProfilePageRoute = "/instructor/profile";

  final String studentRoute = "/student";

  final String adminRoute = "/admin";
  final String studentCreateRoute = "/admin/studentCreate";

  getRouter() {
    return GoRouter(
      initialLocation: loginRoute,
      routes: [
        GoRoute(
            path: loginRoute,
            builder: (context, state) {
              return const LoginPage();
            }),
        GoRoute(
            path: userProfilePageRoute,
            builder: (context, state) {
              return const UserProfilePage();
            }),
        GoRoute(
            path: questionHomepageRoute,
            builder: (context, state) {
              return const QuestionHomepage();
            }),
        GoRoute(
            path: questionCreateRoute,
            builder: (context, state) {
              return AddQuestionPage();
            }),
        GoRoute(
            path: studentCreateRoute,
            builder: (context, state) {
              return const StudentCreationPage();
            }),
        GoRoute(
            path: instructorRoute,
            builder: (context, state) {
              return const CourseHomePage();
            }),
        GoRoute(
            path: studentRoute,
            builder: (context, state) {
              return const StudentHomepage();
            }),
        GoRoute(
            path: adminRoute,
            builder: (context, state) {
              return Admin();
            }),
      ],
    );
  }
}
