import 'dart:convert';

class Event {
  String title;
  DateTime date;
  List<dynamic> participants;
  String eventCreator;

  Event({
    required this.title,
    required this.date,
    required this.participants,
    required this.eventCreator,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      date: DateTime.parse(json['date']),
      participants: json['participants'],
      eventCreator: json['eventCreator'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'participants': participants,
      'eventCreator': eventCreator,
    };
  }
}
