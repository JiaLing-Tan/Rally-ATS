import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/widget/status_indicator.dart';

import '../model/openPosition.dart';
import '../resources/utils.dart';
import 'package:http/http.dart' as http;

import '../screen/open_position_screen.dart';

class OpenPositions extends StatefulWidget {
  final MyBuilder builder;

  const OpenPositions({super.key, required this.builder});

  @override
  State<OpenPositions> createState() => _OpenPositionsState();
}

class _OpenPositionsState extends State<OpenPositions> with AutomaticKeepAliveClientMixin {
  bool _isLoading = false;

  Stream<List<OpenPosition>> getOpenPosition() async* {
    print("getting data");
    final response =
        await http.get(Uri.parse("$url?token=$token&funcName=getOpenPosition"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OpenPosition> requests = jsonData.map((request) {
        return OpenPosition.fromJson(request);
      }).toList();
      yield requests;
    } else {
      throw Exception('Failed to fetch positions');
    }

    if (_isLoading) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void childMethod(){
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, childMethod);
    print("rebuild open position");
    return StreamBuilder(stream: getOpenPosition(), builder: (context, snapshot){
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      ;
      if (!snapshot.hasData || _isLoading) {
        return Center(
            child: CircularProgressIndicator(
              color: ThemeRally.newBlack,
            ));
      }
      var positions = snapshot.data?.map((data) {
        return data;
      }).toList();
      return MasonryGridView.count(
        itemCount: positions!.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        crossAxisCount: 4,
        itemBuilder: (context, index) {
          OpenPosition position = positions![index];
          String year = position.experience>1? "years":"year";
          return Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                decoration: ThemeRally.widgetDeco(),
                padding: ThemeRally.widgetInnerPadding(right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(position.id),
                              SizedBox(
                                width: 10,
                              ),
                              StatusIndicator(text: position.status)
                            ],
                          ),
                          Text(position.interviewerId),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        position.role,
                        style: TextStyle(fontSize: 25),
                        maxLines: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Wrap(
                        children: position.skill
                            .map((e) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: ThemeRally.widgetDeco(),
                            child: Text(e),
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text("Department: ${position.department}"),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),

                      child: Text("Experience: ${position.experience} $year"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Text("Budget: RM${position.minBudget} - ${position.maxBudget}"),
                    ),

                  ],
                )),
          );
        },
      );
    }
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool wantKeepAlive = true;
}
