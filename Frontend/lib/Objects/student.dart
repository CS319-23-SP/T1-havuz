class Student {
  String id;
  String name;
  List<String> courses;

  Student({required this.id, required this.name, required this.courses});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'].toString(),
      name:
          '${json['firstName']} ${json['middleName'] != null ? json['middleName'] + ' ' : ''}${json['lastName']}',
      courses: List<String>.from(json['coursesTaken']),
    );
  }
}
