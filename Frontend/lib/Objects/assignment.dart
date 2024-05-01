import 'package:first_trial/Objects/question.dart';

class Assignment {
  String id;
  String term;
  String sectionID;
  String deadline;
  String solutionKey;
  List<String> questions;

  Assignment({
    required this.term,
    required this.sectionID,
    required this.questions,
    required this.deadline,
    this.id = "",
    this.solutionKey = "",
  });
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'].toString(),
      term: json['term'].toString(),
      sectionID: json['sectionID'].toString(),
      deadline: json['deadline'].toString(),
      questions: List<String>.from(json['questions'] ?? []),
      solutionKey: json['solutionKey'].toString(),
    );
  }
}
