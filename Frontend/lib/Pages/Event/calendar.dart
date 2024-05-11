import 'dart:convert';

import 'package:first_trial/Objects/event.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String? term = PoolTerm.term;
  String? role = "unknown";
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  Map<DateTime, List<Event>> _eventsByDate = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();

    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();

    fetchEvent();
    setState(() {});
  }

  void fetchEvent() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? userid = await TokenStorage.getID();
      final response = await http.get(
        Uri.http('localhost:8080', '/event/$userid'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);

        setState(() {
          _eventsByDate = parseEventsData(responseData);
        });
      } else {
        throw Exception('Failed to fetch events data');
      }
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  Map<DateTime, List<Event>> parseEventsData(dynamic responseData) {
    Map<DateTime, List<Event>> parsedEvents = {};
    for (var eventData in responseData as List<dynamic>) {
      final event = Event.fromJson(eventData);
      final eventDate = event.date;
      if (parsedEvents.containsKey(eventDate)) {
        parsedEvents[eventDate]!.add(event);
      } else {
        parsedEvents[eventDate] = [event];
      }
    }
    return parsedEvents;
  }

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focus) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          children: [
            LeftBar(role: role),
            IconButton(
              onPressed: () {
                GoRouter.of(context).go("/createEvent");
                //add event
              },
              icon: Icon(
                Icons.post_add_rounded,
                size: 50,
              ),
            ),
            Expanded(
              child: Container(
                height: 1000,
                width: 1000,
                child: TableCalendar(
                  calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PoolColors.recievedText,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: PoolColors.sentText,
                        shape: BoxShape.circle,
                      ),
                      markerSize: 10,
                      markerDecoration: BoxDecoration(
                          color: PoolColors.fairTurkuaz,
                          borderRadius: BorderRadius.circular(70))),
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: today,
                  rowHeight: 80,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  onDaySelected: _onDaySelected,
                  eventLoader: (day) => _eventsByDate[day] ?? [],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      20), // Adjust the border radius as needed
                ),
                child: ListView.builder(
                  itemCount: _eventsByDate[today]?.length ?? 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.all(100),
                              title: Text(
                                _eventsByDate[today]![index].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  Text(
                                    'Participants:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    _eventsByDate[today]![index]
                                        .participants
                                        .join(', '),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Date:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    _eventsByDate[today]![index]
                                        .date
                                        .toString(),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Explanations :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    _eventsByDate[today]![index].messageText,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: ListTile(
                        title: Text(_eventsByDate[today]![index].title),
                        subtitle:
                            Text(_eventsByDate[today]![index].date.toString()),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
