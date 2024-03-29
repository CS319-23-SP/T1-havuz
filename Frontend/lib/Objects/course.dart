import 'section.dart';
import 'instructor.dart';

class Course {
  String department;
  String courseCode;
  List<Section> sections;
  Instructor coordinator;

  Course(
      {required this.department,
      required this.courseCode,
      required this.sections,
      required this.coordinator});
}
