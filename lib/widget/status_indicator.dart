import 'package:flutter/material.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/resources/utils.dart';

class StatusIndicator extends StatelessWidget {
  final String text;
  final bool isBig;
   StatusIndicator({super.key, required this.text, this.isBig = false});

  @override
  Widget build(BuildContext context) {
    var color = colorMap[text]?? ThemeRally.newBlack;
    return Container(
      padding: isBig? EdgeInsets.symmetric(
          horizontal: 9): EdgeInsets.symmetric(
          horizontal: 7),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(25),
          border: Border.all(
              color: color)),
      child: Text(
        text,
        style:
        TextStyle(color: color, fontSize: isBig? 13: 11),
      ),
    );
  }
}
