import 'package:first_trial/Objects/forum_post.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewForumPage extends StatefulWidget {
  const ViewForumPage({
    super.key,
    required this.sectionID,
  });
  final String sectionID;

  @override
  State<ViewForumPage> createState() => _ViewForumPageState();
}

class _ViewForumPageState extends State<ViewForumPage> {
  String? term = PoolTerm.term;
  String? role = "unknown";
  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    await fetchForums();
    setState(() {});
  }

  List<ForumPost> forums = [];
  Future<void> fetchForums() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();
      String sectionID = widget.sectionID;
      final response = await http.get(
        Uri.http('localhost:8080', '/forum/$term/$sectionID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          forums = parseForumPostData(responseData['forumPosts']);
        });
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching s: $e');
    }
  }

  List<ForumPost> parseForumPostData(dynamic responseData) {
    return (responseData as List<dynamic>)
        .map((assignmentData) => ForumPost.fromJson(assignmentData))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Center(
        child: ListView.builder(
          itemCount: forums.length,
          itemBuilder: (context, index) {
            final forum = forums[index];
            return ListTile(
              title: Text(forum.title),
              subtitle: Text(forum.forumInitiator),
              onTap: () {
                final id = forum.initialReplyId;
                final sectionID = forum.sectionId;

                GoRouter.of(context).go("/$sectionID/forum/$id");
              },
            );
          },
        ),
      ),
    );
  }
}
