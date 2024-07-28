
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/widget/pomodoro.dart';
import 'package:rally/widget/quote.dart';
import 'package:rally/widget/request_dashboard.dart';
import 'package:rally/widget/stats.dart';
import 'package:rally/widget/daily_schedule_dashboard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeRally.background,
      child: Padding(
        padding: ThemeRally.widgetInnerPadding(right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 15, left: 10),
                child: Text(
                  "Welcome back, Ling!",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Quote(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stats(statsTitle: "Total Employee"),
                  Stats(statsTitle: "New Employee"),
                  Stats(statsTitle: "Open Position"),
                  Stats(statsTitle: "Job Applicants")
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DailyScheduleDashboard(),
                  RequestDashboard(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool wantKeepAlive = true;
}
