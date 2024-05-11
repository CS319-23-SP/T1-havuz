class Evaluation {
  String sectionId;
  String courseMessage;
  String instructorMessage;

  Evaluation({
    required this.sectionId,
    this.courseMessage = '',
    this.instructorMessage = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'sectionId': sectionId,
      'courseMessage': courseMessage,
      'instructorMessage': instructorMessage,
    };
  }

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      sectionId: json['sectionId'],
      courseMessage: json['courseMessage'] ?? '',
      instructorMessage: json['instructorMessage'] ?? '',
    );
  }
}
