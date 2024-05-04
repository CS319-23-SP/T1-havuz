import 'dart:convert';

import 'package:first_trial/Pages/Chat/Widgets/chat_message.dart';
import 'package:first_trial/Pages/Chat/Widgets/chat_room.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chat_Homepage extends StatefulWidget {
  const Chat_Homepage({super.key});

  @override
  State<Chat_Homepage> createState() => Chat_HomepageState();
}

int indexx = 0;
bool _chatOn = false;

class Chat_HomepageState extends State<Chat_Homepage> {
  String? role = "unknown";
  ChatRoom cr = ChatRoom(
      roomId: "roomId",
      userIds: ["userIds"],
      chatInitiator: "chatInitiator",
      messages: [
        ChatMessage(
            messageId: "messageId",
            chatRoomId: "chatRoomId",
            messageText: "messageText",
            messageType: "messageType",
            postedByUserId: "postedByUserId",
            createdAt: DateTime(2022))
      ]);

  List<String> contactIds = [];
  List<ChatRoom> chatRooms = [];
  @override
  void initState() {
    super.initState();
    checkRole();
    getContacts();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    setState(() {});
  }

  Future<void> getContacts() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();

      final response = await http.get(
        Uri.http('localhost:8080', '/chad'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          for (var i = 0; i < responseData['conversations'].length; i++) {
            cr = parseChatRoomData(responseData['conversations'])[i];
            chatRooms.add(cr);
            print(cr.userIds);
          }
          setState(() {});
        } else {
          throw Exception('Failed to fetch courses data');
        }
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching coD33FADSFurses: $e');
    }
  }

  List<ChatRoom> parseChatRoomData(dynamic responseData) {
    return (responseData as List<dynamic>)
        .map((assignmentData) => ChatRoom.fromJson(assignmentData))
        .toList();
  }

  void updateChatStatus(bool chatOn, int index) {
    setState(() {
      _chatOn = chatOn;
      indexx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        children: [
          Contacts(
            onTapCallback: updateChatStatus,
            chatRoom: chatRooms,
          ),
          Expanded(
              child: _chatOn
                  ? Text(chatRooms[indexx].messages.toString())
                  : Placeholder())
        ],
      ),
    );
  }
}

class Contacts extends StatefulWidget {
  final List<ChatRoom> chatRoom;
  final Function(bool, int) onTapCallback;

  const Contacts({
    super.key,
    required this.chatRoom,
    required this.onTapCallback,
  });
  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth / 4,
      decoration: BoxDecoration(color: PoolColors.fairBlue.withOpacity(0.4)),
      child: ListView.builder(
          itemCount: widget.chatRoom.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                widget.onTapCallback(true, index);
              },
              title: Text(widget.chatRoom[index].userIds.toString()),
            );
          }),
    );
  }
}
