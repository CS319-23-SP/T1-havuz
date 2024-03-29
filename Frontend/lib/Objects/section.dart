import 'package:first_trial/Objects/course.dart';
import 'package:first_trial/Objects/instructor.dart';
import 'package:first_trial/Objects/student.dart';

class Section extends Course {
  List<Instructor> instructors;
  List<Student> students;
  Section(
      {required super.department,
      required super.courseCode,
      required super.sections,
      required super.coordinator,
      required this.instructors,
      required this.students});
}
