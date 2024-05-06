// ignore_for_file: prefer_const_constructors

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
String? ID = "";

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
      ID = await TokenStorage.getID();
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

  List<List<ChatMessage>> messages = [[], []];
  Future<void> fetchMessages(String roomId) async {
    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.http('localhost:8080', '/chad/${roomId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        parseMessagesData(json.decode(response.body), roomId);
      } else {
        throw Exception('Failed to fetch questions data');
      }
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }

  void parseMessagesData(dynamic responseData, String roomID) async {
    List<ChatMessage> roomMessages = [];
    for (var i = 0; i < responseData['conversation'].length; i++) {
      final message = ChatMessage.fromJson(responseData['conversation'][i]);
      roomMessages.add(message);
      print(message.messageText);
    }
    int roomIndex = chatRooms.indexWhere((room) => room.roomId == roomID);
    if (roomIndex != -1) {
      messages[roomIndex] = roomMessages;
    }
  }

  void updateChsatStatus(bool chatOn, int index) {
    setState(() {
      _chatOn = chatOn;
      indexx = index;
      fetchMessages(chatRooms[indexx].roomId);
    });
  }

  void updateChatStatus(bool chatOn, int index) async {
    await fetchMessages(chatRooms[index].roomId);

    setState(() {
      _chatOn = chatOn;
      indexx = index;
    });
  }

  final messageController = TextEditingController();
  void _createMessage(List<ChatMessage> messages) async {
    /*final messageText = messageController.text;
    ChatMessage message = messages[indexx];
    String chatRoomId = messages[indexx].chatRoomId;
    String postedById = messages[indexx].postedByUserId;

    final url = Uri.parse('http://localhost:8080/chad');
    final id = int.tryParse(studentId);
    if (id == null) {
      print("bad id");
      return;
    }

    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'firstName': firstName,
        if (middleName.isNotEmpty) 'middleName': middleName,
        'lastName': lastName,
        'department': department,
      }),
    );
    if (response.statusCode == 200) {
      print('Student created successfully');
    } else {
      print('Failed to create student: ${response.reasonPhrase}');
    }
    GoRouter.of(context).go('/admin');*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Contacts(
            onTapCallback: updateChatStatus,
            chatRoom: chatRooms,
          ),
          Expanded(
            child: _chatOn
                ? Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ListView.builder(
                            //reverse: true,
                            shrinkWrap: true,
                            itemCount: messages[indexx].length,
                            itemBuilder: (BuildContext context, int index) {
                              final bool isMyMessage = messages[indexx]
                                          [messages[indexx].length - index - 1]
                                      .postedByUserId ==
                                  ID;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Align(
                                    alignment: isMyMessage
                                        ? Alignment.bottomLeft
                                        // Align to end if it's my message
                                        : Alignment
                                            .bottomRight, // Align to start if it's not my message
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5),
                                      decoration: BoxDecoration(
                                          borderRadius: isMyMessage
                                              ? BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15))
                                              : BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15)),
                                          color: isMyMessage
                                              ? PoolColors.recievedText
                                              : PoolColors.sentText),
                                      padding: EdgeInsets.all(10),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                          messages[indexx][index].messageText),
                                    )),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type your message...',
                                  border: OutlineInputBorder(),
                                ),
                                // Add your logic to handle sending messages here
                                // onPressed: () {},
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.send),
                                onPressed: /*_createMessage(messages[indexx])*/
                                    () {}),
                          ],
                        ),
                      ),
                    ],
                  )
                : Placeholder(),
          )
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
  late List<ChatRoom> chat;
  String? ownUserId;
  @override
  void initState() {
    super.initState();
    chat = widget.chatRoom;
    getid();
  }

  void getid() async {
    ownUserId = await TokenStorage.getID();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Filter out the user's own ID from the list of chatRoom
    List<String> otherUserIds = [];

    // Iterate through each chat room's userIds and exclude the user's own ID

    widget.chatRoom.forEach((chatRoom) {
      for (var userId in chatRoom.userIds) {
        if (userId != ownUserId) {
          otherUserIds.add(userId);
        }
      }
    });
    return Container(
      width: screenWidth / 4,
      decoration: BoxDecoration(color: PoolColors.fairBlue.withOpacity(0.4)),
      child: ListView.builder(
          itemCount: widget.chatRoom.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide.none, // Removes the top border
                  bottom: BorderSide(
                      color: Colors
                          .black), // Add or adjust bottom border as needed
                  left: BorderSide.none, // Add or adjust left border as needed
                  right:
                      BorderSide.none, // Add or adjust right border as needed
                ),
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    widget.onTapCallback(true, index);
                  });
                },
                title: Text(otherUserIds[index]),
              ),
            );
          }),
    );
  }
}
