import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rally/resources/theme.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ThemeRally.widgetOuterPadding(),
      child: Container(
        decoration: ThemeRally.widgetDeco(),
        width: 150,
        padding: ThemeRally.widgetInnerPadding(left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(alignment: Alignment.center, children: [
              Container(
                child: CircularPercentIndicator(
                  percent: 75/100,
                  lineWidth: 10,
                  radius: 40,
                  progressColor: ThemeRally.newBlack,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                ),
              ),
              Text("30:00", style: TextStyle(fontWeight: FontWeight.w500),)
            ]),
            SizedBox(height: 20,),
            Icon(
              Icons.play_circle,
              color: Colors.grey.withOpacity(0.4),
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
