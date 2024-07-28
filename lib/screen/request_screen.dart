import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rally/model/request.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/widget/request_data_table.dart';
import 'package:rally/widget/request_details.dart';
import 'package:rally/widget/request_textfiled.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {



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
            title: Text(
              "Request",
              style: TextStyle(fontSize: 25),
            ),
          ),
          body: Padding(
            padding: ThemeRally.widgetOuterPadding(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RequestDetails(),
                    RequestTextfield()
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Flexible(child: RequestDataTable()),
              ],
            ),
          ),
        ));
  }
}
