import 'dart:async';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:rally/resources/theme.dart';

import '../model/schedules.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer that triggers setState every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});

      // If Schedules.calendarOccupied is false, cancel the timer
      if (!Schedules.calendarOccupied) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the timer to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Schedules.calendarOccupied
        ? const Center(child: CircularProgressIndicator())
        : Stack(children: [
      WeekView(
        backgroundColor: ThemeRally.background,
      ),
      Positioned(
        right: 20,
        top: 110,
        child: GestureDetector(
          onTap: () {
            // AddEvent(context, DateTime(2024, 7, 22, 12, 0, 0),DateTime(2024, 7, 22, 16, 0, 0), '12', '32');
            setState(() {});
            // RemoveEvent();
          },
          child: const Icon(
            size: 25,
            Icons.refresh,
            // color: ThemeRally.newBlack,
          ),
        ),
      ),
    ]);
  }

//   @override
// // TODO: implement wantKeepAlive
//   bool wantKeepAlive = true;
}
