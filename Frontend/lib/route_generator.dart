import 'package:first_trial/Pages/Admin/admin_page.dart';
import 'package:first_trial/Pages/Admin/student_create_page.dart';
import 'package:first_trial/Pages/Chat/chat_homepage.dart';
import 'package:first_trial/Pages/Chat/create_contact.dart';
import 'package:first_trial/Pages/Forum/create_forum.dart';
import 'package:first_trial/Pages/Forum/forum_by_id.dart';
import 'package:first_trial/Pages/Forum/view_forums.dart';
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
  final String viewForumRoute = "/:sectionID/forum";
  final String createForumRoute = "/:sectionID/createForum";

  final String studentRoute = "/student";

  final String profileRoute = "/user/profile/:userId";

  final String assignmentRoute = "/:role/assignment/:sectionID/:assignmentID";

  final String adminRoute = "/admin";
  final String studentCreateRoute = "/admin/studentCreate";

  final String createAssignmentRoute = "/createAssignment/:sectionID";
  final String contactRoute = "/chad/createContact";
  final String studentSectionGrade = "/student/grade/:studentID";
  final String studentSectionAttendance = "/student/attendance/:studentID";
  final String instructorAttendance = "/instructor/give-attendance";

  final String forumRouteId = "/:sectionId/forum/:id";
  getRouter() {
    return GoRouter(
      initialLocation: loginRoute,
      routes: [
        GoRoute(
          path: studentSectionGrade,
          builder: (context, state) => StudentSectionGradePage(), // New page
        ),
        GoRoute(
          path: studentSectionAttendance,
          builder: (context, state) => StudentAttendancePage(), // New page
        ),
        GoRoute(
          path: instructorAttendance,
          builder: (context, state) => GiveAttendancePage(), // New page
        ),
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: chat,
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
            path: viewForumRoute,
            builder: (context, state) {
              final sectionID = state.pathParameters['sectionID'].toString();
              return ViewForumPage(sectionID: sectionID);
            }),
        GoRoute(
            path: createForumRoute,
            builder: (context, state) {
              final sectionID = state.pathParameters['sectionID'].toString();
              return CreateForumPage(sectionID: sectionID);
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
        GoRoute(
            path: forumRouteId,
            builder: (context, state) {
              final id = state.pathParameters['id'].toString();
              final sectionId = state.pathParameters['sectionId'].toString();
              return ForumRoutePage(replyId: id, sectionId: sectionId);
            }),
      ],
    );
  }
}
