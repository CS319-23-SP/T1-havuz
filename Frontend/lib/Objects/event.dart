import 'dart:convert';

class Event {
  String messageText;
  String title;
  DateTime date;
  List<dynamic> participants;
  String eventCreator;

  Event({
    required this.messageText,
    required this.title,
    required this.date,
    required this.participants,
    required this.eventCreator,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      messageText: json['messageText'],
      date: DateTime.parse(json['date']),
      participants: json['participants'],
      eventCreator: json['eventCreator'],
    );
  }
}
