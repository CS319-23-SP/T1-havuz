import 'package:first_trial/Pages/Admin/admin_page.dart';
import 'package:first_trial/Pages/Admin/student_create_page.dart';
import 'package:first_trial/Pages/Chat/chat_homepage.dart';
import 'package:first_trial/Pages/Chat/create_contact.dart';
import 'package:first_trial/Pages/Section/Widgets/assignment_details.dart';
import 'package:first_trial/Pages/Section/Widgets/create_assignment.dart';
import 'package:first_trial/Pages/UserProfile/user_profile_page.dart';
import 'package:first_trial/Pages/Auth/login_page.dart';
import 'package:first_trial/Pages/Student/attendance.dart';
import 'package:first_trial/Pages/Student/grade.dart';
import 'package:first_trial/Pages/Questions/question_create.dart';
import 'package:first_trial/Pages/Questions/question_homepage.dart';
import 'package:first_trial/Pages/Homepage/homepage.dart';
import 'package:first_trial/Pages/Instructor/give_attendance_page.dart';
import 'package:go_router/go_router.dart';

class RouteGenerator {
  final String loginRoute = "/login";
  final String chat = "/chad";
  final String instructorRoute = "/instructor";
  final String questionHomepageRoute = "/instructor/question";
  final String questionCreateRoute = "/instructor/question/create";

  final String studentRoute = "/student";

  final String profileRoute = "/user/profile/:userId";

  final String assignmentRoute = "/:role/assignment/:sectionID/:assignmentID";

  final String adminRoute = "/admin";
  final String studentCreateRoute = "/admin/studentCreate";

  final String createAssignmentRoute = "/createAssignment/:sectionID";
  final String contactRoute = "/chad/createContact";

  getRouter() {
    return GoRouter(
      initialLocation: loginRoute,
      routes: [
        GoRoute(
          path: '/student/grade/:studentID',
          builder: (context, state) => StudentSectionGradePage(), // New page
        ),
        GoRoute(
          path: '/student/attendance/:studentID',
          builder: (context, state) => StudentAttendancePage(), // New page
        ),
        GoRoute(
          path: '/instructor/give-attendance',
          builder: (context, state) => GiveAttendancePage(), // New page
        ),
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: '/chad',
          builder: (context, state) {
            return const Chat_Homepage();
          },
        ),
        GoRoute(
            path: loginRoute,
            builder: (context, state) {
              return const LoginPage();
            }),
        GoRoute(
            path: assignmentRoute,
            builder: (context, state) {
              final sectionID = state.pathParameters['sectionID'].toString();
              final assignmentID =
                  state.pathParameters['assignmentID'].toString();
              final role = state.pathParameters['role'].toString();
              return Assignment_Details(
                  role: role, assignmentID: assignmentID, sectionID: sectionID);
            }),
        GoRoute(
            path: profileRoute,
            builder: (context, state) {
              final userId = state.pathParameters['userId'].toString();
              return UserProfilePage(userId: userId);
            }),
        GoRoute(
            path: createAssignmentRoute,
            builder: (context, state) {
              final section = state.pathParameters['sectionID'].toString();
              return CreateAssignmentPage(sectionID: section);
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
              return const CourseHomePage();
            }),
        GoRoute(
            path: adminRoute,
            builder: (context, state) {
              return Admin();
            }),
        GoRoute(
            path: contactRoute,
            builder: (context, state) {
              return CreateContactPage();
            }),
      ],
    );
  }
}
