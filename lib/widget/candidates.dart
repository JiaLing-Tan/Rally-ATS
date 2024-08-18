import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rally/model/candidate.dart';
import 'package:rally/model/feedback.dart';
import 'package:rally/model/provider/filter_provider.dart';
import 'package:rally/model/provider/role_provider.dart';
import 'package:rally/resources/theme.dart';
import 'package:http/http.dart' as http;
import 'package:rally/widget/candidate_details.dart';
import 'package:rally/widget/filter.dart';
import 'package:rally/widget/status_indicator.dart';

import '../resources/utils.dart';

class Candidates extends StatefulWidget {
  const Candidates({super.key});

  @override
  State<Candidates> createState() => _CandidatesState();
}

class _CandidatesState extends State<Candidates>
    with AutomaticKeepAliveClientMixin {
  Candidate showCandidate = Candidate.empty();
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  List<InterviewFeedback> interviewFeedback = [];


  Stream<List<Candidate>> getCandidates() async* {
    print("getting data");
    final response =
        await http.get(Uri.parse("$url?token=$token&funcName=getCandidate"));
    final feedbackResponse =
        await http.get(Uri.parse("$url?token=$token&funcName=getFeedback"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<Candidate> candidates = jsonData
          .map((candidateJson) => Candidate.fromJson(candidateJson))
          .toList();
      final List<dynamic> feedbackJsonData = jsonDecode(feedbackResponse.body);
      interviewFeedback = feedbackJsonData
          .map((feedbackJson) => InterviewFeedback.fromJson(feedbackJson))
          .toList();

      // candidates = candidates.where((candidate) {
      //   return statusList.contains(candidate.status);
      // }).toList();

      yield candidates;
    } else {
      throw Exception('Failed to fetch candidates');
    }
    print("oi");

    if (isLoading) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void selectCandidate(Candidate candidate) {
    setState(() {
      showCandidate = candidate;
    });
  }

  void closeCandidate() {
    setState(() {
      showCandidate = Candidate.empty();
    });
  }

  Object filterWidget() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Filter(context: context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final role = ref.watch(roleProvider);
      final filter = ref.watch(filterProvider);
      return Padding(
        padding: ThemeRally.widgetOuterPadding(),
        child: Container(
          padding: ThemeRally.widgetInnerPadding(right: 20),
          decoration: ThemeRally.widgetDeco(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              title: Column(
                children: [
                  Container(
                    height: 55,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Job Applicants",
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
                                  setState(() {
                                    isLoading = true;
                                  });
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
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Stack(children: [
                StreamBuilder(
                    stream: getCandidates(),
                    builder: (context, snapshot) {
                      print(snapshot.error);

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      ;
                      if (!snapshot.hasData || isLoading) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: ThemeRally.newBlack,
                        ));
                      }
                      isLoading = false;
                      var candidates = snapshot.data?.map((data) {
                        return data;
                      }).toList();
                      role.populateRoles(candidates);
                      candidates!.sort((a, b) => (b.date).compareTo(a.date));
                      if (_searchTerm != "") {
                        candidates = candidates!
                            .where((candidate) => [
                                  candidate.id,
                                  candidate.name,
                                  candidate.role,
                                  candidate.skills,
                                  candidate.education
                                ]
                                    .map((e) => e
                                        .toString()
                                        .toLowerCase()
                                        .contains(_searchTerm.toLowerCase()))
                                    .any((element) => element))
                            .toList();
                      }
                      ;
                      candidates = filter.rolesFilter.length > 0
                          ? candidates
                              .where((candidate) =>
                                  filter.rolesFilter.indexOf(candidate.role) >=
                                  0)
                              .toList()
                          : candidates;

                      return candidates!.length > 1
                          ? DataTable2(
                              showCheckboxColumn: false,
                              minWidth: 600,
                              columns: [
                                DataColumn2(
                                    fixedWidth: 100,
                                    label: Text("ID",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                                DataColumn(
                                    label: Text("Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                                DataColumn2(
                                    label: Text("Role",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                                DataColumn2(
                                    fixedWidth: 170,
                                    label: Text("Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                                DataColumn2(
                                    fixedWidth: 100,
                                    label: Text("Rating",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                                DataColumn2(
                                    fixedWidth: 200,
                                    label: Text("Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)))
                              ],
                              rows: candidates!.map((candidate) {
                                return DataRow2(
                                    onTap: () {
                                      {
                                        print("tapped ${candidate.id}");
                                        selectCandidate(candidate);
                                      }
                                    },
                                    cells: [
                                      DataCell(Text(candidate.id)),
                                      DataCell(Text(candidate.name)),
                                      DataCell(Text(candidate.role)),
                                      DataCell(Text(DateFormat("d MMM y")
                                          .format(candidate.date))),
                                      DataCell(
                                          Text(candidate.rating.toString())),
                                      DataCell(StatusIndicator(text: candidate.status, isBig: true,))
                                    ]);
                              }).toList(),
                              dataRowHeight: 50,
                              headingRowHeight: 40,
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.grey.withOpacity(0.1)),
                            )
                          : Center(
                              child: Text("No candidate available"),
                            );
                    }),
                Visibility(
                    visible: showCandidate.id != "",
                    child: CandidateDetails(
                      feedbacks: interviewFeedback
                          .where((feedback) =>
                              feedback.candidateId == showCandidate.id)
                          .toList(),
                      candidate: showCandidate,
                      onCloseClicked: closeCandidate,
                    ))
              ]),
            ),
          ),
        ),
      );
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool wantKeepAlive = true;
}

//   snapshot.data!.map((candidate) {
//   return DataRow2(
//       onTap: () {
//         {
//           print("tapped ${candidate.id}");
//           selectCandidate(candidate.id);
//         }
//       },
//       cells: [
//         DataCell(Text(candidate.id)),
//         DataCell(Text(candidate.name)),
//         DataCell(Text(candidate.role)),
//         DataCell(Text("${candidate.date}")),
//         DataCell(Text(candidate.rating.toString())),
//         DataCell(Text(candidate.status))
//       ]);
// }).toList(),
// List.generate(
//     10,
//     (index) => DataRow2(
//             onTap: () {
//               {
//                 print("tapped $index");
//                 selectCandidate("ID$index");
//               }
//             },
//             cells: [
//               DataCell(Text("ID$index")),
//               DataCell(Text("Name$index")),
//               DataCell(Text("Job$index")),
//               DataCell(Text("Date$index")),
//               DataCell(Text("Rating$index")),
//               DataCell(Text("Status$index"))
//             ])),
