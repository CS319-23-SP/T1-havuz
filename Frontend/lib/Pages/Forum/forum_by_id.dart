import 'package:first_trial/Objects/forum_post.dart';
import 'package:first_trial/Objects/forum_reply.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/Pages/Widgets/success_fail.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForumRoutePage extends StatefulWidget {
  const ForumRoutePage({
    Key? key,
    required this.replyId,
    required this.sectionId,
  }) : super(key: key);

  final String replyId;
  final String sectionId;

  @override
  State<ForumRoutePage> createState() => _ForumRoutePageState();
}

bool isParentIDZero = true;

class _ForumRoutePageState extends State<ForumRoutePage> {
  bool isVisibleTextField = false;
  final TextEditingController addReplyController = TextEditingController();

  String? term = PoolTerm.term;
  String? role = "unknown";
  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    fetchForums();
    setState(() {});
  }

  List<ForumReply> replies = [];

  ForumReply forum = ForumReply(
      message: "messageText",
      postedByUser: "postedByUser",
      parentReplyId: "parentReplyId",
      replyId: "replyId");
  Future<void> fetchForums() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();

      String parentID = widget.replyId;
      String sectionID = widget.sectionId;
      final response = await http.get(
        Uri.http('localhost:8080', '/forum/$parentID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          forum.message = responseData["post"]['message'];
          forum.replyId = responseData["post"]['replyID'];
          forum.parentReplyId = responseData["post"]['parentReplyId'];
          forum.postedByUser = responseData["post"]['postedByUser'];
          replies = parseForumReplyData(responseData['repliesOfPost']);
        });
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching s: $e');
    }
  }

  List<ForumReply> parseForumReplyData(dynamic responseData) {
    List<ForumReply> parsedList = [];
    if (responseData != null) {
      responseData.forEach((replyData) {
        parsedList.add(ForumReply.fromJson(replyData));
      });
    }
    return parsedList;
  }

  void addReply() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final message = addReplyController.text;
      final replyId = forum.replyId;

      final url = Uri.parse('http://localhost:8080/forum/$replyId');
      Map<String, dynamic> requestBody = {
        'messageText': message,
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuccessWidget(
              context: context,
              onDismiss: () {
                addReplyController.clear();
                isVisibleTextField = false;
              },
            );
          },
        );
      }
      print(response.statusCode);
    } catch (e) {
      print("object$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Stack(
        children: [
          Row(
            children: [
              LeftBar(role: role),
              IconButton(
                  onPressed: () async {
                    final sectionID = widget.sectionId;
                    final id = forum.parentReplyId;
                    print(id);
                    if (id == "0") {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Failed'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'There is no more parent nigga calm down.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    } else {
                      setState(() {
                        isVisibleTextField = false;
                      });
                      await fetchForums();
                      GoRouter.of(context).go("/$sectionID/forum/$id");
                    }
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: PoolColors.cardWhite,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: PoolColors.recievedText,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    forum.postedByUser,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      forum.message,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isVisibleTextField = true;
                                        });
                                      },
                                      child: Text(
                                        'Reply',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: PoolColors
                                              .black, // Customize the color as needed
                                        ),
                                      ),
                                    ),
                                    // Spacer between reply button and icon button
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: replies.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(left: 100, right: 10),
                              child: InkWell(
                                onTap: () async {
                                  final sectionID = widget.sectionId;
                                  final id = replies[index].replyId;
                                  forum = replies[index];
                                  setState(() {
                                    isVisibleTextField = false;
                                  });
                                  await fetchForums();
                                  GoRouter.of(context)
                                      .go("/$sectionID/forum/$id");
                                },
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: PoolColors.sentText,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        replies[index].postedByUser,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(replies[index].message,
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Positioned TextField for Reply
          isVisibleTextField
              ? Positioned(
                  bottom: screen.height / 2 - 14,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 130, left: 150),
                    decoration: BoxDecoration(
                        color: PoolColors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: addReplyController,
                            decoration: InputDecoration(
                              hintText: 'Type your reply...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                addReply();
                              });
                            },
                            icon: Icon(Icons.send)),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
