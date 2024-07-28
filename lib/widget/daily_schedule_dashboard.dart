import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:rally/resources/theme.dart';

import '../model/schedules.dart';

class DailyScheduleDashboard extends StatefulWidget {
  const DailyScheduleDashboard({super.key});

  @override
  State<DailyScheduleDashboard> createState() => _DailyScheduleDashboardState();
}

class _DailyScheduleDashboardState extends State<DailyScheduleDashboard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Expanded(
      child: Padding(
        padding: ThemeRally.widgetOuterPadding(),
        child: Container(
          padding: ThemeRally.widgetInnerPadding(right: 20),
          decoration: ThemeRally.widgetDeco(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "Today",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        // Schedules.AddEvent(context, DateTime(2024, 7, 22, 12, 0, 0),DateTime(2024, 7, 22, 16, 0, 0), '12', '32');

                        setState(() {
                          List eventsCopy = List.from(
                              CalendarControllerProvider.of(context)
                                  .controller
                                  .allEvents);
                          for (var event in eventsCopy) {
                            CalendarControllerProvider.of(context)
                                .controller
                                .remove(event);
                          }
                        });
                      },
                      child: const Icon(
                        size: 25,
                        Icons.refresh,
                        // color: ThemeRally.newBlack,
                      ),
                    ),
                  )
                ],
              ),
              const Divider(
                color: Colors.black,
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  width: (size.width * 0.5).abs(),
                  height: 1000,
                  child: FutureBuilder(
                      future: Schedules.callCalander(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Stack(children: [
                            // DayView(
                            //   backgroundColor: ThemeRally.background,
                            // ),
                            Container(
                              color: Colors.grey.withOpacity(0.2),
                              width: size.width,
                              height: size.height,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            // const Center(child: CircularProgressIndicator()),
                          ]);
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return StreamBuilder(
                              stream: Schedules.addToCalendar(
                                  snapshot.data, context),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return DayView(
                                    heightPerMinute: 1.1,
                                    startHour: 7,
                                    backgroundColor: ThemeRally.background,
                                    onEventTap: (event, selectedTime) {
                                      _showEventDetailsDialog(context, event);
                                    },
                                  );
                                }
                              });
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }

  void RemoveEvent() {
    setState(() {
      List eventsCopy = List.from(
          CalendarControllerProvider.of(context).controller.allEvents);

      for (var event in eventsCopy) {
        CalendarControllerProvider.of(context).controller.remove(event);
      }
    });
  }

  @override
// TODO: implement wantKeepAlive
  bool wantKeepAlive = true;
}

Future<void> _showEventDetailsDialog(context, event) async {
  final eventObject = event[0];
  Map<String, dynamic> eventJson = eventObject.toJson();
  print(eventJson);
  var startTime = eventJson['startTime'];
  var endTime = eventJson['endTime'];
  DateTime now = DateTime.now();

  String format(dateTime) {
    String _twoDigits(int n) {
      if (n >= 10) {
        return '$n';
      }
      return '0$n';
    }

    return '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} ${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}';
  }

  print(startTime.runtimeType);

  Duration difference = startTime.difference(now);

  String getDifference(startTime, endTime, now) {
    if (now.isAfter(startTime) && now.isBefore(endTime)) {
      return 'On going meeting, ${now.difference(startTime).inMinutes} min left.';
    } else if (now.isAfter(endTime)) {
      return 'Ended ${difference.inHours.abs()} Hour, ${difference.inMinutes % 60} min ago';
    } else if (now.isBefore(startTime)) {
      return "Start in ${difference.inHours.abs()} Hour, ${difference.inMinutes % 60} min";
    } else {
      return "Error";
    }
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          eventJson['title'],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(eventJson['description'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  Text(
                    "Start at ${format(startTime)}",
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "End at ${format(endTime)}",
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            StreamBuilder<String>(
                stream: Stream.value(getDifference(startTime, endTime, now)),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                }),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
