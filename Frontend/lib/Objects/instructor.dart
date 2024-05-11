import 'course.dart';

class Instructor {
  String id;
  String name;
  String department;
  List<String> coursesGiven;
  Instructor(
      {required this.id,
      required this.name,
      required this.department,
      required this.coursesGiven});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'].toString(),
      name:
          '${json['firstName']} ${json['middleName'] != null ? json['middleName'] + ' ' : ''}${json['lastName']}',
      department: json['department'].toString(),
      coursesGiven: List<String>.from(json['coursesGiven']),
    );
  }
}
