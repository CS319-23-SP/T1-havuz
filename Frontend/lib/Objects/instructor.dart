import 'course.dart';

class Instructor {
  String id;
  String name;
  String department;
  List<Course> coursesGiven;
  Instructor(
      {required this.id,
      required this.name,
      required this.department,
      required this.coursesGiven});
}
