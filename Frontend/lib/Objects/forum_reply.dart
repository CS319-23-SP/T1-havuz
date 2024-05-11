import 'dart:convert';

class ForumReply {
  String message;
  String postedByUser;
  String parentReplyId;
  String replyId;

  ForumReply({
    required this.message,
    required this.postedByUser,
    required this.parentReplyId,
    required this.replyId,
  });

  factory ForumReply.fromJson(Map<String, dynamic> json) {
    return ForumReply(
        message: json['message'],
        postedByUser: json['postedByUser'],
        parentReplyId: json['parentReplyId'],
        replyId: json['replyID']);
  }
}
