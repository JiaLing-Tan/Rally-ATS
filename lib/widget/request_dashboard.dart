import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rally/resources/theme.dart';

class RequestDashboard extends StatefulWidget {
  const RequestDashboard({super.key});

  @override
  State<RequestDashboard> createState() => _RequestDashboardState();
}

class _RequestDashboardState extends State<RequestDashboard> {
  @override
  List<DataRow> data = List.generate(
      20,
      (index) => DataRow(cells: [
            DataCell(Text("Task$index")),
            DataCell(Text("Date$index")),
            DataCell(Text("Member$index")),
            DataCell(Text("Status$index"))
          ]));

  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: ThemeRally.widgetOuterPadding(),
        child: Container(
          padding: ThemeRally.widgetInnerPadding(right: 20),
          decoration: ThemeRally.widgetDeco(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Request",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Container(
                    decoration: ThemeRally.widgetDeco(),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "View all",
                      style: TextStyle(color: ThemeRally.newBlack, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              DataTable(
                columns: [
                  DataColumn(
                      label: Text("Todo",
                          style: TextStyle(fontWeight: FontWeight.w500))),
                  DataColumn(
                      label: Text("Date",
                          style: TextStyle(fontWeight: FontWeight.w500))),
                  DataColumn(
                      label: Text("Member",
                          style: TextStyle(fontWeight: FontWeight.w500))),
                  DataColumn(
                      label: Text("Status",
                          style: TextStyle(fontWeight: FontWeight.w500))),
                ],
                rows: data,
                dataRowMaxHeight: 50,
                dataRowMinHeight: 50,
                headingRowHeight: 40,
                headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.withOpacity(0.1)),
              )
              // Container(
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     physics: NeverScrollableScrollPhysics(),
              //     itemCount: 10,
              //     itemBuilder: (BuildContext, int index) {
              //       return Container(
              //         padding: ThemeRally.widgetInnerPadding(left: 0),
              //         width: double.infinity,
              //         child: Text("request$index", style: TextStyle(color: Colors.black45),),
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
