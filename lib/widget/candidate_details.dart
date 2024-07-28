import 'dart:ui' as ui;
import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rally/model/candidate.dart';
import 'package:rally/model/provider/roleProvider.dart';
import 'package:rally/resources/email_launcher.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/resources/utils.dart';
import 'package:rally/widget/offer_letter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../model/feedback.dart';

typedef void closeCallback();

class CandidateDetails extends StatefulWidget {
  final Candidate candidate;
  final List<InterviewFeedback> feedbacks;
  final closeCallback onCloseClicked;

  const CandidateDetails(
      {super.key,
      required this.candidate,
      required this.onCloseClicked,
      required this.feedbacks});

  @override
  State<CandidateDetails> createState() => _CandidateDetailsState();
}

class _CandidateDetailsState extends State<CandidateDetails> {
  bool showProcess = false;
  bool _isLoadingReject = false;
  bool _isLoadingInterview = false;
  bool _isLoadingApprove = false;
  bool _isLoadingOnboard = false;

  Future<http.Response> rejectCandidate(String id) async {
    setState(() {
      _isLoadingReject = true;
    });
    showSnackBar("Please wait...", context);
    String? urlGet = "$url?token=$token&funcName=rejectCandidate&id=$id";
    var response = await http.get(Uri.parse(urlGet));
    showSnackBar("Rejected ${widget.candidate.id}", context);
    setState(() {
      _isLoadingReject = false;
    });
    return response;
  }

  Future<http.Response> scheduleInterview(String id) async {
    setState(() {
      _isLoadingInterview = true;
    });
    showSnackBar("Please wait...", context);
    String? urlGet = "$url?token=$token&funcName=scheduleInterview&id=$id";
    var response = await http.get(Uri.parse(urlGet));
    showSnackBar("Schedule meeting with ${widget.candidate.id}", context);
    setState(() {
      _isLoadingInterview = false;
    });
    return response;
  }

  Object offerLetterWidget() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return OfferLetter(candidate: widget.candidate,context: context,);
        });
  }

  Future<http.Response> onboarding(String id) async {
    setState(() {
      _isLoadingOnboard = true;
    });
    showSnackBar("Please wait...", context);
    String? urlGet = "$url?token=$token&funcName=onboarding&id=$id";
    var response = await http.get(Uri.parse(urlGet));
    showSnackBar("Onboarding material sent to ${widget.candidate.id}", context);
    setState(() {
      _isLoadingOnboard = false;
    });

    return response;
  }

  void inactiveFunction() {
    showSnackBar(
        "The button is deactivated due to the status of candidate, double tap to reactivate",
        context);
  }

  List<Column> getFeedback() {
    return widget.feedbacks
        .map((feedback) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Interviewer: " + feedback.interviewerId),
                    Row(
                      children: [
                        Text("Rating: " + feedback.getTotal().toString()),
                        Text(
                          "/50",
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Overall Opinion: "),
                    Flexible(
                        child: Text(
                      feedback.overallOpinion,
                      textAlign: TextAlign.justify,
                    )),
                  ],
                )
              ],
            ))
        .toList();
  }

  Widget getButton(Function() onTap, Color color, String text, IconData icon,
      bool isLoading) {
    int statusLevel = status.indexOf(widget.candidate.status);
    int? temp = statusMap[text];
    bool isActive = true;
    if (temp != null) {
      isActive = !(statusLevel > temp!);
    } else {
      isActive = widget.candidate.status == "Confirmed";
    }

    return GestureDetector(
      onDoubleTap: !isActive
          ? () {
              print("ok");
              onTap();
              setState(() {});
            }
          : () {},
      onTap: isActive ? onTap : inactiveFunction,
      child: Container(
        decoration: ThemeRally.widgetDeco(color: Colors.white),
        width: 130,
        padding: EdgeInsets.all(10),
        child: isLoading
            ? Center(
                child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 20,
                  width: 20,
                ),
              ))
            : Row(
                children: [
                  Icon(
                    icon,
                    color: isActive ? color : Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    text,
                    style: TextStyle(color: isActive ? color : Colors.grey),
                  )
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Candidate candidate = widget.candidate;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: ThemeRally.widgetInnerPadding(left: 30, top: 30, bottom: 30),
          decoration: ThemeRally.widgetDeco(),
          height: MediaQuery.sizeOf(context).height,
          width: 500,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(right: 30),
              child: Stack(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    candidate.name,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Text(
                          candidate.email,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                            // fontWeight: FontWeight.w600
                          ),
                        ),
                        onTap: () {
                          EmailLauncher.openMail(candidate.email);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.workspaces_rounded,
                        color: ThemeRally.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Position applied",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ThemeRally.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(candidate.role),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.work_history_rounded,
                        color: ThemeRally.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Experience",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ThemeRally.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: candidate.experience
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: ThemeRally.black,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Flexible(child: Text(e))
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.school_rounded,
                        color: ThemeRally.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Education",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ThemeRally.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: candidate.education
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: ThemeRally.black,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Flexible(child: Text(e))
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.handyman_rounded,
                        color: ThemeRally.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Skills",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ThemeRally.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Wrap(
                    children: candidate.skills
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                decoration: ThemeRally.widgetDeco(),
                                child: Text(e),
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.featured_play_list_rounded,
                            color: ThemeRally.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Rating Explanation",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: ThemeRally.black),
                          ),
                        ],
                      ),
                      Text(
                        "Scoring: ${candidate.rating.toString()}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(candidate.explanation, textAlign: TextAlign.justify),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: widget.feedbacks.length > 0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.feedback,
                          color: ThemeRally.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Interview Feedback",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: ThemeRally.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: getFeedback(),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Tooltip(
                              preferBelow: false,
                              message: "Open resume",
                              child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Container(
                                              width:600,
                                              height: 600,
                                              child:
                                                  candidate.resumeId == "None"
                                                      ? Text("No resume found")
                                                      : Iframe(candidate.resumeId),
                                            ),
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.picture_as_pdf_rounded,
                                    color: ThemeRally.black,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Tooltip(
                              preferBelow: false,
                              message: "Contact",
                              child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SizedBox(
                                              width: 200,
                                              height: 200,
                                              child: Center(
                                                child: QrImageView(
                                                  size: 200,
                                                  data: candidate.contactNumber,
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.qr_code_2_rounded,
                                    color: ThemeRally.black,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Tooltip(
                              preferBelow: false,
                              message: "Close",
                              child: GestureDetector(
                                  onTap: widget.onCloseClicked,
                                  child: Icon(Icons.close)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Tooltip(
                              preferBelow: false,
                              message: "Process",
                              child: Container(
                                decoration: ThemeRally.widgetDeco(
                                    color: ThemeRally.white),
                                padding: EdgeInsets.all(5),
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showProcess = !showProcess;
                                      });
                                    },
                                    child: Icon(showProcess
                                        ? Icons.keyboard_double_arrow_up_rounded
                                        : Icons
                                            .keyboard_double_arrow_down_rounded)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: showProcess,
                          child: Container(
                            decoration: ThemeRally.widgetDeco(isFloating: true),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                getButton(
                                    () => rejectCandidate(candidate.id),
                                    Colors.redAccent,
                                    "Reject",
                                    Icons.remove_circle_outline_rounded,
                                    _isLoadingReject),
                                SizedBox(
                                  height: 15,
                                ),
                                getButton(
                                    () => scheduleInterview(candidate.id),
                                    ThemeRally.vibrantBlue,
                                    "Interview",
                                    Icons.people_outline_rounded,
                                    _isLoadingInterview),
                                SizedBox(
                                  height: 15,
                                ),
                                getButton(
                                    () => offerLetterWidget(),
                                    Colors.lightGreen,
                                    "Offer Job",
                                    Icons.approval_rounded,
                                    _isLoadingApprove),
                                SizedBox(
                                  height: 15,
                                ),
                                getButton(
                                    () => onboarding(candidate.id),
                                    Colors.green,
                                    "Onboarding",
                                    Icons.work_rounded,
                                    _isLoadingOnboard)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }
}


class Iframe extends StatelessWidget {
  Iframe(String id) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('iframe', (int viewId) {
      var iframe = html.IFrameElement();
      iframe.src = 'https://drive.google.com/file/d/$id/preview';
      return iframe;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        width: 700,
        height: 1000,
        child: HtmlElementView(viewType: 'iframe'));
  }
}
