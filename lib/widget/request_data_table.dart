import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rally/model/provider/request_provider.dart';
import 'package:rally/model/request.dart';
import 'package:rally/resources/theme.dart';
import 'package:http/http.dart' as http;
import 'package:rally/widget/filter.dart';
import 'package:rally/widget/status_indicator.dart';

import '../resources/utils.dart';

class RequestDataTable extends StatefulWidget {
  const RequestDataTable({super.key});

  @override
  State<RequestDataTable> createState() => _RequestDataTableState();
}

class _RequestDataTableState extends State<RequestDataTable>
    with AutomaticKeepAliveClientMixin {
  @override
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";



  Object filterWidget() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Filter(context: context);
        });
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild child");
    return Consumer(builder: (context, ref, _) {
      final provideRequest = ref.watch(requestProvider);
      return Container(
          padding: ThemeRally.widgetInnerPadding(right: 20),
          decoration: ThemeRally.widgetDeco(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              title: Column(
                children: [
                  Container(
                    height: 55,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Request",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Container(
                            height: 35,
                            width: 400,
                            child: SearchBar(
                              onChanged: (_) {
                                setState(() {
                                  _searchTerm = _searchController.text;
                                });
                              },
                              controller: _searchController,
                              hintText: "Search",
                              leading: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Icon(
                                  Icons.search,
                                  color: ThemeRally.newBlack,
                                ),
                              ),
                              backgroundColor:
                              MaterialStateProperty.all(ThemeRally.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                    provideRequest.setLoading(true);
                                },
                                child: Container(
                                  decoration: ThemeRally.widgetDeco(),
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.refresh,
                                    color: ThemeRally.newBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: filterWidget,
                                child: Container(
                                  decoration: ThemeRally.widgetDeco(),
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.filter_list_rounded,
                                    color: ThemeRally.newBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: StreamBuilder(
                  stream: provideRequest.getRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || provideRequest.isLoading) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: ThemeRally.newBlack,
                      ));
                    }
                    var requests = snapshot.data?.map((data) {
                      return data;
                    }).toList();
                    return DataTable2(
                      columns: [
                        DataColumn2(
                            label: Text("Request",
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        DataColumn2(
                            label: Text("Date",
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        DataColumn2(
                            label: Text("Member",
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        DataColumn2(
                            label: Text("Tag",
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        DataColumn2(
                            label: Text("Status",
                                style: TextStyle(fontWeight: FontWeight.w500))),
                      ],
                      rows: requests!
                          .map((request) => DataRow2(
                                  onTap: () {
                                    provideRequest.setRequest(request);
                                  },
                                  cells: [
                                    DataCell(Text(request.id)),
                                    DataCell(Text(DateFormat("d MMM y")
                                        .format(request.timestamp))),
                                    DataCell(Text(request.employeeId)),
                                    DataCell(Text(request.tag)),
                                    DataCell(StatusIndicator(text: request.status, isBig: true,))
                                  ]))
                          .toList(),
                      dataRowHeight: 50,
                      headingRowHeight: 40,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey.withOpacity(0.1)),
                    );
                  }
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

                  ),
            ),
          ));
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool wantKeepAlive = true;
}
