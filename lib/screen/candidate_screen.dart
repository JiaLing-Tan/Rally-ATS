import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/widget/candidates.dart';
import 'package:rally/widget/request_dashboard.dart';

class CandidateScreen extends StatefulWidget {
  const CandidateScreen({super.key});

  @override
  State<CandidateScreen> createState() => _CandidateScreenState();
}

class _CandidateScreenState extends State<CandidateScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ThemeRally.widgetInnerPadding(right: 20),
        color: ThemeRally.background,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            title: Text("Candidates", style: TextStyle(fontSize: 25),),

          ),
          body: Candidates(),
        ));
  }
}
