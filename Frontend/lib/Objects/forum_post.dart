import 'dart:convert';

class ForumPost {
  String forumInitiator;
  String title;
  String sectionId;
  String initialReplyId;

  ForumPost({
    required this.forumInitiator,
    required this.title,
    required this.sectionId,
    required this.initialReplyId,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      forumInitiator: json['forumInitiator'],
      title: json['title'],
      sectionId: json['sectionId'],
      initialReplyId: json['initialReplyId'],
    );
  }
}
