import 'package:flutter/material.dart';
import 'package:rally/resources/theme.dart';

class Quote extends StatefulWidget {
  const Quote({super.key});

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ThemeRally.widgetOuterPadding(),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: ThemeRally.widgetInnerPadding(top: 30, bottom: 30, left: 30),
          child: Row(

            children: [
              Icon(Icons.favorite_outlined, color: Colors.red,),
              SizedBox(width: 20),
              Flexible(child: Text("Just be the best version of you.", style: TextStyle(fontSize: 17),)),
            ],
          ),
        ),
        decoration: ThemeRally.widgetDeco()
      ),
    );
  }
}
