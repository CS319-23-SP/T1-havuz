class Course {
  String id;
  String term;
  String syllabus;
  String department;
  String coordinatorID;
  String credits;
  List<String> sections;
  List<String> exams;
  Map<String, String> finalGrades;

  Course({
    required this.id,
    required this.term,
    required this.syllabus,
    required this.department,
    required this.coordinatorID,
    required this.credits,
    required this.sections,
    required this.exams,
    required this.finalGrades,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'].toString(),
      term: json['term'].toString(),
      syllabus: json['syllabus'].toString(),
      department: json['department'].toString(),
      coordinatorID: json['coordinatorID'].toString(),
      credits: json['credits'].toString(),
      sections: List<String>.from(json['sections'] ?? []),
      exams: List<String>.from(json['exams'] ?? []),
      finalGrades: Map<String, String>.from(json['finalgrades'] ?? {}),
    );
  }
}
