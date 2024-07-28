import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rally/resources/theme.dart';
import 'package:window_manager/window_manager.dart';

List<String> status = [
  "In Progress",
  "Scheduling",
  "Invited",
  "Interview Scheduled",
  "Evaluating",
  "Rejected",
  "Offered",
  "Confirmed",
  "Onboarding"
];
Map<String, int> statusMap = {"Offer Job": 4, "Reject": 4, "Interview": 0};

Map colorMap = {
  "In Progress" : Colors.orange,
  "Scheduling": Colors.purple,
  "Invited": Colors.blue,
  "Interview Scheduled": ThemeRally.vibrantBlue,
  "Evaluating": Colors.teal,
  "Rejected": Colors.redAccent,
  "Offered": Colors.lightGreen,
  "Confirmed": Colors.green,
  "Approved" : Colors.green,
  "Onboarding" : ThemeRally.newBlack,
};

List<String> tag = [
  "Recruitment",
  "Relationships",
  "Performance",
  "Understaffed"
];

List<String> sortingList = ["ID", "Name", "Role", "Date", "Rating", "Status"];
Map<String, int> dayMap = {
  "Last 30 days": 30,
  "Last 90 days": 90,
  "Last year": 365
};

List<String> reqStatus = ["In Progress", "Rejected", "Approved"];


String url = dotenv.env['url']!;
String token = dotenv.env['token']!;
List<String> cats = [
  "Documentation",
  "News",
  "Legal Documents",
  "General",
  "Handbook"
];


showSnackBar(String message, context) {
  final snackbar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: 1),
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

showBackDialog(String confirmation, context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: Text(
          confirmation,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
            ),
            child: const Text('Nevermind'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
            ),
            child: const Text('Leave'),
            onPressed: () {
              if (confirmation == 'Are you sure you want to leave the app?') {
                windowManager.close();
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    },
  );
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) =>
    Color.fromRGBO(
        tintValue(color.red, factor),
        tintValue(color.green, factor),
        tintValue(color.blue, factor),
        1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) =>
    Color.fromRGBO(
        shadeValue(color.red, factor),
        shadeValue(color.green, factor),
        shadeValue(color.blue, factor),
        1);
