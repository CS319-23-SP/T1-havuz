import 'package:first_trial/Pages/Chat/Widgets/chat_message.dart';

class ChatRoom {
  String roomId;
  List<String> userIds;
  String chatInitiator;
  List<ChatMessage> messages;

  ChatRoom({
    required this.roomId,
    required this.userIds,
    required this.chatInitiator,
    required this.messages,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    List<ChatMessage> messages = [];
    if (json['message'] != null) {
      messages = List<ChatMessage>.from(
        json['message'].map(
          (messageJson) => ChatMessage.fromJson(messageJson),
        ),
      );
    }
    print(messages.toString());
    return ChatRoom(
      roomId: json['room']['_id'],
      userIds:
          List<String>.from(json['room']['userIds'].map((id) => id.toString())),
      chatInitiator: json['room']['chatInitiator'].toString(),
      messages: messages,
    );
  }
}
