// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:first_trial/Pages/Chat/Widgets/chat_message.dart';
import 'package:first_trial/Pages/Chat/Widgets/chat_room.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/success_fail.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chat_Homepage extends StatefulWidget {
  const Chat_Homepage({super.key});

  @override
  State<Chat_Homepage> createState() => Chat_HomepageState();
}

int indexx = 0;
bool _chatOn = false;
bool addContact = false;
String? ID = "";

String? addContactSt = "22000004";

class Chat_HomepageState extends State<Chat_Homepage> {
  String? term = PoolTerm.term;

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

  List<ChatRoom> chatRooms = [];
  @override
  void initState() {
    super.initState();
    connectAndListen(context);
    checkRole();
    getContacts();
  }

  @override
  void dispose() {
    // Close the connection here
    super.dispose();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    setState(() {});
  }

  Future<void> getContacts() async {
    chatRooms.clear();
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
          List<ChatRoom> newChatRooms =
              parseChatRoomData(responseData['conversations']);
          for (var room in newChatRooms) {
            if (!chatRooms
                .any((existingRoom) => existingRoom.roomId == room.roomId)) {
              chatRooms.add(room);
            }
          }
          setState(() {});
        } else {
          throw Exception('Failed to fetch courses data');
        }
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  List<ChatRoom> parseChatRoomData(dynamic responseData) {
    return (responseData as List<dynamic>)
        .map((assignmentData) => ChatRoom.fromJson(assignmentData))
        .toList();
  }

  List<List<ChatMessage>> messages = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    []
  ];
  Future<void> fetchMessages(String roomId) async {
    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.http('localhost:8080', '/chad/$roomId'),
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
      print(ChatMessage.fromJson(responseData['conversation'][i]));
      final message = ChatMessage.fromJson(responseData['conversation'][i]);
      roomMessages.add(message);
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
  void _createMessage(String message, String roomID) async {
    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.post(
        Uri.http('localhost:8080', '/chad/$roomID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'messageText': message}),
      );
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {});
      } else {
        print('Failed to create: ${response.reasonPhrase}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FailWidget(
              context: context,
              onDismiss: () {},
            );
          },
        );
      }
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }

  bool hasViewedYouAdded = false;

  void connectAndListen(BuildContext context) {
    if (!mounted) return; // Check if the widget is still mounted

    print("called");

    IO.Socket socket = IO.io('http://localhost:8080',
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connect');
    });

    socket.on('newchatroom', (data) {
      if (!hasViewedYouAdded && mounted) {
        viewYouAdded(context); // Pass the context here
      }
    });

    socket.on('newmessage', (data) {
      print("new message received");
      fetchMessages(data);
    });

    socket.onDisconnect((_) => print('disconnect'));
  }

  void viewYouAdded(BuildContext context) {
    hasViewedYouAdded = true;

    print("viewYouAdded");
    chatRooms.clear();
    getContacts();
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
                            reverse: false,
                            shrinkWrap: true,
                            itemCount: messages[indexx].length,
                            itemBuilder: (BuildContext context, int index) {
                              final bool isMyMessage =
                                  messages[indexx][index].postedByUserId == ID;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Align(
                                    alignment: isMyMessage
                                        ? Alignment.bottomRight
                                        // Align to end if it's my message
                                        : Alignment
                                            .bottomLeft, // Align to start if it's not my message
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5),
                                      decoration: BoxDecoration(
                                          borderRadius: !isMyMessage
                                              ? BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15))
                                              : BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15)),
                                          color: isMyMessage
                                              ? PoolColors.recievedText
                                              : PoolColors.sentText),
                                      padding: EdgeInsets.all(10),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: !isMyMessage
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              ValueNotifier<String>
                                                  userIdNotifier =
                                                  ValueNotifier<String>('');
                                              userIdNotifier.value =
                                                  messages[indexx][index]
                                                      .postedByUserId
                                                      .toString();
                                              GoRouter.of(context).go(
                                                  "/user/profile/${messages[indexx][index].postedByUserId}");
                                            },
                                            child: Text(
                                              !isMyMessage
                                                  ? messages[indexx][index]
                                                      .postedByUserId
                                                  : "You",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(messages[indexx][index]
                                              .messageText),
                                        ],
                                      ),
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
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  setState(() {
                                    _createMessage(messageController.text,
                                        chatRooms[indexx].roomId);
                                    messageController.clear();
                                  });
                                }),
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

    List<List<String>> otherUserIds = List.generate(
      widget.chatRoom.length,
      (_) => [],
      growable: false,
    );
    // Iterate through each chat room's userIds and exclude the user's own ID
    int index = 0;
    widget.chatRoom.forEach((chatRoom) {
      for (var userId in chatRoom.userIds) {
        if (userId != ownUserId) {
          otherUserIds[index].add(userId);
        }
      }
      index++;
    });
    return Container(
      width: screenWidth / 4,
      decoration: BoxDecoration(color: PoolColors.fairBlue.withOpacity(0.4)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(45)),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        GoRouter.of(context).go("/chad/createContact");
                      });
                    },
                    icon: Icon(Icons.add))),
          ),
          Expanded(
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
                        left: BorderSide
                            .none, // Add or adjust left border as needed
                        right: BorderSide
                            .none, // Add or adjust right border as needed
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          widget.onTapCallback(true, index);
                        });
                      },
                      title: Text(otherUserIds[index].toString()),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
