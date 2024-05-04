class ChatMessage {
  String messageId;
  String chatRoomId;
  String messageText;
  String messageType;
  String postedByUserId;
  DateTime createdAt;

  ChatMessage({
    required this.messageId,
    required this.chatRoomId,
    required this.messageText,
    required this.messageType,
    required this.postedByUserId,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['_id'],
      chatRoomId: json['chatRoomId'],
      messageText: json['message']['messageText'],
      messageType: json['type'],
      postedByUserId: json['message']['postedByUser']['_id'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
