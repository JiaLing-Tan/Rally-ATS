import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:rally/resources/utils.dart';
import 'package:http/http.dart' as http;
import 'package:calendar_view/calendar_view.dart';

class Schedules {
  Schedules();

  static var calendarOccupied = true;

  static void AddEvent(context, startTime, endTime, title, desc) {
    var color = Colors.green;

    DateTime now = DateTime.now();

    if (now.isAfter(startTime) && now.isBefore(endTime)) {
      color = Colors.red;
    } else if (now.isBefore(startTime)) {
      color = Colors.blue;
    } else if (now.isAfter(endTime)) {
      color = Colors.blueGrey;
    }

    final event = CalendarEventData(
      date: startTime,
      startTime: startTime,
      endTime: endTime,
      color: color,
      title: title,
      description: desc,
      titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
      descriptionStyle: const TextStyle(fontSize: 10, color: Colors.white),
    );

    CalendarControllerProvider.of(context).controller.add(event);
  }

  static Future callCalander() async {
    String urlGet = "$url?token=$token&funcName=getCalIdFromSheet";
    var response = await http
        .get(Uri.parse(urlGet))
        .then((value) => jsonDecode(value.body));
    print(response);

    return response;
  }


  static addToCalendar(calanderObjects, context) {

    print(calanderObjects);

    calendarOccupied = true;

    for (var i in range(calanderObjects.length)) {
      var calanderObject = calanderObjects[i];
      final title = calanderObject['title'];
      final endTimes = calanderObject['endTime'];
      final startTimes = calanderObject['startTime'];

      final startTime = DateTime(startTimes['year'], startTimes['month'],
          startTimes['day'], startTimes['hours'], startTimes['minutes']);

      final endTime = DateTime(endTimes['year'], endTimes['month'],
          endTimes['day'], endTimes['hours'], endTimes['minutes']);
      Schedules.AddEvent(context, startTime, endTime, title, "Tan Jia Ling");

      if (i+1 == calanderObjects.length){
        calendarOccupied = false;
        return Stream.value(true);
      }
    }
  }


}

