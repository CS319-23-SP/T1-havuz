class Question {
  String id;
  String header;
  String text;
  String creatorID;
  List<String> topics;
  List<String> courses;
  List<String> pastExams;

  Question({
    required this.id,
    required this.header,
    required this.courses,
    required this.text,
    required this.topics,
    required this.creatorID,
    required this.pastExams,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'].toString(),
      courses: List<String>.from(json['courses']),
      header: json['header'],
      creatorID: json['creatorId'].toString(),
      text: json['text'],
      topics: List<String>.from(json['topics']),
      pastExams: List<String>.from(json['pastExams']),
    );
  }
}