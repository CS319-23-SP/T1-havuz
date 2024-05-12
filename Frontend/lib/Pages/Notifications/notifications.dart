import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String? role = "unknown";

  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    fetchNotifications();
    setState(() {});
  }

  Future<void> fetchNotifications() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();

      final response = await http.get(
        Uri.http('localhost:8080', '/event/notifications/$ID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        List<Map<String, dynamic>> parsedNotifications =
            responseData.map((notification) {
          return {
            'title': notification['title'],
            'date': notification['date'],
            'isSeen': notification['isSeen'],
            'id': notification['_id']
          };
        }).toList();

        setState(() {
          notifications = parsedNotifications;
        });
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  Future<void> fetchIsSeen(String id) async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();

      final response = await http.post(
        Uri.http('localhost:8080', '/event/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        // Remove the notification from the list
        setState(() {
          notifications.removeWhere((notification) => notification['id'] == id);
        });
      } else {
        throw Exception('Failed to mark notification as seen');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
                String _formatDate(String dateString) {
                  DateTime dateTime = DateTime.parse(dateString);
                  return DateFormat('dd-MM-yyyy').format(dateTime);
                }

                final notification = notifications[index];
                if (notification['isSeen']) {
                  return Container();
                } else {
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You are invited to:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          notification['title'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'Date: ${_formatDate(notification['date'])}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            fetchIsSeen(notification['id']);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.5)),
                            child: Icon(Icons.done_all),
                          ),
                        ),
                        SizedBox(width: 8), // Add some space between buttons
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            GoRouter.of(context).go('/calendar');
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.5)),
                            child: Icon(Icons.calendar_month_outlined),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
