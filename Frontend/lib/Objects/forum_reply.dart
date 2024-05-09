import 'dart:convert';

class ForumReply {
  String messageText;
  String postedByUser;
  String parentReplyId;
  String replyId;

  ForumReply({
    required this.messageText,
    required this.postedByUser,
    required this.parentReplyId,
    required this.replyId,
  });

  factory ForumReply.fromJson(Map<String, dynamic> json) {
    return ForumReply(
        messageText: json['messageText'],
        postedByUser: json['postedByUser'],
        parentReplyId: json['parentReplyId'],
        replyId: json['replyID']);
  }
}
