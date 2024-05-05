class Section {
  String id;
  String term;
  String sectionID;
  String quota;
  List<String> students;
  List<String> assignments;
  String instructorID;
  List<String> material;

  Section({
    required this.id,
    required this.term,
    required this.sectionID,
    required this.quota,
    required this.students,
    required this.assignments,
    required this.instructorID,
    required this.material,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'].toString(),
      term: json['term'].toString(),
      sectionID: json['courseID'].toString(),
      quota: json['quota'].toString(),
      instructorID: json['instructorID'].toString(),
      students: List<String>.from(json['students'] ?? []),
      assignments: List<String>.from(json['assignments'] ?? []),
      material: List<String>.from(json['material'] ?? []),
    );
  }
}
