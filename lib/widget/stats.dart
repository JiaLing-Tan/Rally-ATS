import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rally/resources/theme.dart';

class Stats extends StatefulWidget {
  final String statsTitle;

  const Stats({super.key, required this.statsTitle});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: ThemeRally.widgetOuterPadding(),
        child: Container(

          padding: ThemeRally.widgetInnerPadding(top: 15, bottom: 15),
          decoration: ThemeRally.widgetDeco(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: 10,),
                  Flexible(child: Text(widget.statsTitle)),
                ],
              ),
              SizedBox(height: 15,),
              Text("20")
            ],
          ),
        ),
      ),
    );
  }
}
